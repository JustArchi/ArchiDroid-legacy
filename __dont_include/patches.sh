#!/bin/bash
GERRIT="https://gerrit.omnirom.org"

cd /root/android/omni

adpatch() {
	# Prepare variables and path
	NUMBER="$1"
	PATCHSET="$2"
	shift 2
	GENERIC="android"
	for i in "$@"; do
		cd $i
		GENERIC+="_$i"
	done
	
	# Find latest patchset
	git fetch $GERRIT/$GENERIC refs/changes/$NUMBER/$PATCHSET
	while (true); do
		PATCHSET=`expr $PATCHSET + 1`
		git fetch $GERRIT/$GENERIC refs/changes/$NUMBER/$PATCHSET >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			PATCHSET=`expr $PATCHSET - 1`
			break
		else
			echo "$NUMBER" "$PATCHSET"
			read -p "Tell me when you're done, master!" -n1 -s
		fi
	done
	
	# Finally apply patch
	git fetch $GERRIT/$GENERIC refs/changes/$NUMBER/$PATCHSET
	git cherry-pick FETCH_HEAD
	
	if [ $? -ne 0 ]; then
		git reset --hard
		git clean -fd
		echo "FAILED WITH $NUMBER $GENERIC"
		read -p "Tell me when you're done, master!" -n1 -s
	fi
	
	# Back to root
	for i in `seq 1 $#`; do
		cd ..
	done
}

# Multi-Window
# https://gerrit.omnirom.org/#/c/1510/
adpatch "10/1510" "14" "frameworks" "base"

# Wi-Fi Tethering fix
# https://gerrit.omnirom.org/#/c/3970/
adpatch "70/3970" "1" "device" "samsung" "smdk4412-common"

# Exfat-fix
# https://gerrit.omnirom.org/#/c/3856/
# https://gerrit.omnirom.org/#/c/3857/
adpatch "56/3856" "1" "system" "vold"
adpatch "57/3857" "1" "device" "samsung" "smdk4412-common"

# Quick Settings (SlimBean)
# https://gerrit.omnirom.org/#/c/3918/
# https://gerrit.omnirom.org/#/c/3932/
# CHERRY-PICKED
# https://gerrit.omnirom.org/#/c/3941/ | Patch Set 6 | https://github.com/JustArchi/android_packages_apps_Settings/commit/c0e1f983fcb1464b52ea1a526ae1ba7595bda91a
adpatch "18/3918" "8" "frameworks" "base"
adpatch "32/3932" "3" "packages" "services" "Telephony"
#adpatch "41/3941" "6" "packages" "apps" "Settings"

# ListView Animations
# CHERRY-PICKED
# https://gerrit.omnirom.org/#/c/2863/ | Patch Set 6 | https://github.com/JustArchi/android_frameworks_base/commit/26d81e4cfc6dabfd035e681e8638f84f5a2aeb23 
# https://gerrit.omnirom.org/#/c/2862/ | Patch Set 7 | https://github.com/JustArchi/android_packages_apps_OmniGears/commit/0674dc8ac6a0a74dfcc6d2abc56f752985f8789a

exit 0
