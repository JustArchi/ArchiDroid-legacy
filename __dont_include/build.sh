#!/bin/bash
# ArchiDroid build.sh Helper

WERSJA="ro.build.display.id=ArchiDroid 2.0.3"
OTA="echo \"updateme.version=2.0.3\" >> /system/build.prop"
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

# Bo CM tez ma syf...
rm -rf bloatware/
mkdir -p bloatware/system/app
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
rm ../system/app/CMUpdater.apk
### BLOATWARE ###
#################
exit 0
