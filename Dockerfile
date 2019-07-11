FROM golang:1.12-alpine as build
MAINTAINER Winding.of_NKTN <Winding@kazuki.xyz>

RUN apk add --no-cache \
        build-base \
        git && \
    echo "Please wait... go get modules" && \
    go get github.com/gorilla/websocket \
	golang.org/x/crypto/sha3 \
	github.com/mattn/go-sqlite3 \
	github.com/gin-gonic/gin \
	github.com/himananiito/m3u8

COPY . /tmp/build

RUN cd /tmp/build && \
    go build src/livedl2.go


FROM alpine:latest

WORKDIR /livedl

VOLUME /livedl

RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    apk del tzdata

RUN apk add --no-cache \
        ca-certificates \
        bash \
        ffmpeg \
        openssl

COPY . /livedl

COPY --from=build /tmp/build/livedl2 /livedl/

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "/livedl/livedl2"]
