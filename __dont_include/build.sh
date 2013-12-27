#!/bin/bash
# ArchiDroid build.sh Helper

# Not Disabled
#exit 1

# Common
VERSION=1.7.5
STABLE=0
NOSYNC=0
SAMMY=0
NOOPD=0
NOBUILD=0
TEMP=0

for ARG in "$@" ; do
	if [ $TEMP -eq 0 ]; then
		case "$ARG" in
			sammy)
				SAMMY=1
				NOOPD=1
				echo "Building ArchiDroid 1.X!"
				;;
			stable)
				STABLE=1
				echo "WARNING: Building stable release!"
				;;
			nosync)
				NOSYNC=1
				echo "WARNING: Not updating repos!"
				;;
			noopd)
				NOOPD=1
				echo "WARNING: Disabling OpenPDroid!"
				;;
			nobuild)
				NOBUILD=1
				echo "WARNING: Assuimg build is already complete!"
				;;
			version)
				echo "WARNING: Version override!"
				TEMP=1
				;;
			*)
		esac
	else
		VERION=$ARG
		TEMP=0
		echo "Version: $VERSION"
	fi
done

OTA="echo \"updateme.version=$VERSION\" >> /system/build.prop"
if [ $STABLE -eq 0 ]; then
	VERSION="$VERSION EXPERIMENTAL"
else
	VERSION="$VERSION STABLE"
fi
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

if [ $SAMMY -eq 0 ] && [ $NOBUILD -eq 0 ]; then
	if [ $NOSYNC -eq 0 ]; then
		cd /root/git/auto
		bash updaterepos.sh
		cd /root/android/omni/out/target/product/i9300
		if [ $? -eq 0 ]; then
			for f in `ls` ; do
				if [[ "$f" != "obj" ]]; then
					rm -rf $f
				fi
			done
		fi
		cd /root/android/omni
		repo selfupdate
		repo sync -c -j8
	else
		cd /root/android/omni
	fi
	if [ $? -ne 0 ]; then
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	
	# Apply all temporary patches
	bash ../../shared/git/ArchiDroid/__dont_include/patches.sh
	
	source build/envsetup.sh
	brunch i9300
	cd $OUT
	cp omni-*.zip /root/shared/git/ArchiDroid
fi

cd /root/shared/git/ArchiDroid

if [ ! -e *.zip ]; then
	exit 1
fi

unzip *.zip -d __adtemp
rm -Rf system/
mv META-INF/com/google/android/updater-script META-INF/com/google/android/updater-script2
mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary2
cd __adtemp
cp -R * ..
cd ..
rm -f META-INF/com/google/android/updater-script && mv META-INF/com/google/android/updater-script2 META-INF/com/google/android/updater-script
if [ $SAMMY -eq 0 ]; then
	rm -f META-INF/com/google/android/update-binary-installer && mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary-installer && mv META-INF/com/google/android/update-binary2 META-INF/com/google/android/update-binary
else
	rm -f META-INF/com/google/android/update-binary && mv META-INF/com/google/android/update-binary2 META-INF/com/google/android/update-binary
fi
OLD=`md5sum __dont_include/_updater-scripts/archidroid/updater-script | awk '{print $1}'`
NEW=`md5sum __adtemp/META-INF/com/google/android/updater-script | awk '{print $1}'`

if [ $OLD != $NEW ]; then
	echo "Warning! New $NEW does not equal old $OLD."
	echo "Probably just symlink or permissions stuff"
	diff __dont_include/_updater-scripts/archidroid/updater-script __adtemp/META-INF/com/google/android/updater-script
	cp __adtemp/META-INF/com/google/android/updater-script __dont_include/_updater-scripts/archidroid/updater-script
	read -p "Tell me when you're done, master!" -n1 -s
else
	echo "MD5 Sums matches, no further action required, automatic mode goes on..."
fi
rm -Rf __adtemp
rm -f *.zip

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

sed -i 's/ro.sf.lcd_density=320/#ro.sf.lcd_density=320/g' $FILE

if [ $SAMMY -eq 1 ]; then
	sed -i 's/S_Over_the_horizon.ogg/09_Underwater_world.ogg/g' $FILE
	sed -i 's/S_Whistle.ogg/S_Good_News.ogg/g' $FILE
	sed -i 's/Walk_in_the_forest.ogg/Dawn_chorus.ogg/g' $FILE
fi

GDZIE=`grep -n "ro.build.display.id=" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo "ro.build.display.id=ArchiDroid $VERSION" >> $FILEO
echo "ro.archidroid.version=$VERSION" >> $FILEO
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

if [ $SAMMY -eq 1 ]; then
	cd framework-res
	zip -0 -r ../../system/framework/framework-res.apk *
	cd ..
	rm -f ../system/app/Superuser.apk
	rm -f ../system/xbin/su
	rm -f ../system/xbin/daemonsu
	rm -f ../system/etc/init.d/99SuperSUDaemon
	rm -f ../system/etc/install-recovery.sh
fi

if [ $STABLE -eq 1 ]; then
	bash zipalign.sh
fi
if [ $NOOPD -eq 0 ]; then
	bash openpdroid.sh
else
	rm -f ../omni-*.zip
fi
exit 0