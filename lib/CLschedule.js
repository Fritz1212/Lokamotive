const fs = require('fs').promises;
const path = require('path');

/**
 * Kelas untuk mengambil data jadwal Commuter Line dari file teks.
 *
 * @created 2024-12-01
 * @author Jane Doe
 */
class CLschedule {
    /**
   * Membaca file teks jadwal Commuter Line dan mengubahnya menjadi array objek.
   *
   * Fungsi ini akan:
   * - Menggabungkan direktori saat ini dengan nama file 'commuterLineSchedule.txt'.
   * - Membaca file tersebut secara asinkron dengan encoding 'utf8'.
   * - Menghapus spasi di awal/akhir, memecah file menjadi baris-baris, dan menghilangkan carriage returns.
   * - Memeriksa apakah file memiliki format yang valid (minimal 2 baris untuk header dan data).
   * - Mengekstrak header dari baris pertama dan membersihkan setiap header.
   * - Mengkonversi setiap baris data menjadi objek dengan properti yang sesuai dari header.
   * - Mengembalikan array objek yang mewakili jadwal.
   *
   * @created 2024-12-01
   * @author Jane Doe
   * @async
   * @return {Promise<Object[]>} - Promise yang mengembalikan array objek jadwal.
   * @throws {Error} - Akan melempar error jika terjadi kesalahan pada pembacaan file atau format file tidak valid.
   */
    async getCLData() {
        try {
            const filePath = path.join(__dirname, 'commuterLineSchedule.txt');
            const data = await fs.readFile(filePath, 'utf8');

            // Trim, split lines, and remove carriage returns
            const lines = data.trim().split('\n').map(line => line.replace(/\r/g, ''));

            if (lines.length < 2) {
                throw new Error('Invalid file format');
            }

            // Extract headers and clean up spaces
            const headers = lines[0].split('|').map(h => h.trim());

            // Parse each line into an object
            const schedule = lines.slice(1).map(line => {
                const values = line.split('|').map(v => v.trim());
                let obj = {};

                headers.forEach((header, idx) => {
                    obj[header] = values[idx] || null; // Handle missing values
                });

                return obj;
            });

            return schedule;
        } catch (error) {
            console.error('Error reading schedule file:', error.message);
            throw error;
        }
    }
}

module.exports = new CLschedule();