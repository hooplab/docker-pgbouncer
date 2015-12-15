FROM ubuntu
MAINTAINER Håvard Lindset <havard@hoopla.no>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pgbouncer vim

ADD ./config.ini /etc/pgbouncer/config.ini

RUN touch /etc/pgbouncer/pgbouncer_overrides.ini
RUN touch /etc/pgbouncer/databases_overrides.ini

EXPOSE 6432
VOLUME /var/run/postgresql/

CMD ["pgbouncer", "/etc/pgbouncer/config.ini"]
