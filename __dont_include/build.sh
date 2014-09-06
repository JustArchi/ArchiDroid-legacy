#!/bin/bash

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
VERSION=2.5.4

# Detect HOME properly
# This workaround is required because arm-eabi-nm has problems following ~. Don't change it
if [[ "$(dirname ~)" = "/" ]]; then
	HOME="$(dirname ~)$(basename ~)" # Root
else
	HOME="$(dirname ~)/$(basename ~)" # User
fi

# HOW TO PORT ARCHIDROID TO OTHER DEVICE
# 1. Make sure you have a good base, this can be a stock ROM or AOSP ROM. Put it in .zip format in the root of ArchiDroid.
# 2. Enter __dont_include folder and execute this script with nobuild parameter - bash build.sh "nobuild", before that, modify following parameters to proper ones

# CHANGE ME
ADROOT="$HOME/shared/git/ArchiDroid" # This is where ArchiDroid GitHub repo is located
ADZIP="cm-" # This is with what output zip starts, i.e. for omni-xxx-yyy.zip you should type "omni-"

# CHANGE ME IF BUILDING FROM SOURCE
ADCOMPILEROOT="$HOME/android/cm" # This is where AOSP sources are located
ADVARIANT="i9300" # This is AOSP variant to build, the one used in brunch command. If you use "brunch mydevice", you should set it to mydevice here
BUILDVARIANT="user" # Change this to userdebug if for some reason you can't build with user variant
NOGIT=0 # Change that to 1, it's 0 only for me to allow faster updates of local AOSP repos

# Notice: If you want you can also totally ignore above 3 variables and always call build.sh with "nobuild" parameter, i.e. bash build.sh nobuild
# In this case, make sure that you already have output zip base in ADROOT specified on the top
# build.sh will then jump straight to extracting and overwriting current ArchiDroid base with new one
# This is perfect if you already have your own build.sh for building from source, then you move output zip to ADROOT and call bash build.sh nobuild

# OPTIONAL
ADOUT="$ADCOMPILEROOT/out/target/product/$ADVARIANT" # This is the location of output zip from above sources, usually it doesn't need to be changed
ADREPOS="$HOME/git/auto" # This is used only when NOGIT is 0

# 3. It should properly start extracting everything and overwriting /system partition
# 4. Ignore md5 sum mismatch, as it's a feature for me to easily detect updater-script changes when I'm merging new base
# 5. After it's done, you should have new system folder
# 6. Edit META-INF/com/google/android/updater-script. You should modify SYMLINKS, PERMISSIONS and BLOCK PATHS for YOUR device.
# All of them should be taken from updater-script of the base.
# MAKE SURE that you edit ALL INCLUDED BLOCKS to MATCH your device! Mostly important - kernel block, modem block and recovery block. CHECK IT TWICE. If you overwrite wrong block then you can say bye to your phone
#
# 7. After YOU'RE SURE that you have proper blocks, symlinks and permissions. You can start modyfing ArchiDroid to your own.
# 8. Start from META-INF/com/google/android/aroma/exec folder, there are a few scripts which ALSO utilize blocks, this time partitions - /system /data /cache /preload. You should edit them to match your device, mostly important - admount, adumount, adreformat, check_fs
# 9. Lastly, delete _archidoid/auto/system/partlayout4nandroid or replace it with proper one for your device
# 10. When you're sure that everything is good and you understand that if you missed something, you may even brick your device, then delete or change safety check on the top of updater-script to match your device
#
# This should be pretty much it, start modifying aroma to your preferences, make sure that you won't flash improper kernel, recovery, modem etc.
# If you know what you're doing, you should be fine. Eventually you can always catch me on xda or github - JustArchi
# Aha, and prepare for many issues because ArchiDroid definitely won't work out of the box without additional modifications to your preferences. ArchiDroid backend is pretty much universal, but apps, gapps, or anything, may not be
# In general if you used proper blocks then nothing can go wrong, flash it, boot, and fix remaining errors, FCs, or anything
# You should also check _archidroid/auto folder, as this is flashed on top of the base, by default.

# Common
STABLE=0
NOSYNC=0
SAMMY=0
BPROP=0
NOOPD=1
NOBUILD=0
TEMP=0

export USE_CCACHE=1

cd "$(dirname "$0")"

for ARG in "$@" ; do
	if [[ "$TEMP" -eq 0 ]]; then
		case "$ARG" in
			sammy)
				SAMMY=1
				NOOPD=1
				echo "Building ArchiDroid 1.X!"
				;;
			bprop)
				BPROP=1
				NOBUILD=1
				echo "Build prop update only!"
				;;
			stable)
				STABLE=1
				echo "WARNING: Building stable release!"
				;;
			nosync)
				NOSYNC=1
				echo "WARNING: Not updating repos!"
				;;
			nogit)
				NOGIT=1
				echo "WARNING: Not updating local repos!"
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
		VERION="$ARG"
		TEMP=0
		echo "Version: $VERSION"
	fi
