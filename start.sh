#!/bin/bash

_ddd_dir=$(dirname $BASH_SOURCE)

ddd () {
  # TODO: replace with URL to git repo
  docker build -t ddd _ddd_dir
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
  sleep 5
  if (( which xdg-open ))
  then
    xdg-open "https://localhost:8080?secret=$secret"
  else
    echo "Please visit https://localhost:8080?secret=$secret"
  fi
}
