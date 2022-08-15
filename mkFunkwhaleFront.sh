#!/bin/sh

# Obsolete. We don't compile front assets ourselves, we use the pre-compiled package from the funkwhale ci server

FUNKWHALE_VERSION="1.2.7"

LOCAL='./funkwhale-front'
TMP=$LOCAL'_tmp'

rm -rf $TMP && mkdir $TMP
cd $TMP

DIST="https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/$FUNKWHALE_VERSION/funkwhale-$FUNKWHALE_VERSION.tar.bz2"
curl $DIST | tar xj
mv funkwhale-*/front/* . && rm -rf funkwhale-*
sed -i 's/scripts\/fix-fomantic/python scripts\/fix-fomantic/' scripts/fix-fomantic-css.sh
yarn
yarn build

cd ..
mv $TMP/dist $LOCAL
rm -rf $TMP
git add $LOCAL
