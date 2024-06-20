# Usar uma versão mais recente do Node.js para a etapa de build do front-end
FROM node:16 AS build

WORKDIR /app

# Copiar arquivos de dependências do front-end e instalar dependências
COPY modernchef/package*.json ./modernchef/
WORKDIR /app/modernchef
RUN npm install

# Copiar todo o projeto do front-end e executar o build
COPY modernchef/ ./
RUN npm run build

# Imagem de produção
FROM node:16

WORKDIR /app

# Copiar arquivos de dependências do backend e instalar dependências
COPY modernchef/backend/package*.json ./backend/
WORKDIR /app/backend
RUN npm install

# Copiar o backend
COPY modernchef/backend/ ./

# Copiar o build do front-end para a pasta de estáticos do backend
COPY --from=build /app/modernchef/build ./public

# Expor a porta para o backend
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
