FROM node:18.17 as base

FROM base as builder

WORKDIR /home/node/app
COPY package*.json ./

COPY . .
RUN npm install
RUN npm run build

FROM base as runtime

ENV NODE_ENV=production
ENV PAYLOAD_CONFIG_PATH=dist/payload.config.js

WORKDIR /home/node/app
COPY package*.json  ./


RUN npm install --production

COPY --from=builder /home/node/app/dist ./dist
COPY --from=builder /home/node/app/build ./build
COPY --from=builder /home/node/app/dist/payload/ /home/node/app/dist
RUN ls /home/node/app
RUN ls /home/node/app/dist/payload
RUN ls /home/node/app/build
RUN ls /home/node/app/dist

EXPOSE 3000

CMD ["node", "dist/server.js"]
