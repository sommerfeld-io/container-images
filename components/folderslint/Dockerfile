FROM node:22.9.0-alpine
LABEL maintainer="sebastian@sommerfeld.io"
LABEL org.opencontainers.image.vendor="sommerfeld-io"
LABEL org.opencontainers.image.documentation="https://sommerfeld-io.github.io/container-images/images/folderslint"

RUN npm install --location=global folderslint@1.2.0

ENTRYPOINT [ "folderslint" ]
