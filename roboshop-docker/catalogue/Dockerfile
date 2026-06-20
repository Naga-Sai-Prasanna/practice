FROM node:20
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install
ENV MONGO="true" \
    MONGO_URL=
CMD ["node", "server.js"]


