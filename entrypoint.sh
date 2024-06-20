#!/bin/bash
# Iniciar o backend
cd /app/backend
node server.js &

# Iniciar o frontend (supondo que o frontend seja iniciado com serve)
cd /app/modernchef
npm start
