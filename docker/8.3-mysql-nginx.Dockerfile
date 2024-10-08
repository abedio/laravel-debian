FROM ghcr.io/abedio/php-debian:8.3-mysql-nginx

COPY fs/etc/supervisor/conf.d/worker.conf /etc/supervisor/conf.d/

RUN rm -rf /var/www/html && \
	ln -s /var/www/public /var/www/html && \
	echo "* * * * * /usr/local/bin/php  /var/www/artisan schedule:run > /dev/null 2>&1" > /etc/crontab
