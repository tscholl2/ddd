#!/bin/bash

ddd () {
  # TODO: replace with URL to git repo
  docker build -t ddd -f Dockerfile $(dirname $BASH_SOURCE)
  local secret=$(xxd -c 32 -p -l 16 /dev/random)
  echo "SECRET="
  echo $secret
  docker run \
    --rm \
    --detach \
    --name ddd \
    --volume $(pwd):/home/user/project \
    --env PASSWORD=$secret \
    -p 8080:8080 \
    ddd
  sleep 5 && xdg-open "https://localhost:8080?secret=$secret"
}
