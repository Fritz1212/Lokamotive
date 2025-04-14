const haversineDistance = require('./haversine.js');
const heap = require('heap');

class routeSearch {
  constructor(graph, userPreference) {
    this.graph = graph;
    this.userPreference = userPreference;
  }

  djikstra(startId, endId) {
    let graph = this.graph;
    const nodes = Object.values(graph.nodes);
    const dist = {};
    const prev = {};
    const priorityQueue = new heap((a, b) => a.dist - b.dist);

    for (const node of nodes) {
      dist[node.id] = Infinity;
      prev[node.id] = null;
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
      const currentNode = nodes.find((n) => n.id === u);
      if (!currentNode || !currentNode.edge) continue;
      for (const edge of currentNode.edge) {
        const neighborId = toString(edge.to);
        const alt = dist[u] + edge.details.time;
        if (alt < dist[neighborId]) {
          dist[neighborId] = alt;
          prev[neighborId] = u;
          priorityQueue.push({ id: neighborId, dist: alt });
        }
      }
    }

    // console.log("priorityQueue : ", priorityQueue);

    const path = [];
    let current = endId;
    while (prev[current]) {
      path.unshift(prev[current]);
      current = prev[current];
    }

    // console.log("djikstra path : ", path);

    return { path, totalWeight: dist[endId] };
  }

  buildSegmentsFromPath(path) {
    if (!path || path.length < 2) return [];

    const segments = [];
    let currentSegment = null;

    for (let i = 0; i < path.length - 1; i++) {
      const fromNode = path[i];
      const toNode = path[i + 1];

      const edge = fromNode.edge.find(e => e.to.id === toNode.id);
      if (!edge) continue;

      const { mode, details } = edge;

      // Start a new segment if it's the first or mode changes
      if (!currentSegment || currentSegment.mode !== mode) {
        if (currentSegment) segments.push(currentSegment);

        currentSegment = {
          mode,
          details: { ...details },
          nodes: [fromNode, toNode]
        };
      } else {
        // Same mode, extend the current segment
        currentSegment.nodes.push(toNode);
      }
    }

    if (currentSegment) segments.push(currentSegment);
    return segments;
  }

  aStar(startId, goalId) {
    const start = this.graph.nodes[startId];
    const goal = this.graph.nodes[goalId];
    if (!start || !goal) return { path: [], totalWeight: Infinity };

    const visited = new Map();

    class PriorityQueue {
      constructor() {
        this.data = [];
      }

      enqueue(element, priority) {
        this.data.push({ element, priority });
        this.data.sort((a, b) => a.priority - b.priority);
      }

      dequeue() {
        return this.data.shift()?.element;
      }

      isEmpty() {
        return this.data.length === 0;
      }
    }

    const openSet = new PriorityQueue();
    openSet.enqueue({ node: start, g: 0, path: [] }, 0);

    while (!openSet.isEmpty()) {
      const current = openSet.dequeue();
      const { node, g, path } = current;

      if (visited.has(node.id) && visited.get(node.id) <= g) continue;
      visited.set(node.id, g);

      if (node.id === goal.id) {
        // console.log("da path is : ", path);
        return { path: [...path, node], totalWeight: g, segments: this.buildSegmentsFromPath([...path, node]) };
      }

      for (const edge of node.edge) {
        console.log("Neighbor edge:", edge.to?.id, edge.to?.lat, edge.to?.lang);
        if (!edge.to) continue;
        const cost = isNaN(edge.details.time) ? 0 : edge.details.time;
        const neighbor = edge.to;
        const newG = g + cost;
        const h = haversineDistance.haversine_distance(neighbor.lat, goal.lat, neighbor.lang, goal.lang);
        console.log("Neighbor:", neighbor.id, neighbor.lat, neighbor.lang);
        console.log("Goal:", goal.id, goal.lat, goal.lang);

        console.log("haversine_distance : ", h);

        if (h < 0.3) { // adjust threshold (in km) to your tolerance
          console.log(`Injecting fake edge from ${node.id} to goal (distance ${h} km)`);

          const newG = g + h;
          openSet.enqueue({ node: goal, g: newG, path: [...path, node] }, newG); // no h, since it's goal
        }

        console.log(`Visiting ${node.id}, g=${g}`);

        openSet.enqueue({ node: neighbor, g: newG, path: [...path, node] }, newG + h);
        console.log(`Enqueue ${neighbor.id} with f=${newG + h}`);

      }
    }

    return { path: [], totalWeight: Infinity };
  }

  idaStar(startId, endId) {
    const path = this.aStar(startId, endId);
    console.log("aStar path : ", path);
    if (!path) return { path: [], totalWeight: Infinity };

    return path;
  }

}

module.exports = {
  routeSearch,
};