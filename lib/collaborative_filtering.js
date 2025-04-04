const math = require('mathjs');

class TransportationRecommender {
  constructor(pathFinder) {
    // pathFinder: objek yang menyediakan metode findRoutes(currentLocation, destination)
    this.pathFinder = pathFinder;
    // Data pengguna: userId -> { isColdStart, preferences, interactions, embedding }
    this.userData = new Map();
    // Data rute: routeId -> routeData (untuk update preferensi, jika diperlukan)
    this.routes = new Map();
    // Embeddings untuk pengguna dan rute
    this.userEmbeddings = new Map();
    this.routeEmbeddings = new Map();
    // Data training untuk pembaruan batch (trainingData: array of { userId, routeId, rating })
    this.trainingData = [];
    // Konfigurasi dasar
    this.config = {
      embeddingDimensions: 10,
      learningRate: 0.05,
      coldStartThreshold: 3, // Minimal interaksi untuk hybrid recommendation
      hybridWeights: { cf: 0.7, rb: 0.3 }
      // Catatan: preferredMode tidak di-set default di sini, melainkan disediakan saat registrasi user.
    };
  }

  // Registrasi pengguna baru; jika tidak diberikan preferensi, user dianggap cold start.
  registerUser(userId, preferredMode = null) {
    const userRecord = {
      interactions: [],
      preferences: preferredMode || "Commuter Line", // Misalnya, "Commuter Line"
      isColdStart: true,
      embedding: null
    };
    this.userData.set(userId, userRecord);
  }

  // Fungsi utama untuk menghasilkan rekomendasi rute.
  // currentLocation dan destination di sini diharapkan merupakan node (dari graph) yang telah dibuat.
  recommend(userId, currentLocation, destination, graph) {

    const candidateRoutes = this.pathFinder.findRoutes(currentLocation, destination, graph);
    console.log("candidateRoutes : ", candidateRoutes);
    const user = this.userData.get(userId);
    let recommendations;
    if (!user || user.isColdStart || user.interactions.length < this.config.coldStartThreshold) {

      recommendations = this._coldStartRecommendation(user, candidateRoutes);
    } else {
      recommendations = this._hybridRecommendation(userId, candidateRoutes);
    }
    return recommendations.sort((a, b) => b.score - a.score);
  }

  // Rule-based scoring: menghitung persentase segmen dalam route yang memiliki mode sesuai preferensi.
  _calculateRuleBasedScore(route, preferredMode) {
    if (!preferredMode) return 0;

    if (!route.segments) {
      route.segments = []
    }

    const matchingSegments = route.segments.filter(
      segment => segment.mode.toLowerCase() === preferredMode.toLowerCase()
    ).length;
    const totalSegments = route.segments.length;
    return totalSegments > 0 ? matchingSegments / totalSegments : 0;
  }

  _coldStartRecommendation(user, routes) {
    const preferredMode = user && user.preferences ? user.preferences : null;
    return routes.map(route => ({
      route,
      score: this._calculateRuleBasedScore(route, preferredMode)
    }));
  }

  // Collaborative filtering scoring: hitung dot product antara embedding pengguna dan embedding rute.
  _calculateCFScores(userId, routes) {
    const user = this.userData.get(userId);
    if (!user || !user.embedding) return routes.map(() => 1);
    const userEmb = user.embedding;
    return routes.map(route => {
      const routeId = route.id;
      const routeEmb = this.routeEmbeddings.get(routeId) || this._initializeRouteEmbedding(routeId);
      return math.dot(userEmb, routeEmb);
    });
  }

  _hybridRecommendation(userId, routes) {
    const cfScores = this._calculateCFScores(userId, routes);
    const preferredMode = this.userData.get(userId).preferences;
    const rbScores = routes.map(route => this._calculateRuleBasedScore(route, preferredMode));
    return routes.map((route, i) => ({
      route,
      score: (this.config.hybridWeights.cf * cfScores[i]) +
        (this.config.hybridWeights.rb * rbScores[i])
    }));
  }

  updateUserChoice(userId, chosenRoute) {
    const user = this.userData.get(userId);
    if (!user) return;
    user.interactions.push(chosenRoute.id);
    if (!user.embedding) {
      user.embedding = this._initializeEmbedding();
    }
    if (!this.routeEmbeddings.has(chosenRoute.id)) {
      this.routeEmbeddings.set(chosenRoute.id, this._initializeRouteEmbedding(chosenRoute.id));
    }
    this._updateEmbeddings(user, chosenRoute.id);
    this.trainingData.push({ userId, routeId: chosenRoute.id, rating: 1 });
    if (user.interactions.length >= this.config.coldStartThreshold) {
      user.isColdStart = false;
      // Lakukan pembaruan batch menggunakan SVD untuk menyelaraskan embedding
      this._trainSVD({ k: 1, learningRate: 0.005, iterations: 5 });
    }
  }

  _initializeEmbedding() {
    return math.random([this.config.embeddingDimensions], 0, 6 / this.config.embeddingDimensions);
  }

  _initializeRouteEmbedding(routeId) {
    if (!this.routeEmbeddings.has(routeId)) {
      this.routeEmbeddings.set(routeId, this._initializeEmbedding());
    }
    return this.routeEmbeddings.get(routeId);
  }

  _updateEmbeddings(user, routeId) {
    const userEmb = user.embedding;
    const routeEmb = this._initializeRouteEmbedding(routeId);
    const error = 1 - math.dot(userEmb, routeEmb); // Target rating = 1 (positif)
    const userGrad = math.multiply(error, routeEmb);
    const routeGrad = math.multiply(error, userEmb);
    user.embedding = math.add(userEmb, math.multiply(this.config.learningRate, userGrad));
    this.routeEmbeddings.set(routeId, math.add(routeEmb, math.multiply(this.config.learningRate, routeGrad)));
  }

  // --- Metode Matrix Factorization dengan SVD ---
  // Pendekatan ini menggunakan update batch sederhana menggunakan SVD via gradient descent.
  _trainSVD(config) {
    // Buat mapping user dan route dari trainingData
    const userMap = Array.from(this.userData.keys());
    const routeMap = Array.from(this.routeEmbeddings.keys());

    // Inisialisasi faktor laten untuk pengguna dan rute
    const U = userMap.map(userId =>
      this.userData.get(userId).embedding || math.random([config.k], 0, 6 / config.k)
    );
    const V = routeMap.map(routeId =>
      this.routeEmbeddings.get(routeId) || math.random([config.k], 0, 6 / config.k)
    );

    // Lakukan training dengan iterasi sederhana (gradient descent) untuk menyelaraskan faktor.
    for (let iter = 0; iter < config.iterations; iter++) {
      this.trainingData.forEach(({ userId, routeId, rating }) => {
        const uIdx = userMap.indexOf(userId);
        const vIdx = routeMap.indexOf(routeId);
        const u = U[uIdx];
        const v = V[vIdx];
        const pred = math.dot(u, v);
        const err = rating - pred;
        // Update faktor: gradient descent sederhana
        U[uIdx] = math.add(u, math.multiply(config.learningRate * err, v));
        V[vIdx] = math.add(v, math.multiply(config.learningRate * err, u));
      });
    }

    // Update embedding untuk masing-masing user dan rute
    userMap.forEach((userId, idx) => {
      this.userData.get(userId).embedding = U[idx];
    });
    routeMap.forEach((routeId, idx) => {
      this.routeEmbeddings.set(routeId, V[idx]);
    });
  }

  addRoute(routeData) {
    if (!this.routes) this.routes = new Map();
    this.routes.set(routeData.id, routeData);
  }
}

module.exports = TransportationRecommender;
