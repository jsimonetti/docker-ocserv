FROM debian:testing

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -yy update && apt-get -yy upgrade && apt-get -yy install ocserv && apt-get clean all

WORKDIR /etc/ocserv

EXPOSE 443
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]

