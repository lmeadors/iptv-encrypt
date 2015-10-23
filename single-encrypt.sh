#!/bin/bash
if [ -z "$1" ]; then
  echo "missing path"
else
FILE_PATH=`readlink -e $1`
TIMESTAMP=`date +%s`
OUTPUT_ROOT=`readlink -e dash`
echo "FILE_PATH:   $FILE_PATH"
echo "TIMESTAMP:   $TIMESTAMP"
echo "OUTPUT_ROOT: $OUTPUT_ROOT"

# These are based on the input
KEY=`echo -n "$FILE_PATH" | awk -F/ '{print $NF}' | awk -F. '{print $1}'`
PARENT=`echo -n "$FILE_PATH" | awk -F/ '{print $(NF-1)}'`
CONTENT_ID=`echo -n $TIMESTAMP$KEY | xxd -p`
echo "KEY:         $KEY"
echo "PARENT:      $PARENT"
echo "CONTENT_ID:  $CONTENT_ID"

OUT_AUDIO="$OUTPUT_ROOT/$PARENT/$KEY-audio-enc.mp4"
OUT_VIDEO="$OUTPUT_ROOT/$PARENT/$KEY-video-enc.mp4"

# WV TEST CREDENTIALS
#KEY_URL="https://license.uat.widevine.com/cenc/getcontentkey/widevine_test"
#AES_KEY="1ae8ccd0e7985cc0b6203a55855a1034afc252980e970ca90e5202689f947ab9"
#AES_IV="d58ce954203b7c9a9a9d467f59839249"
#SIGNER="widevine_test"

# UAT WIDEVINE CREDENTIALS/URL
KEY_URL="https://license.uat.widevine.com/cenc/getcontentkey/dilloniptvpartners"
AES_KEY="48ad182b975cbe3cea2305368643a945b8d654ba03d2359da045b940bc22abce"
AES_IV="aeac630e021cb56ad1bd0f1cc6ae58a1"
SIGNER="dilloniptvpartners"

# PRODUCTION WIDEVINE CREDENTIALS/URL
#KEY_URL="https://license.widevine.com/cenc/getcontentkey/dilloniptvpartners"
#AES_KEY="1678a4d15bda7fc4e812ce7eed535d97df31a1a1c3b12752c5d367e6ccc2d0e2"
#AES_IV="998c0a0ae89246acb514ac4c572f5b21"
#SIGNER="dilloniptvpartners"

mkdir -p "$OUTPUT_ROOT/$PARENT"

packager \
	input=$FILE_PATH,stream=video,output=$OUT_VIDEO \
	input=$FILE_PATH,stream=audio,output=$OUT_AUDIO \
	--enable_widevine_encryption \
	--key_server_url "$KEY_URL" \
	--content_id "$CONTENT_ID" \
	--signer "$SIGNER" \
	--aes_signing_key "$AES_KEY" \
	--aes_signing_iv "$AES_IV" \
	--crypto_period_duration 0 \
	--mpd_output "$OUTPUT_ROOT/$PARENT/manifest.mpd"
fi

