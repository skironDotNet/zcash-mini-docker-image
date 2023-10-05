FROM ubuntu:20.04

RUN apt update && apt install -y ca-certificates && apt clean command

ADD output/zcashd /usr/local/bin/

RUN mkdir -p /srv/.zcash && chown 2001:2001 /srv/.zcash
RUN mkdir -p /srv/.zcash-params && chown 2001:2001 /srv/.zcash-params

ARG ZEC_USER=zcashd
ARG ZEC_UID=2001

RUN useradd --home-dir /srv/$ZEC_USER \
            --shell /bin/bash \
            --create-home \
            --uid $ZEC_UID\
            $ZEC_USER
USER $ZEC_USER
WORKDIR /srv/$ZEC_USER

ENTRYPOINT ["zcashd"]
