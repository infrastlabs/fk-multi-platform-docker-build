#!/bin/bash
arch=${TARGETPLATFORM#*/}
echo "arch: $arch"

function unpack(){
old=$(pwd); cd $1
ls |grep -E ".tgz$|.tar.gz$" |while read one; do
  dir=${one%.tgz}
  dir=${dir%.tar.gz}
  echo $dir
  mkdir -p $dir; tar -zxf $one -C $dir
done
cd $old
}
# WORKDIR /down
cd /down/down_k8s_v1.23.17; unpack $arch
cd /down; unpack $arch #xx.tar.gz all in /down/
# cd /down/down_gitee; unpack $arch
# unpack arm64

tree -L 2


################
cd /down;
mkdir -p /rootfs/usr/local/apps/{cfssl,buildkit,containerd} /rootfs/usr/local/kedge /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
# cri: ctd,fuse-overlayfs,cni,runc
\cp -a $arch/containerd-1.6.15-linux-$arch/bin/* /rootfs/usr/local/apps/containerd/
\cp -a $arch/containerd-fuse-overlayfs-1.0.5-linux-$arch/containerd-fuse-overlayfs-grpc /rootfs/usr/local/apps/containerd/
ls /rootfs/usr/local/buildkit/ |while read one; do ln -s /usr/local/apps/containerd/$one /rootfs/usr/local/bin/; done
# cni/runc
\cp -a $arch/cni-plugins-linux-$arch-v1.2.0/* /rootfs/opt/cni/bin/
\cp -a $arch/runc.$arch /rootfs/usr/local/sbin/runc
# cri_tools: crictl,nerdctl
\cp -a $arch/crictl-v1.26.0-linux-$arch/crictl /rootfs/usr/local/bin/
\cp -a $arch/nerdctl-1.1.0-linux-$arch/nerdctl /rootfs/usr/local/bin
ln -s /usr/local/bin/nerdctl /rootfs/usr/local/bin/docker
# 23.10 +buildkit
\cp -a $arch/buildkit-v0.12.2.linux-$arch/bin/* /rootfs/usr/local/apps/buildkit/
ls /rootfs/usr/local/apps/buildkit/ |while read one; do ln -s /usr/local/apps/buildkit/$one /rootfs/usr/local/bin/; done

# 23.2.4: +cfssl,dcp,gosv
if [ "amd64" == "$arch" ]; then #只有x64版本
  \cp -a down_cfssl_x64/$arch/cfssl_1.6.3_linux_amd64 /rootfs/usr/local/apps/cfssl/
  \cp -a down_cfssl_x64/$arch/cfssljson_1.6.3_linux_amd64 /rootfs/usr/local/apps/cfssl/
  \cp -a down_cfssl_x64/$arch/cfssl-certinfo_1.6.3_linux_amd64 /rootfs/usr/local/apps/cfssl/
  chmod +x /rootfs/usr/local/apps/cfssl/cfssl*
fi
test "amd64" == "$arch" && file=$arch/docker-compose-linux-x86_64 || file=$arch/docker-compose-linux-aarch64; 
\cp -a $file /rootfs/usr/local/bin/docker-compose #rename, link dcp @Dockerfile
# supervisord_static:只x64包里有
test "amd64" == "$arch" && file=$arch/supervisord_0.7.3_Linux_64-bit/supervisord_0.7.3_Linux_64-bit/supervisord || file=$arch/supervisord_0.7.3_Linux_ARM64/supervisord_0.7.3_Linux_ARM64/supervisord
\cp -a $file /rootfs/usr/local/bin/go-supervisord
chmod +x /rootfs/usr/local/bin/*




# alter,view
rm -f /rootfs/usr/local/bin/containerd-stress /rootfs/usr/local/bin/containerd-shim-runc-v1
chmod 755 /rootfs/usr/local/sbin/runc #/rootfs/usr/local/bin/k3s*
tree -h /rootfs
ls -lh /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
