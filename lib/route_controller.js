const GraphBuilder = require('./GraphBuilder');
const { dijkstra, idaStar, heuristic } = require('./route_search.js');
const AlternativeRouteService = require('./alternate_route.js');

// Contoh fungsi getEffectiveWeight sederhana
function getEffectiveWeight(edge) {
  let w = edge.details.time; // asumsikan waktu sebagai cost dasar
  if (edge.mode === "Commuter Line") {
    w -= 2;
    if (w < 0) w = 0.1;
  }
  if (edge.mode === "Bus Transjakarta") {
    w += 5;
  }
  return w;
}

// Extended RouteSearchService yang menyediakan getEffectiveWeight
class RouteSearchServiceExtended {
  constructor(graph, userPreference) {
    this.graph = graph;
    this.userPreference = userPreference;
  }
  dijkstra(startId, endId) {
    return dijkstra(this.graph, startId, endId);
  }
  idaStar(startId, endId) {
    return idaStar(this.graph, startId, endId, heuristic);
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

    // Bangun graph multimoda
    const graph = await GraphBuilder.buildGraph();

    // Cari node berdasarkan nama (pencocokan case-insensitive)
    let startNode = null;
    let endNode = null;
    Object.values(graph.nodes).forEach(node => {
      if (node.name.toLowerCase() === start.toLowerCase()) startNode = node;
      if (node.name.toLowerCase() === destination.toLowerCase()) endNode = node;
    });

    if (!startNode || !endNode) {
      return res.status(404).json({ error: "Lokasi start atau destination tidak ditemukan dalam graph." });
    }

    const routeSearchService = new RouteSearchServiceExtended(graph, preference || "CL");
    const altRouteService = new AlternativeRouteService(graph, routeSearchService);

    // Cari k-shortest paths dari startNode ke endNode
    const routesFound = altRouteService.findKShortestPaths(startNode.id, endNode.id, parseInt(k) || 3);
    if (!routesFound || routesFound.length === 0) {
      return res.status(404).json({ error: "Tidak ada rute yang ditemukan." });
    }

    // Format output
    const formattedRoutes = recommendations.map((rec, idx) => {
      const route = rec.route;
      // Buat string segmen untuk deskripsi
      const segmentsStr = route.segments
        .map(seg => `${seg.mode} ${seg.details.route || ""}`.trim())
        .join(" → ");
      // Ambil semua titik (dari edge.from dan edge.to) dan hilangkan duplikasi berdasarkan id
      const stops = [];
      route.segments.forEach(seg => {
        if (seg.from && !stops.find(s => s.id === seg.from.id)) {
          stops.push({ id: seg.from.id, name: seg.from.name, lat: seg.from.lat, lng: seg.from.lng });
        }
        if (seg.to && !stops.find(s => s.id === seg.to.id)) {
          stops.push({ id: seg.to.id, name: seg.to.name, lat: seg.to.lat, lng: seg.to.lng });
        }
      });
      return {
        routeId: route.id,
        score: rec.score.toFixed(2),
        description: segmentsStr,
        totalTime: `${route.totalWeight} min`,
        stops // list stops dengan koordinat
      };
    });

    res.json({ routes: formattedRoutes });
  } catch (error) {
    console.error("Error getting routes:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};
