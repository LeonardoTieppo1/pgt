# Etapa de build do front-end
FROM node:14 AS build_frontend

WORKDIR /app

# Copia os arquivos de dependências do front-end e instala
COPY modernchef/package*.json modernchef/
WORKDIR /app/modernchef
RUN npm install --frozen-lockfile

# Copia todo o projeto do front-end e executa o build
COPY modernchef/ ./
RUN npm run build


# Etapa de build do backend
FROM node:14 AS build_backend

WORKDIR /app

# Copia os arquivos de dependências do backend e instala
COPY modernchef/backend/package*.json backend/
WORKDIR /app/backend
RUN npm install --frozen-lockfile

# Copia o backend
COPY modernchef/backend/ ./


# Imagem de produção
FROM node:14

WORKDIR /app

# Copia o build do front-end para a pasta de estáticos do backend
COPY --from=build_frontend /app/modernchef/build ./public

# Copia o backend
COPY --from=build_backend /app/backend ./backend

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
