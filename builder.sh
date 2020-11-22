#!/bin/sh

TAG_NAME=kindle_wine
USER_NAME=wine

sudo docker build  -t $TAG_NAME .

mkdir -p ./$USER_NAME
sudo chown -R 1001:1001 ./$USER_NAME
