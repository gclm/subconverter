FROM node:16-alpine AS web
WORKDIR /app
COPY . /app
RUN ls -l && pwd
RUN npm install
RUN npm run build

FROM nginx:1.25-alpine
LABEL maintainer="gclm <gclmit@163.com>"

COPY --from=web /app/dist /usr/share/nginx/html
COPY .. /app

# 配置时区为上海时区
RUN apk add --no-cache tzdata curl wget vim \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# 编译 subconverter 服务器端
WORKDIR /
RUN apk add --no-cache --virtual .build-tools git g++ build-base linux-headers cmake && \
    apk add --no-cache --virtual .build-deps curl-dev rapidjson-dev libevent-dev pcre2-dev yaml-cpp-dev && \
    git clone https://github.com/ftk/quickjspp --depth=1 && \
    cd quickjspp && \
    git submodule update --init && \
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make quickjs -j $THREADS && \
    install -m644 quickjs/libquickjs.a /usr/lib && \
    install -d /usr/include/quickjs/ && \
    install -m644 quickjs/quickjs.h quickjs/quickjs-libc.h /usr/include/quickjs/ && \
    install -m644 quickjspp.hpp /usr/include && \
    cd .. && \
    git clone https://github.com/PerMalmberg/libcron --depth=1 && \
    cd libcron && \
    git submodule update --init && \
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make libcron -j $THREADS && \
    install -m644 libcron/out/Release/liblibcron.a /usr/lib/ && \
    install -d /usr/include/libcron/ && \
    install -m644 libcron/include/libcron/* /usr/include/libcron/ && \
    install -d /usr/include/date/ && \
    install -m644 libcron/externals/date/include/date/* /usr/include/date/ && \
    cd .. && \
    git clone https://github.com/ToruNiina/toml11 --depth=1 && \
    cd toml11 && \
    cmake -DCMAKE_CXX_STANDARD=11 . && \
    make install -j $THREADS && \
    cd .. && \
    git clone https://github.com/tindy2013/subconverter --depth=1 && \
    cd subconverter && \
    [ -n "$SHA" ] && sed -i 's/\(v[0-9]\.[0-9]\.[0-9]\)/\1-'"$SHA"'/' src/version.h;\
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make -j $THREADS && \
    mv subconverter /usr/bin && \
    mv base ../ && \
    cd .. && \
    rm -rf subconverter quickjspp libcron toml11 /usr/lib/lib*.a /usr/include/* /usr/local/include/lib*.a /usr/local/include/* && \
    apk add --no-cache --virtual subconverter-deps pcre2 libcurl yaml-cpp libevent && \
    apk del .build-tools .build-deps

# set entry
WORKDIR /base

EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
