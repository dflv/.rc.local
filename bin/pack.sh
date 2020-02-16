#!/bin/bash

SWITCH=$1
PACK_NAME=$2
FOLDER=$3

if [ "$SWITCH" == "-h" ] || [ "$SWITCH" == "--help" ];
then
    echo "$0:"
    echo "      -c package-name [source-folder]: pack the backup package"
    echo "      -x package-name [target-folder]: unpack the backup package"
    echo "      -h/--help: dump the help info"
fi

if [ "$SWITCH" != "-c" ] && [ "$SWITCH" != "-x" ];
then
    echo "ERROR - invalid parameter \"$1\""
    exit
fi

if [ "$PACK_NAME" == "" ];
then
    echo "ERROR - invalid package name"
    exit
fi

ls "$PACK_NAME" >& /dev/null
if [ "$?" != "0" ];
then
    echo "ERROR - package not found \"$PACK_NAME\""
    exit
fi

if [ "$FOLDER" == "" ];
then
    FOLDER="."
elif [ ! -d "$FOLDER" ];
then
    echo "ERROR - source/target not found \"$FOLDER\""
    exit
fi

if [ "$SWITCH" == "-c" ];
then
    echo "TODO"
fi

if [ "$SWITCH" == "-x" ];
then
    if [ -f $PACK_NAME ];
    then
        DIRECT_PACK_NAME="`realpath $PACK_NAME`"
        # assume it is a tgz package
        RAND="`openssl rand -hex 8`"
        mkdir /tmp/$PACK_NAME"-folder-"$RAND
        pushd /tmp/$PACK_NAME"-folder-"$RAND >& /dev/null
        tar xzf $DIRECT_PACK_NAME
        if [ "$?" != "0" ];
        then
            echo "ERROR - invalid package type \"$PACK_NAME\""
            exit
        fi
        popd >& /dev/null
        PACK_NAME=/tmp/$PACK_NAME"-folder-"$RAND
        TO_BE_DEL=1
    else
        PACK_NAME="`realpath $PACK_NAME`"
        TO_BE_DEL=0
    fi
    # now PACK_NAME is the folder which contains tgz packages
    pushd $FOLDER >& /dev/null
    RAND="`openssl rand -hex 8`"
    LIST_FILE="$PACK_NAME-tgz-list-$RAND"
    # tar xzf *.tgz
    find $PACK_NAME -type f -name "*.tgz" > $LIST_FILE
    while read -r line;
    do
        tar xzf $line
        if [ "$?" != "0" ];
        then
            echo "ERROR - failed to unpack \"$line\""
        fi
    done < $LIST_FILE
    rm -f $LIST_FILE
    # copy the other files
    find $PACK_NAME -type f | grep -v "tgz$" > $LIST_FILE
    while read -r line;
    do
        cp $line .
        FILE="`realpath $line`"
        chmod a-x $FILE
    done < $LIST_FILE
    rm -f $LIST_FILE
    if [ $TO_BE_DEL == "1" ];
    then
        rm -rf $PACK_NAME
    fi
    popd >& /dev/null
fi
