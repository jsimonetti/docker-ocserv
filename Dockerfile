FROM alpine:latest AS builder

RUN apk add --no-cache musl-dev iptables gnutls-dev readline-dev libnl3-dev lz4-dev 
RUN buildDeps="xz openssl gcc autoconf make linux-headers protobuf-c-dev libev-dev"; \
	set -x \
	&& apk add $buildDeps \
	&& cd \
	&& wget http://ocserv.gitlab.io/www/download.html -O download.html \
	&& OC_VERSION=`sed -n 's/^.*version is <b>\(.*\)$/\1/p' download.html` \
	&& OC_FILE="ocserv-$OC_VERSION" \
	&& rm -fr download.html \
	&& wget ftp://ftp.infradead.org/pub/ocserv/$OC_FILE.tar.xz \
	&& tar xJf $OC_FILE.tar.xz \
	&& rm -fr $OC_FILE.tar.xz \
	&& cd $OC_FILE \
	&& sed -i '/#define DEFAULT_CONFIG_ENTRIES /{s/96/200/}' src/vpn.h \
	&& ./configure \
	&& make -j"$(nproc)" \
	&& make install \
	&& mkdir -p /etc/ocserv \
	&& cp ./doc/sample.config /etc/ocserv/ocserv.conf \
	&& cd \
	&& rm -fr ./$OC_FILE 





FROM alpine:latest

RUN apk add --no-cache iptables gnutls lz4-libs libev protobuf-c readline libnl3

COPY --from=builder /usr/local/bin/occtl /usr/local/bin/ocpasswd /usr/local/bin/ocserv-fw /usr/bin/
COPY --from=builder /usr/local/sbin/ocserv /usr/sbin/

ADD ./start.sh /start.sh

WORKDIR /etc/ocserv

EXPOSE 443
CMD [ "/start.sh" ]
