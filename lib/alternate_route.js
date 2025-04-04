// AlternativeRouteService.js

class AlternativeRouteService {
  constructor(graph, routeSearchService) {
    this.graph = graph;
    this.routeSearchService = routeSearchService;
  }

  /**
   * Pendekatan sederhana: menggunakan IDA* (atau Dijkstra) lalu menghapus satu edge (atau node) 
   * untuk mendapatkan alternatif rute.
   * @param {string|number} startId - ID node awal.
   * @param {string|number} endId - ID node tujuan.
   * @param {number} k - Jumlah alternatif rute yang diinginkan.
   * @returns {Array} Array dari rute (objek { path, totalWeight }).
   */
  findKShortestPathsSimple(startId, endId, k = 1) {
    if (!this.graph.hasNode(startId) || !this.graph.hasNode(endId)) {
      throw new Error("Invalid start or end node ID");
    }

    const routes = [];
    const removedEdges = [];

    for (let i = 0; i < k; i++) {
      let result = this.routeSearchService.idaStar(startId, endId);
      if (result.totalWeight === Infinity) {
        result = this.routeSearchService.djikstra(startId, endId);
        if (result.totalWeight === Infinity) break;
      }
      routes.push(result);

      // Hapus edge dengan bobot efektif terbesar dari rute yang ditemukan
      if (result.path.length > 0) {
        const edgeToRemove = result.path.reduce((max, edge) => {
          const w = this.routeSearchService.getEffectiveWeight(edge);
          return (w > max.weight) ? { edge, weight: w } : max;
        }, { edge: null, weight: -Infinity }).edge;

        if (edgeToRemove) {
          const fromNode = edgeToRemove.from;
          fromNode.edges = fromNode.edges.filter(e => e !== edgeToRemove);
          removedEdges.push({ fromNode, edge: edgeToRemove });
        }
      } else {
        break;
      }
    }

    // Kembalikan edge yang dihapus agar graf kembali utuh
    removedEdges.forEach(rem => {
      rem.fromNode.edges.push(rem.edge);
    });

    return routes;
  }

  /**
   * Implementasi Yen's algorithm untuk k-shortest paths.
   * Pendekatan ini lebih efisien dalam mendapatkan alternatif rute yang berbeda.
   * @param {string|number} startId - ID node awal.
   * @param {string|number} endId - ID node tujuan.
   * @param {number} k - Jumlah rute alternatif yang diinginkan.
   * @returns {Array} Array dari rute (objek { path, totalWeight }).
   */
  findKShortestPathsYen(startId, endId, k = 1) {
    const A = [];
    const B = [];

    const getShortestPath = () => {
      // console.log("startId : ", startId);
      // console.log("endId : ", endId);
      let result = this.routeSearchService.idaStar(startId, endId);
      console.log("result : ", result);
      if (result.totalWeight === Infinity) {
        result = this.routeSearchService.djikstra(startId, endId);
      }
      return result;
    };

    const shortestPath = getShortestPath();
    if (shortestPath.totalWeight === Infinity) {
      return A;
    }
    A.push(shortestPath);

    for (let k_i = 1; k_i <= k; k_i++) {
      for (let i = 0; i < 1; i++) {
        const spurNode = A[k_i - 1].path.slice(0, i + 1).at(-1);
        const rootPath = A[k_i - 1].path.slice(0, i);


        const removedEdges = new Set();
        for (const route of A) {
          const routeRoot = route.path.slice(0, i);
          if (this.pathsEqual(rootPath, routeRoot)) {
            const edgeToRemove = route.path[i];
            const fromNode = edgeToRemove.from;
            const index = fromNode.edge.indexOf(edgeToRemove);
            if (index > -1) {
              fromNode.edge.splice(index, 1);
              removedEdges.add({ fromNode, edge: edgeToRemove });
            }
          }
        }

        let spurPath = this.routeSearchService.idaStar(spurNode.id, endId);
        if (spurPath.totalWeight === Infinity) {
          spurPath = this.routeSearchService.djikstra(spurNode.id, endId);
        }

        if (spurPath.totalWeight < Infinity) {
          const totalPath = rootPath.concat(spurPath.path);
          const totalWeight = rootPath.reduce((acc, edge) => acc + this.routeSearchService.getEffectiveWeight(edge), 0)
            + spurPath.totalWeight;
          B.push({ path: totalPath, totalWeight });
        }

        removedEdges.forEach(rem => {
          rem.fromNode.edge.push(rem.edge);
        });
      }

      if (B.length === 0) break;

      B.sort((a, b) => a.totalWeight - b.totalWeight);
      const bestCandidate = B.shift();
      A.push(bestCandidate);
    }

    return A;
  }

  /**
   * Helper function untuk membandingkan dua array edge (root path)
   * @param {Array} path1 
   * @param {Array} path2 
   * @returns {boolean} True jika kedua path identik dalam urutan dan konten.
   */
  pathsEqual(path1, path2) {
    if (path1.length !== path2.length) return false;
    for (let i = 0; i < path1.length; i++) {
      if (path1[i].from.id !== path2[i].from.id ||
        path1[i].to.id !== path2[i].to.id ||
        path1[i].mode !== path2[i].mode) {
        return false;
      }
    }
    return true;
  }

  /**
   * Fungsi untuk menggabungkan kedua pendekatan (simple removal dan Yen's algorithm)
   * untuk mendapatkan maksimal kombinasi rute.
   * @param {string|number} startId 
   * @param {string|number} endId 
   * @param {number} k - jumlah rute yang diinginkan.
   * @returns {Array} Array dari rute alternatif.
   */
  findKShortestPaths(startId, endId, k = 1) {
    // Pertama, coba menggunakan Yen's algorithm
    let yenPaths = this.findKShortestPathsYen(startId, endId, k);
    // Jika jumlah rute kurang dari k, tambahkan hasil dari pendekatan simple
    if (yenPaths.length < k) {
      const simplePaths = this.findKShortestPathsSimple(startId, endId, k - yenPaths.length);
      yenPaths = yenPaths.concat(simplePaths);
    }
    return yenPaths;
  }
}

module.exports = AlternativeRouteService;
