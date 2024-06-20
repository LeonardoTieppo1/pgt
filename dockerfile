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

# Copia o build do front-end para a pasta de estáticos do backend
COPY --from=build /app/modernchef/build ./public

# Copia os arquivos do backend
COPY modernchef/backend ./backend

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar o servidor
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
