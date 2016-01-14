#!/bin/bash
docker ps | grep "$*" | awk '{print $1}' | xargs docker kill
