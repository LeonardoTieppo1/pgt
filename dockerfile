# Etapa de build do front-end
FROM node:14 AS frontend-build

WORKDIR /app/modernchef

# Copia os arquivos de dependências do front-end e instala
COPY modernchef/package.json modernchef/package-lock.json ./
RUN npm ci

# Copia o restante do front-end e executa o build
COPY modernchef/ ./
RUN npm run build

# Etapa de build do back-end
FROM node:14 AS backend-build

WORKDIR /app/backend

# Copia os arquivos de dependências do back-end e instala
COPY modernchef/backend/package.json modernchef/backend/package-lock.json ./
RUN npm ci

# Copia o restante do back-end
COPY modernchef/backend/ ./

# Imagem de produção final
FROM node:14

WORKDIR /app

# Copia o back-end da etapa de build
COPY --from=backend-build /app/backend /app/backend

# Copia o build do front-end para a pasta de estáticos do back-end
COPY --from=frontend-build /app/modernchef/build /app/backend/public

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar o back-end
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
