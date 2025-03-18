const GraphBuilder = require("./graph_builder.js");
const RouteSearchService = require("./route_search.js");
const AlternativeRouteService = require("./alternate_route.js");
const TransportationRecommender = require("./collaborative_filtering.js");

class RouteController {
  constructor() {
    this.graphBuilder = GraphBuilder;
    const PathFinder = require("./path_finder");
    this.pathFinder = new PathFinder({});
    this.pathFinder.initialize();
    this.recommender = new TransportationRecommender(this.pathFinder);
  }
}

// WebSocket-compatible version
async function getRecommendedRoutesWS(message, ws) {
  try {
    // Parse JSON message from client
    const { userId, start, destination, preference, k } = JSON.parse(message);
    if (!userId || !start || !destination) {
      return ws.send(JSON.stringify({ error: "Parameter 'userId', 'start', dan 'destination' wajib diisi." }));
    }

    // Load graph and find start/destination stops
    const graph = await this.graphBuilder.buildGraph();
    const nodes = Object.values(graph.nodes);
    const startStop = nodes.find((n) => n.name.toLowerCase() === start.toLowerCase());
    const destStop = nodes.find((n) => n.name.toLowerCase() === destination.toLowerCase());

    if (!startStop || !destStop) {
      return ws.send(JSON.stringify({ error: "Lokasi start atau destination tidak ditemukan dalam graph." }));
    }

    // Register user if not exists
    if (!this.recommender.userData.has(userId)) {
      this.recommender.registerUser(userId, preference);
    }

    // Get recommendations
    const recommendations = this.recommender.recommend(userId, startStop, destStop);

    // Format response
    const formattedRoutes = recommendations.map((rec, idx) => ({
      routeId: rec.route.id,
      score: rec.score.toFixed(2),
      description: rec.route.segments.map(seg => `${seg.mode} ${seg.details.route || ""}`.trim()).join(" → "),
      totalTime: `${rec.route.totalWeight} min`,
      coordinates: rec.route.segments.flatMap(seg =>
        seg.coordinates.map(coord => ({ latitude: coord.lat, longitude: coord.lng }))
      )
    }));

    // Send response via WebSocket
    ws.send(JSON.stringify({ routes: formattedRoutes }));
  } catch (error) {
    console.error("Error in getRecommendedRoutesWS:", error);
    ws.send(JSON.stringify({ error: error.message }));
  }
}

module.exports = {
  getRecommendedRoutesWS,
  getRoutes: async (req, res) => {
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
  }
};