#!/bin/sh
sysctl -p
exec ocserv -c /etc/ocserv/ocserv.conf -f

