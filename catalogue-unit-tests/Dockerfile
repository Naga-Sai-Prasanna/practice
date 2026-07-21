FROM node:20-alpine AS builder
# this creates /app and move there
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install


FROM node:20-alpine
# this creates /app and move there
RUN apk update && apk upgrade --no-cache
# this creates /app and move there
WORKDIR /app
EXPOSE 8080
COPY --from=builder /app /app
ENV MONGO="true" \
          MONGO_URL="mongodb://mongodb:27017/catalogue"

RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
RUN chown -R roboshop:roboshop /app
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]     