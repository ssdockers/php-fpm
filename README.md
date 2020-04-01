# use env to config php-fpm

```shell script
docker run --name php -d --restart=always -e fpm_ext_zz_docker__listen=/tmp/php/sock -v /tmp/php:/tmp/php ssdockers/php-fpm:0.1
```

### -e ini_OPTION=VALUE for set php.ini

for example

```
-e ini_short_open_tag=On
-e ini_session__use_cookies=0
```

if OPTION has ".", must use "__"

### -e ini_ext_EXTNAME__OPTION=VALUE for set php.ini

for example

```
-e ini_ext_pdo_mysql__extension=pdo_mysql.so
```

divide EXTNAME and OPTION must use "__"


### -e fpm_OPTION=VALUE for set php-fpm.conf

for example

```
-e fpm_include=etc/php-fpm.d/*.conf
```


### -e fpm_ext_EXTNAME__OPTION=VALUE for set php.ini

for example

```
-e fpm_ext_zz_docker__listen=/tmp/php.sock
```

if EXTFILE is php-fpm.d/zz-docker.conf，just use zz_docker for EXTNAME is ok
