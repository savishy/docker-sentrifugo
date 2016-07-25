This is a Docker image for [Sentrifugo](http://www.sentrifugo.com/), an
open-source HRMS tool.

I am using this as a real world example to learn Docker.

### References ###

1. Running multiple processes http://stackoverflow.com/a/25150809/682912
2. nginx foreground http://honeyco.nyc/blog/running-nginx-in-the-foreground/
2. php in foreground http://linux.die.net/man/8/php-fpm

### How to run ###

`./run-container.sh`

This will start two containers, one for the app and another for the db. 

### Implementation ###

1. `sentrifugo-app` is an nginx application container.
   This has `nginx` and `php-fpm`. 

2. `sentrifugo-db` is a MySQL database container.
   This is linked to the nginx container as its database.

### Notes ###

1. Here `php-fpm` and `nginx` are started with supervisor.
1. The `supervisord.conf` is a good example of starting multiple processes
   inside a docker container. The processes have to be started *in the
   foreground, to enable supervisor to monitor their start.*
