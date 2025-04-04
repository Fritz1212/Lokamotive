// services/path_finder.js
const GraphBuilder = require('./graph_builder.js');
const RouteSearchService = require('./route_search.js');
const AlternativeRouteService = require('./alternate_route.js');

class PathFinder {
  constructor(userPreferences) {
    this.graph = null;
    this.userPrefs = userPreferences;
    this.realTimeData = {};
  }

  async initialize(start, destination, startLat, startLng, destinationLat, destinationLng) {
    this.graph = await GraphBuilder.buildGraph(start, destination, startLat, startLng, destinationLat, destinationLng);
    await this._fetchRealTimeData();
    return this.graph
  }

  async _fetchRealTimeData() {
    // Contoh integrasi data real-time (mock)
    this.realTimeData = {
      'commuter-line': { delay: 5 },
      'transjakarta': { congestion: 0.3 }
    };
  }

  findRoutes(startId, endId, graph, k = 1) {
    let x = RouteSearchService.routeSearch
    const searchService = new x(
      this.graph,
      (edge) => this.getEffectiveWeight(edge)
    );

    const altService = new AlternativeRouteService(
      this.graph,
      searchService
    );

    // console.log("startId : ", startId);
    // console.log("endId : ", endId);
    return altService.findKShortestPaths(startId, endId, k);

    // return searchService.djikstra(startId, endId);
  }

  getEffectiveWeight(edge) {
    const baseWeight = edge.details.time;
    const { preferredModes, timePreferences } = this.userPrefs;

    // 1. Mode preference adjustment
    const modeAdjustment = this._calculateModeAdjustment(edge, preferredModes);

    // 2. Time-based penalty
    const timePenalty = this._calculateTimePenalty(baseWeight, timePreferences);

    // 3. Real-time adjustments
    const realTimeAdjustment = this._getRealTimeAdjustment(edge.mode);

    // 4. Transfer penalty
    const transferPenalty = edge.isTransfer ? 5 : 0;

    return baseWeight + modeAdjustment + timePenalty + realTimeAdjustment + transferPenalty;
  }

  _calculateModeAdjustment(edge, preferredModes) {
    const mode = edge.mode.toLowerCase();
    const preferred = preferredModes.map(m => m.toLowerCase());

    if (preferred.includes(mode)) {
      return -0.3 * edge.details.time; // Diskon 30% untuk mode preferensi
    }
    return 0.1 * edge.details.time; // Penalti 10% untuk mode non-preferred
  }

  _calculateTimePenalty(baseTime, { maxSingleSegment = 45, maxTotal = 120 }) {
    let penalty = 0;

    // Penalty untuk segmen tunggal terlalu panjang
    if (baseTime > maxSingleSegment) {
      penalty += (baseTime - maxSingleSegment) * 0.2;
    }

    // Penalty untuk total waktu perjalanan
    if (baseTime > maxTotal) {
      penalty += (baseTime - maxTotal) * 0.15;
    }

    return penalty;
  }

  _getRealTimeAdjustment(mode) {
    const data = this.realTimeData[mode.toLowerCase()] || {};
    return (data.delay || 0) + (data.congestion * 10 || 0);
  }
}

module.exports = PathFinder;