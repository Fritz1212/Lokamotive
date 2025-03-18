// const math = require('mathjs');
// const brain = require('brain.js');

// class TransportationRecommender {
//   constructor(pathFinder) {
//     this.pathFinder = pathFinder; // Object yang menyediakan findRoutes(currentLocation, destination)
//     this.userData = new Map();    // Map: userId -> { isColdStart, preferences, interactions, embedding }
//     this.routes = new Map();      // Map: routeId -> routeData (untuk update preferensi)
//     this.userEmbeddings = new Map();
//     this.routeEmbeddings = new Map();
    
//     this.config = {
//       embeddingDimensions: 10,
//       learningRate: 0.05,
//       coldStartThreshold: 3, // misalnya, < 3 interaksi = cold start
//       hybridWeights: { cf: 0.7, rb: 0.3 },
//       ruleBased: {
//         timeThreshold: 30,    // menit
//         costThreshold: 15000,
//         comfortThreshold: 3,
//         weights: { time: 0.4, cost: 0.3, comfort: 0.3 }
//       }
//     };

//     // Neural network untuk fine-tuning (opsional, dilatih offline atau dengan iterasi rendah)
//     this.net = new brain.NeuralNetwork({ hiddenLayers: [10] });
//     this.isModelTrained = false;
//     this.trainingData = []; // Data interaksi untuk retraining neural network
//   }

//   // Saat pengguna mendaftar, jika tidak ada preferensi, maka set sebagai cold start
//   registerUser(userId, preferences = null) {
//     const userRecord = {
//       interactions: [],
//       preferences: preferences || { ...this.config.ruleBased },
//       isColdStart: !preferences,
//       embedding: null
//     };
//     this.userData.set(userId, userRecord);
//   }

//   // Fungsi untuk menghasilkan rekomendasi rute
//   recommend(userId, currentLocation, destination) {
//     const candidateRoutes = this.pathFinder.findRoutes(currentLocation, destination);
//     const user = this.userData.get(userId);
//     let recommendations;
//     if (!user || user.isColdStart || user.interactions.length < this.config.coldStartThreshold) {
//       recommendations = this._applyRuleBasedScoring(candidateRoutes, this.config.ruleBased);
//     } else {
//       recommendations = this._hybridRecommendation(userId, candidateRoutes);
//     }
//     return recommendations.sort((a, b) => b.score - a.score);
//   }

//   // Rule-based scoring untuk setiap candidate route
//   _applyRuleBasedScoring(routes, preferences) {
//     return routes.map(route => {
//       let score = 0;
//       // Misalnya, setiap segmen rute diperiksa dan jika mode sesuai preferensi, diberi nilai penuh
//       route.segments.forEach(segment => {
//         if (segment.mode === preferences.preferredTransport || segment.mode === "Commuter Line") {
//           score += preferences.weights.time; // atau bisa disesuaikan per kriteria
//         }
//       });
//       return { route, score };
//     });
//   }

//   // Collaborative filtering scoring berdasarkan dot product antara embedding pengguna dan rute
//   _calculateCFScores(userId, routes) {
//     const user = this.userData.get(userId);
//     if (!user || !user.embedding) return routes.map(() => 1);
//     const userEmb = user.embedding;
//     return routes.map(route => {
//       const routeId = route.id;
//       const routeEmb = this.routeEmbeddings.get(routeId) || this._initializeRouteEmbedding(routeId);
//       return math.dot(userEmb, routeEmb);
//     });
//   }

//   // Hybrid recommendation: gabungkan skor CF dan rule-based
//   _hybridRecommendation(userId, routes) {
//     const cfScores = this._calculateCFScores(userId, routes);
//     const rbScores = this._applyRuleBasedScoring(routes, this.userData.get(userId).preferences)
//                       .map(obj => obj.score);
//     return routes.map((route, i) => ({
//       route,
//       score: (this.config.hybridWeights.cf * cfScores[i]) + (this.config.hybridWeights.rb * rbScores[i])
//     }));
//   }

