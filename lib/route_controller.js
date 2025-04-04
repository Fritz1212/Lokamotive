const GraphBuilder = require("./graph_builder.js");
const RouteSearchService = require("./route_search.js");
const AlternativeRouteService = require("./alternate_route.js");
const TransportationRecommender = require("./collaborative_filtering.js");
const haversineDistance = require('./haversine.js');
const PathFinder = require("./path_finder");

// WebSocket-compatible version
async function getRecommendedRoutesWS(message, ws) {
  let pathFinder = new PathFinder({});

  try {
    // Parse JSON message from client
    const { userId, start, destination, startLat, startLng, destinationLat, destinationLng, preference, k } = JSON.parse(message);
    if (!userId || !start || !destination) {
      return ws.send(JSON.stringify({ error: "Parameter 'userId', 'start', dan 'destination' wajib diisi." }));
    }
    // Load graph and find start/destination stops
    console.log("Building graph...");
    const graph = await pathFinder.initialize(start, destination, startLat, startLng, destinationLat, destinationLng);
    recommender = new TransportationRecommender(pathFinder);
    const nodes = Object.values(graph.nodes);
    const startStop = nodes.find((n) => n.name.toLowerCase() === start.toLowerCase());
    const destStop = nodes.find((n) => n.name.toLowerCase() === destination.toLowerCase());

    if (!startStop || !destStop) {
      return ws.send(JSON.stringify({ error: "Lokasi start atau destination tidak ditemukan dalam graph." }));
    }

    // Register user if not exists
    if (!recommender.userData.has(userId)) {
      recommender.registerUser(userId, preference);
    }

    //first mile and last mile problem
    const nearestNodeStart = haversineDistance.findNearestNode({ lat: startLat, lng: startLng }, graph)
    graph.addEdge('0', nearestNodeStart.nearestNodeId, "Walking", {})

    const nearestNodeDestination = haversineDistance.findNearestNode({ lat: destinationLat, lng: destinationLng }, graph)
    graph.addEdge("destination", nearestNodeDestination.nearestNodeId, "Walking", {})

    // const firstNode = nodes[0];
    // const lastNode = nodes[nodes.length - 1];
    // console.log("firstNode : ", firstNode);
    // console.log("lastNode : ", lastNode);

    // Get recommendations
    const recommendations = recommender.recommend(userId, startStop.id, destStop.id, graph);

    console.log("Recommendations : ", recommendations);

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

    console.log("Formmated routes : ", formattedRoutes);

    // Send response via WebSocket
    ws.send(JSON.stringify({ routes: formattedRoutes }));
  } catch (error) {
    console.error("Error in getRecommendedRoutesWS:", error);
    ws.send(JSON.stringify({ error: error.message }));
  }
}

module.exports = {
  getRecommendedRoutesWS,
};