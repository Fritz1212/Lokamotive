class Edge {
    constructor(from, to, mode, details = {}) {
        this.from = from;
        this.to = to;
        this.mode = mode;
        this.details = { ...details, time: Number(details.time) || 0 };
    }
}

module.exports = Edge;