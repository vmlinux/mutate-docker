#!/bin/bash
docker ps -a | grep 'Exited' | grep "$*" | awk '{print $1}' | xargs docker rm
