# laravel-debian

Opinionated, production-ready Docker images for **Laravel** apps on Debian. Built **on top of [`php-debian`](https://github.com/itsmattius/php-debian)**, these images add the small set of conventions a Laravel app expects: `public/` as the document root, `artisan schedule:run` wired into cron, and a default `queue:work` supervisor program — so you can drop a Laravel project in and run.

## Available tags

Built and published from [`.github/workflows/ci.yml`](.github/workflows/ci.yml) on every push to `main`.

| Tag | Base image |
| --- | --- |
| `7.4-fpm` | `ghcr.io/itsmattius/php-debian:7.4-fpm` |
| `8.1-fpm` | `ghcr.io/itsmattius/php-debian:8.1-fpm` |
| `8.2-fpm` | `ghcr.io/itsmattius/php-debian:8.2-fpm` |
| `8.3-fpm` | `ghcr.io/itsmattius/php-debian:8.3-fpm` |
| `8.4-fpm` | `ghcr.io/itsmattius/php-debian:8.4-fpm` |
| `8.5-fpm` | `ghcr.io/itsmattius/php-debian:8.5-fpm` |

Pull from GHCR:

```bash
docker pull ghcr.io/itsmattius/laravel-debian:8.3-fpm
```

## What it adds on top of `php-debian`

Inherits everything from the base — Nginx, PHP-FPM, Composer, ionCube, Redis, OPcache, supervisord, supercronic — and layers on:

- **Document root → `/var/www/public`.** `/var/www/html` is replaced with a symlink to `/var/www/public`, so Nginx serves your Laravel `public/` directory.
- **Scheduler.** `/etc/crontab` is rewritten to run `php /var/www/artisan schedule:run` every minute under supercronic.
- **Queue worker.** A supervisor program runs `php /var/www/artisan queue:work` as `www-data`, with `autorestart` and `startretries=50`. See [`.docker/etc/supervisor/conf.d/worker.conf`](.docker/etc/supervisor/conf.d/worker.conf).

## Usage

Mount your Laravel project root at `/var/www` (the image symlinks `/var/www/html` → `/var/www/public` for you):

```bash
docker run -d \
  --name myapp \
  -p 8080:80 \
  -v "$PWD":/var/www \
  ghcr.io/itsmattius/laravel-debian:8.3-fpm
```

Or with `compose.yaml`:

```yaml
services:
  app:
    image: ghcr.io/itsmattius/laravel-debian:8.3-fpm
    ports:
      - "8080:80"
    volumes:
      - ./:/var/www
    environment:
      APP_ENV: production
      APP_KEY: base64:...
```

For a typical first run, install dependencies and run migrations:

```bash
docker exec myapp composer install --no-dev --prefer-dist --optimize-autoloader
docker exec myapp php /var/www/artisan migrate --force
```

## Extending the image

Because this image is just a thin layer on top of `php-debian`, you extend it the same way.

### Add a PHP extension

```dockerfile
FROM ghcr.io/itsmattius/laravel-debian:8.3-fpm
RUN docker-php-ext-install pdo_pgsql
```

### Add a supervisor program (e.g. Horizon)

Create `horizon.conf`:

```ini
[program:horizon]
process_name=%(program_name)s
command=php /var/www/artisan horizon
user=www-data
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/log/laravel-horizon.log
```

Drop it into `/etc/supervisor/conf.d/` (any `*.conf` file in that directory is picked up):

```dockerfile
FROM ghcr.io/itsmattius/laravel-debian:8.3-fpm
COPY horizon.conf /etc/supervisor/conf.d/
```

### Add a cron job

`/etc/crontab` is read by [supercronic](https://github.com/aptible/supercronic). Append your own jobs alongside the scheduler:

```dockerfile
FROM ghcr.io/itsmattius/laravel-debian:8.3-fpm
RUN echo '0 * * * * /usr/local/bin/php /var/www/artisan my:hourly-task' >> /etc/crontab
```

## License

[MIT](LICENSE) © Mehdi Abedi
