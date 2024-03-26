FROM alpine
LABEL maintainer="no-reply.lan@outlook.com"
ARG FRP_VERSION=${FRP_VERSION}

RUN apk add --update
RUN echo "Target version = ${FRP_VERSION}"
ADD https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz /frp.tar.gz
RUN mkdir /frp_app
RUN tar -xzvf /frp.tar.gz -C /frp_app/
RUN mv /frp_app/frp_*/frpc /usr/bin/
RUN mv /frp_app/frp_*/frps /usr/bin/
RUN rm -rf /frp_app
RUN rm -rf frp.tar.gz

VOLUME /config

ENV ARGS frps
ENV CONFIG_FILE frps.toml
ENV TZ Asia/Shanghai

CMD /usr/bin/${ARGS} -c /config/${CONFIG_FILE}
