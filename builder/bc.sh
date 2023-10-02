
cat > /tmp/Dockerfile<<EOF
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
RUN echo 123;  uname -a; 
EOF

# @buildctl, test `buildkitd  --oci-worker=true --containerd-worker=false` (runc only)

# buildctl build ... \
# --output type=image,\"name=docker.io/username/image,docker.io/username2/image2\",push=true
cd /tmp
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --opt platform=linux/amd64,linux/arm64 \
    --output type=image,name=test.registry.ssl:8143/bc:v0.1,push=true
    # --output type=local,dest=/tmp/path-to-output-dir
    
    # https://github.com/moby/buildkit#starting-the-buildkitd-daemon
    # --output type=local,dest=./bin/release,platform-split=false
    # --output type=tar,dest=out.tar
    # --output type=oci,dest=path/to/output.tar
    # --output type=docker,name=myimage | docker load
    # --output type=image,name=test.registry.ssl:8143/bc:v0.1,push=true
    # --opt target=foo \
    # --opt build-arg:foo=bar
    # --opt platform=linux/amd64,linux/arm64 \
    # 
    # --opt source=docker/dockerfile \
    # --opt context=https://github.com/moby/moby.git \
    # --opt build-arg:APT_MIRROR=cdn-fastly.deb.debian.org
    # 
    # --export-cache type=inline \
    # --export-cache type=registry,ref=localhost:5000/myrepo:buildcache \
    # --import-cache type=registry,ref=localhost:5000/myrepo:buildcache
    # --export-cache type=local,dest=path/to/output-dir
    # --import-cache type=local,src=path/to/input-dir
    # --export-cache type=s3,region=eu-west-1,bucket=my_bucket,name=my_image \
    # --import-cache type=s3,region=eu-west-1,bucket=my_bucket,name=my_image


# TCP

# buildkitd \
#   --addr tcp://0.0.0.0:1234 \
#   --tlscacert /path/to/ca.pem \
#   --tlscert /path/to/cert.pem \
#   --tlskey /path/to/key.pem

# buildctl \
#   --addr tcp://example.com:1234 \
#   --tlscacert /path/to/ca.pem \
#   --tlscert /path/to/clientcert.pem \
#   --tlskey /path/to/clientkey.pem \
#   build ...

# buildctl --addr=nerdctl-container://buildkitd build \
#  --frontend dockerfile.v0 --local context=. --local dockerfile=. \
#  --output type=oci | nerdctl load
