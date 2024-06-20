#!/bin/bash
# Inicia o servidor Node.js para o front-end na porta 3000
cd /app/modernchef
npm start &

# Inicia o servidor Node.js para o back-end na porta 5000
cd /app/backend
node server.js
