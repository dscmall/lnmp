# 部署

#### 介绍

大商创 X 版本支持一键部署运行环境。LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RHEL/Fedora/Aliyun/Amazon、Debian/Ubuntu/Raspbian/Deepin/Mint Linux VPS或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序。

#### 软件架构

支持自定义Nginx、PHP编译参数及网站和数据库目录、支持生成LetseEcrypt证书、LNMP模式支持多PHP版本、支持单独安装Nginx/MySQL/MariaDB/Pureftpd服务器，同时提供一些实用的辅助工具如：虚拟主机管理、FTP用户管理、Nginx、MySQL/MariaDB、PHP的升级、常用缓存组件Redis/Xcache等的安装、重置MySQL root密码、502自动重启、日志切割、SSH防护DenyHosts/Fail2Ban、备份等许多实用脚本。

#### 数据盘挂载（可选）

如有数据盘，请先挂载到 /ecmoban 目录，如数据盘已有数据，进行格式化操作前请做好相应备份。参考步骤：https://help.aliyun.com/document_detail/25426.html

#### 一键安装 LNMP 环境教程

安装前确认已经安装基本工具（wget、git、screen）

- 使用  命令安装 git、screen、wget 命令。 

```
yum install -y git screen wget
```

1、安装准备

为防止掉线等情况，建议使用screen，可以先执行：

```
screen -S lnmp
```

安装过程如断线可使用 `screen -r lnmp` 恢复。

2、执行LNMP安装命令

- 下载安装脚本

```
cd /usr/local/src && git clone https://gitee.com/dscmall/lnmp.git && cd lnmp && chmod -R +x ../lnmp/
```

- 执行安装脚本（注意 *PHPSelect* 参数的差异）

php 7.1

```
LNMP_Auto="y" DBSelect="4" DB_Root_Password="123456zZ" InstallInnodb="y" PHPSelect="7" SelectMalloc="1" ./install.sh lnmp
```

php 7.2

```
LNMP_Auto="y" DBSelect="4" DB_Root_Password="123456zZ" InstallInnodb="y" PHPSelect="8" SelectMalloc="1" ./install.sh lnmp
```

提示如下 说明安装完毕 

```
Install lnmp completed! enjoy it.
```

3、安装 swoole 扩展（可选）

```
./addons.sh swoole
```

4、安装 swoole loader 扩展

执行安装脚本，确保当前位置是在 /usr/local/src/lnmp/ 下，然后执行如下命令 可以用 `pwd` 查看 当前所在目录

