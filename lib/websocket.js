// websocket.js
const WebSocket = require("ws");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const db = require("./db");
dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET || "jwtsecret";

/**
 * Mengatur (setup) WebSocket server dengan fitur autentikasi menggunakan JWT.
 *
 * Fungsi ini menginisialisasi WebSocket server dan menangani event koneksi client.
 * Ketika client mengirim pesan, fungsi ini akan mencoba memparsing pesan sebagai JSON dan
 * memeriksa keberadaan token untuk melakukan verifikasi JWT. Jika token valid, client
 * dianggap telah terautentikasi dan mendapatkan pesan sukses. Jika token tidak valid atau
 * terjadi error dalam pemrosesan, client akan mendapatkan pesan error dan koneksi akan ditutup.
 * @author Juwita Nethania Chandra
 * @param {http.Server} server - Instance HTTP server yang akan digunakan untuk WebSocket.
 */
const setupWebSocket = (server) => {

  wss.on("connection", (ws) => {
    console.log("Client connected");

     // Event 'message' digunakan untuk memproses pesan yang diterima dari client
    ws.on("message", (message) => {
      try {
        const data = JSON.parse(message);
        if (data.token) {
          jwt.verify(data.token, JWT_SECRET, (err, decoded) => {
            if (err) {
              ws.send(JSON.stringify({ status: "error", message: "Invalid token" }));
              ws.close();
            } else {
              console.log("Authenticated user:", decoded.email);
              ws.send(JSON.stringify({ status: "success", message: "Authenticated" }));
            }
          });
        }
      } catch (error) {
        console.error("❌ Error processing message:", error);
        ws.send(JSON.stringify({ status: "error", message: "Invalid format" }));
      }
    });

    ws.on("close", () => {
      console.log("Client disconnected");
    });
  });
};

module.exports = setupWebSocket;
