FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
# from https://raw.githubusercontent.com/forsrc/docker-coturn/master/apt-get/Dockerfile
RUN apt-get update

RUN apt-get -y install coturn openssl systemd sudo

ARG AUTH_SECRET
ARG REALM_NAME

RUN echo '\n\
use-auth-secret\n\
static-auth-secret='"$AUTH_SECRET"'\n\
realm='"$REALM_NAME" > /etc/turnserver.conf

RUN echo '#!/bin/bash'                        >  /docker-entrypoint.sh
RUN echo "if [ \"\${1:0:1}\" == '-' ]; then"  >> /docker-entrypoint.sh
RUN echo '  set -- turnserver "$@"'           >> /docker-entrypoint.sh
RUN echo 'fi'                                 >> /docker-entrypoint.sh
RUN echo 'exec $(eval "echo $@")'             >> /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#ENV USER=forsrc
#ARG PASSWD=forsrc
#RUN apt-get update
#RUN apt-get install -y sudo
#RUN useradd -m --shell /bin/bash $USER && \
#    echo "$USER:$PASSWD" | chpasswd && \
#    echo "$USER ALL=(ALL) ALL" >> /etc/sudoers
#RUN apt-get clean

#RUN chown $USER:$USER /var/lib/turn/
#RUN chown $USER:$USER /var/run/

#WORKDIR /home/$USER
#USER $USER

EXPOSE 3478 3478/udp
EXPOSE 5347 5347/udp

VOLUME ["/var/lib/coturn"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["--log-file=stdout", "-c", "/etc/turnserver.conf", "$COTURN_ARGS"]
