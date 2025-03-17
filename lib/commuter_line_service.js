const { getCoordinatesForStation } = require('./coordinates_service.js');

const stationCodeMap = {
  // AREA JABODETABEK
  "AC": "Stasiun ANCOL, Jabodetabek, Indonesia",
  "AK": "Stasiun ANGKE, Jabodetabek, Indonesia",
  "BJD": "Stasiun BOJONGGEDE, Jabodetabek, Indonesia",
  "BKS": "Stasiun BEKASI, Jabodetabek, Indonesia",
  "BKST": "Stasiun BEKASI TIMUR, Jabodetabek, Indonesia",
  "BOI": "Stasiun BOJONG INDAH, Jabodetabek, Indonesia",
  "BOO": "Stasiun BOGOR, Jabodetabek, Indonesia",
  "BPR": "Stasiun BATU CEPER, Jabodetabek, Indonesia",
  "BUA": "Stasiun BUARAN, Jabodetabek, Indonesia",
  "CBN": "Stasiun CIBINONG, Jabodetabek, Indonesia",
  "CC": "Stasiun CICAYUR, Jabodetabek, Indonesia",
  "CIT": "Stasiun CIBITUNG, Jabodetabek, Indonesia",
  "CJT": "Stasiun CILEJIT, Jabodetabek, Indonesia",
  "CKI": "Stasiun CIKINI, Jabodetabek, Indonesia",
  "CKR": "Stasiun CIKARANG, Jabodetabek, Indonesia",
  "CKY": "Stasiun CIKOYA, Jabodetabek, Indonesia",
  "CLT": "Stasiun CILEBUT, Jabodetabek, Indonesia",
  "CSK": "Stasiun CISAUK, Jabodetabek, Indonesia",
  "CTA": "Stasiun CITAYAM, Jabodetabek, Indonesia",
  "CTR": "Stasiun CITERAS, Jabodetabek, Indonesia",
  "CUK": "Stasiun CAKUNG, Jabodetabek, Indonesia",
  "CW": "Stasiun CAWANG, Jabodetabek, Indonesia",
  "DAR": "Stasiun DARU, Jabodetabek, Indonesia",
  "DP": "Stasiun DEPOK, Jabodetabek, Indonesia",
  "DPB": "Stasiun DEPOK BARU, Jabodetabek, Indonesia",
  "DRN": "Stasiun DUREN KALIBATA, Jabodetabek, Indonesia",
  "DU": "Stasiun DURI, Jabodetabek, Indonesia",
  "GDD": "Stasiun GONDANGDIA, Jabodetabek, Indonesia",
  "GGL": "Stasiun GROGOL, Jabodetabek, Indonesia",
  "GST": "Stasiun GANG SENTIONG, Jabodetabek, Indonesia",
  "JAKK": "Stasiun Jakarta Kota, Jakarta, Indonesia",
  "JAY": "Stasiun JAYAKARTA, Jabodetabek, Indonesia",
  "JMU": "Stasiun JURANG MANGU, Jabodetabek, Indonesia",
  "JNG": "Stasiun JATINEGARA, Jabodetabek, Indonesia",
  "JUA": "Stasiun JUANDA, Jabodetabek, Indonesia",
  "KAT": "Stasiun KARET, Jabodetabek, Indonesia",
  "KBY": "Stasiun KEBAYORAN, Jabodetabek, Indonesia",
  "KDS": "Stasiun KALIDERES, Jabodetabek, Indonesia",
  "KLD": "Stasiun KLENDER, Jabodetabek, Indonesia",
  "KLDB": "Stasiun KLENDER BARU, Jabodetabek, Indonesia",
  "KMO": "Stasiun KEMAYORAN, Jabodetabek, Indonesia",
  "KMT": "Stasiun KRAMAT, Jabodetabek, Indonesia",
  "KPB": "Stasiun KAMPUNG BANDAN, Jabodetabek, Indonesia",
  "KRI": "Stasiun KRANJI, Jabodetabek, Indonesia",
  "LNA": "Stasiun LENTENG AGUNG, Jabodetabek, Indonesia",
  "MGB": "Stasiun MANGGA BESAR, Jabodetabek, Indonesia",
  "MJ": "Stasiun MAJA, Jabodetabek, Indonesia",
  "MTR": "Stasiun MATRAMAN, Jabodetabek, Indonesia",
  "MRI": "Stasiun MANGGARAI, Jabodetabek, Indonesia",
  "TLM": "Stasiun METLAND TELAGAMURNI, Jabodetabek, Indonesia",
  "NMO": "Stasiun NAMBO, Jabodetabek, Indonesia",
  "PDRG": "Stasiun PONDOK RAJEG, Jabodetabek, Indonesia",
  "PDJ": "Stasiun PONDOK RANJI, Jabodetabek, Indonesia",
  "PI": "Stasiun PORIS, Jabodetabek, Indonesia",
  "PLM": "Stasiun PALMERAH, Jabodetabek, Indonesia",
  "POC": "Stasiun PONDOK CINA, Jabodetabek, Indonesia",
  "POK": "Stasiun PONDOK JATI, Jabodetabek, Indonesia",
  "PRP": "Stasiun PARUNG PANJANG, Jabodetabek, Indonesia",
  "PSE": "Stasiun PASAR SENEN, Jabodetabek, Indonesia",
  "PSG": "Stasiun PESING, Jabodetabek, Indonesia",
  "PSM": "Stasiun PASAR MINGGU, Jabodetabek, Indonesia",
  "PSMB": "Stasiun PASAR MINGGU BARU, Jabodetabek, Indonesia",
  "RJW": "Stasiun RAJAWALI, Jabodetabek, Indonesia",
  "RU": "Stasiun RAWA BUNTU, Jabodetabek, Indonesia",
  "RW": "Stasiun RAWA BUAYA, Jabodetabek, Indonesia",
  "SDM": "Stasiun SUDIMARA, Jabodetabek, Indonesia",
  "SRP": "Stasiun SERPONG, Jabodetabek, Indonesia",
  "SUDB": "Stasiun SUDIRMAN BARU, Jabodetabek, Indonesia",
  "SUD": "Stasiun SUDIRMAN, Jabodetabek, Indonesia",
  "SW": "Stasiun SAWAH BESAR, Jabodetabek, Indonesia",
  "TB": "Stasiun TAMBUN, Jabodetabek, Indonesia",
  "TEB": "Stasiun TEBET, Jabodetabek, Indonesia",
  "TEJ": "Stasiun TENJO, Jabodetabek, Indonesia",
  "TGS": "Stasiun TIGARAKSA, Jabodetabek, Indonesia",
  "THB": "Stasiun TANAH ABANG, Jabodetabek, Indonesia",
  "TKO": "Stasiun TAMAN KOTA, Jabodetabek, Indonesia",
  "TNG": "Stasiun TANGERANG, Jabodetabek, Indonesia",
  "TNT": "Stasiun TANJUNG BARAT, Jabodetabek, Indonesia",
  "TPK": "Stasiun TANJUNG PRIOK, Jabodetabek, Indonesia",
  "TTI": "Stasiun TANAH TINGGI, Jabodetabek, Indonesia",
  "UI": "Stasiun UNIV. INDONESIA, Jabodetabek, Indonesia",
  "UP": "Stasiun UNIV. PANCASILA, Jabodetabek, Indonesia",

  // AREA YOGYAKARTA
  "BBN": "Stasiun BRAMBANAN, Yogyakarta, Indonesia",
  "CE": "Stasiun CEPER, Yogyakarta, Indonesia",
  "DL": "Stasiun DELANGGU, Yogyakarta, Indonesia",
  "GW": "Stasiun GAWOK, Yogyakarta, Indonesia",
  "JN": "Stasiun JENAR, Yogyakarta, Indonesia",
  "KT": "Stasiun KLATEN, Yogyakarta, Indonesia",
  "KTA": "Stasiun KUTOARJO, Yogyakarta, Indonesia",
  "LPN": "Stasiun LEMPUYANGAN, Yogyakarta, Indonesia",
  "MGW": "Stasiun MAGUWO, Yogyakarta, Indonesia",
  "PWS": "Stasiun PURWOSARI, Yogyakarta, Indonesia",
  "SLO": "Stasiun SOLO BALAPAN, Yogyakarta, Indonesia",
  "SWT": "Stasiun SROWOT, Yogyakarta, Indonesia",
  "WJ": "Stasiun WOJO, Yogyakarta, Indonesia",
  "WT": "Stasiun WATES, Yogyakarta, Indonesia",
  "YK": "Stasiun YOGYAKARTA, Yogyakarta, Indonesia",
  "PL": "Stasiun PALUR, Yogyakarta, Indonesia",
  "SK": "Stasiun SOLO JEBRES, Yogyakarta, Indonesia",

  // AREA MERAK
  "JBU": "Stasiun JAMBU BARU, Merak, Indonesia",
  "CT": "Stasiun CATANG, Merak, Indonesia",
  "CKL": "Stasiun CIKEUSAL, Merak, Indonesia",
  "WLT": "Stasiun WALANTAKA, Merak, Indonesia",
  "KRA": "Stasiun KARANGANTU, Merak, Indonesia",

  // SERANG
  "RK": "Stasiun RANGKASBITUNG, Serang, Indonesia",
  "TOJB": "Stasiun TONJONG BARU, Serang, Indonesia",
  "CLG": "Stasiun CILEGON, Serang, Indonesia",
  "KEN": "Stasiun KRENCENG, Serang, Indonesia",
  "MER": "Stasiun MERAK, Serang, Indonesia"
};

