const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

/**
 * Mengotentikasi pesan WebSocket berdasarkan token yang terdapat pada pesan.
 *
 * Fungsi ini melakukan parsing pesan dalam format JSON untuk memeriksa keberadaan token.
 * Jika token tidak ada, fungsi akan mengirimkan respons error kepada client.
 * Jika token ada, token tersebut diverifikasi menggunakan secret JWT yang disimpan pada environment variables.
 * Apabila verifikasi gagal, client akan menerima pesan error mengenai token yang tidak valid.
 * Jika verifikasi berhasil, data user akan dilampirkan ke objek WebSocket (ws.user) dan fungsi callback 'next'
 * dipanggil untuk melanjutkan proses.
 *
 * @author Juwita Nethania Chandra
 * @param {WebSocket} ws - Objek WebSocket yang terhubung dengan client.
 * @param {string} message - Pesan yang diterima dalam format string. Diharapkan pesan tersebut memiliki properti 'token'.
 * @param {Function} next - Callback function yang dipanggil setelah proses otentikasi berhasil.
 */
function authenticateWebSocket(ws, message, next) {
  try {
    const data = JSON.parse(message);

    if (!data.token) {
      ws.send(JSON.stringify({ status: "error", message: "No token provided" }));
      return;
    }

    jwt.verify(data.token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        ws.send(JSON.stringify({ status: "error", message: "Invalid token" }));
        return;
      }

      ws.user = decoded; // Menyimpan data user di objek WebSocket
      next();
    });

  } catch (error) {
    ws.send(JSON.stringify({ status: "error", message: "Invalid message format" }));
  }
}

module.exports = { authenticateWebSocket };
// const authMiddleware = (req, res, next) => {
//   const token = req.header("Authorization");

//   // 1. Periksa apakah token ada
//   if (!token) {
//     return res.status(401).json({ message: "Akses ditolak! Token tidak ada." });
//   }

//   try {
//     // 2. Verifikasi token
//     const decoded = jwt.verify(token.replace("Bearer ", ""), "RAHASIA_SUPER_AMAN");
//     req.user = decoded; // Simpan data user dari token ke request
//     next(); // Lanjut ke middleware berikutnya
//   } catch (err) {
//     res.status(401).json({ message: "Token tidak valid!" });
//   }
// };

// module.exports = authMiddleware;
