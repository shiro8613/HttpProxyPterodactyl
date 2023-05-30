FROM golang:1.19-alpine as build

RUN apk add --update --no-cache ca-certificates tzdata git 
RUN mkdir /usr/local/hproxy
WORKDIR /usr/local/hproxy
RUN git clone -q https://github.com/shiro8613/HttpProxy.git .
RUN go mod download
RUN go build -o httpproxy

FROM alpine:latest
COPY --from=build /usr/local/hproxy /usr/local/hproxy
RUN ln -s /usr/local/hproxy/httpproxy
RUN adduser -D -h /home/container container
RUN chown -R container:container /usr/local/hproxy
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/ash", "/entrypoint.sh" ]
