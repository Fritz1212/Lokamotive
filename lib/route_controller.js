const GraphBuilder = require('./graph_builder.js');
const RouteSearchService = require('./route_search.js');
const AlternativeRouteService = require('./alternate_route.js');
const util = require('util');

// Fungsi getEffectiveWeight bisa didefinisikan di sini atau di RouteSearchService
// Contoh implementasi sederhana:
function getEffectiveWeight(edge) {
  let w = edge.details.time; // asumsikan edge.details.time sebagai cost dasar
  // Contoh rule-based: jika mode adalah "Commuter Line", kurangi cost
  if (edge.mode === "Commuter Line") {
    w -= 2;
    if (w < 0) w = 0.1;
  }
  // Jika mode adalah "Bus Transjakarta", tambahkan penalti
  if (edge.mode === "Bus Transjakarta") {
    w += 5;
  }
  return w;
}

// Membuat versi extended RouteSearchService agar getEffectiveWeight tersedia
class RouteSearchServiceExtended {
  constructor(graph, userPreference) {
    this.graph = graph;
    this.userPreference = userPreference;
  }
  dijkstra(startId, endId) {
    const { dijkstra } = require('../services/route_search.js');
    return dijkstra(this.graph, startId, endId);
  }
  idaStar(startId, endId) {
    const { idaStar } = require('../services/route_search.js');
    return idaStar(this.graph, startId, endId);
  }
  getEffectiveWeight(edge) {
    return getEffectiveWeight(edge);
  }
}

exports.getRoutes = async (req, res) => {
  try {
    const { start, destination, preference, k } = req.query;
    if (!start || !destination) {
      return res.status(400).json({ error: "Parameter 'start' dan 'destination' wajib diisi." });
    }

    // Ambil data stop menggunakan StopService (di sini diasumsikan StopService.getStops() mengembalikan array objek stop)
    // Buat Map dengan key berupa nama stasiun dalam huruf kecil
    const stopMap = new Map(stops.map(stop => [stop.name.toLowerCase(), stop]));
    const startStop = stopMap.get(start.toLowerCase());
    const destStop = stopMap.get(destination.toLowerCase());

    if (!startStop || !destStop) {
      return res.status(404).json({ error: "Lokasi start atau destination tidak ditemukan." });
    }

    // Bangun graph multi-modal secara dinamis
    const graph = await GraphBuilder.buildGraph();
    console.log(graph)

    // Pastikan kita mendapatkan node dari graph berdasarkan id yang sama dengan StopService
    // Asumsikan bahwa node.id sama dengan stop.id
    const routeSearchService = new RouteSearchServiceExtended(graph, preference || "CL");
    const altRouteService = new AlternativeRouteService(graph, routeSearchService);

    // Cari k-shortest paths dari start ke destination
    const routesFound = altRouteService.findKShortestPaths(startStop.id.toString(), destStop.id.toString(), parseInt(k) || 3);

    if (!routesFound || routesFound.length === 0) {
      return res.status(404).json({ error: "Tidak ada rute yang ditemukan." });
    }

    // Format hasil rute untuk output seperti contoh:
    const formattedRoutes = routesFound.map((route, idx) => {
      const segmentsStr = route.path.map(edge => {
        // Misalnya, jika edge.details.route ada, gunakan itu
        return `${edge.mode} ${edge.details.route || ""}`.trim();
      }).join(" → ");

      // Simulasi tambahan info seperti leaves_in dan cost (ini bisa digantikan dengan perhitungan aktual)
      const totalTime = route.totalWeight;
      const leavesIn = idx === 0 ? 30 : 12;
      const cost = idx === 0 ? 10000 : 12000;

      return {
        routeId: idx + 1,
        totalTime: `${totalTime} min total`,
        description: segmentsStr,
        info: `Leaves in ${leavesIn} min, Cost Rp ${cost}`
      };
    });

    res.json({ routes: formattedRoutes });
  } catch (error) {
    console.error("Error getting routes:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};