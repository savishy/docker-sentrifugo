This is a Docker image for [Sentrifugo](http://www.sentrifugo.com/), an
open-source HRMS tool.

I am using this as a real world example to learn Docker.

### How to run ###

**Prerequisite**: Download Sentrifugo.zip for Linux. Place it in the root directory.
Name it `Sentrifugo.zip`.

On a fresh start, run `docker-compose up`.

### Implementation ###

* Sentrifugo runs inside an Ubuntu 16.04 Docker Container with PHP 7.0 and Nginx.

#### `sentrifugo-app` ###


1. `sentrifugo-app` is an nginx application container.
   This has `nginx` and `php-fpm`.
1. Sentrifugo is installed to `/sentrifugo/`


#### `sentrifugo-db` ###

2. `sentrifugo-db` is a MySQL database container.
   This is linked to the nginx container as its database.

## Notes ##

### Major Bug

1. Once you proceed through the initial setup steps of Sentrifugo, it is supposed to delete/rename
the `/sentrifugo/install/index.php`. This will make `sentrifugo-url/index.php` actually *execute* instead of redirecting
you to install everytime.

Here's the chunk of code inside index.php:

```
$filepath = 'install/index.php';
if(file_exists($filepath))
{
header("Location: install/index.php");
}else
```

However, the deletion doesn't happen, so you always get redirected to installation.

Therefore, *after you complete initial setup of Sentrifugo*:
1. SSH to the Docker container `sentrifugo-app`.
1. Rename the `/sentrifugo/install/` dir to something else.
1. Verify that going to `<sentrifugo-url>/index.php` takes you to the login page.


### Other
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
