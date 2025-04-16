// services/path_finder.js
const GraphBuilder = require('./graph_builder.js');
const RouteSearchService = require('./route_search.js');
const AlternativeRouteService = require('./alternate_route.js');

/**
 * Kelas PathFinder bertanggung jawab untuk membangun graph rute berdasarkan titik awal dan tujuan,
 * mengambil data real-time, serta menghitung rute terbaik berdasarkan preferensi pengguna.
 *
 * @author Fritz Gradiyoga
 */
class PathFinder {
  /**
   * Membuat instance PathFinder.
   *
   * @author Fritz Gradiyoga
   * @param {Object} userPreferences - Objek yang berisi preferensi pengguna, misalnya:
   *                                   - preferredModes: Array String yang menunjukkan moda transportasi yang diprioritaskan.
   *                                   - timePreferences: Objek yang berisi parameter untuk penalti waktu, seperti maxSingleSegment dan maxTotal.
   */
  constructor(userPreferences) {
    this.graph = null;
    this.userPrefs = userPreferences;
    this.realTimeData = {};
  }

  /**
   * Menginisialisasi graph rute dengan membangun graph berdasarkan titik awal dan tujuan serta mengambil data real-time.
   *
   * Metode ini memanggil GraphBuilder untuk membangun graph dan melakukan pengambilan data real-time.
   *
   * @author Fritz Gradiyoga
   * @async
   * @param {String} start - ID atau nama titik awal.
   * @param {String} destination - ID atau nama titik tujuan.
   * @param {number} startLat - Lintang (latitude) dari titik awal.
   * @param {number} startLng - Bujur (longitude) dari titik awal.
   * @param {number} destinationLat - Lintang (latitude) dari titik tujuan.
   * @param {number} destinationLng - Bujur (longitude) dari titik tujuan.
   * @return {Promise<Object>} Graph rute yang telah dibangun.
   */
  async initialize(start, destination, startLat, startLng, destinationLat, destinationLng) {
    this.graph = await GraphBuilder.buildGraph(start, destination, startLat, startLng, destinationLat, destinationLng);
    await this._fetchRealTimeData();
    return this.graph
  }

  /**
   * Mengambil data real-time terkait kondisi perjalanan.
   *
   * Metode privat yang mensimulasikan integrasi data real-time (misalnya delay atau kemacetan) sebagai mock data.
   *
   * @author Fritz Gradiyoga
   * @async
   * @return {Promise<void>} Tidak mengembalikan nilai.
   */
  async _fetchRealTimeData() {
    // Contoh integrasi data real-time (mock)
    this.realTimeData = {
      'commuter-line': { delay: 5 },
      'transjakarta': { congestion: 0.3 }
    };
  }

  /**
   * Mencari rute terbaik atau alternatif antara dua node dalam graph menggunakan layanan pencarian rute.
   *
   * Metode ini menggunakan service RouteSearchService untuk pencarian rute dasar serta AlternativeRouteService
   * untuk menemukan alternatif rute (k-shortest paths) dengan parameter 'k'.
   *
   * @author Fritz Gradiyoga
   * @param {String|Number} startId - ID node awal.
   * @param {String|Number} endId - ID node tujuan.
   * @param {Object} graph - Graph yang akan digunakan untuk pencarian rute.
   * @param {number} [k=1] - Jumlah rute terpendek yang ingin dicari.
   * @return {Array<Object>} Array berisi rute (path) yang ditemukan.
   */
  findRoutes(startId, endId, graph, k = 1) {
    let x = RouteSearchService.routeSearch
    const searchService = new x(
      this.graph,
      (edge) => this.getEffectiveWeight(edge)
    );

    const altService = new AlternativeRouteService(
      this.graph,
      searchService
    );

    // console.log("startId : ", startId);
    // console.log("endId : ", endId);
    return altService.findKShortestPaths(startId, endId, k);

    // return searchService.djikstra(startId, endId);
  }

