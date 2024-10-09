FROM ubuntu:24.04
LABEL maintainer="sebastian@sommerfeld.io"
LABEL org.opencontainers.image.vendor="sommerfeld-io"
LABEL org.opencontainers.image.documentation="https://sommerfeld-io.github.io/container-images/images/shdoc"

RUN apt-get update \
    && apt-get install -y --no-install-recommends gawk=1:5.2.1-2build3 \
    && apt-get install -y --no-install-recommends git=1:2.43.0-1ubuntu7.1 \
    && apt-get install -y --no-install-recommends make=4.3-4.1build2 \
    && apt-get install -y --no-install-recommends ca-certificates=20240203 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --recursive https://github.com/reconquest/shdoc

WORKDIR /opt/shdoc
RUN make install
