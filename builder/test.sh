

cat > /tmp/Dockerfile<<EOF
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
RUN echo 123;  uname -a; 
EOF

cd /tmp
img=t01
img=test.registry.ssl:8143/t012
plat="--platform=amd64,arm64"

docker build $plat -t $img .
docker push $img $plat #--all-platforms