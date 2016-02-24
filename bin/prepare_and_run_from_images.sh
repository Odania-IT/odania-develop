#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

ln -s $DIR/docker-compose.d/from_image.yml $DIR/docker-compose.yml

docker-compose pull
docker-compose up
