const jwt = require("jsonwebtoken");
const cookieParser = require("cookie-parser");

app.use(express.json());
app.use(cookieParser());

// Generate JWT Token
const generateToken = (user) => {
  return jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET, { expiresIn: "1h" });
};

// Login Endpoint
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

