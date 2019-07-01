FROM alpine:3.10

ENV PGB_VER="1.10.0"

RUN addgroup psql && \
    adduser -H -D -u 1000 -S -G psql psql

RUN apk add -U --virtual deps \
        gcc g++ make libevent-dev \
        libressl-dev c-ares-dev udns-dev && \
    apk add libevent c-ares && \
    cd ~ && \
    wget https://pgbouncer.github.io/downloads/files/$PGB_VER/pgbouncer-$PGB_VER.tar.gz && \
    tar xf pgbouncer-$PGB_VER.tar.gz && \
    cd ~/pgbouncer-$PGB_VER/ && \
    ./configure --prefix=/opt/pgbouncer \
        --with-udns && \
    make -j$(nproc) && \
    make install && \
    rm -rf ~/* && \
    apk del --purge deps && \
    mkdir /opt/pgbouncer/etc/

CMD /opt/pgbouncer/bin/pgbouncer --user=psql /opt/pgbouncer/etc/pgbouncer.ini
