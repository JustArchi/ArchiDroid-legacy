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

# NOTICE #1
# Yes, you're right, this was initially written to allow easy parallel jobs in background.
# By simply adding & to the end of our WORK command we would run all these command in parallel
# which would drastically reduce time needed for doing all of these tasks
# HOWEVER, unfortunately, AROMA or CWM recovery doesn't allow background tasks
# and immediately crashes when the first one is launched
# Therefore, we can't use background task at least now, maybe in future...

VRDIR="/cache/vrtheme"

WORK() {
	# $1 - Target dir such as /system/app or /system/framework
	# $2 - Apk name such as SystemUI.apk or framework-res.apk
	cd "$VRDIR/$1/$2" &&
	"$VRDIR/zip" -r "$1/$2" * &&
	"$VRDIR/zipalign" -f 4 "$1/$2" "$1/$2.aligned" &&
	mv -f "$1/$2.aligned" "$1/$2" &&
	chmod 644 "$1/$2"
}

if [ -d "$VRDIR/system/app" ]; then
	find "$VRDIR/system/app" -mindepth 1 -maxdepth 1 -type d | while read APK; do
		#WORK "/system/app" "$(basename "$APK")" & # NOTICE #1
		WORK "/system/app" "$(basename "$APK")"
	done
fi
if [ -d "$VRDIR/system/framework" ]; then
	find "$VRDIR/system/framework" -mindepth 1 -maxdepth 1 -type d | while read APK; do
		#WORK "/system/framework" "$(basename "$APK")" & # NOTICE #1
		WORK "/system/framework" "$(basename "$APK")"
	done
fi

#wait # NOTICE #1

rm -rf "$VRDIR"
exit 0
