#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2011 VillainROM
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

VRDIR="/cache/vrtheme"
VALIDTARGETS="app framework priv-app"
TOOLS="zip zipalign dexopt-wrapper"
LOG="$VRDIR/log.txt" # Can be /dev/null

WORK_DEODEX() {
	# $1 - Target dir such as /system/app or /system/framework
	# $2 - Apk name such as SystemUI.apk or framework-res.apk
	if [ -f "$1/$2" ]; then
		echo "MODDING: $1/$2"
		cd "$VRDIR/$1/$2" &&
		"$VRDIR/zip" -r "$1/$2" ./* >/dev/null &&
		"$VRDIR/zipalign" -f 4 "$1/$2" "$1/$2.aligned" >/dev/null &&
		mv -f "$1/$2.aligned" "$1/$2" &&
		chmod 644 "$1/$2" &&
		echo "OK: $1/$2"
	else
		echo "WARNING: $1/$2 was found for modding but there's no such file in the ROM!"
		return 1
	fi
}

WORK_ODEX() {
	local ODEXFILE="$(echo "$1/$2" | rev | cut -d'.' -f2- | rev).odex"
	WORK_DEODEX "$1" "$2" || return
	if [ -f "$VRDIR/$1/$2/classes.dex" ]; then
		echo "ODEX: Found classes.dex in new $2"
		rm -f "$ODEXFILE"
		"$VRDIR/dexopt-wrapper" "$1/$2" "$ODEXFILE" >/dev/null || echo "ODEX: Could not odex $1/$2"
	fi
}

#exec 1>"$LOG"
#exec 2>&1

for TOOL in $TOOLS; do
	chmod 755 "$VRDIR/$TOOL"
done

if [ -f "/system/framework/framework.odex" ]; then
	echo "INFO: Using ODEX mode"
	# Define BOOTCLASSPATH as all available JARs
	BOOTCLASSPATH=""
	for f in /system/framework/*.jar; do
		BOOTCLASSPATH="$BOOTCLASSPATH$f:"
	done
	export BOOTCLASSPATH="$BOOTCLASSPATH"

	for TARGET in $VALIDTARGETS; do 
		if [ -d "$VRDIR/system/$TARGET" ]; then
			find "$VRDIR/system/$TARGET" -mindepth 1 -maxdepth 1 -type d | while read APK; do
				WORK_ODEX "/system/$TARGET" "$(basename "$APK")"
			done
		fi
	done
else
	echo "INFO: Using DEODEX mode"
	for TARGET in $VALIDTARGETS; do 
		if [ -d "$VRDIR/system/$TARGET" ]; then
			find "$VRDIR/system/$TARGET" -mindepth 1 -maxdepth 1 -type d | while read APK; do
				WORK_DEODEX "/system/$TARGET" "$(basename "$APK")"
			done
		fi
	done
fi

rm -rf "$VRDIR"
exit 0
