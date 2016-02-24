#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

ln -sf $DIR/config/config.dev.yml $DIR/config/config.yml
ln -sf $DIR/docker-compose.d/build.yml $DIR/docker-compose.yml

$DIR/bin/run.rb git checkout
