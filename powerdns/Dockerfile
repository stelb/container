# syntax=docker/dockerfile:1

FROM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && apt-get clean

RUN apt-get install -y \
    pdns-backend-pgsql \
    pdns-server \
    postgresql-client \
    tini \
    && rm -rf /var/lib/apt/lists/*

ENV PG_HOST=pghost
ENV PG_PORT=5432
ENV PG_DATABASE=pdns
ENV PG_USER=pdns
ENV PG_PASSWORD=changeit

ENV PDNS_APIKEY=changeit
ENV PDNS_WEBSERVERPASSWORD=changeit

ADD pdns.sh /pdns.sh
RUN chmod u+x /pdns.sh

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/pdns.sh" ]

EXPOSE 53/tcp
# Default webserver port
EXPOSE 8081/tcp

