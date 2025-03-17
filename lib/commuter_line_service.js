const moment = require('moment');
const { getCoordinatesForStation } = require('./coordinates_service.js');

/**
 * Memproses data Commuter Line yang telah dibaca dari file .txt.
 * Jika tidak terdapat data koordinat (origin_lat, origin_lng, destination_lat, destination_lng),
 * maka fungsi ini akan melakukan geocoding untuk mendapatkan nilai tersebut.
 *
 * Asumsi: scheduleData adalah array objek dengan field:
 * - station_id, station_origin_id, station_destination_id, train_id, line, route,
 *   departs_at, arrives_at, dan mungkin origin_lat, origin_lng, destination_lat, destination_lng.
 *
 * @param {Array} scheduleData - Data mentah dari file .txt.
 * @returns {Promise<Array>} Array objek node unik, masing-masing dengan properti: id, name, lat, lng.
 */
async function processCommuterData(scheduleData) {
  const nodesMap = {};

  await Promise.all(scheduleData.map(async item => {
    // Filter record yang tidak lengkap
    if (!item.station_origin_id || !item.station_destination_id ||
        !item.train_id || !item.line || !item.route || !item.departs_at || !item.arrives_at) {
      return;
    }

    // Format waktu ke HH:mm
    const formattedDeparts = moment(item.departs_at).format('HH:mm');
    const formattedArrives = moment(item.arrives_at).format('HH:mm');

    // Ambil koordinat, jika tersedia, atau set ke null jika tidak
    let origin_lat = item.origin_lat ? parseFloat(item.origin_lat) : null;
    let origin_lng = item.origin_lng ? parseFloat(item.origin_lng) : null;
    let destination_lat = item.destination_lat ? parseFloat(item.destination_lat) : null;
    let destination_lng = item.destination_lng ? parseFloat(item.destination_lng) : null;

    // Jika koordinat origin tidak tersedia, lakukan geocoding menggunakan station_origin_id (atau nama stasiun jika tersedia)
    if (origin_lat === null || origin_lng === null) {
      const originQuery = item.station_origin_id;
      const originCoords = await getCoordinatesForStation(originQuery);
      if (originCoords) {
        origin_lat = originCoords.lat;
        origin_lng = originCoords.lng;
      }
    }

    // Jika koordinat destination tidak tersedia, lakukan geocoding menggunakan station_destination_id
    if (destination_lat === null || destination_lng === null) {
      const destinationQuery = item.station_destination_id;
      const destinationCoords = await getCoordinatesForStation(destinationQuery);
      if (destinationCoords) {
        destination_lat = destinationCoords.lat;
        destination_lng = destinationCoords.lng;
      }
    }

    // Tambahkan node untuk station_origin_id
    if (!nodesMap[item.station_origin_id]) {
      nodesMap[item.station_origin_id] = {
        id: item.station_origin_id,
        name: item.station_origin_id, // Ganti dengan nama lengkap jika ada
        lat: origin_lat,
        lng: origin_lng
      };
    }
    
    // Tambahkan node untuk station_destination_id
    if (!nodesMap[item.station_destination_id]) {
      nodesMap[item.station_destination_id] = {
        id: item.station_destination_id,
        name: item.station_destination_id,
        lat: destination_lat,
        lng: destination_lng
      };
    }
  }));

  // Kembalikan array node unik
  return Object.values(nodesMap);
}

module.exports = processCommuterData;
