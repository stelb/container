#!/bin/sh

cat >/etc/powerdns/pdns.conf <<EOF
setuid=pdns
setgid=pdns
 
# https://doc.powerdns.com/authoritative/backends/generic-postgresql.html
launch=gpgsql
gpgsql-host=${PG_HOST}
gpgsql-port=${PG_PORT}
gpgsql-dbname=${PG_DATABASE}
gpgsql-user=${PG_USER}
gpgsql-password=${PG_PASSWORD}
gpgsql-dnssec=yes
 
loglevel=4
master=yes
slave=no
webserver=yes
dnsupdate=yes
api=yes
api-key=${PDNS_APIKEY}
daemon=no
guardian=no
default-publish-cdnskey=1
default-publish-cds=2,4
webserver-address=0.0.0.0
webserver-port=8081
webserver-allow-from=0.0.0.0/0,::/0
webserver-password=${PDNS_WEBSERVERPASSWORD}
#allow-axfr-ips=0.0.0.0/0,::/0
#allow-notify-from=0.0.0.0/0,::/0
enable-lua-records=1
version-string=anonymous
default-soa-edit=INCEPTION-INCREMENT
EOF

init_db() {
    export PGPASSWORD="$PG_PASSWORD"
    psql -h "$PG_HOST" \
        -U "$PG_USER" \
        -f /usr/share/pdns-backend-pgsql/schema/schema.pgsql.sql 
}

check_db() {
   export PGPASSWORD="$PG_PASSWORD"
   TABCOUNT=$(psql -h "$PG_HOST" \
        -U "$PG_USER" \
        -t -c "select count(*) from pg_tables where schemaname='public'")
    export TABCOUNT

    if [ "$TABCOUNT" -gt 0 ]; then
        echo schema exists
        return 1
    else
        echo create schema
        return 0
    fi        
}

if check_db; then
  init_db;
fi

pdns_server