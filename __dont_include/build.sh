#!/bin/bash
# ArchiDroid build.sh Helper

WERSJA="ro.build.display.id=ArchiDroid 2.1.2"
OTA="echo \"updateme.version=2.1.2\" >> /system/build.prop"
DENSITY="#ro.sf.lcd_density=320"

function zamien {
	FILEO=wynik.txt
	# $1 co
	# $2 na co
	# $3 plik
	GDZIE=`grep -n "${1}" $3 | cut -f1 -d:`
	ILE=`cat $3 | wc -l`
	ILE=`expr $ILE - $GDZIE`
	GDZIE=`expr $GDZIE - 1`
	cat $3 | head -${GDZIE} > $FILEO
	echo $2 >> $FILEO
	cat $3 | tail -${ILE} >> $FILEO
	cp $FILEO $3
	rm $FILEO
}

cd ..
unzip cm-*.zip -d __newtemasek
rm -Rf system/
cd __newtemasek
for i in `ls` ; do
	if [ $i != "META-INF" ]; then
		cp -R $i ..
	fi
done
cd ..
OLD=`md5sum __dont_include/_updater-scripts/temasek/updater-script | awk '{print $1}'`
NEW=`md5sum __newtemasek/META-INF/com/google/android/updater-script | awk '{print $1}'`

if [ $OLD -ne $NEW ]; then
	echo "Warning! New $NEW does not equal old $OLD."
	echo "Probably just symlink or permissions stuff"
	diff __dont_include/_updater-scripts/temasek/updater-script __newtemasek/META-INF/com/google/android/updater-script
	cp __newtemasek/META-INF/com/google/android/updater-script __dont_include/_updater-scripts/temasek/updater-script
	read -p "Tell me when you're done, master!" -n1 -s
else
	echo "MD5 Sums matches, no further action required, automatic mode goes on..."
fi
sleep 5

cd __dont_include/
# Bo CM tez ma syf...
#rm -rf bloatware/
#mkdir -p bloatware/system/app
#mv ../system/app/CellBroadcastReceiver.apk bloatware/system/app
#TODO uzupelnic syf

##################
### OTA UPDATE ###
FILE=otaold.sh
FILEO=ota.sh
cp ../_archidroid/ota/ota.sh $FILE
GDZIE=`grep -n "updateme.version=" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo $OTA >> $FILEO
ILE=`expr $ILE + 1`
cat $FILE | tail -${ILE} >> $FILEO
cp $FILEO $FILE
rm $FILEO
cp $FILE ../_archidroid/ota/ota.sh
rm $FILE
### OTA UPDATE ###
##################

#########################
### BUILD.PROP UPDATE ###
FILE=buildold.prop
FILEO=build.prop
cp ../system/build.prop $FILE

echo "# ArchiDroid build.prop" >> $FILEO
cat $FILE >> $FILEO
cp $FILEO $FILE
rm $FILEO

GDZIE=`grep -n "ro.sf.lcd_density=320" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo $DENSITY >> $FILEO
cat $FILE | tail -${ILE} >> $FILEO
cp $FILEO $FILE
rm $FILEO

GDZIE=`grep -n "ro.build.display.id=" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo $WERSJA >> $FILEO
cat $FILE | tail -${ILE} >> $FILEO
cp $FILEO $FILE
rm $FILEO

cp $FILE ../system/build.prop
rm $FILE

### BUILD.PROP UPDATE ###
#########################

#################
### BLOATWARE ###
#rm ../system/app/CMUpdater.apk
### BLOATWARE ###
#################

bash openpdroid.sh
exit 0
