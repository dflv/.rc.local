#!/bin/bash

ARCH=$1

if [ "$ARCH" == "" ]; then
    ARCH=arm64
fi

DIR=$2

if [ "$DIR" == "" ]; then
    DIR=.
fi

TMP_FILE_0=/tmp/.tmp.file.to.idx.`openssl rand -hex 8`
TMP_FILE_1=$TMP_FILE_0.001
TMP_FILE_2=$TMP_FILE_0.002
TMP_FILE_3=$TMP_FILE_0.003

pushd $DIR

find . -name "*.[chS]" >& $TMP_FILE_0
cat $TMP_FILE_0 | grep -v "^./arch" >& $TMP_FILE_1
cat $TMP_FILE_0 | grep "^./arch/$ARCH" >& $TMP_FILE_2
cp -f $TMP_FILE_2 $TMP_FILE_3
cat $TMP_FILE_1 >> $TMP_FILE_3

cscope -kb -i$TMP_FILE_3
ctags -L $TMP_FILE_3

rm -f $TMP_FILE*

popd
