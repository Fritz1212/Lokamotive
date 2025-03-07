// // const fs = require("fs");
// // const https = require("https");
// // const express = require("express");

// // const app = express();
// // const PORT = 443; // Default HTTPS port

// // // Baca sertifikat SSL
// // const options = {
// //   key: fs.readFileSync("server.key"), // Private Key
// //   cert: fs.readFileSync("server.cert"), // SSL Certificate
// // };

// // // Buat server HTTPS
// // https.createServer(options, app).listen(PORT, () => {
// //   console.log(`🚀 Server berjalan di https://localhost:${PORT}`);
// // });

// // // Contoh route untuk cek apakah HTTPS berhasil
// // app.get("/", (req, res) => {
// //   res.send("🔒 testing testing");
// // });


// const express = require("express");
// const https = require("https");
// const fs = require("fs");

// const app = express();
// const PORT = 3000;

// // Middleware untuk parsing JSON
// app.use(express.json());

// // Endpoint default (test server)
// app.get("/", (req, res) => {
//   res.send("Lokamotive HTTPS Server is Running!");
// });

// // Endpoint contoh: API rute transportasi
// app.get("/api/rute", (req, res) => {
//   res.json({
//     message: "API Rute Transportasi Berhasil!",
//     data: ["TransJakarta", "KRL", "MRT", "LRT"],
//   });
// });

// // Konfigurasi HTTPS
// const options = {
//   key: fs.readFileSync("server.key"),
//   cert: fs.readFileSync("server.cert"),
// };

// https.createServer(options, app).listen(PORT, () => {
//   console.log(`🚀 Server HTTPS berjalan di https://localhost:${PORT}`);
// });

const express = require("express");
const https = require("https");
const fs = require("fs");
const cors = require("cors");
const dotenv = require("dotenv");
const authRoutes = require("./routes/authRoutes");
const flut = require("") // Pastikan path ini benar

dotenv.config(); // Load .env variables

const app = express();
const PORT = process.env.PORT || 3000; // Port bisa diatur lewat .env

// Middleware
app.use(cors());
app.use(express.json());

// Routing
app.use("/api/auth", authRoutes);

// Endpoint test server
app.get("/", (req, res) => {
  res.send("Lokamotive HTTPS Server is Running!");
});

// API contoh: rute transportasi
app.get("/api/rute", (req, res) => {
  res.json({
    message: "API Rute Transportasi Berhasil!",
    data: ["TransJakarta", "KRL", "MRT", "LRT"],
  });
});

//buat google
app.get("/api/google", (req, res) => {
  
});

// Konfigurasi HTTPS
const options = {
  key: fs.readFileSync("server.key"), 
  cert: fs.readFileSync("server.cert"),
};

// Jalankan server HTTPS
https.createServer(options, app).listen(PORT, () => {
  console.log(`🚀 Server HTTPS berjalan di https://localhost:${PORT}`);
});
