#!/bin/bash
for PLIK in `find optymalizacja/ -type f` ; do
CHECK=`echo $PLIK | grep "**.apk" | wc -l`
if [ $CHECK -ne 1 ]; then
#echo $CHECK
#echo $PLIK
rm $PLIK
fi
done
