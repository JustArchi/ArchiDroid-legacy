#!/bin/bash
# Archi's cleaning script, only for me, not needed for rom or aroma
# Also probably won't work on Android because of egrep ;)

# This script (re)moves bloatware defined in clean.txt from ARHD Rom
# It shouldn't be used by normal users but if you know what you're doing
# then sure you can execute it yourself (using any basic linux with egrep)
# on basically any rom and even your own settings.

# However don't expect any support because it's made to work "just for me"
# and as long as it works then I won't add or implement any unnecessary
# functions or other modifications. It's simple, makes my work faster and that's it.

mkdir -p bloatware/system/app > /dev/null 2>&1
cat clean.txt | grep "\.apk" | while read line; do
mv ../../system/app/$line bloatware/system/app/ > /dev/null 2>&1
done

mkdir -p bloatware/system/lib > /dev/null 2>&1
cat clean.txt | grep "\.so" | while read line; do
mv ../..$line bloatware/system/lib/ > /dev/null 2>&1
done

cat clean.txt | grep "\/system\/" | while read line; do
line2=`echo $line | egrep -o '^[^:]*/'`
mkdir -p bloatware$line2 > /dev/null 2>&1
mv ../..$line bloatware$line2/ > /dev/null 2>&1
done

exit 0
