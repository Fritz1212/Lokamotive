const Graph = require('./graph.js');

//ukur jarak antara dua titik koordinat
function haversine_distance(lat1, lat2, long1, long2) {
    console.log("masuk sini")
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

function findNearestNode(currentLocation, graph) {
    let minDistance = Infinity;
    let nearestNodeId = null;

    console.log("currentLocation:", currentLocation);


    for (const nodeId in graph.nodes) {
        if (nodeId === '0' || nodeId === 'destination') continue; // 🔥 skip self and destination

        const node = graph.nodes[nodeId];
        if (node.lat == null || node.lng == null) continue;

        const dist = haversine_distance(currentLocation.lat, currentLocation.lang, node.lat, node.lang);
        console.log(`Distance from ${nodeId} to current location: ${dist} km`);

        if (dist < minDistance) {
            minDistance = dist;
            nearestNodeId = nodeId;
            console.log(`Nearest node: ${nodeId}, Distance: ${minDistance} km`);
        }
    }

    return {
        nearestNodeId,
        distance: minDistance
        // lat: graph.nodes[nearestNodeId].lat,
        // lng: graph.nodes[nearestNodeId].lang
    };
}

async function combinedDistance(origin, destination, apiKey) {
    const originUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${origin}&key=${apiKey}`;
    const destinationUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${destination}&key=${apiKey}`;
    const directionService = new google.maps.directionService();
    const directionRenderer = new google.maps.directionRenderer();
    directionRenderer.setMap(map);

    const route = {
        origin: origin,
        destination: destination,
        travelMode: 'DRIVING'
    }

    directionService.route(route, function (result, status) {
        if (status === 'OK') {
            directionRenderer.setDirections(result);
        } else {
            return;
        }

        const leg = result.routes[0].legs[0];
        if (!leg) {
            window.alert('Directions request failed');
            return;
        }

        const startLocation = leg.start_location;
        const endLocation = leg.end_location;

        const distance = haversine_distance(startLocation.lat(), endLocation.lat(), startLocation.lng(), endLocation.lng());
        const googleDistance = leg.distance.value / 1000; //in km   

        const combined = (distance + googleDistance) / 2;
        return combined;
    });
}

module.exports = {
    combinedDistance,
    haversine_distance,
    findNearestNode
}