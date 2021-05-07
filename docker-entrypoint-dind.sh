#!/usr/bin/env bash

if [ -e /var/run/docker.sock ]; then
  setfacl -m u:1000:rw /var/run/docker.sock
fi

if [ -n "$DOCKERHUB_USER" ] && [ -n "$DOCKERHUB_PASS" ]; then
  SETTINGS_TPL='/tmp/settings.xml.j2'
  SETTINGS_FILE=$HOME'/.m2/settings.xml'
  chown -v jenkins:jenkins $HOME
  gosu jenkins mkdir $HOME/.m2
  gosu jenkins j2 "$SETTINGS_TPL" > $SETTINGS_FILE
  docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASS
fi


exec /docker-entrypoint.sh "$@"
