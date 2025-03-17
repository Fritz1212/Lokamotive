const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

class TJScheduleService {
  constructor() {
    this.scheduleData = [];
  }

  // Load & parse CSV
  async loadSchedule() {
    return new Promise((resolve, reject) => {
      const filePath = path.join(__dirname, 'transjakarta_schedule.csv'); // Sesuaikan lokasi file CSV
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
  getAllSchedules() {
    return this.scheduleData;
  }

  // endapatkan rute berdasarkan `route_id`
  getScheduleByRoute(routeId) {
    return this.scheduleData.filter(schedule => schedule.route_id === routeId);
  }

  // Mendapatkan semua halte unik
  getAllStops() {
    const stops = new Set();
    this.scheduleData.forEach(schedule => stops.add(schedule.stop_name));
    return Array.from(stops);
  }
}

module.exports = new TJScheduleService();
