#!/bin/sh

DIST='https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/1.0.1/funkwhale-1.0.1.tar.bz2'
LOCAL='./funkwhale-front'
TMP=$LOCAL'_tmp'

rm -rf $TMP && mkdir $TMP
cd $TMP
curl $DIST | tar xj
mv funkwhale-*/front/* . && rm -rf funkwhale-*
sed -i 's/!\/bin\/bash/!\/run\/current-system\/sw\/bin\/bash/' scripts/*.sh
sed -i 's/scripts\/fix-fomantic/python scripts\/fix-fomantic/' scripts/fix-fomantic-css.sh
yarn
yarn build
cd ..
mv $TMP/dist $LOCAL
rm -rf $TMP
git add $LOCAL
