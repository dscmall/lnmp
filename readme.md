# 部署

#### 介绍

大商创 X 版本支持一键部署运行环境。LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RHEL/Fedora/Aliyun/Amazon、Debian/Ubuntu/Raspbian/Deepin/Mint Linux VPS或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序。

#### 软件架构

支持自定义Nginx、PHP编译参数及网站和数据库目录、支持生成LetseEcrypt证书、LNMP模式支持多PHP版本、支持单独安装Nginx/MySQL/MariaDB/Pureftpd服务器，同时提供一些实用的辅助工具如：虚拟主机管理、FTP用户管理、Nginx、MySQL/MariaDB、PHP的升级、常用缓存组件Redis/Xcache等的安装、重置MySQL root密码、502自动重启、日志切割、SSH防护DenyHosts/Fail2Ban、备份等许多实用脚本。

#### 数据盘挂载（可选）

如有数据盘，请先挂载到 /ecmoban 目录，如数据盘已有数据，进行格式化操作前请做好相应备份。参考步骤：https://help.aliyun.com/document_detail/25426.html

#### 一键安装 LNMP 环境教程

安装前确认已经安装基本工具（wget、git、screen）

- 使用 `yum install -y git` 命令安装 git。 
- 使用 `yum install -y screen` 命令安装 screen。 
- 使用 `yum install -y wget` 命令安装 wget。 

1、安装准备

为防止掉线等情况，建议使用screen，可以先执行：

```
screen -S lnmp
```

安装过程如断线可使用 `screen -r lnmp` 恢复。

2、执行LNMP安装命令

```
cd /usr/local/src && git clone https://gitee.com/dscmall/lnmp.git && cd lnmp && chmod -R +x ../lnmp/ && LNMP_Auto="y" DBSelect="3" DB_Root_Password="root123aA" InstallInnodb="y" PHPSelect="7" SelectMalloc="1" ./install.sh lnmp
```

```
提示如下 说明安装完毕 

Install lnmp V1.6 completed! enjoy it.
```

3、安装 swoole loader 扩展

- 执行安装脚本，确保当前位置是在 /usr/local/src/lnmp/ 下，然后执行如下命令 可以用 `pwd` 查看 当前所在目录

```
cd ./loader && ./install.sh && /etc/init.d/nginx reload

会出现提示  Please select the php path to install loader extension:

1 : /usr/bin/php
2 : /usr/bin/php-fpm

选择 1 然后回车即可 
```

4、修改 mysql 的 root 用户密码

访问：[http://ip/pma](http://ip/pma)，使用 root 用户登录后，请立即修改初始密码（`root123aA`）。

5、LNMP添加、删除虚拟主机及伪静态[使用教程](https://lnmp.org/faq/lnmp-vhost-add-howto.html)
