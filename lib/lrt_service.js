const fs = require('fs');
const path = require('path');

class LRTScheduleService {
  constructor() {
    this.scheduleData = [];
    this.loadSchedule();
  }

  // Load data JSON LRT
  loadSchedule() {
    try {
      const filePath = path.join(__dirname, 'lrt_schedule.json'); // Pastikan file ada di direktori yang sama
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
      stations.add(schedule.from);
      stations.add(schedule.to);
    });
    return Array.from(stations);
  }
}

module.exports = new LRTScheduleService();
