#!/bin/bash

# Test de l'endpoint contribuable
echo "Testing endpoint: GET /api/collectes/contribuable/63"

curl -X GET "http://localhost:8000/api/collectes/contribuable/63" \
  -H "Authorization: Bearer token" \
  -H "Content-Type: application/json" \
  -v

echo ""
echo "Test completed"
