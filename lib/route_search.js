const haversineDistance = require('./haversine.js');
const heap = require('heap');

/**
 * Kelas routeSearch menyediakan metode pencarian rute menggunakan algoritma
 * Dijkstra, A* dan IDA* untuk menemukan jalur terpendek berdasarkan graph dan
 * preferensi pengguna. Selain itu, kelas ini juga dapat membangun segmen-segmen
 * perjalanan berdasarkan node yang dilalui.
 *
 * @author Fritz Gradiyoga
 */
class routeSearch {
  /**
   * Membuat instance routeSearch.
   *
   * @created 2024-12-01
   * @param {Object} graph - Graph yang berisi node dan edge yang mewakili jaringan rute.
   * @param {Object} userPreference - Preferensi pengguna yang dapat mempengaruhi perhitungan bobot edge.
   */
  constructor(graph, userPreference) {
    /**
     * Graph rute yang akan digunakan dalam pencarian.
     * @type {Object}
     */
    this.graph = graph;
    /**
     * Preferensi pengguna untuk pencarian rute.
     * @type {Object}
     */
    this.userPreference = userPreference;
  }

  /**
   * Mencari jalur terpendek antara dua node menggunakan algoritma Dijkstra.
   *
   * Metode ini menginisialisasi jarak tiap node dengan Infinity, kemudian menggunakan
   * priority queue untuk memilih node dengan jarak paling minimum dan memperbarui jarak
   * tetangga sampai mencapai node tujuan.
   *
   * @param {String|Number} startId - ID node awal.
   * @param {String|Number} endId - ID node tujuan.
   * @return {Object} Objek yang berisi:
   *                  - path: Array urutan node yang merupakan jalur terpendek.
   *                  - totalWeight: Total bobot (waktu) dari path.
   */
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

  /**
   * Mengonversi path yang didapat menjadi segmen-segmen perjalanan.
   *
   * Segmen dibentuk berdasarkan perbedaan mode transportasi antar node.
   * Jika mode pada edge berubah, maka dibuat segmen baru.
   *
   * @created 2024-12-01
   * @param {Array<Object>} path - Array node yang dilalui dalam perjalanan.
   * @return {Array<Object>} Array segmen perjalanan yang berisi:
   *                         - mode: Moda transportasi.
   *                         - details: Objek rincian terkait edge.
   *                         - nodes: Array node yang termasuk dalam segmen.
   */
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

  /**
   * Mencari jalur terpendek antara dua node menggunakan algoritma A*.
   *
   * Metode A* menggunakan heuristik jarak Haversine untuk memprioritaskan node yang
   * lebih dekat ke tujuan. Bila jarak antara node dan tujuan sangat dekat, dapat disuntikkan
   * "fake edge" untuk menyelesaikan pencarian.
   * @author Fritz Gradiyoga
   * @param {String|Number} startId - ID node awal.
   * @param {String|Number} goalId - ID node tujuan.
   * @return {Object} Objek yang berisi:
   *                  - path: Array node yang dilalui sebagai jalur.
   *                  - totalWeight: Total bobot dari path.
   *                  - segments: Segmen perjalanan yang dibangun dari path.
   */
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

  /**
   * Menggunakan metode IDA* untuk mencari rute terpendek.
   *
   * IDA* memanfaatkan algoritma A* sebagai dasar, kemudian mengembalikan path yang didapat.
   *
   * @param {String|Number} startId - ID node awal.
   * @param {String|Number} endId - ID node tujuan.
   * @return {Object} Objek yang berisi:
   *                  - path: Jalur yang ditemukan.
   *                  - totalWeight: Total bobot dari jalur.
   */
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