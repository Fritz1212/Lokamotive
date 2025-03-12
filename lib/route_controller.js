const GraphBuilder = require('./services/graph_builder.js');
const RouteSearchService = require('./services/route_search.js');
const AlternativeRouteService = require('./services/alternate_route.js');

// Asumsikan data stop sudah diambil oleh StopService (tidak perlu disertakan di sini lagi)

exports.getRoutes = async (req, res) => {
  const { start, destination, preference, k } = req.query;
  if (!start || !destination) {
    return res.status(400).json({ error: "Parameter 'start' dan 'destination' wajib diisi." });
  }

  try {
    // Cari stop berdasarkan nama (misalnya, menggunakan StopService atau data cache)
    const stops = await require('../services/StopService').getStops();
    const stopMap = new Map(stops.map(stop => [stop.name.toLowerCase(), stop]));
    const startStop = stopMap.get(start.toLowerCase());
    const destStop = stopMap.get(destination.toLowerCase());

    if (!startStop || !destStop) {
      return res.status(404).json({ error: "Lokasi start atau destination tidak ditemukan." });
    }

    // Bangun graf multi-modal secara dinamis
    const graph = await GraphBuilder.buildGraph();

    const routeSearchService = new RouteSearchService(graph, preference || "CL");
    const altRouteService = new AlternativeRouteService(graph, routeSearchService);

    const routes = altRouteService.findKShortestPaths(startStop.id.toString(), destStop.id.toString(), parseInt(k) || 3);

    if (routes.length === 0) {
      return res.status(404).json({ error: "Tidak ada rute yang ditemukan." });
    }

    const formattedRoutes = routes.map((r, idx) => ({
      routeId: idx + 1,
      totalTime: r.totalWeight.toFixed(2),
      segments: r.path.map(edge => ({
        from: edge.from.name,
        to: edge.to.name,
        mode: edge.mode,
        details: edge.details,
        effectiveCost: routeSearchService.getEffectiveWeight(edge).toFixed(2)
      }))
    }));

    res.json({ routes: formattedRoutes });
  } catch (error) {
    console.error("Error getting routes:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};