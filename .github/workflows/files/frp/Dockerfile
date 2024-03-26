FROM alpine
LABEL maintainer="no-reply.lan@outlook.com"
ARG FRP_VERSION=${FRP_VERSION}

RUN apk add --update
RUN echo "Target version = ${FRP_VERSION}"
ADD https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz /frp

VOLUME /config

ENV ARGS frps
ENV CONFIG_FILE frps.toml
ENV TZ Asia/Shanghai

CMD /frp/${ARGS} -c /config/${CONFIG_FILE}
