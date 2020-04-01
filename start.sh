#!/bin/bash

cd `dirname $0`
cp -f php/php.ini-production php/php.ini

sed_tag=""
sed_flag="$sed_flag"
if [ `uname` = 'Darwin' ];then
    sed_tag=".bak"
    sed_flag="g"
fi

replace()
{
    v=$3
    # echo "grep -c -E \"^\s*$2\s*=\s*.*$\" $1"
    if [[ `grep -c -E "^\s*$2\s*=\s*.*$" $1` = "0" ]]; then
        echo "$2 = $v" >> $1
    fi
    # echo "sed -i $sed_tag -E \"s#^([[:blank:]]*)$2([[:blank:]]*)=([[:blank:]]*).*\$#\\1$2\\2=\\3$v#$sed_flag\" $1"
    sed -i $sed_tag -E "s#^([[:blank:]]*)$2([[:blank:]]*)=([[:blank:]]*).*\$#\\1$2\\2=\\3$v#$sed_flag" $1
}

echo `date '+%Y-%m-%d %H:%M:%S'`"    config php/php.ini"
env | grep -i ^INI_ | while read -r a
do
    a=${a:4}
    k=`echo "${a%%=*}" | sed 's/__/./g'`
    if [[ `echo "$k" | grep -c -i -E ^EXT_` == "1" ]]; then
        continue
    fi
    v=${a#*=}
	echo `date '+%Y-%m-%d %H:%M:%S'`"	  - replace $k to [$v]"
    replace php/php.ini "$k" "$v"
done

echo `date '+%Y-%m-%d %H:%M:%S'`"   config php/conf.d"
env | grep -i ^INI_EXT_ | while read -r a
do
    a=${a:8}
    tmpk=${a%%=*}
    v=${a#*=}
    f=${tmpk%%__*}
    k=${tmpk#*__}
    k=`echo "$k" | sed 's/___/-/g'`
    k=`echo "$k" | sed 's/__/./g'`
    echo `date '+%Y-%m-%d %H:%M:%S'`"     - replace $f / $k to [$v]"
    replace "php/conf.d/docker-php-ext-${f}.ini" "$k" "$v"
done

echo `date '+%Y-%m-%d %H:%M:%S'`"   config php-fpm.conf"
env | grep -i ^FPM_ | while read -r a
do
    a=${a:4}
    k=`echo "${a%%=*}" | sed 's/__/./g'`
    if [[ `echo "$k" | grep -c -i -E ^EXT_` == "1" ]]; then
        continue
    fi
    v=${a#*=}
    echo `date '+%Y-%m-%d %H:%M:%S'`"     - replace $k to [$v]"
    replace php-fpm.conf "$k" "$v"
done

echo `date '+%Y-%m-%d %H:%M:%S'`"   config php-fpm.d"
env | grep -i ^FPM_EXT_ | while read -r a
do
    a=${a:8}
    tmpk=${a%%=*}
    v=${a#*=}
    f="php-fpm.d/${tmpk%%__*}.conf"
    f1=`echo "php-fpm.d/${tmpk%%__*}.conf" | sed 's/_/-/g'`
    if [[ ! -f $f && -f $f1 ]];then
        f=$f1
    fi
    k=${tmpk#*__}
    k=`echo "$k" | sed 's/___/-/g'`
    k=`echo "$k" | sed 's/__/./g'`
    echo `date '+%Y-%m-%d %H:%M:%S'`"     - replace $f / $k to [$v]"
    replace "$f" "$k" "$v"
done
