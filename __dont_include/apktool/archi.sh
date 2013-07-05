#!/bin/bash
# OPTIPNG
# PNG CRUSH
# SOX
# ZIPALIGN
# TODO: Sqlite Vacuum

ILE=0
LICZBA=7
CZYOPTI=1
CZYPNGCRUSH=1
CZYVERBOSE=1

LOG_FILE="apk.log"

if [ \! -f `whereis optipng | cut -f 2 -d ' '` ] ; then
	echo "ERROR: install optipng (apt-get install optipng)"
	exit 1;
fi;
if [ \! -f `whereis pngcrush | cut -f 2 -d ' '` ] ; then
	echo "ERROR: install pngcrush (apt-get install pngcrush)"
	exit 1;
fi;
if [ \! -f `whereis sox | cut -f 2 -d ' '` ] ; then
	echo "ERROR: install sox (apt-get install sox)"
	exit 1;
fi;
if [ \! -f `whereis zipalign | cut -f 2 -d ' '` ] ; then
	echo "ERROR: install zipalign (sudo cp ...android-sdk/android-sdk/zipalign /usr/bin/)"
	exit 1;
fi;

rm -rf ./place-apk-here-to-batch-optimize/original/*
if [ -e $LOG_FILE ]; then
	rm $LOG_FILE;
fi;
touch $LOG_FILE
mkdir -p ./place-apk-here-to-batch-optimize/original
find ./place-apk-here-to-batch-optimize -iname "*.apk" | while read APK_FILE ;
do
	echo "Optimizing $APK_FILE"
	7za x -o"./place-apk-here-to-batch-optimize/original" $APK_FILE
	ILE=0
	if [ $CZYOPTI -eq 1 ] ; then
		find ./place-apk-here-to-batch-optimize/original -iname "*.png" | while read PNG_FILE ; do
			#while [ $ILE -ge $LICZBA ] ; do
			#	sleep 1
			#	ILE=`ps aux | grep [o]ptipng | wc -l`
			#done
			if [ `echo "$PNG_FILE" | grep -c "\.9\.png$"` -eq 0 ] ; then
				#if [ $CZYVERBOSE -eq 1 ] ; then
				#	optipng -o99 "$PNG_FILE" &
				#else
					optipng -o99 "$PNG_FILE" > /dev/null 2>&1 &
				#fi
			fi
			ILE=`ps aux | grep [o]ptipng | wc -l`
		done;

		ILE=`ps aux | grep [o]ptipng | wc -l`

		while [ $ILE -ge 1 ] ; do
			sleep 1
			ILE=`ps aux | grep [o]ptipng | wc -l`
		done
	fi

	if [ $CZYPNGCRUSH -eq 1 ] ; then
		find ./place-apk-here-to-batch-optimize/original -iname "*.png" | while read PNG_FILE ; do
				#while [ $ILE -ge $LICZBA ] ; do
				#        sleep 1
				#        ILE=`ps aux | grep [p]ngcrush | wc -l`
				#done
				if [ `echo "$PNG_FILE" | grep -c "\.9\.png$"` -eq 0 ] ; then
				#	if [ $CZYVERBOSE -eq 1 ] ; then
				#		pngcrush -rem alla -reduce -brute -ow "$PNG_FILE" &
				#	else
                                                pngcrush -rem alla -reduce -brute -ow "$PNG_FILE" > /dev/null 2>&1 &
				#	fi
				fi
				#ILE=`ps aux | grep [p]ngcrush | wc -l`
		done;

		ILE=`ps aux | grep [p]ngcrush | wc -l`

		while [ $ILE -ge 1 ] ; do
			sleep 1
			ILE=`ps aux | grep [p]ngcrush | wc -l`
		done
	fi

	7za a -tzip "./place-apk-here-to-batch-optimize/temp.zip" ./place-apk-here-to-batch-optimize/original/* -mx9
	FILE=`basename "$APK_FILE"`
	DIR=`dirname "$APK_FILE"`
	mv -f ./place-apk-here-to-batch-optimize/temp.zip "$DIR/optimized-$FILE"
	zipalign -v -c 4 "$DIR/optimized-$FILE";
	ZIPCHECK=$?;
	if [ $ZIPCHECK -eq 0 ]; then
		echo "OK $FILE" >> $LOG_FILE;
	else
                #echo "ERROR $FILE" >> $LOG_FILE;
                zipalign -fv 4 "$DIR/optimized-$FILE" "$DIR/optimized2-$FILE";
                mv -f "$DIR/optimized2-$FILE" "$DIR/optimized-$FILE"
                #rm "$DIR/optimized-$FILE"
	fi;
	mv -f "$DIR/optimized-$FILE" "$DIR/$FILE"
	rm -rf ./place-apk-here-to-batch-optimize/original/*
done;
