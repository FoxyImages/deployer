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
    - "127.0.0.1:8092:6001"
  links:
    - redis
redis:
  container_name: deployer-redis
  image: redis:latest
  restart: always
```

Env variables `APP_KEY` and `JWT_SECRET` will be generated if not given.

Default user after installation is `admin@example.com` and password is `password`.

## Sample nginx config that will act like proxy to container

```
server {
    listen       80;
    server_name  deployer.domain.tld;
    return       301 https://$server_name$request_uri;
}

server {
    listen       443 ssl http2;
    server_name  deployer.domain.tld;

    include /etc/nginx/ssl/ssl_settings;

    location /socket.io {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:8092;
    }

    location / {
        proxy_pass http://127.0.0.1:8091;
        include proxy_params;
    }
}
```

## Inspecting deployer

To look around in the image, run:

    docker run --rm -t -i sunfoxcz/deployer:<VERSION> /sbin/my_init -- bash -l

where `<VERSION>` is [one of the deployer version numbers](https://github.com/sunfoxcz/docker-deployer/blob/master/ChangeLog.md).

You don't have to download anything manually. The above command will automatically pull the baseimage-docker image from the Docker registry.
