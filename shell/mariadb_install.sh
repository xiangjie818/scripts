#!/bin/bash
source_pkg=mariadb-10.2.32.tar.gz
pkgs_url=http://192.168.1.1/sources/apache
install_dir=/usr/local/mysql
datadir=/var/lib/mysql

mkdir -p ${install_dir}
mkdir -p ${datadir}


# 安装依赖包
yum -y install make gcc openssl gcc-c++ openssl-devel  libtool libtool-ltdl  libtool-ltdl-devel expat-devel wget
yum -y install cmake libaio-devel bison bison-devel zlib-devel  openssl openssl-devel  ncurses ncurses-devel libcurl-devel libarchive-devel make


# 创建用户
groupadd -r mysql
useradd -r -g mysql -s /sbin/nologin -d /usr/local/mysql -M mysql

# 下载源码包
wget ${pkgs_url}/${source_pkg}
tar xf $source_pkg

# 编译安装
cd mariadb-10.2.32

cmake . -DCMAKE_INSTALL_PREFIX=${install_dir} \
  -DMYSQL_DATADIR=${datadir} \
  -DSYSCONFDIR=/etc \
  -DWITHOUT_TOKUDB=1 \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_ARCHIVE_STPRAGE_ENGINE=1 \
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
  -DWIYH_READLINE=1 \
  -DWIYH_SSL=system \
  -DWITH_LOBWRAP=0 \
  -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DEXTRA_CHARSETS=all \
  -DMYSQL_TCP_PORT=3306

make -j 4 && make install

# 配置
cd /usr/local/mysql
cp -f support-files/mysql.server /etc/init.d/mysqld
cp -f support-files/my-large.cnf /etc/my.cnf

echo """[mysqld]
datadir = ${datadir}
innodb_file_per_table = on
skip_name_resolve = on""" > /etc/my.cnf.d/mariadb.cnf

/usr/local/mysql/scripts/mysql_install_db --datadir=${datadir} --user=mysql
/etc/init.d/mysqld start
chkconfig mysqld on

cat /etc/profile | grep mysql

if [ $? != 0 ] ; then
   echo "export PATH=$PATH:/usr/local/mysql/bin/" >> /etc/profile
fi

source /etc/profile
mysqladmin -uroot password "123456"
mysql -uroot -p123456 -e "drop database test;"
