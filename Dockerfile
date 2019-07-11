FROM golang:1.12-alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache \
        build-base \
        git && \
    go get github.com/gorilla/websocket && \
    go get golang.org/x/crypto/sha3 && \
    go get github.com/mattn/go-sqlite3 && \
    go get github.com/gin-gonic/gin && \
    go get github.com/himananiito/m3u8

COPY . /tmp/build

RUN cd /tmp/build && \
    go build src/livedl2.go


FROM alpine:latest 

RUN apk add --no-cache \
        ca-certificates \
        bash \
        ffmpeg \
        openssl

COPY --from=builder /tmp/build/livedl2 /usr/local/bin/

WORKDIR /livedl

VOLUME /livedl

EXPOSE 8080

CMD bash

