const haversineDistance = require('./haversine.js');
const heap = require('heap');

class routeSearch {
  constructor(graph, userPreference) {
    this.graph = graph;
    this.userPreference = userPreference;
  }

  djikstra(graph, startId, endId) {
    const nodes = this.graph.getNodes();
    const edges = this.graph.getEdges();
    const dist = {};
    const prev = {};
    const priorityQueue = new heap((a, b) => a.dist - b.dist);

    for (const nodeId in graph.nodes) {
      dist[nodeId] = Infinity;
      prev[nodeId] = null;
    }

    dist[startId] = 0;
    priorityQueue.push({ id: startId, dist: 0 });

    while (!priorityQueue.empty()) {
      const { id: u, dist: currentDistance } = priorityQueue.pop();
      if (currentDistance > dist[u]) {
        continue;
      }
      if (u === endId) {
        break;
      }

      const currentNode = graph.nodes[u];
      for (const edge of currentNode.edges) {
        const neighborId = edge.toNode.id;
        const alt = dist[u] + edge.details.time;
        if (alt < dist[neighborId]) {
          dist[neighborId] = alt;
          prev[neighborId] = u;
          priorityQueue.push({ id: neighborId, dist: alt });
        }
      }
    }

    const path = [];
    let current = endId;
    while (prev[current]) {
      path.unshift(prev[current]);
      current = prev[current];
    }

    return { path, totalWeight: dist[endId] };
  }
}

function heuristic(node, goal) {
  const distance = haversineDistance(node.lat, node.lng, goal.lat, goal.lng);
  return distance;
}

function idaSearch(graph, current, g, bound, goal, path, visited, heuristicFn) {
  const f = g + heuristicFn(current, goal);
  if (f > bound) return f;
  if (current.id === goal.id) return "FOUND";
  let min = Infinity;
  for (const edge of current.edges) {
    const neighbor = edge.toNode;
    if (visited.has(neighbor.id)) {
      continue;
    }
    visited.add(neighbor.id);
    path.push(edge);
    const cost = edge.details.time; // using time as cost
    const t = idaSearch(graph, neighbor, g + cost, bound, goal, path, visited, heuristicFn);
    if (t === "FOUND") {
      return "FOUND";
    }
    if (t < min) {
      min = t;
    }
    path.pop();
    visited.delete(neighbor.id);
  }
  return min;
}

function idaStar(graph, startId, endId, heuristicFn) {
  const start = graph.nodes[startId];
  const goal = graph.nodes[endId];
  if (!start || !goal) return { path: [], totalWeight: Infinity };

  let bound = heuristicFn(start, goal);
  let path = [];
  let visited = new Set();
  visited.add(start.id);

  while (true) {
    const t = idaSearch(graph, start, 0, bound, goal, path, visited, heuristicFn);
    if (t === "FOUND") {
      const totalWeight = path.reduce((acc, edge) => acc + edge.details.time, 0);
      return { path: [...path], totalWeight };
    }
    if (t === Infinity) return { path: [], totalWeight: Infinity };
    bound = t;
  }
}

module.exports = {
  routeSearch,
  idaStar,
  heuristic,
};