```
# php 7.1 扩展目录
cd ./loader/1.9 
# php 7.2 扩展目录
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

选择 1 然后回车即可 

5、**【注意】** 请立即修改 mysql 的 root 用户密码

访问：[http://ip/pma](http://ip/pma)，使用 root 用户登录后，请立即修改初始密码（`123456zZ`）。

6、LNMP添加、删除虚拟主机及伪静态[使用教程](https://lnmp.org/faq/lnmp-vhost-add-howto.html)

## 常用功能说明

**以下操作需在lnmp安装包目录下执行，如lnmp**

### 自定义参数
lnmp.conf配置文件，可以修改lnmp.conf自定义下载服务器地址、网站/数据库目录及添加nginx模块和php编译参数；不论安装升级都会调用该文件里的设置(如果修改了默认的参数建议备份此文件)；

### FTP服务器
执行：`./pureftpd.sh` 安装，可使用 `lnmp ftp {add|list|del}` 进行管理。

### 升级脚本：
执行：`./upgrade.sh` 按提示进行选择
也可以直接带参数：`./upgrade.sh {nginx|mysql|mariadb|php|phpa|m2m|phpmyadmin}`
* 参数: nginx   可升级至任意Nginx版本。
* 参数: mysql   可升级至任意MySQL版本，MySQL升级风险较大，虽然会自动备份数据，依然建议自行再备份一下。
* 参数: mariadb 可升级已安装的Mariadb，虽然会自动备份数据，依然建议自行再备份一下。
* 参数: m2m     可从MySQL升级至Mariadb，虽然会自动备份数据，依然建议自行再备份一下。
* 参数: php     仅适用于LNMP，可升级至大部分PHP版本。
* 参数: phpa    可升级LNMPA/LAMP的PHP至大部分版本。
* 参数: mphp    多PHP版本升级工具，只支持7.2.x-7.2.x类似小版本升级，大版本直接新装即可；
* 参数: phpmyadmin    可升级phpMyadmin。

### 扩展插件
执行: `./addons.sh {install|uninstall} {eaccelerator|xcache|memcached|opcache|redis|apcu|imagemagick|ioncube}`
以下为扩展插件安装使用说明
#### 缓存加速：
* 参数: xcache 安装时需选择版本和设置密码，http://yourIP/xcache/ 进行管理，用户名 admin，密码为安装xcache时设置的。
* 参数: redis  安装redis
* 参数: memcached 可选择php-memcache或php-memcached扩展。
* 参数: opcache 可访问 http://yourIP/ocp.php 进行管理。
* 参数: eaccelerator 安装。
* 参数: apcu 安装apcu php扩展，支持php7，可访问 http://yourIP/apc.php 进行管理。 
**请勿安装多个缓存类扩展模块，多个可能导致网站出现问题 ！**

#### 图像处理：
* imageMagick安装卸载执行：`./addons.sh {install|uninstall} imageMagick` imageMagick路径：/usr/local/imagemagick/bin/。

#### 解密：
* IonCube安装执行：`./addons.sh {install|uninstall} ionCube`。

#### 其他常用脚本：
* 可选1，多PHP版本安装执行：`./install.sh mphp` 可以安装多个PHP版本 ，只支持LNMP模式，lnmp vhost add时进行选择或使用时需要将nginx虚拟主机配置文件里的include enable-php.conf替换为 include enable-php5.6.conf 即可前面的5.6换成你刚才安装的PHP的大版本号5.* 或7.0之类的。
* 可选2，数据库安装执行：`./install.sh db` 可以直接单独安装MySQL或MariaDB数据库。
* 可选3，Nginx安装执行：`./install.sh nginx`可以直接单独安装Nginx。
**以下工具在lnmp安装包tools目录下**可拷贝到其他目录下运行
* 可选4，执行：`./reset_mysql_root_password.sh` 可重置MySQL/MariaDB的root密码。
* 可选5，执行：`./check502.sh`  可检测php-fpm是否挂掉,502报错时重启，配合crontab使用。
* 可选6，执行：`./cut_nginx_logs.sh` 日志切割脚本。
* 可选7，执行：`./remove_disable_function.sh` 运行此脚本可删掉禁用函数。

### 卸载
* 卸载LNMP、LNMPA或LAMP可执行：`./uninstall.sh` 按提示选择即可卸载。

## 状态管理
* LNMP/LNMPA/LMAP状态管理：`lnmp {start|stop|reload|restart|kill|status}`
* Nginx状态管理：`lnmp nginx或/etc/init.d/nginx {start|stop|reload|restart}`
* MySQL状态管理：`lnmp mysql或/etc/init.d/mysql {start|stop|restart|reload|force-reload|status}`
* MariaDB状态管理：`lnmp mariadb或/etc/init.d/mariadb {start|stop|restart|reload|force-reload|status}`
* PHP-FPM状态管理：`lnmp php-fpm或/etc/init.d/php-fpm {start|stop|quit|restart|reload|logrotate}`
* PureFTPd状态管理：`lnmp pureftpd或/etc/init.d/pureftpd {start|stop|restart|kill|status}`
* Apache状态管理：`lnmp httpd或/etc/init.d/httpd {start|stop|restart|graceful|graceful-stop|configtest|status}`

## 虚拟主机管理
* 添加：`lnmp vhost add`
* 删除：`lnmp vhost del`
* 列出：`lnmp vhost list`
* 数据库管理：`lnmp database {add|list|edit|del}`
* FTP用户管理：`lnmp ftp {add|list|edit|del|show}`
* SSL添加：`lnmp ssl add`
* 通配符/泛域名SSL添加：`lnmp dnsssl {cx|ali|cf|dp|he|gd|aws}` 需依赖域名dns api

## LNMP相关目录文件

### 目录位置
* Nginx：/usr/local/nginx/
* MySQL：/usr/local/mysql/
* MariaDB：/usr/local/mariadb/
* PHP：/usr/local/php/
* 多PHP目录：/usr/local/php5.6/ 版本号随安装版本不同而不同
* PHP扩展插件配置文件目录：/usr/local/php/conf.d/
* PHPMyAdmin：/ecmoban/wwwroot/default/phpmyadmin/
* 默认虚拟主机网站目录：/ecmoban/wwwroot/default/
* Nginx日志目录：/ecmoban/wwwlogs/

### 配置文件：
* Nginx主配置文件：/usr/local/nginx/conf/nginx.conf
* MySQL/MariaDB配置文件：/etc/my.cnf
* PHP配置文件：/usr/local/php/etc/php.ini
* PHP-FPM配置文件：/usr/local/php/etc/php-fpm.conf
* PureFtpd配置文件：/usr/local/pureftpd/etc/pure-ftpd.conf
* Apache配置文件：/usr/local/apache/conf/httpd.conf

### lnmp.conf 配置文件参数说明

| 参数名称 | 参数介绍 | 例子 |
| :-------: | :---------: | :--------: | 
|Download_Mirror|下载镜像|一般默认，如异常可[修改下载镜像](https://lnmp.org/faq/download-url.html)|
|Nginx_Modules_Options|添加Nginx模块或其他编译参数|--add-module=/第三方模块源码目录|
|PHP_Modules_Options|添加PHP模块或编译参数|--enable-exif 有些模块需提前安装好依赖包|
|MySQL_Data_Dir|MySQL数据库目录设置|默认/usr/local/mysql/var|
|MariaDB_Data_Dir|MariaDB数据库目录设置|默认/usr/local/mariadb/var|
|Default_Website_Dir|默认虚拟主机网站目录位置|默认/ecmoban/wwwroot/default|
|Enable_Nginx_Openssl|Nginx是否使用新版openssl|默认 y，建议不修改，y是启用并开启到http2|
|Enable_PHP_Fileinfo|是否安装开启php的fileinfo模块|默认n，根据自己情况而定，安装启用的话改成 y|
|Enable_Nginx_Lua|是否为Nginx安装lua支持|默认n，安装lua可以使用一些基于lua的waf网站防火墙|
|Enable_Swap|是否添加SWAP|默认y，当内存不足时可提高编译安装成功概率|
