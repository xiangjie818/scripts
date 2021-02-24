#!/bin/bash
REPO_NET=rsync://mirrors.tuna.tsinghua.edu.cn/centos/7
REPO_DIR=/mnt/e/repo


rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/ /media/zxj/zxj/repo/centos/7/os/x86_64/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/extras/x86_64/ /media/zxj/zxj/repo/centos/7/extras/x86_64/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/updates/x86_64/ /media/zxj/zxj/repo/centos/7/updates/x86_64/
rsync -vrtP --delete --bwlimit=3000 --exclude=debug/ rsync://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64/ /media/zxj/zxj/repo/epel/

#rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-nautilus/el7/noarch  /media/zxj/zxj/repo/ceph/rpm-nautilus/el7/
#rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-nautilus/el7/x86_64  /media/zxj/zxj/repo/ceph/rpm-nautilus/el7/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-luminous/el7/noarch  /media/zxj/zxj/repo/ceph/rpm-luminous/el7/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-luminous/el7/x86_64  /media/zxj/zxj/repo/ceph/rpm-luminous/el7/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-jewel/el7/noarch  /media/zxj/zxj/repo/ceph/rpm-jewel/el7/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/ceph/rpm-jewel/el7/x86_64  /media/zxj/zxj/repo/ceph/rpm-jewel/el7/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/storage/x86_64/ceph-jewel/ /media/zxj/zxj/repo/ceph/ceph-jewel/
rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/storage/x86_64/ceph-luminous/ /media/zxj/zxj/repo/ceph/ceph-luminous/
#rsync -vrtP --delete rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/cloud/x86_64/openstack-queens/ /media/zxj/zxj/repo/openstack/openstack-queens/