  /**
   * Menghitung effective weight (bobot efektif) dari sebuah edge berdasarkan beberapa faktor:
   * - Waktu dasar yang diperlukan (baseWeight)
   * - Penyesuaian berdasarkan preferensi moda transportasi
   * - Penalti berdasarkan waktu perjalanan (segmen tunggal dan total)
   * - Penyesuaian berdasarkan data real-time
   * - Penalti transfer jika edge merupakan perpindahan antar moda
   *
   * @author Fritz Gradiyoga
   * @param {Object} edge - Objek edge yang memiliki properti:
   *                        - details: Objek yang memuat waktu tempuh (time).
   *                        - mode: Mode transportasi pada edge tersebut.
   *                        - isTransfer: Boolean yang menandakan apakah edge merupakan transfer.
   * @return {number} Nilai effective weight yang dihitung.
   */
  getEffectiveWeight(edge) {
    const baseWeight = edge.details.time;
    const { preferredModes, timePreferences } = this.userPrefs;

    // 1. Mode preference adjustment
    const modeAdjustment = this._calculateModeAdjustment(edge, preferredModes);

    // 2. Time-based penalty
    const timePenalty = this._calculateTimePenalty(baseWeight, timePreferences);

    // 3. Real-time adjustments
    const realTimeAdjustment = this._getRealTimeAdjustment(edge.mode);

    // 4. Transfer penalty
    const transferPenalty = edge.isTransfer ? 5 : 0;

    return baseWeight + modeAdjustment + timePenalty + realTimeAdjustment + transferPenalty;
  }

  /**
   * Menghitung penyesuaian bobot berdasarkan preferensi moda transportasi.
   *
   * Jika moda transportasi pada edge termasuk dalam preferensi, diberikan diskon 30%
   * dari waktu dasar; jika tidak, diberikan penalti 10% dari waktu dasar.
   *
   * @author Fritz Gradiyoga
   * @param {Object} edge - Objek edge yang memiliki properti 'mode' dan 'details.time'.
   * @param {Array<String>} preferredModes - Array moda transportasi yang diprioritaskan.
   * @return {number} Nilai penyesuaian waktu berdasarkan preferensi.
   */
  _calculateModeAdjustment(edge, preferredModes) {
    const mode = edge.mode.toLowerCase();
    const preferred = preferredModes.map(m => m.toLowerCase());

    if (preferred.includes(mode)) {
      return -0.3 * edge.details.time; // Diskon 30% untuk mode preferensi
    }
    return 0.1 * edge.details.time; // Penalti 10% untuk mode non-preferred
  }

   /**
   * Menghitung penalti waktu berdasarkan durasi perjalanan.
   *
   * Penalti diberikan jika durasi segmen tunggal melebihi batas maksimum yang diizinkan,
   * atau jika total waktu perjalanan melebihi batas maksimum total.
   *
   * @author Fritz Gradiyoga
   * @param {number} baseTime - Waktu dasar atau durasi segmen dalam satuan menit.
   * @param {Object} timePreferences - Objek yang berisi preferensi waktu, dengan properti:
   *                                   - maxSingleSegment: Durasi maksimum segmen tunggal.
   *                                   - maxTotal: Durasi maksimum total perjalanan.
   * @return {number} Total penalti waktu yang dihitung.
   */
  _calculateTimePenalty(baseTime, { maxSingleSegment = 45, maxTotal = 120 }) {
    let penalty = 0;

    // Penalty untuk segmen tunggal terlalu panjang
    if (baseTime > maxSingleSegment) {
      penalty += (baseTime - maxSingleSegment) * 0.2;
    }

    // Penalty untuk total waktu perjalanan
    if (baseTime > maxTotal) {
      penalty += (baseTime - maxTotal) * 0.15;
    }

    return penalty;
  }

  /**
   * Mengambil penyesuaian waktu berdasarkan data real-time untuk sebuah mode transportasi.
   *
   * Jika terdapat delay atau kemacetan pada data real-time, nilai-nilai tersebut akan ditambahkan sebagai
   * penyesuaian. Delay ditambahkan secara langsung, sedangkan faktor kemacetan dikonversi dengan mengalikan 10.
   *
   * @author Fritz Gradiyoga
   * @param {String} mode - Mode transportasi dari edge.
   * @return {number} Nilai penyesuaian waktu real-time.
   */
  _getRealTimeAdjustment(mode) {
    const data = this.realTimeData[mode.toLowerCase()] || {};
    return (data.delay || 0) + (data.congestion * 10 || 0);
  }
}

module.exports = PathFinder;