const math = require('mathjs');
const mysql = require("mysql");
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "lokamotiveBINUS",
  password: process.env.DB_PASSWORD || "lokamotive123",
  database: process.env.DB_NAME || "lokamotive",
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database connection failed:", err);
    return;
  }
  console.log("✅ Connected to MySQL");
});

/**
 * Kelas untuk merekomendasikan transportasi umum berdasarkan data pengguna, preferensi, 
 * serta embedding dan data training. Kelas ini menggunakan metode hybrid (cold start dan collaborative filtering)
 * untuk menentukan rekomendasi rute yang optimal.
 *
 * @author Jessica Nathania Wenardi, Fritz Gradiyoga
 */
class TransportationRecommender {
  /**
   * Membuat instance TransportationRecommender.
   *
   * @param {Object} pathFinder - Objek yang menyediakan metode findRoutes(currentLocation, destination, graph)
   *                              untuk mencari rute berdasarkan lokasi saat ini dan tujuan.
   */
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
      embeddingDimensions: 1,
      learningRate: 0.05,
      coldStartThreshold: 3, // Minimal interaksi untuk hybrid recommendation
      hybridWeights: { cf: 0.7, rb: 0.3 }
      // Catatan: preferredMode tidak di-set default di sini, melainkan disediakan saat registrasi user.
    };
  }

  /**
   * Menginisialisasi data pengguna dengan memuat data dari database dan melakukan registrasi
   * jika data pengguna tidak ditemukan.
   *
   * @param {string} userId - ID unik pengguna.
   * @param {string} preference - Preferensi mode transportasi pengguna.
   */
  initialize(userId, preference) {
    this.loadUserDataFromDatabase();
    setTimeout(() => {
      console.log("User data loaded from database:", this.userData);
      // Register user if not exists
      if (!this.userData.has(userId)) {
        this.registerUser(userId, preference);
      }
    }, 1500);
  }

  /**
   * Memuat data preferensi pengguna dari database dan menyimpannya ke dalam Map userData.
   *
   */
  loadUserDataFromDatabase() {
    db.query("SELECT * FROM userpreference", (err, results) => {
      if (err) {
        console.error("❌ Error fetching user:", err);
        ws.send(JSON.stringify({ status: "error", message: "Database query failed" }));
        return;
      }
      console.log("User data fetched from database:", results);
      // Populate userData map with data from database
      results.forEach((row) => {
        let userRecord = {
          interactions: row.interaction,
          preferences: row.preferences,
          isColdStart: row.isColdStart,
          embedding: row.embedding
        };
        this.userData.set(row.id, userRecord);
      })
    });
  }

  /**
   * Menyimpan data pengguna baru ke dalam database.
   *
   * @param {string} userId - ID unik pengguna.
   * @param {Object} userRecord - Objek data pengguna yang berisi interactions, preferences, isColdStart, dan embedding.
   */
  storeDatatoDatabase(userId, userRecord) {
    db.query(`INSERT INTO userpreference (id, interaction, preferences, isColdStart, embedding) VALUES ('${userId}', ${userRecord.interactions}, '${userRecord.preferences}', ${userRecord.isColdStart}, ${userRecord.embedding})`)
  }

  /**
   * Memperbarui data pengguna yang telah ada dalam database.
   *
   * @param {string} userId - ID unik pengguna.
   * @param {Object} userRecord - Objek data pengguna yang berisi interactions, preferences, isColdStart, dan embedding.
   */
  updateDatabase(userId, userRecord) {
    db.query(`UPDATE userpreference SET interaction = ${userRecord.interactions}, preferences = '${userRecord.preferences}', isColdStart = ${userRecord.isColdStart}, embedding = ${userRecord.embedding} WHERE id = '${userId}'`)
  }

  // Registrasi pengguna baru; jika tidak diberikan preferensi, user dianggap cold start.
  /**
   * Mendaftarkan pengguna baru. Jika tidak diberikan preferensi, maka pengguna dianggap memiliki mode default "Commuter Line".
   *
   * @param {string} userId - ID unik pengguna.
   * @param {string} [preferredMode="Commuter Line"] - Mode transportasi yang dipilih pengguna.
   */
  registerUser(userId, preferredMode = "Commuter Line") {
    const userRecord = {
      interactions: 0,
      preferences: preferredMode || "Commuter Line", // Misalnya, "Commuter Line"
      isColdStart: true,
      embedding: null
    };
    this.userData.set(userId, userRecord);
    this.storeDatatoDatabase(userId, userRecord);
  }

  // Fungsi utama untuk menghasilkan rekomendasi rute.
  // currentLocation dan destination di sini diharapkan merupakan node (dari graph) yang telah dibuat.
  /**
   * Menghasilkan rekomendasi rute untuk pengguna berdasarkan lokasi saat ini, tujuan, dan graph yang diberikan.
   * Metode yang digunakan akan memilih antara rekomendasi cold start atau hybrid berdasarkan interaksi pengguna.
   *
   * @param {string} userId - ID unik pengguna.
   * @param {Object} currentLocation - Objek node yang merepresentasikan lokasi pengguna saat ini.
   * @param {Object} destination - Objek node yang merepresentasikan tujuan pengguna.
   * @param {Object} graph - Struktur graph yang digunakan untuk menemukan rute.
   * @return {Object[]} - Array rekomendasi rute yang telah diurutkan berdasarkan skor (score).
   */
  recommend(userId, currentLocation, destination, graph) {
    const candidateRoutes = this.pathFinder.findRoutes(currentLocation, destination, graph);
    console.log("candidateRoutes : ", candidateRoutes);
    const user = this.userData.get(userId);
    let recommendations;
    console.log(this.userData)
    if (!user || user.isColdStart || user.interactions < this.config.coldStartThreshold) {
      console.log("Cold Start Recommendation");
      recommendations = this._coldStartRecommendation(user, candidateRoutes);
    } else {
      console.log("Hybrid Recommendation");
      recommendations = this._hybridRecommendation(userId, candidateRoutes);
    }
    console.log("bang mau lihat :", recommendations)
    this.updateUserChoice(userId, recommendations[0].route);
    return recommendations.sort((a, b) => b.score - a.score);
  }

  // Rule-based scoring: menghitung persentase segmen dalam route yang memiliki mode sesuai preferensi.
  /**
   * Menghitung skor berbasis aturan (rule-based) dengan menghitung persentase segmen rute yang sesuai dengan preferensi mode.
   *
   * @private
   * @param {Object} route - Objek data rute yang memiliki properti segments.
   * @param {string} preferredMode - Mode transportasi yang menjadi preferensi pengguna.
   * @return {number} - Persentase kesesuaian antara segmen rute dengan preferensi.
   */
  _calculateRuleBasedScore(route, preferredMode) {
    if (!preferredMode) return 0;

    if (!route.segments) {
      route.segments = []
    }

    // console.log("Route Segments : ", route.segments)

    const matchingSegments = route.segments.filter(
      (segment) => {
        console.log("Segment : ", segment.mode.toLowerCase(), preferredMode.toLowerCase())
        return segment.mode.toLowerCase() === preferredMode.toLowerCase()
      }).length;

    console.log("Matching Segments : ", matchingSegments)

    const totalSegments = route.segments.length;
    console.log("Total Segments : ", totalSegments)
    return totalSegments > 0 ? matchingSegments / totalSegments : 0;
  }

  /**
   * Menghasilkan rekomendasi cold start berdasarkan rule-based scoring untuk masing-masing rute.
   *
   * @private
   * @param {Object} user - Objek data pengguna.
   * @param {Object[]} routes - Array daftar rute kandidat.
   * @return {Object[]} - Array rekomendasi yang berisi objek dengan properti route dan score.
   */
  _coldStartRecommendation(user, routes) {
    // console.log("Cold start recommendation for user:", user);
    // console.log("Preferred mode:", user.preferences);
    const preferredMode = user && user.preferences ? user.preferences : null;
    // console.log("preferredMode : ", preferredMode)
    return routes.map(route => ({
      route,
      score: this._calculateRuleBasedScore(route, preferredMode)
    }));
  }

  // Collaborative filtering scoring: hitung dot product antara embedding pengguna dan embedding rute.
  /**
   * Menghitung skor untuk collaborative filtering dengan melakukan perkalian dot product antara embedding pengguna dan rute.
   *
   * @private
   * @param {string} userId - ID pengguna.
   * @param {Object[]} routes - Array rute kandidat.
   * @return {number[]} - Array skor collaborative filtering untuk setiap rute.
   */
  _calculateCFScores(userId, routes) {
    const user = this.userData.get(userId);
    if (!user || !user.embedding) return routes.map(() => 1);
    const userEmb = [user.embedding];
    return routes.map(route => {
      const routeId = route.id;
      const routeEmb = this.routeEmbeddings.get(routeId) || this._initializeRouteEmbedding(routeId);
      return math.dot(userEmb, routeEmb);
    });
  }

  /**
   * Menghasilkan rekomendasi hybrid dengan menggabungkan collaborative filtering (CF) dan rule-based (RB) scoring.
   *
   * @private
   * @param {string} userId - ID pengguna.
   * @param {Object[]} routes - Array rute kandidat.
   * @return {Object[]} - Array rekomendasi yang berisi objek dengan properti route dan score.
   */
  _hybridRecommendation(userId, routes) {
    const cfScores = this._calculateCFScores(userId, routes);
    const preferredMode = this.userData.get(userId).preferences;
    const rbScores = routes.map(route =>
      this._calculateRuleBasedScore(route, preferredMode));
    return routes.map((route, i) => ({
      route,
      score: (this.config.hybridWeights.cf * cfScores[i]) +
        (this.config.hybridWeights.rb * rbScores[i])
    }));
  }

  /**
   * Memperbarui interaksi dan embedding pengguna ketika pengguna memilih sebuah rute.
   * Juga menambahkan data training dan melakukan pembaruan batch dengan SVD jika interaksi sudah mencapai threshold.
   *
   * @param {string} userId - ID pengguna.
   * @param {Object} chosenRoute - Objek rute yang dipilih oleh pengguna.
   */
  updateUserChoice(userId, chosenRoute) {
    const user = this.userData.get(userId);
    if (!user) return;
    user.interactions += 1;
    if (!user.embedding) {
      user.embedding = this._initializeEmbedding();
    }
    if (!this.routeEmbeddings.has(chosenRoute.id)) {
      this.routeEmbeddings.set(chosenRoute.id, this._initializeRouteEmbedding(chosenRoute.id));
    }
    this._updateEmbeddings(user, chosenRoute.id);
    this.trainingData.push({ userId, routeId: chosenRoute.id, rating: 1 });
    if (user.interactions >= this.config.coldStartThreshold) {
      user.isColdStart = false;
      console.log("User is no longer cold start:");
      // Lakukan pembaruan batch menggunakan SVD untuk menyelaraskan embedding
      this._trainSVD({ k: 1, learningRate: 0.005, iterations: 5 });
    }

    this.updateDatabase(userId, user);
  }

   /**
   * Menginisialisasi embedding untuk pengguna dengan nilai random berdasarkan dimensi embedding yang telah dikonfigurasi.
   *
   * @private
   * @return {number[]} - Embedding awal pengguna.
   */
  _initializeEmbedding() {
    return math.random([this.config.embeddingDimensions]
      , 0, 6 / this.config.embeddingDimensions);
  }

  /**
   * Mengembalikan embedding untuk rute. Jika embedding belum ada, maka akan diinisialisasi terlebih dahulu.
   *
   * @private
   * @param {string} routeId - ID rute.
   * @return {number[]} - Embedding rute.
   */
  _initializeRouteEmbedding(routeId) {
    if (!this.routeEmbeddings.has(routeId)) {
      this.routeEmbeddings.set(routeId, this._initializeEmbedding());
    }
    return this.routeEmbeddings.get(routeId);
  }

  /**
   * Memperbarui embedding pengguna dan rute berdasarkan error rating dan learning rate yang telah dikonfigurasi.
   *
   * @private
   * @param {Object} user - Objek data pengguna yang berisi embedding.
   * @param {string} routeId - ID rute yang dipilih.
   */
  _updateEmbeddings(user, routeId) {
    const userEmb = [user.embedding];
    const routeEmb = this._initializeRouteEmbedding(routeId);
    console.log("Embeddings :", routeEmb, userEmb)
    const error = 1 - math.dot(userEmb, routeEmb); // Target rating = 1 (positif)
    const userGrad = math.multiply(error, routeEmb);
    const routeGrad = math.multiply(error, userEmb);
    user.embedding = math.add(userEmb, math.multiply(this.config.learningRate, userGrad));
    this.routeEmbeddings.set(routeId, math.add(routeEmb, math.multiply(this.config.learningRate, routeGrad)));
  }

  // --- Metode Matrix Factorization dengan SVD ---
  // Pendekatan ini menggunakan update batch sederhana menggunakan SVD via gradient descent.
  /**
   * Melakukan training batch menggunakan metode Matrix Factorization dengan SVD (Singular Value Decomposition)
   * melalui gradient descent sederhana untuk menyelaraskan embedding pengguna dan rute berdasarkan data training.
   *
   * @private
   * @param {Object} config - Konfigurasi training yang berisi properti k (faktor laten), learningRate, dan iterations.
   */
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

   /**
   * Menambahkan data rute baru ke dalam daftar rute.
   *
   * @param {Object} routeData - Objek data rute yang harus memiliki properti id.
   */
  addRoute(routeData) {
    if (!this.routes) this.routes = new Map();
    this.routes.set(routeData.id, routeData);
  }
}

module.exports = TransportationRecommender;
