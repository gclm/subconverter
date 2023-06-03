FROM tindy2013/subconverter AS Server

FROM node:16-alpine AS web
WORKDIR /app
COPY .. /app
RUN npm install
RUN npm run build

FROM nginx:1.16-alpine
LABEL maintainer="gclm <gclmit@163.com>"
COPY --from=Server /subconverter /base
COPY --from=frontend /app/dist /usr/share/nginx/html
COPY .. /app

RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata \

EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
