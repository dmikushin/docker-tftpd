# Copyright (c) 2018 kalaksi@users.noreply.github.com.
# This work is licensed under the terms of the MIT license. For a copy, see <https://opensource.org/licenses/MIT>.

# https://unix.stackexchange.com/a/656835/448173
FROM project42/syslog-alpine:latest

ENV TFTPD_BIND_ADDRESS="0.0.0.0:69"
ENV TFTPD_EXTRA_ARGS=""

RUN apk add --no-cache tftp-hpa

EXPOSE 69/udp

CMD in.tftpd --secure --permissive --foreground --verbosity 5 -u ftp --address "$TFTPD_BIND_ADDRESS" -m /tftpboot/mapfile $TFTPD_EXTRA_ARGS /tftpboot

ENTRYPOINT ["/init"]

