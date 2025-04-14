const fs = require('fs').promises;
const path = require('path');
const axios = require('axios');

const GOOGLE_MAPS_API_KEY = 'AIzaSyDAgMexUNwu84Kd5IqC-Kg97ZX7dsACV18';

class MRTScheduleService {
    constructor() {
        this.scheduleFilePath = path.join(__dirname, '.', 'outputMRT.json');
        this.stations = new Map(); // Menyimpan stasiun beserta koordinatnya
    }

    async loadSchedule() {
        try {
            const data = await fs.readFile(this.scheduleFilePath, 'utf8');
            const schedules = JSON.parse(data);

            // Ekstraksi daftar stasiun
            for (const station of schedules) {
                const stationName = station.text;
                if (!this.stations.has(stationName)) {
                    this.stations.set(stationName, { name: stationName, lat: null, lng: null });
                }
            }

            return this.stations;
        } catch (error) {
            console.error('Error loading MRT schedule:', error.message);
            throw error;
        }
    }

    async getStationCoordinates() {
        for (const [name, station] of this.stations) {
            if (station.lat === null || station.lng === null) {
                try {
                    const response = await axios.get(`https://maps.googleapis.com/maps/api/geocode/json`, {
                        params: {
                            address: `${name} MRT Station, Jakarta, Indonesia`,
                            key: GOOGLE_MAPS_API_KEY
                        }
                    });

                    if (response.data.status === 'OK') {
                        const location = response.data.results[0].geometry.location;
                        station.lat = location.lat;
                        station.lng = location.lng;
                    } else {
                        console.warn(`Failed to fetch coordinates for ${name}`);
                    }
                } catch (error) {
                    console.error(`Error fetching coordinates for ${name}:`, error.message);
                }
            }
        }
        return this.stations;
    }


}

module.exports = new MRTScheduleService();