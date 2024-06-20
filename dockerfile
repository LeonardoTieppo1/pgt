# Etapa de instalação das dependências do front-end
FROM node:14 AS build

WORKDIR /app

COPY modernchef/package*.json ./modernchef/
WORKDIR /app/modernchef
RUN npm install

# Etapa de build e cópia do front-end
COPY modernchef/ ./
RUN npm run build && cp -r modernchef/build ./

# Imagem de produção
FROM node:14

WORKDIR /app

# Copia do backend e build do front-end
COPY modernchef/backend/ ./
COPY --from=build /app/modernchef/build ./public

# Expõe a porta para o back-end
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
