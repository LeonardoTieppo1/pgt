# Etapa de build do front-end
FROM node:14 AS build

WORKDIR /app

# Copia todos os arquivos do projeto modernchef para /app
COPY modernchef/ ./

# Navega para dentro da pasta modernchef onde estão os arquivos do front-end
WORKDIR /app/modernchef

# Instala as dependências e executa o build do front-end
RUN npm install
RUN npm run build

# Etapa de produção
FROM node:14

WORKDIR /app

# Cria o diretório 'public' para os arquivos do front-end
RUN mkdir public

# Copia os arquivos de build do front-end da etapa anterior para a pasta public
COPY --from=build /app/modernchef/build /app/public

# Define o diretório de trabalho para o backend
WORKDIR /app

# Copia todo o código do backend
COPY modernchef/backend ./backend

# Expor a porta 5000 para o backend e 3000 para o front-end
EXPOSE 5000
EXPOSE 3000

# Script de entrada para iniciar ambos os serviços
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
