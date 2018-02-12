#!/bin/bash
set -ex

VER="4.5.4"
FINALBASENAME=dynare-$VER-osx

TOP_DIR="TOPDIR"
PKG_DIR="$TOP_DIR/macOS"
WORK_DIR="$TOP_DIR/scratch"

if [ ! -d $WORK_DIR ]; then
    mkdir $WORK_DIR
fi

cd $WORK_DIR
rm -rf dynare-*
wget http://www.dynare.org/release/source/dynare-$VER.tar.xz
tar zxvf dynare-$VER.tar.xz

DIR=dynare-$VER

$TOP_DIR/createOsxFolderForPkg.sh $WORK_DIR $DIR $FINALBASENAME
echo "DONE"
cd $WORK_DIR
zip -r $FINALBASENAME.zip $FINALBASENAME

cd $TOP_DIR
mv -f $WORK_DIR/$FINALBASENAME.zip $PKG_DIR/dynare-$VER-osx.zip

set +e
echo `date +%Y-%m-%d`
echo "Done building $FINALBASENAME.zip"
