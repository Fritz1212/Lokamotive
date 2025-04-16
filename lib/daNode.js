/**
 * Kelas yang merepresentasikan sebuah Node (simpul) dalam graph.
 *
 * @author Jessica Nathania Wenardi
 * @class Node
 * @param {string} id - ID unik untuk node.
 * @param {string} name - Nama dari node.
 * @param {string} type - Tipe atau kategori node.
 * @param {number} lat - Latitude dari lokasi node.
 * @param {number} lang - Longitude dari lokasi node.
 */
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