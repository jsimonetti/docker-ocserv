#!/bin/sh
sysctl -w net.ipv4.conf.all.proxy_arp=1
exec ocserv -c /etc/ocserv/ocserv.conf -f

