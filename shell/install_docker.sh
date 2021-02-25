#!/bin/bash
arch=$(arch)
os_release=el7
download_url=http://192.168.31.209/rpm/${arch}
docker_rpm=docker-19.03.9-${os_release}.${arch}
docker0=100.0.0.1/16
docker_gwbridge=100.1.0.0/16
docker_gw=100.1.0.1
swarm_interface=eth0
swarm_interface_addr=$(ip -o -4 addr show ${swarm_interface} | awk -F"[ /]" '{print $7}')
swarm_port=2377
swarm_leader=192.168.31.88:2377

# Install docker
rpm -qa | grep ${docker_rpm} &> /dev/null
if [ $? != 0 ] ; then
    yum -y install ${download_url}/${docker_rpm}.rpm
fi

echo -e  "\033[33m请输入当前容器节点的角色(leader or worker):\033[0m"
read swarm_node

# Modify daemon.json

if [ -e /etc/docker/daemon.json ] ; then
    cat /etc/docker/daemon.json | grep ${docker0} &> /dev/null
    if [ $? != 0 ] ; then
        sed -i "s@172.17.0.1/16@${docker0}@g" /etc/docker/daemon.json
    fi
fi

systemctl daemon-reload
systemctl enable docker
systemctl restart docker

# docker swarm
# docker swarm init
docker version
if [ $? = 0 ] ; then
    docker network ls | grep docker_gwbridge &> /dev/null
    if [ $? != 0 ] ; then
        docker network create \
          --driver bridge \
          --scope local \
          --subnet=${docker_gwbridge} \
          --gateway=${docker_gw} \
          -o com.docker.network.bridge.enable_icc=false \
          -o com.docker.network.bridge.enable_ip_masquerade=true \
          -o com.docker.network.bridge.name=docker_gwbridge docker_gwbridge
    fi
fi

case $swarm_node in
    leader)
        docker node ls | grep `hostname` &> /dev/null
        if [ $? != 0 ] ; then
            docker swarm init \
              --advertise-addr ${swarm_interface_addr} \
              --listen-addr ${swarm_interface_addr}:${swarm_port}
        fi
    ;;
    worker)
        echo -e "\033[33m请输入加入集群的token：\033[0m"
        read join_token
        docker swarm join --token $join_token $swarm_leader
    ;;
    *)
        echo -e "\033[31m参数错误\033[0m"
    ;;
esac
