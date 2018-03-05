#!/bin/bash
set -ex

DATE=`date +%Y-%m-%d`
TOP_DIR="/Users/houtanb/Documents/DYNARE/package"
PKG_DIR="$TOP_DIR/macosx"
WORK_DIR="$TOP_DIR/scratch"
LAST_SHA_FILENAME="$TOP_DIR/last_sha.txt"

rm -f $TOP_DIR/package.log
rm -f $TOP_DIR/package.err.log

if [ ! -d $WORK_DIR ]; then
    mkdir $WORK_DIR
fi

if [ ! -f $LAST_SHA_FILENAME ]; then
    touch $LAST_SHA_FILENAME
fi

cd $WORK_DIR
rm -rf dynare-*
wget http://www.dynare.org/snapshot/source/dynare-latest-src.tar.xz
tar zxvf dynare-latest-src.tar.xz

DIR="$(basename dynare-4*)"
VER=`echo $DIR | cut -d'-' -f2,3`
SHA=`echo $DIR | cut -d'-' -f4`
LAST_SHA=`cat $LAST_SHA_FILENAME`

if [ "$SHA" == "$LAST_SHA" ]
then
    exit 0
fi

SHORTSHA=`echo $SHA | cut -c1-7`
FINALBASENAME=dynare-$VER-$DATE-$SHORTSHA-osx

$TOP_DIR/createOsxFolderForPkg.sh $WORK_DIR $DIR $FINALBASENAME

echo $SHA > $LAST_SHA_FILENAME

cd $WORK_DIR
zip -r $FINALBASENAME.zip $FINALBASENAME

cd $TOP_DIR
rm -f $PKG_DIR/dynare-latest-osx.zip
cp -f $WORK_DIR/$FINALBASENAME.zip $PKG_DIR/dynare-latest-osx.zip
mv -f $WORK_DIR/$FINALBASENAME.zip $PKG_DIR
rm -rf $WORK_DIR/dynare-*
find $PKG_DIR -type f | sort -r | awk 'NR>11' | xargs rm

# create SHAs
cd $PKG_DIR
rm -f MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS
cd $TOP_DIR
$TOP_DIR/createshas.sh

set +e
`date +%Y-%m-%d`
rsync -v -r -t -e 'ssh -i /Users/houtanb/Documents/DYNARE/package/snapshot-manager_rsa' --delete $PKG_DIR snapshot-manager@kirikou.cepremap.org:/srv/d_kirikou/www.dynare.org/snapshot
echo "Done building $FINALBASENAME.zip"
