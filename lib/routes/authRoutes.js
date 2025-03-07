// const express = require("express");
// const jwt = require("jsonwebtoken");
// const bcrypt = require("bcryptjs");
// const dotenv = require("dotenv");

// dotenv.config(); // Load .env variables

// const router = express.Router();

// // Contoh database sementara (harusnya pakai MySQL)
// const users = [];

// // 🔐 **REGISTER User**
// router.post("/register", async (req, res) => {
//   const { username, password } = req.body;

//   // Cek jika username sudah dipakai
//   if (users.find((user) => user.username === username)) {
//     return res.status(400).json({ message: "Username sudah digunakan!" });
//   }

//   // Hash password
//   const hashedPassword = await bcrypt.hash(password, 10);

//   // Simpan user baru ke array sementara
//   users.push({ username, password: hashedPassword });

//   res.status(201).json({ message: "User berhasil didaftarkan!" });
// });

// // 🔑 **LOGIN User**
// router.post("/login", async (req, res) => {
//   const { username, password } = req.body;

//   // Cari user
//   const user = users.find((user) => user.username === username);
//   if (!user) return res.status(400).json({ message: "User tidak ditemukan!" });

//   // Cek password
//   const isMatch = await bcrypt.compare(password, user.password);
//   if (!isMatch) return res.status(400).json({ message: "Password salah!" });

//   // Buat token JWT
//   const token = jwt.sign({ username: user.username }, process.env.JWT_SECRET, {
//     expiresIn: "1h",
//   });

//   res.json({ message: "Login berhasil!", token });
// });

// module.exports = router;


const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const router = express.Router();

// Dummy database sementara (ganti dengan database asli nanti)
const users = [
  {
    id: 1,
    username: "pororo",
    password: "$2a$10$V3hhHyy1jPaIuCpLvKFSwuhj78BJe9yAqP6uQ1cQ1jJKC5lhTfW2G" // Hash dari 'pororo123'
  }
];

// Route login
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  // 1. Validasi input
  if (!username || !password) {
    return res.status(400).json({ message: "Username dan password wajib diisi!" });
  }

  // 2. Cek user di database
  const user = users.find(u => u.username === username);
  if (!user) {
    return res.status(401).json({ message: "User tidak ditemukan" });
  }

  // 3. Bandingkan password
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    return res.status(401).json({ message: "Password salah" });
  }

  // 4. Buat token JWT
  const token = jwt.sign({ id: user.id, username: user.username }, "RAHASIA_SUPER_AMAN", { expiresIn: "1h" });

  res.json({ message: "Login berhasil", token });
});

module.exports = router;

const authMiddleware = require("../middleware/authMiddleware");

// Route yang dilindungi
router.get("/me", authMiddleware, (req, res) => {
  res.json({ message: "Selamat datang!", user: req.user });
});

