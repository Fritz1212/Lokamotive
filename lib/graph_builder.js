const Graph = require('./graph.js');
const Node = require('./node.js');
const haversineDistance = require('./haversine.js');
const CLService = require('./commuter_line_service.js');
const MRTService = require('./mrt_service.js');
const LRTService = require('./lrt_service.js');
const TJService = require('./transjakarta_service.js');

class GraphBuilder {
  async buildGraph() {
    const graph = new Graph();
    
    // Ambil data contoh commuter line
    const commuterLine = await CLService.getCommuterLineData();
    commuterLine.forEach(stop => {
      graph.addNode(new Node(stop.id, stop.name, stop.type, stop.lat, stop.lng));
    });
    commuterLine.edges.array.forEach(edge => {
        graph.addEdge(edge.fromId, edge.toId, edge.mode, edge.weight, edge.details);
    });
    
    // Tambahkan edge "Jalan Kaki" untuk node yang berdekatan (misal, jarak < 0.5 km)
    const nodeIds = Object.keys(graph.nodes);
    for (let i = 0; i < nodeIds.length; i++) {
      for (let j = i + 1; j < nodeIds.length; j++) {
        const nodeA = graph.nodes[nodeIds[i]];
        const nodeB = graph.nodes[nodeIds[j]];
        const d = haversineDistance(nodeA.lat, nodeA.lng, nodeB.lat, nodeB.lng);
        if (d < 0.5) {
          const walkTime = (d / 5) * 60;
          graph.addEdge(nodeA.id, nodeB.id, "Jalan Kaki", walkTime, { distance: d.toFixed(2) });
          graph.addEdge(nodeB.id, nodeA.id, "Jalan Kaki", walkTime, { distance: d.toFixed(2) });
        }
      }
    }
    
    return graph;
  }
}

module.exports = new GraphBuilder();
