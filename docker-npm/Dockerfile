FROM node:slim

WORKDIR /app

EXPOSE 3000

RUN npm install -g pnpm

COPY package.json .

COPY pnpm-lock.yaml .

RUN pnpm install

COPY . .

