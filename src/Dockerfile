FROM ubuntu:20.04 AS base

RUN apt update && apt install -y ca-certificates

# build in separte temporary container
FROM base AS build

ARG GIT_TAG
WORKDIR /

# install needed tools
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt update && apt-get install -y wget git make jq curl binutils build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python3 python3-zmq zlib1g-dev curl bsdmainutils automake libtinfo5

RUN git clone --progress https://github.com/zcash/zcash.git

# checkout previously discovered latest tag and use that source code
RUN cd /zcash && git checkout -b buildtag $GIT_TAG
RUN /zcash/zcutil/build.sh -j$(nproc) 

# strip built binaries to minimize the size
RUN cd /zcash/src && strip zcashd && strip zcash-cli

# build final minimal docker image
FROM base AS final

RUN apt clean command

ARG ZEC_USER=zcashd
ARG ZEC_UID=2001

RUN mkdir -p /srv/.zcash && chown $ZEC_UID:$ZEC_UID /srv/.zcash
RUN mkdir -p /srv/.zcash-params && chown $ZEC_UID:$ZEC_UID /srv/.zcash-params

RUN useradd --home-dir /srv/$ZEC_USER \
            --shell /bin/bash \
            --create-home \
            --uid $ZEC_UID\
            $ZEC_USER
USER $ZEC_USER

WORKDIR /srv/$ZEC_USER
COPY --from=build /zcash/src/zcashd /usr/local/bin/
COPY --from=build /zcash/src/zcash-cli /usr/local/bin/
COPY --from=build /zcash/src/zcashd-wallet-tool /usr/local/bin/

CMD ["zcashd"]
