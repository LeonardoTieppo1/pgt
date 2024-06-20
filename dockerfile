# Etapa de build do front-end
FROM node:14 AS build

WORKDIR /app

# Copia apenas os arquivos de dependências do front-end e instala
COPY modernchef/package*.json ./modernchef/
WORKDIR /app/modernchef
RUN npm install

# Copia todo o projeto do front-end
COPY modernchef/ ./

# Executa o build do front-end
RUN npm run build

# Imagem de produção
FROM node:14

WORKDIR /app

# Copia os arquivos de dependências do backend e instala em uma única etapa
COPY modernchef/backend/package*.json ./backend/
COPY modernchef/backend/ ./
WORKDIR /app/backend
RUN npm install

# Copia o build do front-end para a pasta de estáticos do backend
COPY --from=build /app/modernchef/build ./public

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
