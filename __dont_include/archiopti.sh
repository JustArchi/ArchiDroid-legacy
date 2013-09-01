#!/bin/bash
# Optimized by Archi
# Many thanks to all contributors, especially batch optimize developers

# 1 - Limit all jobs to $LIMITCOUNTER to provide UI responsiveness and less overhead
# 0 - FULL SAIL AHEAD. Nobody cares about UI responsiveness, finish as fast as possible!
IFLIMIT=0

# Use only one of that. Make sure your system is able to use below commands
IFPNGOUT=1 # pngout
IFOPTIPNG=0 # optipng
IFPNGCRUSH=0 # pngcrush

# Don't change values below unless you know what you're doing
LIMITCOUNTER=$((`nproc`-1)) # Set limit to number of cpu threads minus one to ensure that we have at least one thread able to handle system tasks
ILE=0

cd ..
cd TEST
rm -rf ./_work/*
mkdir -p ./_work/original
find . -iname "*.apk" | while read APK_FILE ;
do
	7za x -o"./_work/original" $APK_FILE
	ILE=0
	if [ $IFPNGOUT -eq 1 ] ; then
		find ./_work/original -iname "*.png" | while read PNG_FILE ; do
			if [ $IFLIMIT -eq 1 ]; then
				while [ $ILE -ge $LIMITCOUNTER ] ; do
					sleep 1
					ILE=`ps aux | grep [p]ngout | wc -l`
				done
			fi
			#optipng -o6 "$PNG_FILE" > /dev/null 2>&1 &
			pngout "$PNG_FILE" &
			ILE=`ps aux | grep [p]ngout | wc -l`
		done;

		ILE=`ps aux | grep [p]ngout | wc -l`

		while [ $ILE -ge 1 ] ; do
			sleep 1
			ILE=`ps aux | grep [p]ngout | wc -l`
		done
	fi
	if [ $IFOPTIPNG -eq 1 ] ; then
		find ./_work/original -iname "*.png" | while read PNG_FILE ; do
			if [ $IFLIMIT -eq 1 ]; then
				while [ $ILE -ge $LIMITCOUNTER ] ; do
					sleep 1
					ILE=`ps aux | grep [o]ptipng | wc -l`
				done
			fi
			#optipng -o6 "$PNG_FILE" > /dev/null 2>&1 &
			optipng -o6 "$PNG_FILE" &
			ILE=`ps aux | grep [o]ptipng | wc -l`
		done;

		ILE=`ps aux | grep [o]ptipng | wc -l`

		while [ $ILE -ge 1 ] ; do
			sleep 1
			ILE=`ps aux | grep [o]ptipng | wc -l`
		done
	fi
	if [ $IFPNGCRUSH -eq 1 ] ; then
		find ./_work/original -iname "*.png" | while read PNG_FILE ; do
			if [ $IFLIMIT -eq 1 ]; then
				while [ $ILE -ge $LIMITCOUNTER ] ; do
					sleep 1
					ILE=`ps aux | grep [p]ngcrush | wc -l`
				done
			fi
				#pngcrush -rem alla -reduce -brute -ow "$PNG_FILE" > /dev/null 2>&1 &
				pngcrush -rem alla -reduce -brute -ow "$PNG_FILE" &
				ILE=`ps aux | grep [p]ngcrush | wc -l`
		done;

		ILE=`ps aux | grep [p]ngcrush | wc -l`

		while [ $ILE -ge 1 ] ; do
			sleep 1
			ILE=`ps aux | grep [p]ngcrush | wc -l`
		done
	fi

	7za a -tzip "./_work/temp.zip" ./_work/original/* -mx9
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
