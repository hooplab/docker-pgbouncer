FROM ubuntu
MAINTAINER Håvard Lindset <havard@hoopla.no>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pgbouncer vim
RUN mkdir /var/run/postgresql

ADD ./config.ini /etc/pgbouncer/config.ini

EXPOSE 6432
VOLUME /var/run/postgresql/.s.PGSQL.6432

ENTRYPOINT ["pgbouncer", "/etc/pgbouncer/config.ini"]
