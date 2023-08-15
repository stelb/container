cat >/etc/powerdns/pdns.conf <<EOF
setuid=pdns
setgid=pdns
 
# https://doc.powerdns.com/authoritative/backends/generic-postgresql.html
launch=gpgsql
gpgsql-host=${PG_HOST}
#gpgsql-port=${PG_PORT}
gpgsql-dbname=${PG_DATABASE}
gpgsql-user=${PG_USER}
gpgsql-password=${PG_PASSWORD}
gpgsql-dnssec=yes
 
loglevel=4
master=yes
slave=no
webserver=yes
api=yes
api-key=${PDNS_APIKEY}
daemon=no
guardian=no
default-publish-cdnskey=1
default-publish-cds=2,4
webserver-port=8081
#webserver-allow-from=127.0.0.1,::1
#allow-axfr-ips=0.0.0.0/0,::/0
#allow-notify-from=0.0.0.0/0,::/0
enable-lua-records=1
version-string=anonymous
default-soa-edit=INCEPTION-INCREMENT
EOF

pdns_server