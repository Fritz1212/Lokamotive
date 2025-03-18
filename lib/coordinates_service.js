const axios = require('axios');

// Cache to store already resolved coordinates
const coordinateCache = new Map();
const MAX_RETRIES = 2;
const CACHE_TTL = 1000 * 60 * 60; // 1 hour cache

async function getCoordinatesForStation(stationQuery) {
  // Check cache first
  const cached = coordinateCache.get(stationQuery);
  if (cached && (Date.now() - cached.timestamp < CACHE_TTL)) {
    return cached.coordinates;
  }

  const apiKey = 'AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o';
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(stationQuery)}&key=${apiKey}`;

  console.log(`Fetching coordinates for "${stationQuery}"...`);

  let retries = 0;
  const controller = new AbortController();

  while (retries <= MAX_RETRIES) {
    try {
      const response = await axios.get(url, {
        timeout: 5000,
        signal: controller.signal
      });

      if (response.data.status !== 'OK') {
        throw new Error(`API Error: ${response.data.status}`);
      }

      const location = response.data.results[0].geometry.location;
      const coordinates = { lat: location.lat, lng: location.lng };

      // Update cache
      coordinateCache.set(stationQuery, {
        coordinates,
        timestamp: Date.now()
      });

      return coordinates;
    } catch (error) {
      if (retries === MAX_RETRIES) {
        console.error(`Failed after ${MAX_RETRIES} retries for "${stationQuery}": ${error.message}`);
        coordinateCache.set(stationQuery, {
          coordinates: null,
          timestamp: Date.now()
        });
        return null;
      }

      if (error.code === 'ECONNABORTED') {
        console.log(`Timeout for "${stationQuery}", retrying...`);
        retries++;
      } else {
        console.error(`Error for "${stationQuery}": ${error.message}`);
        return null;
      }
    } finally {
      controller.abort(); // Clean up any pending requests
    }
  }
}

module.exports = { getCoordinatesForStation };