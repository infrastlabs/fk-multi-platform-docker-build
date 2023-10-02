
cat > /tmp/Dockerfile<<EOF
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
RUN echo 123;  uname -a; 
EOF


# buildctl build ... \
# --output type=image,\"name=docker.io/username/image,docker.io/username2/image2\",push=true
cd /tmp
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=test.registry.ssl:8143/bc:v0.1,push=true
    # --opt target=foo \
    # --opt build-arg:foo=bar