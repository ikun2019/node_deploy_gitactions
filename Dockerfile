FROM node:16.16.0-alpine3.16

WORKDIR /app

# rootのpackage.jsonをdockerにコピー
COPY package*.json ./

# clientのpackage.jsonをdockerにコピー
COPY client/package*.json client/
RUN npm run install-client --only=production

# serverのpackage.jsonをdockerにコピー
COPY server/package*.json server/
RUN npm run install-server --only=production

# client内ファイルをdockerにコピー
COPY client/ client/
RUN npm run build --prefix client

# server内のファイルをdockerにコピー
COPY server/ server/

# ディレクトリの権限を変更
RUN chown -R node:node /app
USER node

# serverの起動
CMD [ "npm", "start", "--prefix", "server" ]

# ポート番号の指定
EXPOSE 8000