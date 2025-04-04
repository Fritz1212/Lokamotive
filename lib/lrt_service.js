const fs = require('fs');
const path = require('path');
const axios = require('axios');
const GOOGLE_MAPS_API_KEY = 'AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o';

class LRTScheduleService {
  constructor() {
    this.scheduleData = [];
    this.loadSchedule();
  }

  // Load data JSON LRT
  loadSchedule() {
    try {
      const filePath = path.join(__dirname, 'scheduleDataLRT.json'); // Pastikan file ada di direktori yang sama
      const rawData = fs.readFileSync(filePath, 'utf8');
      this.scheduleData = JSON.parse(rawData);
    } catch (error) {
      console.error("Error loading LRT schedule:", error);
      this.scheduleData = [];
    }
  }

  // Mendapatkan semua jadwal
  getAllSchedules() {
    return this.scheduleData;
  }

  // Mendapatkan jadwal berdasarkan asal & tujuan
  getScheduleByRoute(from, to) {
    return this.scheduleData.find(
      schedule => schedule.from === from && schedule.to === to
    ) || null;
  }

  // Mendapatkan daftar semua stasiun unik
  getAllStations() {
    const stations = new Set();
    this.scheduleData.forEach(schedule => {
      // console.log(`Processing schedule: from ${schedule.from} to ${schedule.to}`);
      stations.add(schedule.from);
      stations.add(schedule.to);
      // console.log(`Current stations set: ${Array.from(stations)}`);
    });
    return Array.from(stations);
  }

  async getCoordinates(placeName) {
    const API_KEY = GOOGLE_MAPS_API_KEY;
    const url = `https://maps.googleapis.com/maps/api/geocode/json`;
    const OSM_URL = `https://nominatim.openstreetmap.org/search`;


    try {
      const response = await axios.get(url, {
        params: {
          address: placeName,
          key: API_KEY
        }
      });

      if (response.data.status === 'OK') {
        const location = response.data.results[0].geometry.location;
        return { lat: location.lat, lng: location.lng };
      } else {
        console.log("Redirecting to OpenStreetMap...");
      }

      const osmResponse = await axios.get(OSM_URL, {
        params: { q: placeName, format: "json" }
      });

      if (osmResponse.data.length > 0) {
        return { lat: parseFloat(osmResponse.data[0].lat), lng: parseFloat(osmResponse.data[0].lon) };
      } else {
        console.warn("OpenStreetMap could not find coordinates.");
      }
    } catch (error) {
      console.error('Error fetching coordinates:', error.message);
      return null;
    }
  }
}

module.exports = new LRTScheduleService();
