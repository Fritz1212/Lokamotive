const jwt = require("jsonwebtoken");
const cookieParser = require("cookie-parser");

app.use(express.json());
app.use(cookieParser());

/**
 * Menghasilkan token JWT untuk user yang diberikan.
 *
 * @author Juwita Nethania Chandra
 * @param {Object} user - Objek user yang memiliki property id dan username.
 * @return {String} - JWT token yang telah di-sign.
 */
const generateToken = (user) => {
  return jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET, { expiresIn: "1h" });
};

/**
 * Endpoint login untuk proses autentikasi user.
 * Fungsi ini memvalidasi kredensial yang diberikan oleh user,
 * menghasilkan token JWT dengan menggunakan fungsi generateToken, dan
 * menyimpan token tersebut dalam cookie HTTP-Only untuk meningkatkan keamanan.
 *
 * @author Juwita Nethania Chandra
 * @param {Request} req - Objek request dari client yang berisi username dan password.
 * @param {Response} res - Objek response untuk mengirim hasil autentikasi ke client.
 */
app.post("/api/auth/login", (req, res) => {
  const { username, password } = req.body;
  const query = "SELECT * FROM users WHERE user_name = ? AND passwordz = ?";

  db.query(query, [username, password], (err, results) => {
    if (err || results.length === 0) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const user = results[0];
    const token = generateToken(user);

    res.cookie("token", token, { httpOnly: true, secure: true }); // Store JWT in HTTP-Only Cookie
    res.json({ message: "Login successful", token });
  });
});

// WebSocket Authentication Middleware
/**
 * Handler untuk koneksi WebSocket.
 *
 * Fungsi ini menangani event "connection" pada WebSocket server. 
 * Saat terjadi koneksi, fungsi ini akan:
 * - Mengambil token JWT dari cookie dalam header request.
 * - Memverifikasi token menggunakan JWT secret.
 * - Jika token tidak ada atau tidak valid, koneksi WebSocket ditutup.
 * - Jika token valid, data user diattach ke objek WebSocket (ws.user).
 * - Meng-attach handler untuk event "message" untuk menerima pesan dari client.
 * - Meng-attach handler untuk event "close" untuk log ketika client terputus.
 *
 * @author Juwita Nethania Chandra
 * @param {WebSocket} ws - Objek WebSocket yang terhubung dengan client.
 * @param {Object} req - Objek request yang berisi header, termasuk cookie.
 */
wss.on("connection", (ws, req) => {
  const cookies = req.headers.cookie;
  const token = cookies?.split("token=")[1]?.split(";")[0];

  if (!token) {
    ws.close();
    return;
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      ws.close();
      return;
    }

    ws.user = decoded; // Attach user data to WebSocket
    console.log("✅ Authenticated WebSocket connection for", decoded.username);
  });

  ws.on("message", (message) => {
    console.log("Received:", message.toString());
    ws.send("Message received");
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});


// const express = require("express");
// const bcrypt = require("bcryptjs");
// const jwt = require("jsonwebtoken");

// const router = express.Router();

// // Dummy database sementara (ganti dengan database asli nanti)
// const users = [
//   {
//     id: 1,
//     username: "pororo",
//     password: "$2a$10$V3hhHyy1jPaIuCpLvKFSwuhj78BJe9yAqP6uQ1cQ1jJKC5lhTfW2G" // Hash dari 'pororo123'
//   }
// ];

// // Route login
// router.post("/login", async (req, res) => {
//   const { username, password } = req.body;

//   // 1. Validasi input
//   if (!username || !password) {
//     return res.status(400).json({ message: "Username dan password wajib diisi!" });
//   }

//   // 2. Cek user di database
//   const user = users.find(u => u.username === username);
//   if (!user) {
//     return res.status(401).json({ message: "User tidak ditemukan" });
//   }

//   // 3. Bandingkan password
//   const isMatch = await bcrypt.compare(password, user.password);
//   if (!isMatch) {
//     return res.status(401).json({ message: "Password salah" });
//   }

//   // 4. Buat token JWT
//   const token = jwt.sign({ id: user.id, username: user.username }, "RAHASIA_SUPER_AMAN", { expiresIn: "1h" });

//   res.json({ message: "Login berhasil", token });
// });

// module.exports = router;

// const authMiddleware = require("../middleware/authMiddleware");

// // Route yang dilindungi
// router.get("/me", authMiddleware, (req, res) => {
//   res.json({ message: "Selamat datang!", user: req.user });
// });

