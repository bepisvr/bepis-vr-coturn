FROM ghcr.io/bepisvr/bepis-vr-coturn-image:latest

ARG AUTH_SECRET
ARG REALM_NAME

RUN echo '\n\
listening-ip=0.0.0.0\n\
use-auth-secret\n\
static-auth-secret='"$AUTH_SECRET"'\n\
realm='"$REALM_NAME" > /etc/turnserver.conf

EXPOSE 3478 3478/udp
EXPOSE 5347 5347/udp

VOLUME ["/var/lib/coturn"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["--log-file=stdout", "-c", "/etc/turnserver.conf", "$COTURN_ARGS"]
