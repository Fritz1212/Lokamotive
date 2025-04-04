const edge = require('./edge.js');

class Graph {
    constructor() {
        this.nodes = {};
    }

    addNode(node) {
        this.nodes[node.id] = node;
    }

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

    getNodes() {
        return Object.values(this.nodes);
    }

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

    hasNode(id) {
        return !!this.nodes[id];
    }
}

module.exports = Graph;