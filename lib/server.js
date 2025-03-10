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

    try {
      const data = JSON.parse(message);

      // REGISTRASI USER
      if (data.action === "Regis") {
        const { user_name, email, passwordz } = data;

        if (!user_name || !email || !passwordz) {
          ws.send(JSON.stringify({ status: "error", message: "Missing required fields" }));
          return;
        }

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
      }

      // LOGIN USER
      else if (data.action === "Login") {
        const { email, passwordz } = data;

        if (!email || !passwordz) {
          ws.send(JSON.stringify({ status: "error", message: "Email and password are required" }));
          return;
        }

        const query = "SELECT id, user_name, email, passwordz FROM users WHERE email = ?";
        db.query(query, [email], (err, results) => {
          if (err) {
            console.error("❌ Error fetching user:", err);
            ws.send(JSON.stringify({ status: "error", message: "Database query failed" }));
            return;
          }

          if (results.length === 0) {
            ws.send(JSON.stringify({ status: "error", message: "User not found" }));
            return;
          }

          const user = results[0];
          if (user.passwordz !== passwordz) {
            ws.send(JSON.stringify({ status: "error", message: "Invalid password" }));
            return;
          }

          console.log("✅ User logged in:", user.id);
          ws.send(JSON.stringify({
            status: "success",
            id: user.id,
            name: user.user_name,
            email: user.email
          }));
        });
      }

      else if (data.action == "Retrieve") {
        const query = ""
      }

      else {
        ws.send(JSON.stringify({ status: "error", message: "Invalid action" }));
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