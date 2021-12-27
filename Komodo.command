#!/bin/bash

xhost +localhost
docker run --rm -v $HOME:/data -e DISPLAY=host.docker.internal:0 unicornsonlsd/kmd

if [ $? == 125 ]
then
    open -a docker
    docker run --rm -v $HOME:/data -e DISPLAY=host.docker.internal:0 unicornsonlsd/kmd
    
    while [ $? == 125 ]
    do
        docker run --rm -v $HOME:/data -e DISPLAY=host.docker.internal:0 unicornsonlsd/kmd
    done
fi
