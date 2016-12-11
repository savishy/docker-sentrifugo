This is a Docker image for [Sentrifugo](http://www.sentrifugo.com/), an
open-source HRMS tool.

I am using this as a real world example to learn Docker.

### How to run ###

**Prerequisite**: Download Sentrifugo.zip for Linux. Place it in the root directory.
Name it `Sentrifugo.zip`.

On a fresh start, run:

```
# this deletes any old containers you may have started previously.
./delete-old-sentrifugo-containers.sh

# This will start two containers, one for the app and another for the db.
./run-container.sh
```

### Implementation ###

* Sentrifugo runs inside an Ubuntu 16.04 Docker Container with PHP 7.0 and Nginx.

#### `sentrifugo-app` ###


1. `sentrifugo-app` is an nginx application container.
   This has `nginx` and `php-fpm`.
1. Sentrifugo is installed to `/sentrifugo/`


#### `sentrifugo-db` ###

2. `sentrifugo-db` is a MySQL database container.
   This is linked to the nginx container as its database.

### Notes ###

1. Here `php-fpm` and `nginx` are started with supervisor.
1. The `supervisord.conf` is a good example of starting multiple processes
   inside a docker container. The processes have to be started *in the
   foreground, to enable supervisor to monitor their start.*

### References ###

1. Running multiple processes http://stackoverflow.com/a/25150809/682912
2. nginx foreground http://honeyco.nyc/blog/running-nginx-in-the-foreground/
2. php in foreground http://linux.die.net/man/8/php-fpm
3. MySQL Container https://hub.docker.com/_/mysql/
4. Good example of supervisord https://github.com/jbfink/docker-wordpress
