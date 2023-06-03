FROM node:16-alpine AS web
WORKDIR /app
COPY . /app
RUN ls -l && pwd
RUN npm install
RUN npm run build

FROM tindy2013/subconverter:latest AS Server
WORKDIR /base

FROM nginx:1.25-alpine
LABEL maintainer="gclm <gclmit@163.com>"

COPY --from=Server /base /base
COPY --from=web /app/dist /usr/share/nginx/html
COPY .. /app

RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
