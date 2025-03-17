const Graph = require('./graph.js');
const Node = require('./daNode.js');
const haversineDistance = require('./haversine.js');
const CLService = require('./CLschedule.js');
const MRTService = require('./mrt_service.js');
const LRTService = require('./lrt_service.js');
const TJService = require('./transjakarta_service.js');
const processCommuterData = require('./commuter_line_service.js');

class GraphBuilder {
  async buildGraph() {
    const graph = new Graph();

    // **Commuter Line Integration**
    const rawDataCL = await CLService.getCLData();
    const commuterData = await processCommuterData(rawDataCL);
    console.log("sumpah bingung")

    // console.log(rawDataCL)

    commuterData.forEach(item => {

      if (!graph.nodes[item.station_origin_id]) {
        console.log("oiiii 1")
        graph.addNode(new Node(
          item.station_origin_id,
          item.station_origin_name,
          "Commuter Line",
          item.origin_lat,
          item.origin_lng
        ));
      }
      if (!graph.nodes[item.station_destination_id]) {
        console.log("oiiii 2")
        graph.addNode(new Node(
          item.station_destination_id,
          item.station_destination_name,
          "Commuter Line",
          item.destination_lat,
          item.destination_lng
        ));
      }

      let weight = computeTravelTime(item.departs_at, item.arrives_at);
      graph.addEdge(item.station_origin_id, item.station_destination_id, "Commuter Line", weight, {
        route: item.route,
        departs_at: item.departs_at,
        arrives_at: item.arrives_at,
        train_id: item.train_id
      });
    });

    // 🚇 **2. MRT Integration**
    const mrtStations = await MRTService.loadSchedule();
    const latitudeLongitude = await MRTService.getStationCoordinates();

    mrtStations.forEach(station => {
      const stationData = latitudeLongitude.get(station.name);
      if (stationData) {
        graph.addNode(new Node(
          station.name,
          station.name,
          "MRT",
          stationData.lat,
          stationData.lng
        ));
      }
    });

    for (let i = 0; i < mrtStations.length - 1; i++) {
      const origin = mrtStations[i];
      const destination = mrtStations[i + 1];

      graph.addEdge(origin.name, destination.name, "MRT", 3, { line: "MRT Jakarta" });
      graph.addEdge(destination.name, origin.name, "MRT", 3, { line: "MRT Jakarta" });
    }

    // 🚝 **3. LRT Integration**
    const lrtStations = await LRTService.getAllStations();

    for (const stationName of lrtStations) {
      const latitudeLongi = await LRTService.getCoordinates(stationName); // Await in case it's a Promise

      if (!graph.nodes[stationName] && latitudeLongi) {
        graph.addNode(new Node(
          stationName,
          stationName,
          "LRT",
          latitudeLongi.lat,
          latitudeLongi.lng
        ));
      }
    }

    for (let i = 0; i < lrtStations.length - 1; i++) {
      const origin = lrtStations[i];
      const destination = lrtStations[i + 1];

      graph.addEdge(origin.name, destination.name, "LRT", 4, { line: "LRT Jakarta" });
      graph.addEdge(destination.name, origin.name, "LRT", 4, { line: "LRT Jakarta" });
    }

    // 🚌 **4. TransJakarta Integration**
    const tjStops = await TJService.getAllStops();
    tjStops.forEach(stop => {
      if (!graph.nodes[stop.name]) {
        graph.addNode(new Node(
          stop.name,
          stop.name,
          "TransJakarta",
          stop.lat,
          stop.lng
        ));
      }
    });

    for (let i = 0; i < tjStops.length - 1; i++) {
      const origin = tjStops[i];
      const destination = tjStops[i + 1];

      graph.addEdge(origin.name, destination.name, "TransJakarta", 5, { line: "Busway Corridor" });
      graph.addEdge(destination.name, origin.name, "TransJakarta", 5, { line: "Busway Corridor" });
    }

    // 🚶 **5. Walking Connections (Dynamic)**
    this.addWalkingEdges(graph);

    return graph;
  }

  addWalkingEdges(graph) {
    const nodeIds = Object.keys(graph.nodes);
    for (let i = 0; i < nodeIds.length; i++) {
      for (let j = i + 1; j < nodeIds.length; j++) {
        const nodeA = graph.nodes[nodeIds[i]];
        const nodeB = graph.nodes[nodeIds[j]];
        const d = haversineDistance(nodeA.lat, nodeA.lng, nodeB.lat, nodeB.lng);

        if (d < 0.5) { // Jika jarak < 0.5 km, tambahkan koneksi jalan kaki
          const walkTime = (d / 5) * 60; // Kecepatan jalan kaki: 5 km/jam
          graph.addEdge(nodeA.id, nodeB.id, "Jalan Kaki", walkTime, { distance: d.toFixed(2) });
          graph.addEdge(nodeB.id, nodeA.id, "Jalan Kaki", walkTime, { distance: d.toFixed(2) });
        }
      }
    }
  }
}

function computeTravelTime(departs, arrives) {
  const [dh, dm] = departs.split(':').map(Number);
  const [ah, am] = arrives.split(':').map(Number);
  let minutes = (ah * 60 + am) - (dh * 60 + dm);
  return minutes < 0 ? minutes + 1440 : minutes;
}

module.exports = new GraphBuilder();

