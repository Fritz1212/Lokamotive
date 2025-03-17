// src/services/StopCoordinatesService.js
const axios = require('axios');
const apiKey = 'YAIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o'; // Ganti dengan API key Google Anda

/**
 * Fungsi untuk mendapatkan koordinat berdasarkan query stasiun menggunakan Google Geocoding API.
 * @param {string} stationQuery - Query (misalnya, nama atau id stasiun).
 * @returns {Promise<Object|null>} Objek dengan properti { lat, lng } atau null jika gagal.
 */
async function getCoordinatesForStation(stationQuery) {
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(stationQuery)}&key=${apiKey}`;
  try {
    const response = await axios.get(url);
    if (response.data.status === 'OK' && response.data.results.length > 0) {
      const loc = response.data.results[0].geometry.location;
      return { lat: loc.lat, lng: loc.lng };
    } else {
      throw new Error(`Geocoding failed: ${response.data.status}`);
    }
  } catch (error) {
    console.error(`Error geocoding station "${stationQuery}": ${error.message}`);
    return null;
  }
}

module.exports = { getCoordinatesForStation };
