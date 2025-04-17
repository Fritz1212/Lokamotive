require("dotenv").config();
const axios = require("axios");

const GOOGLE_PLACES_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

/**
 * Menangani permintaan pencarian (search) melalui WebSocket.
 *
 * Fungsi ini memeriksa apakah aksi yang diterima berupa "search" dan memvalidasi query yang diberikan.
 * Jika query valid, fungsi ini membangun URL untuk memanggil Google Places API untuk mendapatkan
 * prediksi pencarian berdasarkan input pengguna. Respons dari Google API kemudian dikirim kembali
 * ke client melalui WebSocket. Jika terjadi error atau query tidak valid, fungsi mengirimkan pesan error.
 * 
 * @author Fritz Gradiyoga
 * @async
 * @param {WebSocket} ws - Instance WebSocket yang digunakan untuk komunikasi dengan client.
 * @param {Object} data - Objek data yang dikirim oleh client. Diharapkan berisi properti:
 *                        - action: Aksi yang diinginkan, misalnya "search".
 *                        - query: String input pencarian dari pengguna.
 * @return {Promise<void>} Tidak mengembalikan nilai, tetapi mengirimkan respons melalui WebSocket.
 */
async function handleSearch(ws, data) {
    if (data.action === "search") {
        const query = data.query;
        if (!query || query.length < 3) {
            ws.send(JSON.stringify({ status: "error", message: "Query too short" }));
            return;
        }
        const JABODETABEK_LOCATION = { lat: -6.2088, lng: 106.8456 };
        const RADIUS = 50000;

        const url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${encodeURIComponent(
            query
        )}&types=establishment&components=country:ID&location=${JABODETABEK_LOCATION.lat},${JABODETABEK_LOCATION.lng}&radius=${RADIUS}&strictbounds&key=${GOOGLE_PLACES_API_KEY}`;

        try {
            const response = await axios.get(url);
            ws.send(JSON.stringify({ status: "success", results: response.data.predictions }));
            console.log("bisa ini")
        } catch (error) {
            console.error("❌ Error fetching search results:", error);
            ws.send(JSON.stringify({ status: "error", message: "Google API error" }));
            console.log("bisa ini 2")
        }
    } else {
        ws.send(JSON.stringify({ status: "error", message: "Invalid search action" }));
        console.log("bisa ini 3")
    }
}

module.exports = handleSearch;
