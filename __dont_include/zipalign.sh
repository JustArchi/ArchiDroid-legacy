#!/bin/bash
for file in `find .. -iname "*.apk" -type f` ; do
	./zipalign -v -f 4 $file TEMP.apk
	mv -f TEMP.apk $file
done
exit 0
