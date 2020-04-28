FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y \
	libace-dev \
	libtbb-dev \
	openssl \
	libssl-dev \
	zlib1g-dev \
	libcurl4-openssl-dev \
	php-soap \
	libmysqlclient-dev 

COPY ./vmangos/bin/realmd /opt/vmangos/bin/realmd

WORKDIR /opt/vmangos/

RUN chmod +x /opt/vmangos/bin/realmd

CMD bin/realmd -c /opt/vmangos/etc/realmd.conf
