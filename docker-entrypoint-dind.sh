#!/usr/bin/env bash

if [ ! -z "$DOCKERHUB_USER" ] && [ ! -z "$DOCKERHUB_PASS" ]; then
  SETTINGS_TPL='/tmp/settings.xml.j2'
  SETTINGS_FILE=$HOME'/.m2/settings.xml'
  chown -v jenkins:jenkins $HOME
  gosu jenkins mkdir $HOME/.m2
  gosu jenkins j2 "$SETTINGS_TPL" > $SETTINGS_FILE
fi

exec /docker-entrypoint.sh "$@"
