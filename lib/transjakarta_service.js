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
  getAllSchedules() {
    return this.scheduleData;
  }

  // endapatkan rute berdasarkan `route_id`
  getScheduleByRoute(routeId) {
    return this.scheduleData.filter(schedule => schedule.route_id === routeId);
  }

  // Mendapatkan semua halte unik
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