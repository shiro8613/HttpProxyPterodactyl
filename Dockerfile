FROM golang:1.19-alpine 

RUN apk add --update --no-cache ca-certificates tzdata git 
RUN mkdir /usr/local/hproxy
RUN git clone -q --no-checkout https://github.com/shiro8613/HttpProxy.git /usr/local/hproxy
RUN cd /usr/local/hproxy && go mod tidy && go build -o httpproxy

RUN ln -s /usr/local/hproxy/httpproxy /usr/local/bin/httpproxy

RUN adduser -D -h /home/container container
RUN chown -R container:container /usr/local/hproxy
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/ash", "/entrypoint.sh" ]
