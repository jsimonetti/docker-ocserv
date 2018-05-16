FROM debian:testing

ADD ./start.sh /start.sh

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN set -x && \
    apt-get -yy update && apt-get -yy upgrade && apt-get -yy install --no-install-recommends ocserv procps && apt-get clean all && \
    echo 'net.ipv4.conf.all.proxy_arp = 1' > /etc/sysctl.d/proxy_arp.conf

WORKDIR /etc/ocserv

EXPOSE 443
CMD [ "/start.sh" ]
