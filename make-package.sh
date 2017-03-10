#!/bin/bash
set -ex

TOP_DIR="/Users/houtanb/Documents/DYNARE/package"
PKG_DIR="$TOP_DIR/macosx"
WORK_DIR="$TOP_DIR/scratch"
LAST_SHA_FILENAME="$TOP_DIR/last_sha.txt"

cd $WORK_DIR
rm -rf dynare-*
wget http://www.dynare.org/snapshot/source/dynare-latest-src.tar.xz
tar zxvf dynare-latest-src.tar.xz

DIR="$(basename dynare-master*)"
DATE=`echo $DIR | cut -d'-' -f3,4,5`
SHA=`echo $DIR | cut -d'-' -f6`
LAST_SHA=`cat $LAST_SHA_FILENAME`
if [ "$SHA" == "$LAST_SHA" ]
then
    exit 0
fi

$TOP_DIR/createOsxFolderForPkg.sh $WORK_DIR $DIR $DATE

echo $SHA > $LAST_SHA_FILENAME

cd $WORK_DIR
zip -r dynare-$DATE-$SHA-osx.zip dynare-$DATE-osx

cd $TOP_DIR
rm -f $PKG_DIR/dynare-latest-osx.zip
cp -f $WORK_DIR/dynare-$DATE-$SHA-osx.zip $PKG_DIR/dynare-latest-osx.zip
mv -f $WORK_DIR/dynare-$DATE-$SHA-osx.zip $PKG_DIR
rm -rf $WORK_DIR/dynare-*
find $PKG_DIR -type f | sort -r | awk 'NR>11' | xargs rm
set +e
`date +%Y-%m-%d`
rsync -v -r -t -e 'ssh -i /Users/houtanb/Documents/DYNARE/package/snapshot-manager_rsa' --delete $PKG_DIR snapshot-manager@kirikou.cepremap.org:/srv/d_kirikou/www.dynare.org/snapshot

