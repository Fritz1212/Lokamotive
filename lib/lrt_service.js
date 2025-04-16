const fs = require('fs');
const path = require('path');
const axios = require('axios');
const GOOGLE_MAPS_API_KEY = 'AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o';

/**
 * Kelas LRTScheduleService mengelola data jadwal LRT dan menyediakan fungsi untuk mengakses serta memproses data tersebut.
 *
 * @created 2024-12-01
 * @author Jane Doe
 */
class LRTScheduleService {
  /**
   * Membuat instance LRTScheduleService dan langsung memuat data jadwal dari file JSON.
   *
   * @created 2024-12-01
   * @author Jane Doe
   */
  constructor() {
    /**
     * Array yang menyimpan data jadwal LRT.
     * @type {Array<Object>}
     */
    this.scheduleData = [];
    this.loadSchedule();
  }

  // Load data JSON LRT
  /**
   * Memuat data jadwal LRT dari file JSON.
   * File ini diharapkan berada di direktori yang sama dengan file kode.
   * Jika terjadi error selama proses pembacaan atau parsing file, maka
   * data jadwal akan diinisialisasi sebagai array kosong.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @return {void}
   */
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
   /**
   * Mengembalikan semua jadwal LRT yang telah dimuat.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @return {Array<Object>} Array berisi semua data jadwal LRT.
   */
  getAllSchedules() {
    return this.scheduleData;
  }

  // Mendapatkan jadwal berdasarkan asal & tujuan
  /**
   * Mencari dan mengembalikan data jadwal LRT berdasarkan rute asal dan tujuan.
   *
   * Fungsi ini mencari dalam array scheduleData dan mengembalikan jadwal
   * yang memiliki nilai properti 'from' dan 'to' sesuai dengan parameter yang diberikan.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @param {String} from - Stasiun keberangkatan.
   * @param {String} to - Stasiun tujuan.
   * @return {Object|null} Objek jadwal yang ditemukan, atau null jika tidak ada kecocokan.
   */
  getScheduleByRoute(from, to) {
    return this.scheduleData.find(
      schedule => schedule.from === from && schedule.to === to
    ) || null;
  }

  // Mendapatkan daftar semua stasiun unik
  /**
   * Mengembalikan daftar semua stasiun unik yang terdapat dalam data jadwal LRT.
   *
   * Fungsi ini mengiterasi seluruh jadwal, kemudian mengumpulkan setiap nama stasiun
   * dari properti 'from' dan 'to' ke dalam sebuah Set untuk menghindari duplikasi.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @return {Array<String>} Array berisi nama-nama stasiun unik.
   */
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

  /**
   * Mengambil koordinat (latitude dan longitude) dari sebuah tempat menggunakan API Google Maps.
   * Jika Google Maps API gagal memberikan respons dengan status 'OK', maka fungsi ini akan beralih menggunakan API OpenStreetMap.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @param {String} placeName - Nama tempat yang ingin dicari koordinatnya.
   * @return {Promise<Object|null>} Promise yang mengembalikan objek dengan properti 'lat' dan 'lng',
   *                                atau null jika koordinat tidak dapat diperoleh.
   */
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
