#!/bin/sh

# Inicia o backend
node /app/backend/server.js &

# Mantém o container ativo
tail -f /dev/null
