const express = require('express');
const path = require('path');
const compress = require('compression');

const app = express();
const PORT = process.env.PORT || 3000;

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

// SPA: Redirection vers index.html pour les routes non-API
app.get('*', (req, res) => {
  // Ne pas rediriger les appels API
  if (req.path.startsWith('/api/')) {
    res.status(404).json({ error: 'Not found' });
  } else {
    res.sendFile(path.join(distPath, 'index.html'));
  }
});

// Healthcheck
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Frontend server running on port ${PORT}`);
});
