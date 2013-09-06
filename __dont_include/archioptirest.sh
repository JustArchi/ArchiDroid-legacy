#!/bin/bash
if [[ "$1" == "pngout" ]]; then
	COMMAND="pngout"
elif [[ "$1" == "optipng" ]]; then
	COMMAND="optipng -o6"
elif [[ "$1" == "pngcrush" ]]; then
	COMMAND="pngcrush -rem alla -reduce -brute -ow"
elif [[ "$1" == "advpng" ]]; then
	COMMAND="advpng -z -4"
else
	echo "No match found"
	exit 1
fi
cd ..
cd TEST
find . -iname "*.png" | while read PNG_FILE ; do
	$COMMAND "$PNG_FILE" &
done
