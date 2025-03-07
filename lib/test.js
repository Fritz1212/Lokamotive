// gpt punya yupibear

const express = require('express');
const https = require('https');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// Load SSL Certificate
const options = {
  key: fs.readFileSync('path/to/your/private.key'),
  cert: fs.readFileSync('path/to/your/certificate.crt')
};

// Dummy User Data
const users = [];
const userPreferences = {};
const userHistory = {};

// JWT Secret
const JWT_SECRET = 'your_secret_key';

// User Register Route
app.post('/register', (req, res) => {
  const { username, password } = req.body;
  if (users.find(u => u.username === username)) {
    return res.status(400).json({ error: 'Username already exists' });
  }
  const newUser = { id: users.length + 1, username, password };
  users.push(newUser);
  res.status(201).json({ message: 'User registered successfully' });
});

// User Login Route
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username && u.password === password);
  if (user) {
    const token = jwt.sign({ id: user.id, username: user.username }, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
  } else {
    res.status(401).json({ error: 'Invalid credentials' });
  }
});

// Middleware for Authorization
const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization'];
  if (!token) return res.sendStatus(403);

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

// Set Transportation Preference
app.post('/preference', authenticateToken, (req, res) => {
  const { preference } = req.body;
  userPreferences[req.user.id] = preference;
  res.json({ message: 'Preference saved', preference });
});

// Get Transportation Preference
app.get('/preference', authenticateToken, (req, res) => {
  res.json({ preference: userPreferences[req.user.id] || 'No preference set' });
});

// Store Travel History
app.post('/history', authenticateToken, (req, res) => {
  const { route } = req.body;
  if (!userHistory[req.user.id]) userHistory[req.user.id] = [];
  userHistory[req.user.id].push(route);
  res.json({ message: 'History saved', history: userHistory[req.user.id] });
});

// Get Travel History
app.get('/history', authenticateToken, (req, res) => {
  res.json({ history: userHistory[req.user.id] || [] });
});

// Find Route (Dummy Data for now)
app.post('/find-route', (req, res) => {
  const { from, to } = req.body;
  res.json({ route: `Recommended route from ${from} to ${to}` });
});

// Get Transport Schedule (Dummy Data)
app.get('/schedule', (req, res) => {
  res.json({ schedule: 'Train schedule data here' });
});

// Start HTTPS Server
https.createServer(options, app).listen(3000, () => {
  console.log('Server running on https://localhost:3000');
});
