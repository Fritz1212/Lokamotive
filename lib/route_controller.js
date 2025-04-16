const TransportationRecommender = require("./collaborative_filtering.js");
const haversineDistance = require('./haversine.js');
const PathFinder = require("./path_finder");

// WebSocket-compatible version
/**
 * Fungsi ini menangani permintaan untuk mendapatkan rute rekomendasi melalui WebSocket.
 * Prosesnya mencakup:
 * 1. Parsing pesan JSON dari client untuk mengambil parameter yang diperlukan.
 * 2. Pembangunan graph rute menggunakan kelas PathFinder.
 * 3. Inisialisasi dan pemanggilan rekomendasi rute melalui TransportationRecommender.
 * 4. Penanganan masalah "first mile" dan "last mile" dengan menambahkan edge "Walking" pada graph.
 * 5. Format dan sanitasi rute yang direkomendasikan sebelum dikirim kembali ke client melalui WebSocket.
 *
 * @async
 * @param {string} message - Pesan JSON dari client yang berisi parameter:
 *                             - userId: ID pengguna.
 *                             - start: Nama lokasi awal.
 *                             - destination: Nama lokasi tujuan.
 *                             - startLat: Lintang (latitude) lokasi awal.
 *                             - startLng: Bujur (longitude) lokasi awal.
 *                             - destinationLat: Lintang (latitude) lokasi tujuan.
 *                             - destinationLng: Bujur (longitude) lokasi tujuan.
 *                             - preference: Preferensi tambahan untuk rekomendasi rute.
 *                             - k: (opsional) Jumlah rute terpendek yang ingin dicari.
 * @param {WebSocket} ws - Instance WebSocket untuk mengirimkan respons kembali ke client.
 * @return {void}
 */
async function getRecommendedRoutesWS(message, ws) {
  let pathFinder = new PathFinder({});

  try {
    // Parse JSON message from client
    const { userId, start, destination, startLat, startLng, destinationLat, destinationLng, preference, k } = JSON.parse(message);
    if (!userId || !start || !destination) {
      return ws.send(JSON.stringify({ error: "Parameter 'userId', 'start', dan 'destination' wajib diisi." }));
    }
    // Load graph and find start/destination stops
    console.log("Building graph...");
    const graph = await pathFinder.initialize(start, destination, startLat, startLng, destinationLat, destinationLng);
    recommender = new TransportationRecommender(pathFinder);
    recommender.initialize(userId, preference);
    setTimeout(() => {
      const nodes = Object.values(graph.nodes);
      const startStop = nodes.find((n) => n.name.toLowerCase() === start.toLowerCase());
      const destStop = nodes.find((n) => n.name.toLowerCase() === destination.toLowerCase());

      if (!startStop || !destStop) {
        return ws.send(JSON.stringify({ error: "Lokasi start atau destination tidak ditemukan dalam graph." }));
      }

      // console.log("start lngt: ", startLng)

      //first mile and last mile problem
      const nearestNodeStart = haversineDistance.findNearestNode({ lat: startLat, lang: startLng }, graph)
      graph.addEdge('0', nearestNodeStart.nearestNodeId, "Walking", {})

      const nearestNodeDestination = haversineDistance.findNearestNode({ lat: destinationLat, lang: destinationLng }, graph)
      graph.addEdge("destination", nearestNodeDestination.nearestNodeId, "Walking", {})

      // Get recommendations
      const recommendations = recommender.recommend(userId, startStop.id, destStop.id, graph);

      console.log("recommendations : ", recommendations);

      // Format response
      const formattedRoutes = recommendations.map((rec) => {
        const segments = rec.route.segments;
        const fullPath = rec.route.path;

        const pointsPerSegment = Math.floor(fullPath.length / segments.length);
        let remainder = fullPath.length % segments.length;

        let currentIndex = 0;

        const assignedSegments = segments.map((segment, index) => {
          const extra = index < remainder ? 1 : 0;
          const thisChunkSize = pointsPerSegment + extra;
          const segmentPath = fullPath.slice(currentIndex, currentIndex + thisChunkSize);
          currentIndex += thisChunkSize;

          return {
            ...segment,
            details: {
              ...segment.details,
              route: segmentPath,
            }
          };
        });

        return {
          ...rec,
          route: {
            ...rec.route,
            segments: assignedSegments,
          },
        };
      });

      console.log("formattedRoutes:", formattedRoutes);

       /**
       * Fungsi untuk mensanitasi rute sebelum dikirim ke client.
       * Proses sanitasi mencakup pemfilteran properti yang tidak diperlukan seperti koordinat yang terlalu detail.
       *
       * @param {Object} route - Objek rute yang berisi path, total weight, dan segmen.
       * @return {Object} Objek rute yang telah disanitasi.
       */
      function sanitizeRoute(route) {
        return {
          path: route.path.map(p => ({ lat: p.lat, lang: p.lang })),
          totalWeight: route.totalWeight,
          segments: route.segments.map(seg => ({
            mode: seg.mode,
            // details: {
            //   route: seg.details?.route?.path
            //     ? seg.details.route.path.map(p => ({ lat: p.lat, lang: p.lang }))
            //     : null
            // }
          }))
        };
      }


      const sanitized = formattedRoutes.map(rec => ({
        score: rec.score,
        route: sanitizeRoute(rec.route)
      }));

      console.log("sanitized:", JSON.stringify(sanitized, null, 2));

      // Send response via WebSocket
      ws.send(JSON.stringify(sanitized));
    }, 1500);
  } catch (error) {
    console.error("Error in getRecommendedRoutesWS:", error);
    ws.send(JSON.stringify({ error: error.message }));
  }
}

module.exports = {
  getRecommendedRoutesWS,
};