#!/bin/bash

# Inicia o servidor Node.js para o backend na porta 5000
cd /app/backend
node server.js &

# Inicia o servidor Node.js para o front-end na porta 3000
cd /app/modernchef
npm start
