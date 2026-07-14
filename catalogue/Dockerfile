#1. normal image
# FROM node:20
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node", "server.js"]


# 2. alpine img

# FROM node:20.20.2-alpine3.23
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node", "server.js"]


# 3. multi branch

# FROM node:20.20.2-alpine3.23 AS builder
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# RUN npm install



# FROM node:20.20.2-alpine3.23 
# WORKDIR /app
# EXPOSE 8080
# COPY --from=builder /app /app
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node", "server.js"]

# user

FROM node:20.19.5-alpine3.21 AS builder
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install



FROM node:20.19.5-alpine3.21
WORKDIR /app
EXPOSE 8080
COPY --from=builder /app /app
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"

RUN addgroup -S roboshop && adduser -S  roboshop -G roboshop
RUN chown -R roboshop:roboshop /app 
USER roboshop 
CMD ["node", "server.js"]
