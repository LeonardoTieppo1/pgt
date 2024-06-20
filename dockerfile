# Etapa de build do front-end
FROM node:14 AS frontend-builder

WORKDIR /app/modernchef

# Copia os arquivos de dependências do front-end e instala
COPY modernchef/package*.json ./
RUN npm install

# Copia todo o projeto do front-end e executa o build
COPY modernchef/ ./
RUN npm run build

# Etapa de build do backend
FROM node:14 AS backend-builder

WORKDIR /app/backend

# Copia os arquivos de dependências do backend e instala
COPY modernchef/backend/package*.json ./
RUN npm install

# Copia o backend
COPY modernchef/backend/ ./

# Imagem de produção
FROM node:14

WORKDIR /app

# Copia o build do front-end da stage anterior para a pasta de estáticos do backend
COPY --from=frontend-builder /app/modernchef/build ./public

# Copia o código do backend da stage anterior
COPY --from=backend-builder /app/backend ./

# Expõe a porta para o backend
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
