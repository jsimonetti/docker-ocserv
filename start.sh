#!/bin/sh
sysctl --load=/etc/sysctl.d/proxy_arp.conf
exec ocserv -c /etc/ocserv/ocserv.conf -f

