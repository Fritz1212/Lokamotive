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

  haversine_distance(lat1, long1, lat2, long2) {
    if (
      lat1 == null || lat2 == null ||
      long1 == null || long2 == null
    ) {
      console.warn("Haversine received null/undefined:", lat1, lat2, long1, long2);
      return Infinity; // return huge distance to deprioritize
    }

    const radius = 6371;
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (long2 - long1) * Math.PI / 180;

    const a =
      Math.sin(dLat / 2) ** 2 +
      Math.cos(lat1 * Math.PI / 180) *
      Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLon / 2) ** 2;

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return radius * c;
  }

  aStar(startId, goalId) {
    const start = this.graph.nodes[startId];
    const goal = this.graph.nodes[goalId];
    if (!start || !goal) return { path: [], totalWeight: Infinity };

    console.log("start edge:", start.edge);

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
        return { path: [...path, node], totalWeight: g };
      }

      for (const edge of node.edge) {
        console.log("Neighbor edge:", edge.to?.id, edge.to?.lat, edge.to?.lang);
        if (!edge.to) continue;
        const cost = isNaN(edge.details.time) ? 0 : edge.details.time;
        const neighbor = edge.to;
        const newG = g + cost;
        const h = this.haversine_distance(
          neighbor.lang, goal.lang, // actual latitudes
          neighbor.lat, goal.lat  // actual longitudes
        );
        console.log("Neighbor:", neighbor.id, neighbor.lat, neighbor.lang);
        console.log("Goal:", goal.id, goal.lat, goal.lang);

        console.log("haversine_distance : ", h);

        if (h < 0.3) { // adjust threshold (in km) to your tolerance
          console.log(`Injecting fake edge from ${node.id} to goal (distance ${distToGoal} km)`);

          const cost = distToGoal * 1000; // convert to meters if your weights are in meters
          const newG = g + cost;
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