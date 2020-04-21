#! /bin/bash
# Swoole-compiler loader install wizard

# Color
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Output Logo
echo    ""
echo    "+-------------------------------------------------------------------+"
echo -e "|                   ${RED}Swoole Compiler Loader Installer${NC}                |"
echo    "+-------------------------------------------------------------------+"
echo    "|                     version 1.0.3 (2018-03-15)                    |"                 
echo    "+-------------------------------------------------------------------+"
echo    ""

# The function which outputs help information
help(){
    echo " "
    echo -e " ${YELLOW}Usage :${NC} bash $0 [options] [arguments]"
    echo " "
    echo -e " ${YELLOW}Options :${NC} "
    echo " -h --help       Show the help of swoole compiler loader"
	echo " -s --libsodium  Install libsodium library"
    echo " "
    echo -e " ${YELLOW}Optional Arguments :${NC} "
    echo " php_path : the absolute path of php-cli or php-fpm executable path"
    echo " "
    echo -e " ${YELLOW}Examples : ${NC}"
    echo " bash $0"
    echo " bash $0 /usr/local/sbin/php-fpm"
	echo " base $0 -s"
    echo " "
}
# The function which outputs choice
yes_or_no(){
	if [ $# -eq 0 ]; then 
		echo -e " ${RED}Error:${NC}"
		echo " Wrong function parameter"
		echo ""
		exit 1;
	fi
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
			* ) echo "Please answer yes or no." ;;
        esac
    done
}

