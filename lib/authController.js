const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "jwtsecret";
const SALT_ROUNDS = 10;

/**
 * Menangani pesan otentikasi yang diterima melalui WebSocket.
 *
 * Fungsi ini menerima pesan dari client, mencoba meng-parse-nya sebagai JSON, 
 * dan berdasarkan nilai properti `action`, memanggil fungsi registerUser atau loginUser.
 * Jika action tidak valid atau terjadi kesalahan saat parsing, maka akan mengirimkan response error ke client.
 *
 * @author Juwita Nethania Chandra
 * @param {WebSocket} ws - Objek WebSocket yang terhubung dengan client.
 * @param {string} message - Pesan yang diterima dalam format string.
 */
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
/**
 * Registrasi User.
 *
 * Fungsi ini melakukan registrasi user dengan cara mengenkripsi password menggunakan bcrypt,
 * lalu menyimpan data user beserta password yang telah di-hash ke dalam database.
 * Apabila terjadi kesalahan pada proses enkripsi atau database, akan mengirimkan response error ke client.
 *
 * @author Juwita Nethania Chandra
 * @param {WebSocket} ws - Objek WebSocket untuk mengirim respon kembali ke client.
 * @param {Object} param1 - Objek yang berisi data registrasi user.
 * @param {string} param1.user_name - Nama user.
 * @param {string} param1.email - Email user.
 * @param {string} param1.password - Password user yang akan di-enkripsi.
 */
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
/**
 * Login User.
 *
 * Fungsi ini melakukan proses login user dengan cara mengambil data user berdasarkan email dari database,
 * kemudian membandingkan password yang diberikan dengan password yang telah di-hash menggunakan bcrypt.
 * Jika valid, akan dibuatkan token JWT dan dikirimkan ke client melalui WebSocket.
 *
 * @author Juwita Nethania Chandra
 * @param {WebSocket} ws - Objek WebSocket untuk mengirim respon kembali ke client.
 * @param {Object} param1 - Objek yang berisi data login.
 * @param {string} param1.email - Email user yang digunakan untuk login.
 * @param {string} param1.password - Password user yang akan dibandingkan dengan yang tersimpan di database.
 */
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
/**
 * Reset Password.
 *
 * Fungsi ini digunakan untuk mereset password user.
 * Prosesnya mencakup enkripsi password baru menggunakan bcrypt, kemudian memperbarui data password pada database berdasarkan email.
 * Jika terjadi kesalahan pada proses enkripsi atau saat melakukan query ke database, akan mengembalikan response error.
 *
 * @author Juwita Nethania Chandra
 * @param {Request} req - Objek request yang berisi data body dengan email dan newPassword.
 * @param {Response} res - Objek response yang digunakan untuk mengirim respon kembali ke client.
 */
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
