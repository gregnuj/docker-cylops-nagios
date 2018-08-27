FROM gregnuj/cyclops-base:latest
LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"
USER root 

ENV RUNTIME_PKGS="nagios nagios-plugins"
ENV BUILDTIME_PKGS="alpine-sdk"

# Install packages 
RUN set -ex \
    && apk upgrade --update \
    && apk --no-cache add --virtual $RUNTIME_PKGS \
    && apk --no-cache add --virtual .bdeps $BUILDTIME_PKGS \
    && curl https://mathias-kettner.de/download/mk-livestatus-1.2.8p11.tar.gz | tar xvz \
    && (cd mk-livestatus-1.2.8p11 && ./configure && make && make install ) \
    && rm -rf mk-livestatus-1.2.8p11 \ 
    && apk del .bdeps
    
EXPOSE 22 80 443 9001
WORKDIR "/var/www/html"
CMD ["/usr/bin/supervisord", "-n"]
