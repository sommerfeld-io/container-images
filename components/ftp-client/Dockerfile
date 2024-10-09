FROM ubuntu:24.04
LABEL maintainer="sebastian@sommerfeld.io"

ARG COMMIT_SHA=undefined

LABEL org.opencontainers.image.version="$COMMIT_SHA"
LABEL org.opencontainers.image.revision="$COMMIT_SHA"
LABEL org.opencontainers.image.vendor="sommerfeld-io"
LABEL org.opencontainers.image.title="ftp-client"
LABEL org.opencontainers.image.description="Image with NCFTP to upload and download files from FTP servers"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/sommerfeldio/ftp-client"
LABEL org.opencontainers.image.documentation="https://sommerfeld-io.github.io/container-images/images/ftp-client"
LABEL org.opencontainers.image.source="https://github.com/sommerfeld-io/container-images/tree/main/components/ftp-client"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ncftp=2:3.2.6-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
