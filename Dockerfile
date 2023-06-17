FROM alpine:latest

RUN apk update && apk upgrade -v

RUN apk add python3 py3-pip

