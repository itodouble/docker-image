#####################################################
### Copy platform specific binary
FROM bash as copy-binary
ARG NAVIDROME_VERSION

RUN echo "Target version = ${NAVIDROME_VERSION}"
ADD https://github.com/navidrome/navidrome/releases/download/v${NAVIDROME_VERSION}/navidrome_${NAVIDROME_VERSION}_linux_amd64.tar.gz /navidrome_${NAVIDROME_VERSION}_linux_amd64.tar.gz
RUN mkdir /navidrome
RUN tar -xzvf /navidrome_${NAVIDROME_VERSION}_linux_amd64.tar.gz -C /navidrome/

RUN ls -lah /navidrome
RUN chmod +x /navidrome/navidrome

#####################################################
### Build Final Image
FROM alpine as release
LABEL maintainer="deluan@navidrome.org"

# Install ffmpeg and output build config
RUN apk add --no-cache ffmpeg
RUN ffmpeg -buildconf

COPY --from=copy-binary /navidrome/navidrome /app/

VOLUME ["/data", "/music"]
ENV ND_MUSICFOLDER /music
ENV ND_DATAFOLDER /data
ENV ND_PORT 4533
ENV GODEBUG "asyncpreemptoff=1"

EXPOSE ${ND_PORT}
HEALTHCHECK CMD wget -O- http://localhost:${ND_PORT}/ping || exit 1
WORKDIR /app

ENTRYPOINT ["/app/navidrome"]
