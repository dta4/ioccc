FROM alpine:latest AS builder
MAINTAINER Andreas Schulze <asl@iaean.net>
RUN apk --update upgrade && \
    apk add --no-cache bash gcc make musl-dev
WORKDIR /root
COPY src .
RUN make

FROM alpine:latest  
MAINTAINER Andreas Schulze <asl@iaean.net>
RUN apk --no-cache add \
        bash less busybox-extras joe bind-tools \
        curl wget ca-certificates \
 	socat && \
    rm -rf /var/cache/apk/*
WORKDIR /root/

COPY --from=builder /root/oregonator .
COPY --from=builder /root/ioccc.txt .
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 10042
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/socat", "-d", "-d", "TCP4-LISTEN:10042,bind=0.0.0.0,fork", "EXEC:/root/oregonator /root/ioccc.txt"]
