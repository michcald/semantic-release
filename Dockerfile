FROM node:13-alpine3.11

WORKDIR /app

RUN apk add --no-cache git openssh

RUN npm install -g \
    semantic-release@17.1.1 \
    @semantic-release/exec@5.0.0 \
    conventional-changelog-conventionalcommits

COPY .releaserc /.releaserc

ADD entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
