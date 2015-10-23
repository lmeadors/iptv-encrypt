#!/bin/bash
if [ -z "$1" ]; then
  echo "missing xml file"
else
  # UAT WIDEVINE CREDENTIALS/URL
  #KEY_URL="https://license.uat.widevine.com/cenc/getcontentkey/dilloniptvpartners"
  #AES_KEY="48ad182b975cbe3cea2305368643a945b8d654ba03d2359da045b940bc22abce"
  #AES_IV="aeac630e021cb56ad1bd0f1cc6ae58a1"

  # PRODUCTION WIDEVINE CREDENTIALS/URL
  KEY_URL="https://license.widevine.com/cenc/getcontentkey/dilloniptvpartners"
  AES_KEY="1678a4d15bda7fc4e812ce7eed535d97df31a1a1c3b12752c5d367e6ccc2d0e2"
  AES_IV="998c0a0ae89246acb514ac4c572f5b21"

  # use greadlink on OSX; readlink on linux
  VIDEO_SOURCE=`readlink -e $1`
  VIDEO_SOURCE_DIR=`dirname $VIDEO_SOURCE`
  PARENT=`echo -n "$VIDEO_SOURCE" | awk -F/ '{print $(NF-1)}'`
  TIMESTAMP=`date +%s`
  OUTPUT_ROOT=`readlink -e dash`

  echo "VIDEO_SOURCE:     $VIDEO_SOURCE"
  echo "VIDEO_SOURCE_DIR: $VIDEO_SOURCE_DIR"
  echo "PARENT:           $PARENT"
  echo "TIMESTAMP:        $TIMESTAMP"
  echo "OUTPUT_ROOT:      $OUTPUT_ROOT"

  VIDEO_TYPES=("movie" "preview")
  for VIDEO_TYPE in ${VIDEO_TYPES[@]}; do

    echo "---"
    # These are based on the input
    MOVIE_FILES=`xsltproc extract_$VIDEO_TYPE.xsl $VIDEO_SOURCE | sort`

    if [ -n "$MOVIE_FILES" ]; then

      echo "Creating package for type '$VIDEO_TYPE'"

      CONTENT_ID=`echo -n $TIMESTAMP$PARENT$VIDEO_TYPE | xxd -p | md5sum | awk '{print $1}'`
      echo "CONTENT_ID:       $CONTENT_ID ($TIMESTAMP$PARENT$VIDEO_TYPE)"
      echo -n "KEYS:             "
      IO_SEGMENT=""
      for FILE_PATH in $MOVIE_FILES; do

        KEY=`echo -n "$FILE_PATH" | awk -F/ '{print $NF}' | awk -F. '{print $1}'`
        echo -n "$KEY "

        OUT_AUDIO="$OUTPUT_ROOT/$PARENT/$KEY-audio-enc.mp4"
        OUT_VIDEO="$OUTPUT_ROOT/$PARENT/$KEY-video-enc.mp4"
        IO_SEGMENT="$IO_SEGMENT input=$VIDEO_SOURCE_DIR/$FILE_PATH,stream=video,output=$OUT_VIDEO"
        IO_SEGMENT="$IO_SEGMENT input=$VIDEO_SOURCE_DIR/$FILE_PATH,stream=audio,output=$OUT_AUDIO"

      done
  
      echo ""

      echo mkdir -p "$OUTPUT_ROOT/$PARENT"

      echo packager $IO_SEGMENT \
        --enable_widevine_encryption \
        --key_server_url "$KEY_URL" \
        --content_id "$CONTENT_ID" \
        --signer "dilloniptvpartners" \
        --aes_signing_key "$AES_KEY" \
        --aes_signing_iv "$AES_IV" \
        --crypto_period_duration 0 \
        --mpd_output "$OUTPUT_ROOT/$PARENT/manifest-$VIDEO_TYPE.mpd"

    else
      echo "No files found for type '$VIDEO_TYPE'"
    fi

  done

fi

