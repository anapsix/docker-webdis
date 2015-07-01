FROM alpine
MAINTAINER Anastas Dancha <anapsix@random.io>

RUN apk update && apk upgrade && \
    apk add alpine-sdk libevent-dev bsd-compat-headers git    && \
    git clone --depth 1 http://github.com/nicolasff/webdis.git /tmp/webdis && \
    cd /tmp/webdis && make clean all && \
    sed -i '/redis_host/s/"127.*"/"redis"/g' webdis.json && \
    sed -i '/logfile.*$/d;/verbosity/s/,//' webdis.json  && \
    cp webdis /usr/local/bin/        && \
    cp webdis.json /etc/             && \
    mkdir -p /usr/share/doc/webdis   && \
    cp README.markdown /usr/share/doc/webdis/README && \
    cd /tmp && rm -rf /tmp/webdis    && \
    apk del --purge alpine-sdk libevent-dev bsd-compat-headers git && \
    apk add libevent

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 7379
