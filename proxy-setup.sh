#!/bin/bash

docker network create nginx-proxy
docker-compose -f nginx-proxy/docker-compose-separate-containers.yml up -d
