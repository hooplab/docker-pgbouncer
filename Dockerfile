FROM alpine
MAINTAINER Håvard Lindset <havard@hoopla.no>

RUN apk add --update \
    make gcc openssl autoconf autoconf-doc automake c-ares c-ares-dev curl \
    gcc libc-dev libevent libevent-dev libtool man pkgconfig openssl-dev libevent && \
    rm -rf /var/cache/apk/*

RUN wget https://pgbouncer.github.io/downloads/files/1.7/pgbouncer-1.7.tar.gz -O /tmp/pgbouncer.tar.gz && \
    gzip -d /tmp/pgbouncer.tar.gz && \
    tar -xvf /tmp/pgbouncer.tar -C /tmp && \
    cd /tmp/pgbouncer-1.7/ && \
    ./configure --prefix=/usr/local --with-libevent=libevent-prefix && \
    make && \
    make install && \
    mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/postgresql && \
    cp etc/pgbouncer.ini /etc/pgbouncer && \
    cp etc/userlist.txt /etc/pgbouncer && \
    adduser -D -S pgbouncer && \
    chown pgbouncer /var/run/pgbouncer && \
    rm -rf /tmp/pgbouncer/* && \
    apk del --purge autoconf autoconf-doc automake c-ares-dev curl gcc libc-dev libevent-dev libtool make man openssl-dev pkgconfig

ADD ./config.ini /etc/pgbouncer/config.ini
ADD pgbouncer_overrides.ini /etc/pgbouncer/pgbouncer_overrides.ini
ADD databases_overrides.ini /etc/pgbouncer/databases_overrides.ini

EXPOSE 6432
VOLUME /var/run/postgresql/

CMD ["pgbouncer", "/etc/pgbouncer/config.ini"]


# RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
# RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pgbouncer vim

# ADD ./config.ini /etc/pgbouncer/config.ini

# ADD pgbouncer_overrides.ini /etc/pgbouncer/pgbouncer_overrides.ini
# ADD databases_overrides.ini /etc/pgbouncer/databases_overrides.ini

# EXPOSE 6432
# VOLUME /var/run/postgresql/

# CMD ["pgbouncer", "/etc/pgbouncer/config.ini"]
