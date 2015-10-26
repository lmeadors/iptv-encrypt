# initial setup

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install git g++

    mkdir bin
    cd ~/bin/
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    export PATH=$PATH:$HOME/bin/depot_tools

    cd ~/bin/
    mkdir edash-packager
    cd edash-packager/
    gclient config https://github.com/google/edash-packager.git --name=src
    gclient sync
    ninja -C src/out/Release
    export PATH=$PATH:$HOME/bin/edash-packager/src/out/Release

ssh root@89.248.171.141
passwd: qUqWcYGhR5HW

ssh bbhuser@41.202.18.98
passwd: User@middleware*

ssh bbhuser@10.223.40.23
passwd: User@middleware*

## Widevine info

uat url  = https://license.uat.widevine.com/cenc/getcontentkey/dilloniptvpartners
uat key  = 48ad182b975cbe3cea2305368643a945b8d654ba03d2359da045b940bc22abce
uat iv   = aeac630e021cb56ad1bd0f1cc6ae58a1

prod url = https://license.widevine.com/cenc/getcontentkey/dilloniptvpartners
prod key = 1678a4d15bda7fc4e812ce7eed535d97df31a1a1c3b12752c5d367e6ccc2d0e2
prod iv  = 998c0a0ae89246acb514ac4c572f5b21
