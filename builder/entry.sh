#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
cd $cur

# sv, ctd/cni, tz, bins
function dealKind(){
    echo ".env>>> HOST=$HOST"

    # sv's logfile
    mkdir -p /var/log/supervisor
    rm -f /usr/bin/sv; echo -e "#!/bin/bash\ntest -z "\$1" && exit 0; go-supervisord ctl \$@" > /usr/bin/sv; chmod +x /usr/bin/sv
    
    # cat supervisor.service > /lib/systemd/system/supervisor.service
    mkdir -p /etc/supervisor
    cat sv2.conf > /etc/supervisor/supervisord.conf
    sed -i "s^_HOSTNAME_^$h2^g" /etc/supervisor/supervisord.conf
    mkdir -p $cur/logs-$h2


    # bins cgroup_dbg
    chmod +x .bin/*
    \cp .bin/* /usr/local/bin

    # ctd's root dir; privateCrt
    cat .ctd/config.toml > /etc/containerd/config.toml
    # test "$SPLIT_CTD_DATA" == "true" && sed -i "s^root = \"/var/lib/containerd\"^root = \"/var/lib/containerd/ctd-$h2\"^g" /etc/containerd/config.toml
    # TLS-Registry-Cert
    bash regcert.sh

    # cni conf
    rm -f  /etc/cni/net.d/*
    cat .cni/bridge-nerdctl-cpout.conflist > /etc/cni/net.d/bridge-nerdctl-cpout.conflist



    # docker login; 免进入kind容器拉镜像还得login; docker login 不依赖ctd的启动
    # echo admin123 |docker login server.k8s.local:18443 --username=admin --password-stdin

    # tz
    # https://blog.csdn.net/weixin_40918067/article/details/116858218
    # -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro
    cat /usr/share/zoneinfo/Asia/Shanghai > /etc/timezone #/etc/localtime
    cat /usr/share/zoneinfo/Asia/Shanghai > /etc/localtime

    # limits
    # ulimit -n 6553500 #too many open files ##cannot modify limit: Operation not permitted
    # sysctl fs.inotify.max_user_instances=102400 #OK nonErr: err="inotify_init: too many open files"
    # sysctl fs.inotify.max_user_watches="99999999"

    # https://kind.sigs.k8s.io/docs/user/known-issues/
    # cat /proc/sys/fs/inotify/max_user_instances #容器内，宿主机一样(bare-host级别)
    # cat /proc/sys/fs/inotify/max_user_watches #524288 >5242880
    sudo sysctl fs.inotify.max_user_instances=512000 #宿主机直接执行一次， ct-kubelet可生效
    sudo sysctl fs.inotify.max_user_watches=5242880
}
h2=$(hostname); #$HOSTNAME
h2=${h2:0:5}
dealKind

# tail -f /dev/null #test
# systemd
# exec /sbin/init

# go-sv
sed -i 's^exec .*^exec /usr/local/bin/go-supervisord -c  /etc/supervisor/supervisord.conf^g' /usr/local/bin/entrypoint
exec /usr/local/bin/entrypoint /sbin/init
# exec /usr/bin/supervisord -n -c  /etc/supervisor/supervisord.conf
