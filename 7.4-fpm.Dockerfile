FROM ghcr.io/itsmattius/php-debian:7.4-fpm

COPY .docker/etc/supervisor/conf.d/worker.conf /etc/supervisor/conf.d/

RUN rm -rf /var/www/html && \
	ln -s /var/www/public /var/www/html && \
	echo "* * * * * /usr/local/bin/php  /var/www/artisan schedule:run > /dev/null 2>&1" > /etc/crontab
