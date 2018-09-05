# LNMP一键安装包

## 大商创 X 版本环境部署

```
# ---------- ---------- ---------- ----------
#
# 系统要求：x64 位 linux 系统
# PHP版本：
#   php -i |grep Thread > Thread Safety => disabled
#   php -i |grep 'Debug Build' > Debug Build => no
#
# 提示：如有数据盘，请先挂载到 /ecmoban 目录，并且
# 参考步骤：https://help.aliyun.com/document_detail/25426.html
# 
# ---------- ---------- ---------- ----------

cd /usr/local/src

wget https://github.com/dscmall/lnmp/archive/v1.5.1.tar.gz -cO lnmp1.5.tar.gz && tar zxf lnmp1.5.tar.gz
chmod -R +x lnmp-1.5.1/
cd lnmp-1.5.1 && LNMP_Auto="y" DBSelect="2" DB_Root_Password="dscmall1@#" InstallInnodb="y" PHPSelect="7" SelectMalloc="1" ./install.sh lnmp

cd ./loader && ./swoole-compiler-loader.sh

```
