

- nerdctl+ctd+buildkit
- buildx+buildkit (--platform=linux/amd64,linux/arm64)
- acorn/runtime (buildkit,in-registry)


```bash
# env: kernel-4.8+; qemu, binfmt,
# nerdctl/buildx build -t . --platform=...
# Dockerfile: arg x2


# pri-registry: (nerdctl+buildkit+ctd直接OK; buildx:domain/certs>>TODO)
#  1.priv domain
#  2.priv certs
# filesystem/docker

# 物理机 | 容器Pod内运行
# attestation: registry/syncer
```

**Ref**

- https://github.com/moby/buildkit
- https://github.com/containerd/nerdctl
- https://github.com/containerd/containerd
- 
- https://gitee.com/g-k8s/fk-edgecore-indocker/blob/dev/bins2/Dockerfile
- https://github.com/containernetworking/plugins/releases #CNI
- https://github.com/opencontainers/runc/ #golang
- https://github.com/containers/crun #clang
- https://github.com/containerd/fuse-overlayfs-snapshotter
- https://github.com/kubernetes-sigs/cri-tools
- https://github.com/cloudflare/cfssl

```bash
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
#  1.buildkitd: sysd(.sock路径在/var/lib下)> ./buildkitd直接跑
#  2.nerdctl build: 依赖ctd.sock> 指向docker-ctd\'s dock 构建失败：
host-21-61:~/hand_bkit/down # nerdctl build -t t01 . --address=/var/run/docker/containerd/containerd.sock
FATA[0000] unknown method Server: not implemented

# Kedge@23.192
#  1.ctd: kedge之前配置好的
#  2.buildkitd: 在kedge容器内直接跑
#  3.nerdctl v160/v110: build -t t01 . 正常; 
#  multi: --platform=amd64,arm64 也OK `无需binfmt初始`
#  priv: 指向私仓; (导入证书; login; pushOK)
# root @ f474363c8c64 in .../kedge/down |13:05:21  
$ docker login test.registry.ssl:8143/t02
Enter Username: admin
Enter Password: 
WARNING: Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded
# root @ f474363c8c64 in .../kedge/down |13:05:37  
$ docker push test.registry.ssl:8143/t02
index-latest@sha256:5353140ed24d1dacc58832a23ad76bb55d8c8ee118f549168cd2ea773c6ef28a: done           |++++++++++++++++++++++++++++++++++++++| 
manifest-sha256:c774e5ca3be9f02746abc0ccc9a5a429b7f26a7951633023f61206356fe0df8d:     done           |++++++++++++++++++++++++++++++++++++++| 
config-sha256:0292ff408f2c4f3b9896ed23d28ca1604061ad9a48008c695251d152ef7841b6:       done           |++++++++++++++++++++++++++++++++++++++| 
elapsed: 0.2 s                                                                        total:  1.7 Ki (8.5 KiB/s)

# https://172.25.20.161:8143/
t021:latest # amd64:2.7 MB | arm64:2.6 MB
t02:latest # amd64:2.7 MB
```
