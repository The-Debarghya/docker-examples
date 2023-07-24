FROM alpine:latest

RUN apk update && apk upgrade -v

RUN apk add python3 py3-pip
RUN adduser -D user --shell /usr/bin/ash
WORKDIR /home/user
USER user
ENTRYPOINT ["/bin/ash"]
