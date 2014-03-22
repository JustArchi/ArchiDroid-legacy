#!/bin/bash
# Archi's cleaning script

rm -rf bloatware
mkdir -p bloatware/system/app > /dev/null 2>&1
cat clean.txt | while read line; do
	if [ -z $line ]; then
		continue
	elif [ ! -z `echo "$line" | grep "/"` ]; then
		# Full path
		if [ ! -e ../..$line ]; then
			continue
		fi
		dir=`dirname $line`
		mkdir -p bloatware$dir
		mv ../..$line bloatware$dir/ > /dev/null 2>&1
	else
		# No path
		extension=`echo $line | awk -F"." '{print $NF}'`
		case "$extension" in
			"apk")
				dir="/system/app"
				;;
			"so")
				dir="/system/lib"
				;;
			*)
				echo "Error $line"
				# Assume apk
				dir="/system/app"
		esac
		if [ `echo $line | grep '*' | wc -l` -eq 0 ]; then
			if [ ! -e ../..$dir/$line ]; then
				continue
			fi
		fi
		mkdir -p bloatware$dir
		mv ../..$dir/$line bloatware$dir/ > /dev/null 2>&1
	fi
done

cat delete.txt | while read line; do
	if [ -z $line ]; then
		continue
	elif [ ! -z `echo "$line" | grep "/"` ]; then
		# Full path
		if [ ! -e ../..$line ]; then
			continue
		fi
		dir=`dirname $line`
		rm -rf ../..$line
	else
		# No path
		extension=`echo $line | awk -F"." '{print $NF}'`
		case "$extension" in
			"apk")
				dir="/system/app"
				;;
			"so")
				dir="/system/lib"
				;;
			*)
				echo "Error $line"
				# Assume apk
				dir="/system/app"
		esac
		if [ `echo $line | grep '*' | wc -l` -eq 0 ]; then
			if [ ! -e ../..$dir/$line ]; then
				continue
			fi
		fi
		rm -f ../..$dir/$line
	fi
done

for f in $(find ../../_archidroid/auto/system/csc -type d -name "app"); do rm -rf $f; done
for f in $(find ../../_archidroid/auto/system/csc -type d -name "csc_contents"); do rm -rf $f; done
for f in $(find ../../_archidroid/auto/system/csc -type d -name "etc"); do rm -rf $f; done
for f in $(find ../../_archidroid/auto/system/csc -type d -name "lib"); do rm -rf $f; done
for f in $(find ../../_archidroid/auto/system/csc -type d -name "media"); do rm -rf $f; done

exit 0
