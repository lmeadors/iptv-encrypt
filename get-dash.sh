#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MANIFEST_URL=$1
MANIFEST_HOME=`echo $MANIFEST_URL | awk -Fmanifest '{print $1}'`
MANIFEST_FILE=`echo $MANIFEST_URL | awk -F/ '{print $NF}'`
echo wget $MANIFEST_URL
wget $MANIFEST_URL
echo get media files from $MANIFEST_HOME
MEDIA_FILES=`xsltproc --stringparam base_url "$MANIFEST_HOME" $DIR/dash_media.xsl $MANIFEST_FILE`

for MEDIA_FILE in $MEDIA_FILES; do
  echo wget $MEDIA_FILE
  wget $MEDIA_FILE
done