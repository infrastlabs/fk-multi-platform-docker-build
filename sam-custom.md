

- nerdctl+ctd+buildkit
- buildx+buildkit (--platform=linux/amd64,linux/arm64)
- acorn/runtime (buildkit,in-registry)


```bash
# env: kernel-4.8+; qemu, binfmt,
# nerdctl/buildx build -t . --platform=...
# Dockerfile: arg x2
```