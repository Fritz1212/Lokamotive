const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

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
