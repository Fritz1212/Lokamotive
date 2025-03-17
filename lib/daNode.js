class Node {
    constructor(id, name, type, lat, lang) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.lat = lat;
        this.lang = lang;
        this.edge = [];
    }
}

module.exports = Node;