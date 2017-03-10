#!/bin/bash
set -ex

PKG_DIR="/Users/houtanb/Documents/DYNARE/package"
LAST_SHA_FILENAME="$PKG_DIR/last_sha.txt"

cd $PKG_DIR
wget http://www.dynare.org/snapshot/source/dynare-latest-src.tar.xz
tar zxvf dynare-latest-src.tar.xz

DIR="$(basename dynare-master*)"
SHA=`echo $DIR | cut -d'-' -f6`
LAST_SHA=`cat $LAST_SHA_FILENAME`
if [ "$SHA" == "$LAST_SHA" ]
then
    exit 0
fi

./createOsxFolderForPkg.sh $PKG_DIR $DIR $DATE

echo $SHA > $LAST_SHA_FILENAME
DATE=`echo $DIR | cut -d'-' -f3,4,5`

cd $PKG_DIR
zip -r dynare-$DATE-$SHA-osx.zip dynare-$DATE-osx
rm -f macosx/dynare-latest-osx.zip
cp dynare-$DATE-$SHA-osx.zip macosx/dynare-latest-osx.zip
mv dynare-$DATE-$SHA-osx.zip macosx
rm -rf dynare-$DATE*
find $PKG_DIR/macosx -type f | sort -r | awk 'NR>11' | xargs rm
set +e
`date +%Y-%m-%d`
rsync -v -r -t -e 'ssh -i /Users/houtanb/Documents/DYNARE/package/snapshot-manager_rsa' --delete $PKG_DIR/macosx snapshot-manager@kirikou.cepremap.org:/srv/d_kirikou/www.dynare.org/snapshot

