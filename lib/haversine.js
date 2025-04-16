const Graph = require('./graph.js');

//ukur jarak antara dua titik koordinat
/**
 * Menghitung jarak antara dua titik koordinat menggunakan metode Haversine.
 *
 * Rumus Haversine digunakan untuk memperkirakan jarak (dalam kilometer) antara dua titik
 * di permukaan Bumi berdasarkan perbedaan lintang dan bujur mereka.
 *
 * @created 2024-12-01
 * @author Jane Doe
 * @param {Number} lat1 - Lintang (latitude) dari titik pertama.
 * @param {Number} lat2 - Lintang (latitude) dari titik kedua.
 * @param {Number} long1 - Bujur (longitude) dari titik pertama.
 * @param {Number} long2 - Bujur (longitude) dari titik kedua.
 * @return {Number} Jarak antara kedua titik dalam kilometer.
 */
function haversine_distance(lat1, lat2, long1, long2) {
    const radius = 6371; // radius of the Earth in km
    const distance_lat = (lat2 - lat1) * Math.PI / 180;
    const distance_long = (long2 - long1) * Math.PI / 180;
    const a = Math.sin(distance_lat / 2) ** 2 +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
        Math.sin(distance_long / 2) ** 2;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = radius * c;
    return distance; //in km
}

/**
 * Menemukan node terdekat dari lokasi saat ini dalam graph transportasi.
 *
 * Fungsi ini mengiterasi seluruh node pada objek graph, lalu menghitung jarak
 * antara lokasi saat ini dengan setiap node menggunakan fungsi `haversine_distance`.
 * Node dengan jarak terkecil (selain node dengan id '0' atau 'destination') dianggap
 * sebagai node terdekat.
 *
 * @created 2024-12-01
 * @author Jane Doe
 * @param {Object} currentLocation - Objek yang merepresentasikan lokasi saat ini dengan properti:
 *                                   - lat: Lintang (latitude)
 *                                   - lang: Bujur (longitude)
 * @param {Object} graph - Objek yang memuat node-node dengan struktur: { nodes: { nodeId: { lat, lang, ... } } }
 * @return {Object} Mengembalikan objek yang berisi:
 *                  - nearestNodeId: ID node terdekat.
 *                  - distance: Jarak ke node terdekat dalam kilometer.
 */
function findNearestNode(currentLocation, graph) {
    let minDistance = Infinity;
    let nearestNodeId = null;

    for (const nodeId in graph.nodes) {
        if (nodeId === '0' || nodeId === 'destination') continue; // 🔥 skip self and destination

        const node = graph.nodes[nodeId];
        if (node.lat == null || node.lang == null) continue;

        const dist = haversine_distance(currentLocation.lat, node.lat, currentLocation.lang, node.lang);
        // console.log(`Distance from ${nodeId} to current location: ${dist} km`);

        if (dist < minDistance) {
            minDistance = dist;
            nearestNodeId = nodeId;
            // console.log(`Nearest node: ${nodeId}, Distance: ${minDistance} km`);
        }
    }

    return {
        nearestNodeId,
        distance: minDistance
        // lat: graph.nodes[nearestNodeId].lat,
        // lng: graph.nodes[nearestNodeId].lang
    };
}

// async function combinedDistance(origin, destination, apiKey) {
//     const originUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${origin}&key=${apiKey}`;
//     const destinationUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${destination}&key=${apiKey}`;
//     const directionService = new google.maps.directionService();
//     const directionRenderer = new google.maps.directionRenderer();
//     directionRenderer.setMap(map);

//     const route = {
//         origin: origin,
//         destination: destination,
//         travelMode: 'DRIVING'
//     }

//     directionService.route(route, function (result, status) {
//         if (status === 'OK') {
//             directionRenderer.setDirections(result);
//         } else {
//             return;
//         }

//         const leg = result.routes[0].legs[0];
//         if (!leg) {
//             window.alert('Directions request failed');
//             return;
//         }

//         const startLocation = leg.start_location;
//         const endLocation = leg.end_location;

//         const distance = haversine_distance(startLocation.lat(), endLocation.lat(), startLocation.lng(), endLocation.lng());
//         const googleDistance = leg.distance.value / 1000; //in km   

//         const combined = (distance + googleDistance) / 2;
//         return combined;
//     });
// }

module.exports = {
    // combinedDistance,
    haversine_distance,
    findNearestNode
}