#!/bin/bash
set -e
source /build/buildconfig
set -x

$minimal_apt_get_install beanstalkd npm nodejs nodejs-legacy git rsync supervisor

mkdir /var/www/.ssh
ssh-keyscan -t rsa bitbucket.org >> /var/www/.ssh/known_hosts
ssh-keyscan -t rsa github.com >> /var/www/.ssh/known_hosts

cp /build/config/supervisor.conf /etc/supervisor/conf.d/deployer.conf

cd /var/www
chown www-data:root .
composer create-project rebelinblue/deployer deployer --no-dev

cd /var/www/deployer
cp /build/config/deployer.env .env
chmod -R 777 bootstrap/cache
chmod -R 777 storage/app/mirrors
chmod -R 777 storage/app/public
chmod -R 777 storage/app/tmp
chmod -R 777 storage
npm install --production
sed "s,var app = require('https').*;,var app = require('http').createServer(handler);,g" -i socket.js
echo "* * * * * php /var/www/deployer/artisan schedule:run 1>> /dev/null 2>&1" >> /etc/crontab

rm /etc/nginx/sites.d/default
cp /build/config/nginx-site.conf /etc/nginx/sites.d/deployer
rm /etc/php/7.0/fpm/pool.d/www.conf
cp /build/config/php-pool.conf /etc/php/7.0/fpm/pool.d/deployer.conf

mkdir /etc/service/beanstalkd
mkdir /etc/service/supervisord
cp /build/init/beanstalkd /etc/service/beanstalkd/run
cp /build/init/supervisord /etc/service/supervisord/run
cp /build/bin/deployer /usr/local/bin/deployer
