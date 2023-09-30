

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
```