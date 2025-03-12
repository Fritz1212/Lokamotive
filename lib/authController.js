const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "jwtsecret";
const SALT_ROUNDS = 10;

const handleAuthMessages = (ws, message) => {
  try {
    const data = JSON.parse(message);

    if (data.action === "Regis") {
      registerUser(ws, data);
    } else if (data.action === "Login") {
      loginUser(ws, data);
    } else {
      ws.send(JSON.stringify({ status: "error", message: "Invalid action" }));
    }
  } catch (error) {
    console.error("❌ Error parsing message:", error);
    ws.send(JSON.stringify({ status: "error", message: "Invalid message format" }));
  }
};

// ✅ Registrasi User
const registerUser = (ws, { user_name, email, password }) => {
  bcrypt.hash(password, SALT_ROUNDS, (err, hashedPassword) => {
    if (err) {
      console.error("❌ Hashing error:", err);
      return ws.send(JSON.stringify({ status: "error", message: "Encryption error" }));
    }

    const query = "INSERT INTO users (user_name, email, password) VALUES (?, ?, ?)";
    db.query(query, [user_name, email, hashedPassword], (err, results) => {
      if (err) {
        console.error("❌ Database error:", err);
        return ws.send(JSON.stringify({ status: "error", message: "Database error" }));
      }

      console.log("✅ User registered:", results.insertId);
      ws.send(JSON.stringify({ status: "success", id: results.insertId, user_name, email }));
    });
  });
};

// ✅ Login User
const loginUser = (ws, { email, password }) => {
  const query = "SELECT * FROM users WHERE email = ?";
  db.query(query, [email], (err, results) => {
    if (err || results.length === 0) {
      return ws.send(JSON.stringify({ status: "error", message: "Invalid credentials" }));
    }

    bcrypt.compare(password, results[0].password, (err, isMatch) => {
      if (!isMatch) {
        return ws.send(JSON.stringify({ status: "error", message: "Invalid credentials" }));
      }

      const token = jwt.sign({ id: results[0].id, email }, JWT_SECRET, { expiresIn: "1h" });

      ws.send(JSON.stringify({ status: "success", token }));
    });
  });
};

// Reset Password
const resetPassword = (req, res) => {
  const { email, newPassword } = req.body;
  bcrypt.hash(newPassword, SALT_ROUNDS, (err, hashedPassword) => {
    if (err) return res.status(500).json({ status: "error", message: "Encryption error" });
    const query = "UPDATE users SET password = ? WHERE email = ?";
    db.query(query, [hashedPassword, email], (err, results) => {
      if (err) return res.status(500).json({ status: "error", message: "Database error" });
      res.json({ status: "success", message: "Password updated" });
    });
  });
};

module.exports = { handleAuthMessages };
