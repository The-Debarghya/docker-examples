# -- build stager --
FROM node:lts-bullseye-slim AS builder

WORKDIR /source

COPY package.json .
COPY package-lock.json .

# -- install all deps for build --
RUN npm install -g typescript
RUN npm install --loglevel=error 

# -- compile ts to js --
COPY . .
RUN npm run build

# -- dependancy stager
FROM node:lts-bookworm-slim AS deps

WORKDIR /deps

COPY package.json .
COPY package-lock.json .

# -- production deps only --
RUN npm install --omit=dev --loglevel=error



FROM node:lts-alpine3.18 AS final

RUN apk upgrade --no-cache

WORKDIR /app

COPY package.json .
COPY package-lock.json .

# -- deps from deps stager --
RUN mkdir node_modules
COPY --from=deps /deps/node_modules ./node_modules

# -- compiled code from build stager --
RUN mkdir dist
COPY --from=builder /source/dist ./dist

EXPOSE 4000

CMD [ "npm", "start" ]