const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const mysql = require("mysql");
const dotenv = require("dotenv");
const WebSocket = require("ws");

dotenv.config();

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const io = new Server(server, {
  cors: { origin: "*" },
});

wss.on("connection", (ws) => {
  console.log("Client connected");

  ws.on("message", (message) => {
    console.log("Received:", message.toString());
    ws.send("Message received");

    try {
      const data = JSON.parse(message);

      if (data.action = "Regis") {
        const { user_name, email, passwordz } = data;

        const query = "INSERT INTO users (user_name, email, passwordz) VALUES (?, ?, ?)";
        db.query(query, [user_name, email, passwordz], (err, results) => {
          if (err) {
            console.error("❌ Error inserting user:", err);
            ws.send(JSON.stringify({ status: "error", message: "Database insert failed" }));
          } else {
            console.log("✅ User added:", results.insertId);
            ws.send(JSON.stringify({ status: "success", id: results.insertId, name: user_name, email }));
          }
        });

        //taro sini
      }
    } catch (error) {
      console.error("❌ Error parsing message:", error);
      ws.send(JSON.stringify({ status: "error", message: "Invalid message format" }));
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});

// 🔹 Connect to MySQL Database
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "lokamotiveBINUS",
  password: process.env.DB_PASSWORD || "lokamotive123",
  database: process.env.DB_NAME || "lokamotive",
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database connection failed:", err);
    return;
  }
  console.log("✅ Connected to MySQL");
});



const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';

server.listen(PORT, HOST, () => {
  console.log(`🚀 WebSocket server running on ws://${HOST}:${PORT}`);
  console.log(`🚀 WebSocket server ACTUALLY running on port ${server.address().port}`);
});