done

OTA="echo \"updateme.version=$VERSION\" >> /system/build.prop"
if [[ "$STABLE" -eq 0 ]]; then
	VERSION="$VERSION EXPERIMENTAL"
else
	VERSION="$VERSION STABLE"
fi

if [[ "$SAMMY" -eq 0 && "$NOBUILD" -eq 0 ]]; then
	if [[ "$NOSYNC" -eq 0 ]]; then
		if [[ "$NOGIT" -eq 0 ]]; then
			if [[ -d "$ADREPOS" ]]; then
				cd "$ADREPOS"
				bash updaterepos.sh
			fi
			if [[ -d "$ADREPOS"2 ]]; then
				cd "$ADREPOS"2
				bash updaterepos.sh "trustupstream"
			fi
		fi
		cd "$ADCOMPILEROOT"
		repo selfupdate
		repo sync -c -j16
	else
		cd "$ADCOMPILEROOT"
	fi

	if [[ -d "$ADOUT" ]]; then
		find "$ADOUT" -mindepth 1 -maxdepth 1 -iname "*.zip" | while read line; do
			echo "Removing $line"
			rm -f "$line"
		done
	fi

	source build/envsetup.sh
	brunch "$ADVARIANT" "$BUILDVARIANT" || true
	cd "$ADOUT"
	cp "$ADZIP"*.zip "$ADROOT"
fi

cd "$ADROOT"

if [[ "$BPROP" -eq 0 ]]; then
	unzip *.zip -d __adtemp
	rm -rf system/
	rm -rf recovery/
	mv META-INF/com/google/android/updater-script META-INF/com/google/android/updater-script2
	mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary2
	cd __adtemp
	cp -r * ..
	cd ..
	rm -f META-INF/com/google/android/updater-script && mv META-INF/com/google/android/updater-script2 META-INF/com/google/android/updater-script
	if [[ "$SAMMY" -eq 0 ]]; then
		rm -f META-INF/com/google/android/update-binary-installer && mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary-installer && mv META-INF/com/google/android/update-binary2 META-INF/com/google/android/update-binary
	else
		rm -f META-INF/com/google/android/update-binary && mv META-INF/com/google/android/update-binary2 META-INF/com/google/android/update-binary
	fi
	OLD="$(md5sum __dont_include/_updater-scripts/archidroid/updater-script | awk '{print $1}')"
	NEW="$(md5sum __adtemp/META-INF/com/google/android/updater-script | awk '{print $1}')"

	if [[ "$OLD" != "$NEW" ]]; then
		echo "Warning! New $NEW does not equal old $OLD."
		echo "Probably just symlink or permissions stuff"
		diff __dont_include/_updater-scripts/archidroid/updater-script __adtemp/META-INF/com/google/android/updater-script || true
		cp __adtemp/META-INF/com/google/android/updater-script __dont_include/_updater-scripts/archidroid/updater-script
		read -p "Tell me when you're done, master!" -n1 -s
	else
		echo "MD5 Sums matches, no further action required, automatic mode goes on..."
	fi
	rm -rf __adtemp
	#rm -f *.zip
fi

cd __dont_include/
VERSION+=' ['
if [[ "$SAMMY" -eq 1 ]]; then
	VERSION+="$(cat ../system/build.prop | grep "ro.build.version.incremental" | cut -d '=' -f 2)"
else
	VERSION+="$(cat ../system/build.prop | grep "ro.build.id" | cut -d '=' -f 2)"
fi
VERSION+=']'

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
	chmod 755 zipalign
	./zipalign -v -f 4 ../system/framework/framework-res.apk TEMP.apk
	mv -f TEMP.apk ../system/framework/framework-res.apk
	rm -f ../system/app/Superuser.apk
	rm -f ../system/xbin/su
	rm -f ../system/xbin/daemonsu
	rm -f ../system/etc/init.d/99SuperSUDaemon
	rm -f ../system/etc/install-recovery.sh
	rm -f ../system/etc/.installed_su_daemon
	rm -rf ../system/bin/.ext
	if [ -e ../system/bin/debuggerd.real ]; then
		mv -f ../system/bin/debuggerd.real ../system/bin/debuggerd
	fi
	cd _bloatware
	#bash ZZcleanrom.sh
	cd ..
fi

if [ $NOOPD -eq 0 ]; then
	bash openpdroid.sh
else
	rm -f ../*.zip
fi
exit 0
