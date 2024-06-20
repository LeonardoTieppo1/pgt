# Etapa de build do front-end
FROM node:16 AS frontend-build

WORKDIR /app

# Copia os arquivos de dependências do front-end
COPY modernchef/package*.json ./modernchef/
WORKDIR /app/modernchef
RUN npm install

# Copia todo o projeto do front-end
COPY modernchef/ ./

# Executa o build do front-end
RUN npm run build

# Etapa de build do backend
FROM node:16 AS backend-build

WORKDIR /app

# Copia o código do backend
COPY modernchef/backend /app/backend

# Instala dependências do backend
WORKDIR /app/backend
RUN npm install

# Imagem de produção
FROM node:16

WORKDIR /app

# Copia o build do front-end para a pasta de estáticos do backend
COPY --from=frontend-build /app/modernchef/build ./public

# Copia todo o projeto do front-end (para scripts ou outros arquivos que possam ser necessários)
COPY --from=frontend-build /app/modernchef/ ./modernchef

# Copia o código do backend
COPY --from=backend-build /app/backend ./backend

# Expõe a porta 3000 para o front-end e a porta 5000 para o back-end
EXPOSE 3000
EXPOSE 5000

# Copia o entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
