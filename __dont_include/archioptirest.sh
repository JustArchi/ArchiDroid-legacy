#!/bin/bash
cd ..
cd TEST
find . -iname "*.png" | while read PNG_FILE ; do
	pngout "$PNG_FILE" &
done
