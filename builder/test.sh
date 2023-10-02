

cat > /tmp/Dockerfile<<EOF
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
RUN echo 123;  uname -a; 
EOF

cd /tmp
docker build -t t01 .
