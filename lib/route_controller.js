// src/controllers/route_controller.js
const GraphBuilder = require('./graph_builder.js');
const RouteSearchService = require('./route_search.js');
const AlternativeRouteService = require('./alternate_route.js');
const TransportationRecommender = require('./collaborative_filtering.js');

class RouteController {
  constructor() {
    // Inisialisasi PathFinder melalui GraphBuilder
    // Kita asumsikan GraphBuilder sudah membangun graph secara menyeluruh
    // dan setiap stop sudah ada di dalam graph.
    this.graphBuilder = GraphBuilder;
    // Inisialisasi PathFinder dengan konfigurasi opsional (misal, preferensi real-time)
    const PathFinder = require('./path_finder');
    this.pathFinder = new PathFinder({}); // Tanpa default preferensi; nanti pengguna menentukan
    this.pathFinder.initialize();
    // Inisialisasi TransportationRecommender dengan pathFinder
    this.recommender = new TransportationRecommender(this.pathFinder);
  }

  async getRecommendedRoutes(req, res) {
    try {
      // Ambil parameter query: userId, start, destination, (opsional) preference, k
      const { userId, start, destination, preference, k } = req.query;
      if (!userId || !start || !destination) {
        return res.status(400).json({ error: "Parameter 'userId', 'start', dan 'destination' wajib diisi." });
      }

      // Karena semua stop sudah ada di graph, kita cari node di graph berdasarkan nama (case-insensitive)
      const graph = await this.graphBuilder.buildGraph();
      const nodes = Object.values(graph.nodes);
      const startStop = nodes.find(n => n.name.toLowerCase() === start.toLowerCase());
      const destStop = nodes.find(n => n.name.toLowerCase() === destination.toLowerCase());
      if (!startStop || !destStop) {
        return res.status(404).json({ error: "Lokasi start atau destination tidak ditemukan dalam graph." });
      }

      // Jika pengguna belum terdaftar, daftarkan dengan preferensi yang diberikan (jika ada)
      // Jangan tetapkan default di sini, karena preferensi harus diambil dari input user.
      if (!this.recommender.userData.has(userId)) {
        this.recommender.registerUser(userId, preference);
      }

      // Dapatkan rekomendasi rute dari recommender
      const recommendations = this.recommender.recommend(userId, startStop, destStop);

      // Format output: setiap rute berisi routeId, score, description (gabungan segmen), dan totalTime
      const formattedRoutes = recommendations.map((rec, idx) => {
        const route = rec.route;
        const segmentsStr = route.segments
          .map(seg => `${seg.mode} ${seg.details.route || ""}`.trim())
          .join(" → ");
        return {
          routeId: route.id,
          score: rec.score.toFixed(2),
          description: segmentsStr,
          totalTime: `${route.totalWeight} min`
        };
      });

      res.json({ routes: formattedRoutes });
    } catch (error) {
      console.error("Error in getRecommendedRoutes:", error);
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = RouteController;