async function processCommuterData(scheduleData) {
  const nodesMap = {};
  const MAX_STATIONS = 40;

  for (const item of scheduleData) {
    try {
      // Early exit if we've reached the limit
      if (Object.keys(nodesMap).length >= MAX_STATIONS) break;

      // Validate required fields
      if (!item.station_origin_id || !item.station_destination_id) continue;

      // Get proper station names
      const originName = stationCodeMap[item.station_origin_id];
      const destName = stationCodeMap[item.station_destination_id];

      // Skip non-Jabodetabek stations early
      if (!originName?.includes('Jabodetabek') && !destName?.includes('Jabodetabek')) {
        continue;
      }

      // Process coordinates in parallel
      const [originCoords, destCoords] = await Promise.all([
        processStation(item.station_origin_id, originName, item.origin_lat, item.origin_lng),
        processStation(item.station_destination_id, destName, item.destination_lat, item.destination_lng)
      ]);

      // Update nodes map
      const updateNode = (id, coords) => {
        if (!coords || !stationCodeMap[id]?.includes('Jabodetabek')) return;
        if (Object.keys(nodesMap).length >= MAX_STATIONS) return;

        if (!nodesMap[id]) {
          nodesMap[id] = {
            id,
            name: stationCodeMap[id],
            lat: coords.lat,
            lng: coords.lng
          };
        }
      };

      updateNode(item.station_origin_id, originCoords);
      updateNode(item.station_destination_id, destCoords);

    } catch (error) {
      console.error(`Error processing ${item.train_id}:`, error.message);
    }
  }

  return Object.values(nodesMap).slice(0, MAX_STATIONS);
}

async function processStation(id, name, existingLat, existingLng) {
  if (!name?.includes('Jabodetabek')) return null;

  // Use existing coordinates if valid
  if (existingLat && existingLng) {
    return {
      lat: parseFloat(existingLat),
      lng: parseFloat(existingLng)
    };
  }

  // Geocode only if needed
  return getCoordinatesForStation(name);
}

module.exports = processCommuterData;