//   // Update model berdasarkan pilihan pengguna
//   updateUserChoice(userId, chosenRoute) {
//     const user = this.userData.get(userId);
//     if (!user) return;
//     user.interactions.push(chosenRoute.id);
    
//     // Inisialisasi embedding jika belum ada
//     if (!user.embedding) {
//       user.embedding = this._initializeEmbedding();
//     }
//     if (!this.routeEmbeddings.has(chosenRoute.id)) {
//       this.routeEmbeddings.set(chosenRoute.id, this._initializeRouteEmbedding(chosenRoute.id));
//     }
//     this._updateEmbeddings(user, chosenRoute.id);
//     this.trainingData.push({ userId, routeId: chosenRoute.id, rating: 1 });
//     if (user.interactions.length >= this.config.coldStartThreshold) {
//       user.isColdStart = false;
//       this._updateUserPreferences(user);
//       // Retrain neural network dengan iterasi singkat agar tidak menghambat respon
//       this._retrainNeuralNetwork();
//     }
//   }

//   _initializeEmbedding() {
//     return math.random([this.config.embeddingDimensions], 0, 6 / this.config.embeddingDimensions);
//   }

//   _initializeRouteEmbedding(routeId) {
//     if (!this.routeEmbeddings.has(routeId)) {
//       this.routeEmbeddings.set(routeId, this._initializeEmbedding());
//     }
//     return this.routeEmbeddings.get(routeId);
//   }

//   _updateEmbeddings(user, routeId) {
//     const userEmb = user.embedding;
//     const routeEmb = this._initializeRouteEmbedding(routeId);
//     const error = 1 - math.dot(userEmb, routeEmb); // Target rating = 1 (positif)
//     const userGrad = math.multiply(error, routeEmb);
//     const routeGrad = math.multiply(error, userEmb);
//     user.embedding = math.add(userEmb, math.multiply(this.learningRate, userGrad));
//     this.routeEmbeddings.set(routeId, math.add(routeEmb, math.multiply(this.learningRate, routeGrad)));
//   }

//   _updateUserPreferences(user) {
//     const interactions = user.interactions.map(id => this.routes.get(id)).filter(Boolean);
//     if (interactions.length === 0) return;
//     const totals = interactions.reduce((acc, route) => ({
//       duration: acc.duration + route.duration,
//       cost: acc.cost + route.cost,
//       comfort: acc.comfort + route.comfort
//     }), { duration: 0, cost: 0, comfort: 0 });
//     const avgDuration = totals.duration / interactions.length;
//     const avgCost = totals.cost / interactions.length;
//     const avgComfort = totals.comfort / interactions.length;
//     user.preferences = {
//       ...user.preferences,
//       timeThreshold: avgDuration * 0.8,
//       costThreshold: avgCost * 1.2,
//       comfortThreshold: avgComfort * 0.9,
//       weights: user.preferences.weights
//     };
//     user.isColdStart = false;
//   }

//   _retrainNeuralNetwork() {
//     if (this.trainingData.length === 0) return;
//     const trainingData = this.trainingData.map(entry => {
//       const userRecord = this.userData.get(entry.userId);
//       const userEmb = userRecord ? userRecord.embedding : math.zeros(this.config.embeddingDimensions);
//       const routeEmb = this.routeEmbeddings.get(entry.routeId) || math.zeros(this.config.embeddingDimensions);
//       return {
//         input: userEmb.concat(routeEmb),
//         output: [entry.rating / 5] // Normalisasi rating ke [0, 1]
//       };
//     });
//     const result = this.net.train(trainingData, { iterations: 500, log: false });
//     console.log("Neural network retrained:", result);
//     this.isModelTrained = true;
//   }

//   // Untuk menambahkan data rute baru ke dalam sistem
//   addRoute(routeData) {
//     if (!this.routes) this.routes = new Map();
//     this.routes.set(routeData.id, routeData);
//   }
// }

// module.exports = TransportationRecommender;

const math = require('mathjs');
const brain = require('brain.js');
const PathFinder = require('./path_finder')

