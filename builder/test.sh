

cat > /tmp/Dockerfile<<EOF
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
RUN echo 123;  uname -a; 
EOF

cd /tmp
img=t01
img=test.registry.ssl/t012
docker build --platform=amd64,arm64 --push -t $img .
