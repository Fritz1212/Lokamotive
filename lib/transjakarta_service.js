const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

/**
 * Kelas TJScheduleService bertanggung jawab untuk memuat, memparsing, dan menyediakan akses
 * ke data jadwal dari file CSV yang berisi informasi data transportasi.
 *
 * @created 2024-12-01
 * @author Jane Doe
 */
class TJScheduleService {
   /**
   * Membuat instance TJScheduleService dan menginisialisasi scheduleData sebagai array kosong.
   *
   * @created 2024-12-01
   * @author Jane Doe
   */
  constructor() {
    /**
     * Array yang menyimpan data jadwal yang telah diparsing dari file CSV.
     * @type {Array<Object>}
     */
    this.scheduleData = [];
  }

  // Load & parse CSV
  /**
   * Memuat dan memparsing file CSV yang berisi data jadwal.
   *
   * Fungsi ini membaca file CSV menggunakan stream dan modul csv-parser dengan
   * pemisah ";" serta menyimpan hasil parsing ke dalam properti scheduleData.
   *
   * @created 2024-12-01
   * @async
   * @return {Promise<Array<Object>>} Promise yang mengembalikan array data jadwal setelah file selesai diproses.
   */
  async loadSchedule() {
    return new Promise((resolve, reject) => {
      const filePath = path.join(__dirname, '.', 'combine_tije_opendata_cleaned.csv'); // Sesuaikan lokasi file CSV
      const results = [];

      fs.createReadStream(filePath)
        .pipe(csv({ separator: ';' })) // Menggunakan pemisah ";"
        .on('data', (data) => results.push(data))
        .on('end', () => {
          this.scheduleData = results;
          resolve(results);
        })
        .on('error', (error) => reject(error));
    });
  }

  // Mendapatkan semua jadwal
  /**
   * Mengembalikan semua data jadwal yang telah dimuat.
   *
   * @created 2024-12-01
   * @return {Array<Object>} Array yang berisi seluruh data jadwal.
   */
  getAllSchedules() {
    return this.scheduleData;
  }

  // endapatkan rute berdasarkan `route_id`
  /**
   * Mendapatkan data jadwal berdasarkan route_id.
   *
   * Fungsi ini memfilter scheduleData dan mengembalikan data yang memiliki property route_id sesuai dengan parameter.
   *
   * @created 2024-12-01
   * @param {string} routeId - ID rute yang ingin dicari.
   * @return {Array<Object>} Array berisi data jadwal yang sesuai dengan route_id.
   */
  getScheduleByRoute(routeId) {
    return this.scheduleData.filter(schedule => schedule.route_id === routeId);
  }

  // Mendapatkan semua halte unik
  /**
   * Mengambil daftar semua halte unik dari data jadwal.
   *
   * Fungsi ini memastikan bahwa data schedule telah dimuat (menggunakan loadSchedule jika perlu),
   * kemudian membangun Map untuk menghindari duplikasi berdasarkan nama halte. Hasilnya berupa array
   * objek yang berisi nama halte serta koordinatnya (latitude dan longitude).
   *
   * @created 2024-12-01
   * @async
   * @return {Promise<Array<{name: string, lat: number, lng: number}>>} Array berisi objek halte unik.
   */
  async getAllStops() {
    if (this.scheduleData.length === 0) {
      await this.loadSchedule();
    }

    const uniqueStops = new Map();

    this.scheduleData.forEach(stop => {
      if (!uniqueStops.has(stop.stop_name)) {
        uniqueStops.set(stop.stop_name, {
          name: stop.stop_name,
          lat: parseFloat(stop.stop_lat),
          lng: parseFloat(stop.stop_lon)
        });
      }
    });
    return Array.from(uniqueStops.values());
  }
}

module.exports = new TJScheduleService();