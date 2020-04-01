FROM php:fpm
ADD ./start.sh /usr/local/etc
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&& echo $TZ > /etc/timezone \
&& sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
&& rm -Rf /var/lib/apt/lists/* \
&& apt-get update \
&& apt-get install -y libmcrypt-dev \
&& pecl install -o -f mcrypt redis \
&& rm -rf /tmp/pear  \
&& docker-php-ext-enable mcrypt redis \
&& docker-php-ext-install pdo_mysql opcache
ENTRYPOINT ["bash", "-c", "/usr/local/etc/start.sh && php-fpm"]