class TransportationRecommender {
  constructor(pathFinder) {
    // pathFinder: objek yang menyediakan metode findRoutes(currentLocation, destination)
    this.pathFinder = pathFinder;
    // Data pengguna: userId -> { isColdStart, preferences, interactions, embedding }
    this.userData = new Map();
    // Data rute: routeId -> routeData (untuk update preferensi, jika diperlukan)
    this.routes = new Map();
    // Collaborative filtering embeddings untuk user dan rute
    this.userEmbeddings = new Map();  // userId -> vector (array)
    this.routeEmbeddings = new Map(); // routeId -> vector (array)
    // Data training untuk neural network (opsional)
    this.trainingData = [];
    // Neural network untuk fine-tuning (opsional)
    this.net = new brain.NeuralNetwork({ hiddenLayers: [10] });
    this.isModelTrained = false;
    // Konfigurasi dasar
    this.config = {
      embeddingDimensions: 10,
      learningRate: 0.05,
      coldStartThreshold: 3, // Minimal interaksi untuk hybrid recommendation
      hybridWeights: { cf: 0.7, rb: 0.3 },
      // Preferensi rule-based: hanya berdasarkan mode transportasi.
      // Misalnya, jika pengguna memilih "Commuter Line", maka rute yang memiliki
      // proporsi segmen dengan mode "Commuter Line" yang tinggi akan mendapatkan skor lebih tinggi.
      preferredMode: this.userData.preferences(), //"Commuter Line"
    };
  }

  // Saat pengguna mendaftar, jika mereka tidak memilih preferensi,
  // maka kita gunakan preferensi default (misalnya, "Commuter Line")
  registerUser(userId, preferredMode = null) {
    const userRecord = {
      interactions: [],
      preferences: preferredMode || this.config.preferredMode,
      isColdStart: !preferredMode,
      embedding: null
    };
    this.userData.set(userId, userRecord);
  }

  // Fungsi utama untuk menghasilkan rekomendasi rute
  recommend(userId, currentLocation, destination) {
    const candidateRoutes = this.pathFinder.findRoutes(currentLocation, destination);
    const user = this.userData.get(userId);
    let recommendations;
    if (!user || user.isColdStart || user.interactions.length < this.config.coldStartThreshold) {
      recommendations = this._coldStartRecommendation(user, candidateRoutes);
    } else {
      recommendations = this._hybridRecommendation(userId, candidateRoutes);
    }
    return recommendations.sort((a, b) => b.score - a.score);
  }

  // Rule-based scoring hanya berdasarkan kesesuaian mode
  _calculateRuleBasedScore(route, preferredMode) {
    // Hitung persentase segmen dalam route yang memiliki mode sama dengan preferredMode
    const matchingSegments = route.segments.filter(segment => segment.mode === preferredMode).length;
    const totalSegments = route.segments.length;
    return totalSegments > 0 ? matchingSegments / totalSegments : 0;
  }

  _coldStartRecommendation(user, routes) {
    const preferredMode = user ? user.preferences : this.config.preferredMode;
    return routes.map(route => ({
      route,
      score: this._calculateRuleBasedScore(route, preferredMode)
    }));
  }

  // Collaborative filtering scoring menggunakan dot product antara embedding pengguna dan embedding rute
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
    // Inisialisasi embedding jika belum ada
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
      this._retrainNeuralNetwork();
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

  _retrainNeuralNetwork() {
    if (this.trainingData.length === 0) return;
    const trainingData = this.trainingData.map(entry => {
      const userRecord = this.userData.get(entry.userId);
      const userEmb = userRecord ? userRecord.embedding : math.zeros(this.config.embeddingDimensions);
      const routeEmb = this.routeEmbeddings.get(entry.routeId) || math.zeros(this.config.embeddingDimensions);
      return {
        input: userEmb.concat(routeEmb),
        output: [entry.rating / 5]
      };
    });
    const result = this.net.train(trainingData, { iterations: 100, log: false });
    console.log("Neural network retrained:", result);
    this.isModelTrained = true;
  }

  addRoute(routeData) {
    if (!this.routes) this.routes = new Map();
    this.routes.set(routeData.id, routeData);
  }
}

module.exports = TransportationRecommender;
