#!/bin/bash
# Musze to w koncu doprowadzic do lepszej formy
# Najlepiej juz dzis
# I jeszcze multithreading by sie przydal bo slaba wydajnosc :\
# I verbose wylaczyc dla lepszej wydajnosci
# O i jeszcze do archidroida jako runonce zaplikowac

# OPTIPNG
# PNG CRUSH
# SOX
# ZIPALIGN
# TODO: Sqlite Vacuum

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
	find ./place-apk-here-to-batch-optimize/original -iname "*.png" | while read PNG_FILE ;
		do
		if [ `echo "$PNG_FILE" | grep -c "\.9\.png$"` -eq 0 ] ; then
			optipng -o99 "$PNG_FILE"
			pngcrush -rem alla -reduce -brute "$PNG_FILE" tmp_img_file.png;
			mv -f tmp_img_file.png $PNG_FILE;
		fi
	done;
	find ./place-apk-here-to-batch-optimize/original -iname "*.ogg" | while read OGG_FILE ;
		do
        	sox "$OGG_FILE" -C 0 tmp_audio_file.ogg
        	mv -f tmp_audio_file.ogg $OGG_FILE
    	done;
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
