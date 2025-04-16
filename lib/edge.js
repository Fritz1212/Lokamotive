/**
 * Kelas yang merepresentasikan sebuah Edge (sisi) dalam graph.
 *
 * @created 2024-12-01
 * @author Jane Doe
 * @class Edge
 * @param {Node} from - Node asal dari edge.
 * @param {Node} to - Node tujuan dari edge.
 * @param {string} mode - Mode atau cara penghubung antara kedua node.
 * @param {Object} [details={}] - Objek yang berisikan detail tambahan, misalnya waktu tempuh.
 */
class Edge {
    constructor(from, to, mode, details = {}) {
        this.from = from;
        this.to = to;
        this.mode = mode;
        this.details = { ...details, time: Number(details.time) || 0 };
    }
}

module.exports = Edge;