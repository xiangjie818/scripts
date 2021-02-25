#!/bin/bash
ARCH=$(arch)
if [ $ARCH = x86_64 ] ; then
    arch=amd64
elif [ $ARCH = aarch64 ] ; then
    arch=arm64
else
    echo "Unsupported system architecture"
fi

base_img=alpine
img_repo=registry.cn-beijing.aliyuncs.com/xtreemfs
echo -e "\033[33m请输入镜像站账号：\033[0m"
read user
echo -e "\033[33m请输入镜像站密码：\033[0m"
read -s passwd

docker login --username=${user} -p ${passwd} registry.cn-beijing.aliyuncs.com
# elasticsearch fluent
docker pull ${img_repo}/elasticsearch:6.7.2-${base_img}-${arch}
docker pull ${img_repo}/fluent:1.12-${arch}

# mariadb
docker pull ${img_repo}/mariadb:10.2-${arch}

# nginx
docker pull ${img_repo}/nginx:1.14.0-${arch}

# kafka zookeeper
docker pull ${img_repo}/kafka:2.12-${base_img}-${arch}
docker pull ${img_repo}/zookeeper:3.6.2-${base_img}-${arch}

# redis
docker pull ${img_repo}/redis:stable-${base_img}-${arch}

# pki
docker pull ${img_repo}/pki:3.0-${arch}

# xtreemfs
docker pull ${img_repo}/xtfs-dir:1.6.0-${base_img}-${arch}
docker pull ${img_repo}/xtfs-mrc:1.6.0-${base_img}-${arch}
docker pull ${img_repo}/xtfs-osd:1.6.0-${base_img}-${arch}

# swirl
#docker pull ${img_repo}/swirl:3.0-${arch}
