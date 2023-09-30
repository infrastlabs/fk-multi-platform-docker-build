

- nerdctl+ctd+buildkit
- buildx+buildkit (--platform=linux/amd64,linux/arm64)
- acorn/runtime (buildkit,in-registry)


```bash
# env: kernel-4.8+; qemu, binfmt,
# nerdctl/buildx build -t . --platform=...
# Dockerfile: arg x2


# pri-registry:
#  1.priv domain
#  2.priv certs
# filesystem/docker

# 物理机 | 容器Pod内运行
# attestation: registry/syncer


# fk-edgecore-indocker: @2022.12 (ctd,ctd-fuse,cni,runc, crictl/nerdctl)
\cp -a $arch/containerd-1.6.15-linux-$arch/bin/* /rootfs/usr/local/bin/
\cp -a $arch/containerd-fuse-overlayfs-1.0.5-linux-$arch/containerd-fuse-overlayfs-grpc /rootfs/usr/local/bin/
\cp -a $arch/cni-plugins-linux-$arch-v1.2.0/* /rootfs/opt/cni/bin/
\cp -a $arch/runc.$arch /rootfs/usr/local/sbin/runc
# cri_tools: crictl,nerdctl
\cp -a $arch/crictl-v1.26.0-linux-$arch/crictl /rootfs/usr/local/bin/
\cp -a $arch/nerdctl-1.1.0-linux-$arch/nerdctl /rootfs/usr/local/bin/docker

# tmux-static:
curl -O -fSL http://ghproxy.com/https://github.com/pythops/tmux-linux-binary/releases/download/v3.3a/tmux-linux-x86_64 #arm64


# buildkit
https://github.com/moby/buildkit/releases/download/v0.10.6/buildkit-v0.10.6.linux-amd64.tar.gz #22.11.11 46.7M
https://github.com/moby/buildkit/releases/download/v0.11.6/buildkit-v0.11.6.linux-amd64.tar.gz #23.4.21 61.8M
https://github.com/moby/buildkit/releases/download/v0.12.2/buildkit-v0.12.2.linux-amd64.tar.gz #23.8.13 62.7M

ctd v1.6.15> v1.6.24/v1.7.6  [v1.7@23.3.11]
nerdctl v110> v160 @23.9
https://github.com/containerd/nerdctl/releases/download/v1.6.0/nerdctl-1.6.0-linux-amd64.tar.gz #8.84M


```

**buildkit-try1**

```bash
# 物理机@21.61
#  buildkitd: sysd(.sock路径在/var/lib下)> ./buildkitd直接跑
#  nerdctl build: 依赖ctd.sock> 指向docker-ctd\'s dock
host-21-61:~/hand_bkit/down # nerdctl build -t t01 . --address=/var/run/docker/containerd/containerd.sock
FATA[0000] unknown method Server: not implemented

# Kedge@23.192
ctd: kedge之前配置好的
buildkitd: 在kedge容器内直接跑
nerdctl v160/v110: build -t t01 . 正常; --platform=amd64,arm64 也OK `无需binfmt初始`



```
