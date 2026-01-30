FROM node:25.5.0-alpine
LABEL maintainer="sebastian@sommerfeld.io"

RUN apk add --no-cache git

WORKDIR /work
RUN git clone https://github.com/hakimel/reveal.js.git

WORKDIR /work/reveal.js
RUN npm install

ENTRYPOINT [ "npm", "start", "--", "--host=0.0.0.0" ]
