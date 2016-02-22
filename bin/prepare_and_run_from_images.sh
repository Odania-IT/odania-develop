#!/usr/bin/env bash
ln -s docker-compose.d/from_image.yml docker-compose.yml

docker-compose pull
docker-compose up
