#!/bin/bash

# stop any containers that are running and contain name sentrifugo
containerIds=$(docker ps -q -f "status=running" -f "name=sentrifugo")
for c in $containerIds; do
    echo "--stopping running container $c"
    docker stop $c
done

# remove any containers that are stopped and contain name sentrifugo

containerIds=$(docker ps -q -f "status=exited" -f "name=sentrifugo")
for c in $containerIds; do
    echo "--deleting stopped container $c"
    docker rm $c
done


