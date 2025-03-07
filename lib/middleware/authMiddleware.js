const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
  const token = req.header("Authorization");

  // 1. Periksa apakah token ada
  if (!token) {
    return res.status(401).json({ message: "Akses ditolak! Token tidak ada." });
  }

  try {
    // 2. Verifikasi token
    const decoded = jwt.verify(token.replace("Bearer ", ""), "RAHASIA_SUPER_AMAN");
    req.user = decoded; // Simpan data user dari token ke request
    next(); // Lanjut ke middleware berikutnya
  } catch (err) {
    res.status(401).json({ message: "Token tidak valid!" });
  }
};

module.exports = authMiddleware;
