#!/bin/bash
if [ $# -lt 2 ]; then
	exit 1
fi

cd ../META-INF/com/google/android/aroma/langs
if [ "$1" == "ADD" ]; then
	for FILE in `ls`; do
		LINES=`cat $FILE | wc -l`
		WHERE=`grep -n "$2" $FILE | cut -f1 -d:`
		cat $FILE | head -${WHERE} > temp.txt
		echo "$3" >> temp.txt
		LINES=`expr $LINES - $WHERE`
		cat $FILE | tail -${LINES} >> temp.txt
		cp temp.txt $FILE
		rm -f temp.txt
	done
elif [ "$1" == "DEL" ]; then
	for FILE in `ls`; do
		LINES=`cat $FILE | wc -l`
		WHERE=`grep -n "$2" $FILE | cut -f1 -d:`
		WHERE=`expr $WHERE - 1`
		cat $FILE | head -${WHERE} > temp.txt
		WHERE=`expr $WHERE + 1`
		LINES=`expr $LINES - $WHERE`
		cat $FILE | tail -${LINES} >> temp.txt
		cp temp.txt $FILE
		rm -f temp.txt
	done
fi
exit 0