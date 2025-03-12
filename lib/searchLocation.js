require("dotenv").config();
const axios = require("axios");

const GOOGLE_PLACES_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

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
