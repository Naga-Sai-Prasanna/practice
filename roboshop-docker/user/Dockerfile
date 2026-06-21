FROM node:20
WORKDIR /app
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue" \
    REDIS_URL="redis://redis:6379"
EXPOSE 8080    
COPY package.json .
# till here layers wont change frequently
COPY *.js .
RUN npm install
CMD ["node", "server.js"]
