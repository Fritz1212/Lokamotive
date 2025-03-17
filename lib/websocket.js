// websocket.js
const WebSocket = require("ws");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const db = require("./db");
dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET || "jwtsecret";

const setupWebSocket = (server) => {

  wss.on("connection", (ws) => {
    console.log("Client connected");

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
