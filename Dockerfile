# 编译 subconverter 服务器端
FROM tindy2013/subconverter:latest AS builder

# 编译 前端
FROM node:20-alpine AS web
WORKDIR /app
COPY . /app
RUN ls -l && pwd
RUN npm install
RUN npm run build


FROM nginx:1.25-alpine
LABEL maintainer="gclm <gclmit@163.com>"

COPY --from=builder /usr/bin/subconverter /usr/bin/
COPY --from=builder /base/ /base/
COPY --from=web /app/dist /usr/share/nginx/html
COPY .. /app


RUN apk add --no-cache --virtual subconverter-deps pcre2 libcurl yaml-cpp

# 配置时区为上海时区
RUN apk add --no-cache tzdata curl wget vim \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# set entry
WORKDIR /base

EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
