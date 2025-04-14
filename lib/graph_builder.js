const Graph = require('./graph.js');
const Node = require('./daNode.js');
const haversineDistance = require('./haversine.js');
const CLService = require('./CLschedule.js');
const MRTService = require('./mrt_service.js');
const LRTService = require('./lrt_service.js');
const TJService = require('./transjakarta_service.js');
const processCommuterData = require('./commuter_line_service.js');
const moment = require('moment');

class GraphBuilder {
  async buildGraph(start, destination, startLat, startLng, destinationLat, destinationLng) {
    const graph = new Graph();

    // 🚇**Commuter Line Integration**
    // First process all stations
    const rawDataCL = await CLService.getCLData();
    const commuterStations = await processCommuterData(rawDataCL);

    // Add stations to graph first
    commuterStations.forEach(station => {
      if (!graph.nodes[station.id]) {
        graph.addNode(new Node(
          station.id,
          station.name,  // Use name from stationCodeMap
          "Commuter Line",
          station.lat,
          station.lng
        ));
      }
    });

    // Then process schedule items for edges
    rawDataCL.forEach(scheduleItem => {
      try {
        // Validate required fields
        if (!scheduleItem.station_origin_id ||
          !scheduleItem.station_destination_id ||
          !scheduleItem.departs_at ||
          !scheduleItem.arrives_at) {
          return;
        }

        // Calculate edge weight
        const weight = computeTravelTime(
          moment(scheduleItem.departs_at).format('HH:mm'),
          moment(scheduleItem.arrives_at).format('HH:mm')
        );

        // Add edge
        graph.addEdge(
          scheduleItem.station_origin_id,
          scheduleItem.station_destination_id,
          "Commuter Line",
          weight,
          {
            time: weight
          }
        );
      } catch (error) {
        console.error('Error processing schedule item:', error);
      }
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

    const mrtStationNames = Array.from(mrtStations.keys());

    for (let i = 0; i < mrtStationNames.length - 1; i++) {
      const origin = mrtStationNames[i];
      const destination = mrtStationNames[i + 1];

      graph.addEdge(origin, destination, "MRT", 3, { time: 3 });
      graph.addEdge(destination, origin, "MRT", 3, { time: 3 });
    }

    // 🚝 **3. LRT Integration**
    const lrtStations = await LRTService.getAllStations();

    for (let stationName of lrtStations) {
      let latitudeLongi = await LRTService.getCoordinates(stationName);

      if (!latitudeLongi) {
        latitudeLongi = { lat: null, lng: null };
      }

      if (!graph.nodes[stationName]) {
        graph.addNode(new Node(
          stationName, // Use modified name consistently
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

      // console.log(`Creating LRT edge from ${origin} to ${destination}`);
      graph.addEdge(origin, destination, "LRT", 4, { time: 4 });
      graph.addEdge(destination, origin, "LRT", 4, { line: 4 });
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

      graph.addEdge(origin.name, destination.name, "TransJakarta", 5, { time: 5 });
      graph.addEdge(destination.name, origin.name, "TransJakarta", 5, { time: 5 });
    }

    // 🚶 **5. Walking Connections (Dynamic)**
    this.addWalkingEdges(graph);

    //first mile problem (solved : add edge for current location (gps) to nearest station or stop)
    //tambahin node buat current location juga secara dinamis
    //last mile problem (solved: add edge for last station or stop to destination)

    graph.addNode(new Node("0", start, "Your Location", startLat, startLng))
    graph.addNode(new Node("destination", destination, "Your Destination", destinationLat, destinationLng))

    return graph;
  }

  addWalkingEdges(graph) {
    const nodeIds = Object.keys(graph.nodes);
    for (let i = 0; i < nodeIds.length; i++) {
      for (let j = i + 1; j < nodeIds.length; j++) {
        const nodeA = graph.nodes[nodeIds[i]];
        const nodeB = graph.nodes[nodeIds[j]];
        const d = haversineDistance.haversine_distance(nodeA.lat, nodeB.lat, nodeA.lang, nodeB.lang);

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

