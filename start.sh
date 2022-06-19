#!/bin/bash

_ddd_dir=$(dirname $BASH_SOURCE)

ddd () {
  # TODO: replace with URL to git repo
  #docker build -t ddd _ddd_dir
  local secret=$(xxd -c 32 -p -l 16 /dev/random)
  echo "SECRET=$secret"
  docker run \
    --rm \
    --detach \
    --name ddd \
    --volume $(pwd):/home/user/project \
    --build-arg USERID=$(id -u) \
    --env PASSWORD=$secret \
    -p 8080:8080 \
    ddd
  sleep 5
  local host=$(hostname -I | awk '{print $1}')
  if ! curl -k https://$host:8080;
  then
    host="localhost"
  fi
  if which xdg-open >/dev/null;
  then
    xdg-open "https://$host:8080?password=$secret"
  else
    echo "Please visit https://$host:8080?password=$secret"
  fi
}
