# FROM mhart/alpine-node
FROM node:5.5-slim

# RUN apk add --update --virtual build-dependencies \
#    git make gcc g++ python

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y graphicsmagick

volume ["/app/config"]

# URL of fxa-auth-server
ENV AUTH_SERVER_URL=http://127.0.0.1:9000/v1
ENV DB=mysql
ENV NODE_ENV=dev
ENV IMG=local

ENV LOG_LEVEL=info
ENV LOG_DEBUG=false

ENV CREATE_MYSQL_SCHEMA=true
ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=
ENV MYSQL_DATABASE=fxa_profile
ENV MYSQL_HOST=127.0.0.1
ENV MYSQL_PORT=3306
ENV OAUTH_SERVER_URL=http://127.0.0.1:9010/v1
ENV PUBLIC_URL=http://127.0.0.1:1111
ENV HOST=127.0.0.1
ENV PORT=1111
ENV WORKER_HOST=127.0.0.1
ENV WORKER_PORT=1113

EXPOSE 1111

ADD bin /app/bin
ADD config /app/config
ADD lib /app/lib
ADD scripts /app/scripts
ADD tasks /app/tasks
ADD CHANGELOG.md /app/CHANGELOG.md
ADD LICENSE /app/LICENSE
ADD npm-shrinkwrap.json /app/npm-shrinkwrap.json
ADD package.json /app/package.json

WORKDIR /app

RUN ["npm", "install"]

# RUN apk del build-dependencies && \
#    rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

RUN scripts/check_gm.sh

# write config/version.json
RUN scripts/rpm-version.js > config/version.json

CMD ["npm", "start"]
