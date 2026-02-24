const express = require('express');
const path = require('path');
const compress = require('compression');

const app = express();
const PORT = process.env.PORT || 3000;

// API URL depuis l'environnement Railway (injectée automatiquement)
const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:8000/api';

console.log(`🚀 Frontend démarrage sur le port ${PORT}`);
console.log(`📡 API URL: ${API_BASE_URL}`);

// Compression
app.use(compress());

// Servir les fichiers statiques
const distPath = path.join(__dirname, 'dist', 'collecte-taxe-frontend', 'browser');
app.use(express.static(distPath, { maxAge: '1d' }));

// Middleware pour forcer HTTPS en production
if (process.env.NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if (req.header('x-forwarded-proto') !== 'https') {
      res.redirect(`https://${req.header('host')}${req.url}`);
    } else {
      next();
    }
  });
}

// Endpoint pour la configuration frontend (injecter l'API URL)
app.get('/api/config', (req, res) => {
  res.json({
    apiUrl: API_BASE_URL,
    environment: process.env.NODE_ENV || 'production'
  });
});

// Healthcheck
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// SPA: Redirection vers index.html pour les routes non-API
app.get('*', (req, res) => {
  res.sendFile(path.join(distPath, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Frontend server running on port ${PORT}`);
  console.log(`📍 URL: http://localhost:${PORT}`);
});
