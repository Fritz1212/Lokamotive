const fs = require('fs').promises;
const path = require('path');
const axios = require('axios');

const GOOGLE_MAPS_API_KEY = 'AIzaSyDAgMexUNwu84Kd5IqC-Kg97ZX7dsACV18';

/**
 * Kelas MRTScheduleService mengelola data jadwal MRT dan ekstraksi data stasiun beserta koordinatnya.
 * Data jadwal disimpan dalam file outputMRT.json.
 *
 * @author Fritz Gradiyoga
 */
class MRTScheduleService {
    /**
     * Membuat instance MRTScheduleService.
     * Menginisialisasi path file jadwal dan struktur data untuk menyimpan stasiun serta koordinatnya.
     *
     * @author Fritz Gradiyoga
     */
    constructor() {
        /**
         * Lokasi file output jadwal MRT.
         * @type {String}
         */
        this.scheduleFilePath = path.join(__dirname, '.', 'outputMRT.json');
        /**
         * Map untuk menyimpan data stasiun.
         * Setiap kunci adalah nama stasiun dan nilainya adalah objek yang berisi nama stasiun, lat, dan lng.
         * @type {Map<String, {name: String, lat: number|null, lng: number|null}>}
         */
        this.stations = new Map(); // Menyimpan stasiun beserta koordinatnya
    }

    /**
     * Memuat data jadwal MRT dari file JSON dan mengekstrak daftar stasiun.
     *
     * Data jadwal diambil dari file outputMRT.json dan setiap entri stasiun akan dimasukkan ke dalam Map.
     *
     * @author Fritz Gradiyoga
     * @async
     * @return {Promise<Map<String, {name: String, lat: number|null, lng: number|null}>>} Map berisi daftar stasiun.
     * @throws Error Jika terjadi kegagalan dalam membaca atau memparsing file.
     */
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

    /**
     * Mengambil koordinat (latitude dan longitude) untuk setiap stasiun yang belum memiliki data koordinat.
     *
     * Fungsi ini akan mencoba memperoleh data koordinat menggunakan Google Maps Geocoding API.
     * Jika berhasil, koordinat stasiun akan diperbarui pada struktur data Map.
     *
     * @author Fritz Gradiyoga
     * @async
     * @return {Promise<Map<String, {name: String, lat: number|null, lng: number|null}>>} Map stasiun yang telah diperbarui dengan koordinat.
     */
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