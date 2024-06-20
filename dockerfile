# Etapa de build do front-end
FROM node:14 AS build

WORKDIR /app

# Copia os arquivos de dependências do front-end
COPY modernchef/package.json modernchef/package-lock.json ./modernchef/
WORKDIR /app/modernchef
RUN npm ci

# Copia todo o projeto do front-end e executa o build
COPY modernchef/ ./
RUN npm run build

# Imagem de produção
FROM node:14

WORKDIR /app

# Copia os arquivos de dependências do backend
COPY modernchef/backend/package.json modernchef/backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN npm ci

# Copia o backend
COPY modernchef/backend/ ./

# Copia o build do front-end para a pasta de estáticos do backend
COPY --from=build /app/modernchef/build ./public

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
