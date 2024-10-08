# Laravel Alpine
Laravel PHP Framework running on debian base Docker Image with Nginx 🐳

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/abedio/laravel-debian/ci.yml?style=for-the-badge)
[![LICENSE](https://img.shields.io/github/license/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/blob/master/LICENSE)
[![Stars Count](https://img.shields.io/github/stars/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/stargazers)
[![Forks Count](https://img.shields.io/github/forks/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/network/members)
[![Watchers Count](https://img.shields.io/github/watchers/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/watchers)
[![Issues Count](https://img.shields.io/github/issues/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/issues)
[![Pull Request Count](https://img.shields.io/github/issues-pr/abedio/laravel-debian.svg?style=for-the-badge)](https://github.com/abedio/laravel-debian/pulls)
[![Follow](https://img.shields.io/github/followers/dnj.svg?style=for-the-badge&label=Follow&maxAge=2592000)](https://github.com/dnj)

## Pull it from Github Registry
To pull the docker image:
```bash
docker pull ghcr.io/abedio/laravel-debian:8.3-mysql-nginx
```

## Usage
To run from current dir
```bash
docker run -v $(pwd):/var/www -p 80:80 ghcr.io/abedio/laravel-debian:8.3-mysql-nginx "composer install --prefer-dist"
```

## What's Included
 - [Composer](https://getcomposer.org/) ( v2 - updated )
 - CRON
 - [Supervisor](http://supervisord.org) 

## Other Details
- Debian base image

## PHP Extension
- opcache
- mysqli
- pdo 
- pdo_mysql
- sockets
- json
- intl
- gd
- xml
- zip
- exif
- bz2
- pcntl
- gmp
- bcmath
- inotify
- redis
- memcached
- soap
- ssh2

## Adding other PHP Extension
You can add additional PHP Extensions by running `docker-ext-install` command. Don't forget to install necessary dependencies for required extension.
```bash
FROM ghcr.io/abedio/laravel-debian:8.1-mysql-nginx
RUN docker-php-ext-install xdebug
```

## Adding CRON
```bash
FROM ghcr.io/abedio/laravel-debian:8.1-mysql-nginx
echo '0 * * ? * * /usr/local/bin/php  /var/www/artisan package:command >> /dev/null 2>&1' > /etc/crontab
```
 
## Adding custom Supervisor config
 You can add your own Supervisor config inside `/etc/supervisor/conf.d/` for Laravel Queue or Laravel Horizon. File extension needs to be `*.conf`. By default this image added `worker` process in supervisor. 

E.g: For Laravel Horizon make file `horizon.conf`
```ini
[program:horizon]
process_name=%(program_name)s
command=php /var/www/artisan horizon
autostart=true
autorestart=true
user=forge
redirect_stderr=true
stdout_logfile=/var/log/laravel-horizon.log
```
On your Docker image
```bash
FROM ghcr.io/abedio/laravel-debian:8.3-mysql-nginx
COPY horizon.conf /etc/supervisor/conf.d/
```
For more details on config http://supervisord.org/configuration.html


## Bug Reporting

If you find any bugs, please report it by submitting an issue on our [issue page](https://github.com/abedio/laravel-debian/issues) with a detailed explanation. Giving some screenshots would also be very helpful.

## Feature Request

You can also submit a feature request on our [issue page](https://github.com/abedio/laravel-debian/issues) or [discussions](https://github.com/abedio/laravel-debian/discussions) and I will try to implement it as soon as possible.

