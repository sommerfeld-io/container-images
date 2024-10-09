FROM node:22.9.0-alpine
LABEL maintainer="sebastian@sommerfeld.io"

ARG COMMIT_SHA=undefined

LABEL org.opencontainers.image.version="$COMMIT_SHA"
LABEL org.opencontainers.image.revision="$COMMIT_SHA"
LABEL org.opencontainers.image.vendor="sommerfeld-io"
LABEL org.opencontainers.image.title="folderslint"
LABEL org.opencontainers.image.description="Validate the directory structure of a project"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/sommerfeldio/folderslint"
LABEL org.opencontainers.image.documentation="https://sommerfeld-io.github.io/container-images/images/folderslint"
LABEL org.opencontainers.image.source="https://github.com/sommerfeld-io/container-images/tree/main/components/folderslint"

RUN npm install --location=global folderslint@1.2.0

ENTRYPOINT [ "folderslint" ]
