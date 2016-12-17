# Deployer docker image

[Deployer](https://github.com/REBELinBLUE/deployer) is a PHP Application deployment system powered by Laravel 5.2,
written & maintained by Stephen Ball.

## Sample `docker-compose.yml`

```yml
deployer:
  container_name: deployer
  image: sunfoxcz/deployer:0.1.4
  environment:
    - TZ=Europe/Prague
    - APP_DEBUG=true
    - APP_LOG=syslog
    - APP_KEY=base64:xxx
    - APP_URL=https://deployer.domain.tld
    - APP_TIMEZONE=Europe/Prague
    - JWT_SECRET=xxx
    - SOCKET_URL=https://deployer.domain.tld
    - REDIS_HOST=redis
    - REDIS_PORT=6379
    - REDIS_DATABASE=0
    - DB_TYPE=mysql
    - DB_HOST=mysql.domain.tld
    - DB_DATABASE=deployer
    - DB_USERNAME=deployer
    - DB_PASSWORD=xxx
    - MAIL_FROM_ADDRESS=deployer@domain.tld
  ports:
    - "127.0.0.1:8091:80"
  links:
    - redis
redis:
  container_name: deployer-redis
  image: redis:latest
  restart: always
```

Env variables `APP_KEY` and `JWT_SECRET` will be generated if not given.

Default user after installation is `admin@example.com` and password is `password`.

## Inspecting deployer

To look around in the image, run:

    docker run --rm -t -i sunfoxcz/deployer:<VERSION> /sbin/my_init -- bash -l

where `<VERSION>` is [one of the deployer version numbers](https://github.com/sunfoxcz/docker-deployer/blob/master/ChangeLog.md).

You don't have to download anything manually. The above command will automatically pull the baseimage-docker image from the Docker registry.
