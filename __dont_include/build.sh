#!/bin/bash
# ArchiDroid build.sh Helper

# Not Disabled
#exit 1

# From source? Not yet... soon!
SOURCE=0

WERSJA="ro.build.display.id=ArchiDroid 2.1.5"
WERSJA2="ro.archidroid.version=2.2 ALPHA"
OTA="echo \"updateme.version=2.1.5\" >> /system/build.prop"
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

if [ $SOURCE -eq 1 ]; then
	export PATH=${PATH}:/root/bin
	export USE_CCACHE=1
	cd /root/git/android_packages_apps_Settings
	git pull upstream cr-main-10.2
	git merge cr-main-10.2
	if [ $? -ne 0 ]; then
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	cd /root/android/system
	OLD=`md5sum /root/android/system/device/samsung/i9300/proprietary-files.txt | awk '{print $1}'`
	OLD2=`md5sum /root/android/system/device/samsung/smdk4412-common/proprietary-files.txt | awk '{print $1}'`
	#repo selfupdate
	repo sync
	if [ $? -ne 0 ]; then
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	cd /root/android/system/vendor/cm
	./get-prebuilts
	cd /root/android/system
	source build/envsetup.sh
	breakfast i9300
	NEW=`md5sum /root/android/system/device/samsung/i9300/proprietary-files.txt | awk '{print $1}'`
	NEW2=`md5sum /root/android/system/device/samsung/smdk4412-common/proprietary-files.txt | awk '{print $1}'`
	if [ $OLD != $NEW ] || [ $OLD2 != $NEW2 ]; then
		echo "/root/android/system/device/samsung/i9300/proprietary-files.txt" $OLD $NEW
		echo "/root/android/system/device/samsung/smdk4412-common/proprietary-files.txt" $OLD2 $NEW2
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	brunch i9300
	cd $OUT
	cp cm-10.2-*.zip /root/shared/git/ArchiDroid
fi

cd /root/shared/git/ArchiDroid

if [ ! -e cm-*.zip ]; then
	exit 1
fi

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

if [ $OLD != $NEW ]; then
	echo "Warning! New $NEW does not equal old $OLD."
	echo "Probably just symlink or permissions stuff"
	diff __dont_include/_updater-scripts/temasek/updater-script __newtemasek/META-INF/com/google/android/updater-script
	cp __newtemasek/META-INF/com/google/android/updater-script __dont_include/_updater-scripts/temasek/updater-script
	read -p "Tell me when you're done, master!" -n1 -s
else
	echo "MD5 Sums matches, no further action required, automatic mode goes on..."
fi
sleep 3
rm -Rf __newtemasek
#rm -f cm-*.zip

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

if [ $SOURCE -eq 1 ]; then
	GDZIE=`grep -n "ro.modversion" $FILE | cut -f1 -d:`
	ILE=`cat $FILE | wc -l`
	ILE=`expr $ILE - $GDZIE`
	#GDZIE=`expr $GDZIE - 1`
	cat $FILE | head -${GDZIE} > $FILEO
	echo $WERSJA2 >> $FILEO
	cat $FILE | tail -${ILE} >> $FILEO
	cp $FILEO $FILE
	rm $FILEO
fi

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
#rm -f ../system/app/CMUpdater.apk
### BLOATWARE ###
#################

bash openpdroid.sh
if [ $? -ne 0 ]; then
	exit 1
else
	exit 0
fi