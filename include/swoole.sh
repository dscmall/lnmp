 #!/bin/bash

Install_swoole()
{
    echo "====== Installing Swoole ======"
    echo "Install Swoole ${Swoole_Stable_Ver} Stable Version..."
    Press_Start

    Addons_Get_PHP_Ext_Dir
    zend_ext="${zend_ext_dir}swoole.so"
    if [ -s "${zend_ext}" ]; then
        rm -f "${zend_ext}"
        rm -f "${zend_ext_dir}swoole_loader*.so"
    fi

    cd ${cur_dir}/src
    Download_Files https://github.com/swoole/swoole-src/archive/v${Swoole_Stable_Ver}.tar.gz v${Swoole_Stable_Ver}.tar.gz
    Tar_Cd v${Swoole_Stable_Ver}.tar.gz swoole-src-${Swoole_Stable_Ver}

    ${PHP_Path}/bin/phpize
    ./configure --with-php-config=${PHP_Path}/bin/php-config
    Make_Install
    cd ../

    cat >${PHP_Path}/etc/php.ini<<EOF
extension = "swoole.so"
swoole.use_shortname = 'Off'
EOF

    Restart_PHP

    if [ -s "${zend_ext}" ]; then
        Echo_Green "====== Swoole install completed ======"
        Echo_Green "Swoole installed successfully, enjoy it!"
    else
        Echo_Red "Swoole install failed!"
    fi
}

Uninstall_swoole()
{
    echo "You will uninstall Swoole..."
    Press_Start
    # rm -f ${PHP_Path}/etc/php.ini
    Restart_PHP
    echo "Delete Swoole files..."
    Echo_Green "Uninstall Swoole completed."
}
