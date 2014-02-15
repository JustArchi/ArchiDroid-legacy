#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
	exit 1
fi

AFTERWHAT="$1"
ADDWHAT="$2"
cd ../META-INF/com/google/android/aroma/langs
for FILE in `ls`; do
	LINES=`cat $FILE | wc -l`
	WHERE=`grep -n "$AFTERWHAT" $FILE | cut -f1 -d:`
	cat $FILE | head -${WHERE} > temp.txt
	echo "$ADDWHAT" >> temp.txt
	LINES=`expr $LINES - $WHERE`
	cat $FILE | tail -${LINES} >> temp.txt
	cp temp.txt $FILE
	rm -f temp.txt
done
exit 0