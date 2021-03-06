# 部署

#### 介绍

大商创 X 版本支持一键部署运行环境。[LNMP一键安装包](https://lnmp.org) 是一个用Linux Shell编写的可以为CentOS/RHEL/Fedora/Aliyun/Amazon、Debian/Ubuntu/Raspbian/Deepin/Mint Linux VPS或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序。

#### 数据盘挂载（可选）

如有数据盘，请先挂载到 /ecmoban 目录，如数据盘已有数据，操作前请做好相应备份。参考步骤：https://help.aliyun.com/document_detail/25426.html

#### 环境准备

以 **CentOS** 为例，安装前确认已经安装基本工具

- 使用  命令安装 git、screen、wget 命令。 

```
yum install git screen wget -y
```

为防止掉线等情况，建议使用screen，执行：

```
screen -S lnmp
```

安装过程如断线可使用 `screen -r lnmp` 恢复。

#### 安装 LNMP 环境

1、执行LNMP安装命令

- 下载安装脚本

```
cd /usr/local/src && git clone https://gitee.com/dscmall/lnmp.git && cd lnmp && chmod -R +x ../lnmp/
```

- 执行安装脚本（注意 *PHPSelect* 参数的差异）

php 7.1

```
LNMP_Auto="y" DBSelect="4" DB_Root_Password="p12345678A" InstallInnodb="y" PHPSelect="7" SelectMalloc="1" ./install.sh lnmp
```

php 7.2

```
LNMP_Auto="y" DBSelect="4" DB_Root_Password="p12345678A" InstallInnodb="y" PHPSelect="8" SelectMalloc="1" ./install.sh lnmp
```

提示如下 说明安装完毕 

```
Install lnmp completed! enjoy it.
```

2、安装 swoole loader 扩展

执行安装脚本，确保当前位置是在 /usr/local/src/lnmp/ 下，然后执行如下命令 可以用 `pwd` 查看 当前所在目录

```
# php 7.1 扩展安装目录
cd ./loader/1.9 
# php 7.2 扩展安装目录
cd ./loader/2.2 
```

- 执行安装

```
./install.sh && /etc/init.d/nginx reload
```

会出现提示

```
Please select the php path to install loader extension:

1 : /usr/bin/php
2 : /usr/bin/php-fpm
```

选择 1 然后回车即可，安装完成之后，

- 检查安装状态

```
php --ri swoole_loader
```

安装成功后会出现如下提示

```
[root@centos dscmall]# php --ri swoole_loader

swoole_loader

swoole_loader support => enabled
swoole_loader version => 2.2.0
```

3、>>> **【重要安全提示】** <<< 请立即修改 mysql 的 root 用户密码

访问：[http://ip/pma](http://ip/pma)，使用 root 用户登录后，请立即修改初始密码（`p12345678A`）。

#### 其他

LNMP添加、删除虚拟主机及伪静态[使用教程](https://lnmp.org/faq/lnmp-vhost-add-howto.html)
