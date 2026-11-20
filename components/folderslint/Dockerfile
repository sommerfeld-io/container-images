FROM dhi.io/node:26.13.1-alpine3.24-dev AS build

RUN npm install --location=global folderslint@1.2.0


FROM dhi.io/node:26.13.1-alpine3.24
LABEL maintainer="sebastian@sommerfeld.io"

COPY --from=build /usr/local/lib/node_modules/folderslint /usr/local/lib/node_modules/folderslint

ENTRYPOINT [ "node", "/usr/local/lib/node_modules/folderslint/index.js" ]
