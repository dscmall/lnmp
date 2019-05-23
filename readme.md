# 部署

#### 介绍

大商创 X 版本支持一键部署运行环境。LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RHEL/Fedora/Aliyun/Amazon、Debian/Ubuntu/Raspbian/Deepin/Mint Linux VPS或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序。

#### 软件架构

支持自定义Nginx、PHP编译参数及网站和数据库目录、支持生成LetseEcrypt证书、LNMP模式支持多PHP版本、支持单独安装Nginx/MySQL/MariaDB/Pureftpd服务器，同时提供一些实用的辅助工具如：虚拟主机管理、FTP用户管理、Nginx、MySQL/MariaDB、PHP的升级、常用缓存组件Redis/Xcache等的安装、重置MySQL root密码、502自动重启、日志切割、SSH防护DenyHosts/Fail2Ban、备份等许多实用脚本。

#### 安装教程

安装前确认已经安装 wget 和 git 命令，如提示wget: command not found ，使用 `yum install -y wget` 或 `apt-get install wget` 命令安装wget,
使用 `yum install -y git` 命令安装 git。 为防止掉线等情况，建议使用screen，可以先执行：screen -S lnmp 命令后，再执行LNMP安装命令。

如断线可使用`screen -r lnmp` 恢复。

**重要提示**

如有数据盘，请先挂载到 /ecmoban 目录，如数据盘已有数据，进行格式化操作前请做好相应备份。参考步骤：https://help.aliyun.com/document_detail/25426.html

1、一键安装 LNMP 环境

```
cd /usr/local/src && git clone https://gitee.com/dscmall/lnmp.git && cd lnmp && chmod -R +x ../lnmp/ && LNMP_Auto="y" DBSelect="2" DB_Root_Password="dscmall!@#456aA" InstallInnodb="y" PHPSelect="7" SelectMalloc="1" ./install.sh lnmp
```

```
提示如下 说明安装完毕 

Install lnmp V1.5 completed! enjoy it.
```

2、安装 swoole loader 扩展

- 执行安装脚本，确保当前位置是在 /usr/local/src/lnmp/ 下，然后执行如下命令 可以用 `pwd` 查看 当前所在目录

```
cd ./loader && ./install.sh && /etc/init.d/nginx reload

会出现提示  Please select the php path to install loader extension:

1 : /usr/bin/php
2 : /usr/bin/php-fpm

选择 1 然后回车即可 

```
- 最后重启下php服务 命令如下

```
/etc/init.d/php-fpm restart

```

3、修改 mysql 的 root 用户密码

访问：[http://ip/phpmyadmin](http://ip/phpmyadmin)，使用 root 用户登录后，请立即修改初始密码（`dscmall!@#456aA`）。