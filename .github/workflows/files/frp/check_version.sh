bash
FRP_DOCKER_TAGS_URL=https://hub.docker.com/v2/repositories/itodouble/frp/tags
DOCKER_VERSION=$(curl -s $FRP_DOCKER_TAGS_URL | jq -r '.results[1].name')

FRP_VERSION_FULL=`curl --silent "https://api.github.com/repos/fatedier/frp/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
FRP_VERSION=${FRP_VERSION_FULL#v}
GITHUB_REF_NAME=${FRP_VERSION}
echo ${FRP_VERSION} > version.file
if [ ${FRP_VERSION} != ${DOCKER_VERSION} ]
then
    echo "构建版本："${FRP_VERSION}
    
    echo "FROM alpine:3" > Dockerfile
    echo "LABEL email=\"itodouble@outlook.com\"" >> Dockerfile
    echo "" >> Dockerfile
    echo "RUN apk add --update" >> Dockerfile
    echo "ARG FRP_VERSION=${GITHUB_REF_NAME}" >> Dockerfile
    echo "ARG URL=https://github.com/fatedier/frp/releases/download/v\${FRP_VERSION}/frp_\${FRP_VERSION}_linux_amd64.tar.gz" >> Dockerfile
    echo "" >> Dockerfile
    echo "## /usr/bin/{frps, frpc} -c xxx.toml" >> Dockerfile
    echo "RUN mkdir -p /frp /config \\" >> Dockerfile
    echo "    && cd /frp\\" >> Dockerfile
    echo "    && wget -qO- \${URL} | tar xz \\" >> Dockerfile
    echo "    && mv frp_*/frpc /usr/bin/ \\" >> Dockerfile
    echo "    && mv frp_*/frps /usr/bin/ \\" >> Dockerfile
    echo "    && mv frp_*/*.toml /config/ \\" >> Dockerfile
    echo "    && rm /frp -rf" >> Dockerfile
    
    echo "VOLUME /config" >> Dockerfile
    
    echo "ENV ARGS frps" >> Dockerfile
    echo "ENV CONFIG_FILE frps.toml" >> Dockerfile
    echo "ENV TZ Asia/Shanghai" >> Dockerfile
    
    echo "CMD /usr/bin/\${ARGS} -c /config/\${CONFIG_FILE}" >> Dockerfile
fi
