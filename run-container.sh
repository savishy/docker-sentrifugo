#!/bin/bash
docker run -d --name sentrifugo-db -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -d -p 8080:8080 --name sentrifugo-app --link sentrifugo-db:sentrifugo-db docker-sentrifugo
