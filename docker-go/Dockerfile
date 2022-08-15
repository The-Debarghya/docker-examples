FROM golang:1.8.3 as builder
WORKDIR /go/src/github.com/The-Debarghya/docker-go/findlinks
RUN go get -d -v golang.org/x/net/html
COPY findlinks.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o findlinks .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/The-Debarghya/docker-go/findlinks/findlinks .
CMD ["./findlinks"]

