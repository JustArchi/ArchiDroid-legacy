#!/bin/bash
# Optimized by Archi
# Many thanks to all contributors, especially batch optimize developers
# Usage: bash archiopti.sh pngout/optipng/pngcrush/advpng

# 1 - Limit all jobs to $LIMITCOUNTER to provide UI responsiveness and less overhead
# 0 - FULL SAIL AHEAD. Nobody cares about UI responsiveness, finish as fast as possible!
IFLIMIT=0

# Don't change values below unless you know what you're doing
LIMITCOUNTER=$((`nproc`-1)) # Set limit to number of cpu threads minus one to ensure that we have at least one thread able to handle system tasks
ILE=0

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

CHECK=`echo $COMMAND | awk '{print $1}' | cut -c 1`
TEMP=`echo $COMMAND | cut -c 2-`
CHECK="[$CHECK]$TEMP"

cd ..
cd TEST
rm -rf ./_work/*
mkdir -p ./_work/original
find . -iname "*.apk" | while read APK_FILE ;
do
	7za x -o"./_work/original" $APK_FILE
	ILE=0
	find ./_work/original -iname "*.png" | while read PNG_FILE ; do
		if [ $IFLIMIT -eq 1 ]; then
			while [ $ILE -ge $LIMITCOUNTER ] ; do
				sleep 1
				ILE=`ps aux | grep "$CHECK ./" | wc -l`
			done
		fi
		$COMMAND "$PNG_FILE" &
		ILE=`ps aux | grep "$CHECK ./" | wc -l`
	done;

		ILE=`ps aux | grep "$CHECK ./" | wc -l`

	while [ $ILE -ge 1 ] ; do
		sleep 1
		ILE=`ps aux | grep "$CHECK ./" | wc -l`
	done

	7za a -tzip "./_work/temp.zip" ./_work/original/* -mx9 '-x!resources.arsc'
	if [ -e ./_work/original/resources.arsc ]; then
		7za a -tzip "./_work/temp.zip" ./_work/original/resources.arsc -mx0
	fi
	mv -f ./_work/temp.zip ./_work/temp.apk
	zipalign -v -c 4 ./_work/temp.apk
	ZIPCHECK=$?;
	if [ ! $ZIPCHECK -eq 0 ]; then
                zipalign -fv 4 ./_work/temp.apk ./_work/temp2.apk
                mv -f ./_work/temp2.apk ./_work/temp.apk
				rm -f ./_work/temp2.apk
	fi;
	mv -f ./_work/temp.apk $APK_FILE
	rm -rf ./_work/original/*
done;
rm -rf ./_work/
exit 0
