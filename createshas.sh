#!/bin/sh

create_checksum_file()
{
    FILES=`ls *.zip`

    md5 -r $FILES > MD5SUMS
    shasum $FILES > SHA1SUMS
    shasum -a256 $FILES > SHA256SUMS
    shasum -a512 $FILES > SHA512SUMS
}

cd /Users/houtanb/Documents/DYNARE/package/macosx
create_checksum_file
