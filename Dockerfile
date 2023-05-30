FROM golang:1.19-alpine 

RUN apk add --update --no-cache ca-certificates tzdata git 
RUN go version
RUN adduser -D -h /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/ash", "/entrypoint.sh" ]
