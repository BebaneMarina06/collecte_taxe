FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONPATH=/app

WORKDIR /app

# Dépendances système pour psycopg2, geoalchemy2, Pillow, reportlab, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gdal-bin \
    libgdal-dev \
    postgresql-client \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copier requirements du backend
COPY backend/requirements.txt .
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

# Copier tout le code backend
COPY backend/ .

# Port dynamique Heroku/Railway
EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT:-8000}/health || exit 1

# Commande de démarrage - Railway injecte $PORT automatiquement
CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
