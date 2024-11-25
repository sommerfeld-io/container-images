FROM node:23.3.0-alpine
LABEL maintainer="sebastian@sommerfeld.io"

RUN npm install --location=global folderslint@1.2.0

ENTRYPOINT [ "folderslint" ]
