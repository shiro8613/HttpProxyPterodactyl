FROM golang:1.19-alpine as build

RUN mkdir /usr/local/httpproxy
WORKDIR /usr/local/httpproxy

RUN apk add --update --no-cache ca-certificates tzdata git 
RUN git clone -q --no-checkout https://github.com/shiro8613/HttpProxy.git

RUN cd HttpProxy
RUN go mod tidy

RUN go build -o httpproxy

FROM alpine:latest

RUN mkdir /usr/local/httpproxy
COPY --from=build /usr/local/httpproxy/httpproxy /usr/local/httpproxy/httpproxy
RUN ln -s /usr/local/httpproxy/httpproxy /usr/local/bin/httpproxy

RUN adduser -D -h /home/container container
RUN chown -R container:container /usr/local/httpproxy
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/ash", "/entrypoint.sh" ]