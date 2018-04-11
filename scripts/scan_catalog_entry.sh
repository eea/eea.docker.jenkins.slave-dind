#!/bin/bash

set -e

GIT_ORG=${GIT_ORG:-"eea"}
RANCHER_CATALOG_GITNAME=${RANCHER_CATALOG_PATH:-"eea.rancher.catalog"}

CLAIR_URL=${CLAIR_URL:-"http://clair:6060"}

RANCHER_CATALOG_PATH=${RANCHER_CATALOG_PATH:-$1}
EXCLUDE_IMAGES=${EXCLUDE_IMAGES:-$2}

if [ -z "$RANCHER_CATALOG_PATH" ] ; then
   echo "Problem with script, missing catalog path parameter"
   exit 1
fi


RANCHER_CATALOG_GITSRC=https://github.com/${GIT_ORG}/${RANCHER_CATALOG_GITNAME}.git
current_dir=$(pwd)

LOCATION=$(pwd)

# clone the repo
git clone $RANCHER_CATALOG_GITSRC

cd $RANCHER_CATALOG_GITNAME/$RANCHER_CATALOG_PATH

# get latest rancher entry


old_version=$(grep version config.yml | awk 'BEGIN{FS="\""}{print $2}')

lastdir=$(grep -l "version: \"$old_version\"" */rancher-compose.yml | awk 'BEGIN{FS="/"}{print $1}')

if [ -z "$EXCLUDE_IMAGES" ]; then
   EXCLUDE_IMAGES="^( )*rancher/[^:]+$"
else
   EXCLUDE_IMAGES=$(sed 's/,/|/g' <<< $EXCLUDE_IMAGES)
   EXCLUDE_IMAGES=$(sed 's/ /|/g' <<< $EXCLUDE_IMAGES)
   EXCLUDE_IMAGES="^( )*rancher/[^:]+$|"$EXCLUDE_IMAGES
fi


echo "Found current rancher catalog entry for $RANCHER_CATALOG_PATH - $lastdir"
echo "Will extract images, with the following regex exclusions: '$EXCLUDE_IMAGES'"

all_images=$(grep image: $lastdir/docker-compose* |   cut -d: -f2,3  | sort | uniq  | grep -vE "$EXCLUDE_IMAGES" )

echo "Will start scanning the following images:"
echo "$all_images"

cd $LOCATION
rm -rf  $RANCHER_CATALOG_GITNAME


for image in $all_images; do
  docker pull $image
  TMPDIR=`pwd` clair-scanner --ip=`hostname` --clair=$CLAIR_URL -t=Critical --all=false  $image
  docker rmi $image || true
done

echo "Finished scanning"
