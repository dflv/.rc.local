#!/bin/bash

ARCH=arm64
FILES_TO_INDEX=ag.files

rm -f cscope.* tags
echo "gen index ..."
find ./arch/$ARCH -name "*.[hcS]" > /tmp/$FILES_TO_INDEX
mv ./arch /tmp
find . -name "*.[hcS]" >> /tmp/$FILES_TO_INDEX
cat /tmp/$FILES_TO_INDEX | sort > /tmp/$FILES_TO_INDEX.2
cat /tmp/$FILES_TO_INDEX.2 | \
        grep -v "Documentation" | \
        grep -v "\./dbg" >> /tmp/$FILES_TO_INDEX.3
cp -f /tmp/$FILES_TO_INDEX.3 ./$FILES_TO_INDEX
rm -f /tmp/$FILES_TO_INDEX*
mv /tmp/arch .
echo "run index ..."
cscope -Rkb -i./$FILES_TO_INDEX >& /dev/null &
ctags -L ./$FILES_TO_INDEX >& /dev/null &
wait