# The function which judges the execute ability of the php_path
check_php(){
	if [ $# -eq 0 ]; then 
		echo -e " ${RED}Error:${NC}"
		echo " Wrong function parameter"
		echo ""
		exit 1;
	fi
	check_php_path="$1";
	which "$check_php_path" &> /dev/null;
	check_php_path_exist=$?;
	if [ "$check_php_path_exist" == "0" ]; then
		check_php_path=$(which "$check_php_path")
		if [ -x "$check_php_path" ]; then
			return 0;
		else
			return 1;
		fi
	else 
		return 1;
	fi
}

# The function which installs the libsodium libray
install_libsodium(){
	back_libsodium_path="./libsodium.so"
	if [ ! -e "$back_libsodium_path" ]; then
		echo ""
		echo -e " ${RED}Error:${NC}"
		echo " Not found backed libsodium.so, please check the loader folder"
		echo ""
		exit 1;
	fi
	ldconfig
	libsodium_exists=$(ldconfig -p | awk '/libsodium/')
	if [ -n "$libsodium_exists" ]; then
		echo " libsodium.so      : found"
	else 
		echo " libsodium.so      : not found"
		echo -e "   ${YELLOW}install libsodium.so...${NC}"
	fi
	enabled_so_path="/usr/lib"
	cp "$back_libsodium_path" "$enabled_so_path"
	ldconfig
	libSodiumPath="$enabled_so_path/libsodium.so"
	if [ ! -e $libSodiumPath ]; then
		echo ""
		echo -e " ${RED}Error:${NC}"
		echo " No found shared library libsodium.so"
		echo ""
		exit 1;
	fi
	libsodium_exists=$(ldconfig -p | awk '/libsodium/')
	if [ ! -n "$libsodium_exists" ]; then
		echo ""
		echo -e " ${RED}Error:${NC}"
		echo " Fail to install libsodium.so"
		echo ""
		exit 1;
	fi	
}

# The function which checks the root 
check_root(){
	if [[ $EUID -ne 0 ]]; then
		echo ""
		echo -e " ${RED}This program needs root privilege${NC}"
	    exit 1
	fi
}

# Check the parameter of shell sctipt
if [ "$#" == "1" ] ; then
	if [[ ( "$1" == "-h" ) || ( "$1" == "--help" ) ]] ; then
        help
		exit 1
    fi
	if [[ ( "$1" == "-s" ) || ( "$1" == "--libsodium" ) ]]; then
		# Output checking environment information
		echo " "
		echo -e " ${YELLOW}Install Libsodium...${NC}"
		echo " "
		check_root
		install_libsodium
		echo " "
		exit
	fi
fi

# Output checking environment information
echo " "
echo -e " ${YELLOW}Checking Environment...${NC}"
echo " "

# Check the bin path of php
php_path=""
if [ $# -eq 0 ]; then
	# Check the bin path of php-cli or php-fpm 
	default_optional_php_paths="php php-fpm php5-fpm php-fpm7.0"
	enabled_php_paths=""
	for optional_php_path in $default_optional_php_paths
	do
		check_php "$optional_php_path"
		php_exists=$?
		if [ "$php_exists" == "0" ]; then
			optional_php_path=$(which "$optional_php_path")
			enabled_php_paths=$enabled_php_paths" $optional_php_path"
		fi
	done
	if [ "$enabled_php_paths" == "" ]; then
		echo ""
		echo -e " ${RED}Error:${NC}"
		echo " No found php or php-fpm command, please run this script with the path of php"
		echo ""
		exit 1;
	else
		pathCount=$(echo "$enabled_php_paths" | awk '{print NF}')
  		echo " Please select the php path to install loader extension:"
		echo ""
		indexCount=1
		for enabled_php_path in $enabled_php_paths
		do
			echo " $indexCount : $enabled_php_path"
			indexCount=$(($indexCount + 1))
		done
		echo ""
		echo " 0 :  Quit this script"
    	# Choose the bin path to install loader extension
		while true; do
			preg_str="^[0-$pathCount]$"
			echo ""
  			read -p " Enter a number > ";
  			if [[ $REPLY =~ $preg_str ]]; then
    			if [[ $REPLY == 0 ]]; then
					echo ""
					echo " Exit";
					exit 1;
				fi
				indexCount=1
				for enabled_php_path in $enabled_php_paths
				do
					if [[ $indexCount == $REPLY ]]; then
						php_path=$enabled_php_path
					fi
					indexCount=$(($indexCount + 1))
				done
				break
  			else
				echo ""
  				echo " Invalid input";
  			fi
		done
	fi
elif [ $# -eq 1 ]; then 
	php_path="$1"
	check_php "$1"
	php_exists=$?
	if [ "$php_exists" == "0" ]; then
		php_path=$(which "$php_path")
	else 
		echo -e " ${RED}Error:${NC}"
		echo " Please check if $php_path is existing and executable"
		echo ""
		exit 1;
	fi
else
	echo -e " ${RED}Error:${NC}"
	echo " Please check your parameters, this shell script supports only one optional parameter."
	echo ""
	exit 1;
fi

# Check if installed swoole loader
loader_installed=$($php_path -m 2> /dev/null | awk '/swoole_loader/')
if [ -n "$loader_installed" ]; then
	# check the version of installed swoole loader
	loader_version_installed=$($php_path -i 2> /dev/null | awk '/^swoole_loader version =>/ {print $4}')
	echo -e " ${YELLOW}Swoole Compiler Loader $loader_version_installed is installed now${NC}"
	echo ""
	yes_or_no " Reinstall swoole compiler loader?"
	yes_or_no_res=$?
	if [ "$yes_or_no_res" == "1" ]; then
		echo "";
		echo " Exit script";
		echo "";
		exit 1;
	else
		echo "";
	fi
fi

# Output php path information
echo " php_path          : $php_path"

# Check php version
raw_php_version=$($php_path -i 2> /dev/null | awk 'NR != 2 && /^PHP Version =>/ {print $4}')
php_one_version=$(echo "$raw_php_version" | cut -d . -f 1)
php_two_version=$(echo "$raw_php_version" | cut -d . -f 2)
php_version=$php_one_version.$php_two_version
echo " php_version       : $php_version"

# Check php sapi
php_sapi=$($php_path -i 2> /dev/null | awk '/^Server API =>/ {print $4,$5,$6}')
echo " php_sapi          : $php_sapi"

# Check php thread saftey
php_thread_safety=$($php_path -i 2> /dev/null | awk '/^Thread Safety =>/ {print $4}')
echo " php_thread_safety : $php_thread_safety"

# Check php extension dir
php_extension_dir=$($php_path -i 2> /dev/null | awk '/^extension_dir =>/ {print $3}')
if [ -d "$php_extension_dir" ]; then 
	echo " php_extension_dir : $php_extension_dir"
else 
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " No found php extension directory : $php_extension_dir"
	echo ""
	exit 1;
fi

# Check php extension dir
php_ini_path=$($php_path -i 2> /dev/null | awk '/^Loaded Configuration File =>/ {print $5}')
if [ -f "$php_ini_path" ]; then 
	echo " php_ini_path      : $php_ini_path"
else 
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " No found php.ini file: $php_ini_path"
	echo ""
	exit 1;
fi

# Check xdebug, ioncube loader and zend loader extensions
forbidden_extensions_exists=$($php_path -m 2> /dev/null | awk '/xdebug|ionCube|zend_loader/')
if [ -n "$forbidden_extensions_exists" ]; then
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " It exists xdebug or ionCuber loader or zend_loader extension, please remove these extensions"
	echo ""
	exit 1;
fi

# Ensure root privileges.
check_root

# Check libsodium.so which is required for swoole-compiler loader
install_libsodium

# Install swoole_loader.so to php extension directory
swoole_loader_file="swoole_loader"
swoole_loader_file="$swoole_loader_file""$php_one_version""$php_two_version"
if [ "$php_thread_safety" == "disabled" ]; then
	swoole_loader_file="$swoole_loader_file"".so"
else
	swoole_loader_file="$swoole_loader_file""_zts.so"
fi
real_swoole_loader_path=$php_extension_dir"/"$swoole_loader_file
if [ ! -f "$real_swoole_loader_path" ]; then 
	echo " swoole_loader.so  : not found"
else 
	echo " swoole_loader.so  : found"
fi
swoole_loader_path="./"$swoole_loader_file
if [ -f "$swoole_loader_path" ]; then 
	echo ""
	echo -e " ${YELLOW}installing $swoole_loader_file to php_extension_dir...${NC}"
	cp "$swoole_loader_path" "$php_extension_dir"
	echo ""
else 
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " No found right swoole loader file : $swoole_loader_file"
	echo ""
	exit 1;
fi
real_swoole_loader_path=$php_extension_dir"/"$swoole_loader_file
if [ ! -f "$real_swoole_loader_path" ]; then 
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " No found swoole loader file in php extension dir: $real_swoole_loader_path"
	echo ""
	exit 1;
fi

# Check if exists swoole_loader.so config
raw_ini_loader="extension="$real_swoole_loader_path
ini_loader="$raw_ini_loader"
load_config_exists=$(awk '/swoole_loader/ {print $0}' "$php_ini_path")
if [ -n "$load_config_exists" ]; then
	echo " loader_config     : found"
	sed -i '/swoole_loader/d' "$php_ini_path"
else
	echo " loader_config     : not found"
fi
echo ""
echo -e " ${YELLOW}adding swoole_loader extension config to php.ini...${NC}"
echo "$ini_loader" >> "$php_ini_path"

# Check if installed swoole loader
loader_installed=$($php_path -m 2> /dev/null | awk '/swoole_loader/')
if [ -n "$loader_installed" ]; then
	loader_version_installed=$($php_path -i 2> /dev/null | awk '/^swoole_loader version =>/ {print $4}')
	echo ""
	echo -e " ${YELLOW}Swoole Compiler Loader $loader_version_installed is installed successfully${NC}"
	exit 1;
else
	echo ""
	echo -e " ${RED}Error:${NC}"
	echo " Swoole Compiler Loader failed to install"
	echo ""
	exit 1;
fi
