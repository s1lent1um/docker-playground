FROM ubuntu:trusty

RUN apt-get update && apt-get upgrade -q -y && apt-get install -q -y --force-yes \
    ca-certificates \
    software-properties-common \
    libpcre3-dev \
    libcurl3-openssl-dev

RUN apt-get install -q -y --force-yes \
    openvpn \
    easy-rsa

RUN mkdir /etc/openvpn/easy-rsa && mkdir /etc/openvpn/ccd && cp -r /usr/share/easy-rsa /etc/openvpn/easy-rsa/2.0

COPY vars /etc/openvpn/easy-rsa/2.0/vars

COPY server.conf /etc/openvpn/server.conf

RUN cd /etc/openvpn/easy-rsa/2.0 && cp openssl-1.0.0.cnf openssl.cnf && . ./vars && \
    ./clean-all && ./build-ca --batch && ./build-key-server --batch server && ./build-dh --batch && openvpn --genkey --secret keys/ta.key && \
    cp -r /etc/openvpn/easy-rsa/2.0/keys/ /etc/openvpn/

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/entrypoint.sh" ]

EXPOSE 1194/udp
