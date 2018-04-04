FROM alpine:3.7

ENV PGB_VER="1.8.1"

RUN addgroup psql && \
	adduser -H -D -G psql psql && \
	echo "psql:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk add -U --virtual deps \
		gcc g++ make libevent-dev \
		libressl-dev && \
	cd ~ && \
	wget https://pgbouncer.github.io/downloads/files/$PGB_VER/pgbouncer-$PGB_VER.tar.gz && \
	tar xf pgbouncer-$PGB_VER.tar.gz && \
	cd ~/pgbouncer-$PGB_VER/ && \
	./configure --prefix=/opt/pgbouncer && \
	make -j$(nproc) && \
	make install && \
	rm -rf ~/* && \
	apk del --purge deps && \
	apk add libevent && \
	mkdir /opt/pgbouncer/etc/
