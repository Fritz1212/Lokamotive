const edge = require('./edge.js');

/**
 * Kelas yang merepresentasikan sebuah Graph, menyimpan kumpulan Node dan Edge.
 *
 * @created 2024-12-01
 * @author Jane Doe
 * @class Graph
 */
class Graph {
    constructor() {
        this.nodes = {};
    }

    /**
     * Menambahkan node baru ke graph.
     *
     * @param {Node} node - Objek node yang ingin ditambahkan.
     */
    addNode(node) {
        this.nodes[node.id] = node;
    }

    /**
     * Menambahkan edge baru yang menghubungkan dua node dalam graph.
     *
     * @param {string} fromId - ID node asal.
     * @param {string} toId - ID node tujuan.
     * @param {string} mode - Mode atau jenis hubungan antar node.
     * @param {Object} [details={}] - Detail tambahan yang terkait dengan edge.
     */
    addEdge(fromId, toId, mode, details = {}) {
        const fromNode = this.nodes[fromId];
        const toNode = this.nodes[toId];
        if (fromNode && toNode) {
            if (!fromNode.edge) {
                fromNode.edge = [];
            }
            fromNode.edge.push(new edge(fromNode, toNode, mode, details));
        }
    }

    /**
     * Mengembalikan array semua node yang terdapat dalam graph.
     *
     * @return {Node[]} Array node yang ada.
     */
    getNodes() {
        return Object.values(this.nodes);
    }

    /**
     * Mengembalikan array semua edge yang terdapat dalam graph.
     *
     * @return {Edge[]} Array edge yang ada.
     */
    getEdges() {
        let edges = [];
        for (const id in this.nodes) {
            const node = this.nodes[id];
            if (node.edge && Array.isArray(node.edge)) {
                edges = edges.concat(node.edge);
            }
        }
        return edges;
    }

    /**
     * Memeriksa apakah sebuah node dengan ID tertentu ada dalam graph.
     *
     * @param {string} id - ID dari node yang ingin diperiksa.
     * @return {boolean} True jika node ada, sebaliknya false.
     */
    hasNode(id) {
        return !!this.nodes[id];
    }
}

module.exports = Graph;