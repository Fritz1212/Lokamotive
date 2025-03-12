class Edge{
    constructor(from, to, mode, details = {}){
        this.from = from;
        this.to = to;
        this.mode = mode;
        this.details = details;
    }
}

module.exports = Edge;