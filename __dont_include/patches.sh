#!/bin/bash
GERRIT="https://gerrit.omnirom.org"

cd /root/android/omni

adpatch() {
	# Prepare variables and path
	NUMBER="$1"
	PATCHSET="$2"
	shift 2
	case "$1" in
		"framework")
			GENERIC="android_frameworks_base"
			cd frameworks/base
			GOBACK=2
			;;
		"settings")
			GENERIC="android_packages_apps_Settings"
			cd packages/apps/Settings
			GOBACK=3
			;;
		"omnigears")
			GENERIC="android_packages_apps_OmniGears"
			cd packages/apps/OmniGears
			GOBACK=3
			;;
		*)
			GENERIC="android"
			GOBACK=0
			for i in "$@"; do
				cd $i
				GENERIC+="_$i"
				GOBACK=`expr $GOBACK + 1`
			done
	esac
	
	# Find latest patchset
	git fetch $GERRIT/$GENERIC refs/changes/$NUMBER/$PATCHSET
	while (true); do
		PATCHSET=`expr $PATCHSET + 1`
		git fetch $GERRIT/$GENERIC refs/changes/$NUMBER/$PATCHSET >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			PATCHSET=`expr $PATCHSET - 1`
			break
		else
			echo "NEW PATCHSET: $GENERIC $NUMBER $PATCHSET"
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
	for i in `seq 1 $GOBACK`; do
		cd ..
	done
}

# Multi-Window
# https://gerrit.omnirom.org/#/c/1510/
adpatch "10/1510" "17" "frameworks" "base"

# All Animations
# https://gerrit.omnirom.org/#/c/4251/
# https://gerrit.omnirom.org/#/c/4250/
# https://gerrit.omnirom.org/#/c/4249/
adpatch "51/4251" "35" "frameworks" "base"
adpatch "50/4250" "12" "packages" "apps" "Settings"
#adpatch "49/4249" "31" "packages" "apps" "OmniGears"

# TRDS
# https://gerrit.omnirom.org/#/c/4788/
# https://gerrit.omnirom.org/#/c/4789/
# https://gerrit.omnirom.org/#/c/4790/
# https://gerrit.omnirom.org/#/c/4791/
# https://gerrit.omnirom.org/#/c/4792/
# https://gerrit.omnirom.org/#/c/4793/
# https://gerrit.omnirom.org/#/c/4794/
# https://gerrit.omnirom.org/#/c/4801/
# https://gerrit.omnirom.org/#/c/4806/
# https://gerrit.omnirom.org/#/c/4807/
adpatch "88/4788" "2" "framework"
adpatch "89/4789" "2" "framework"
adpatch "90/4790" "1" "settings"
adpatch "91/4791" "1" "frameworks" "native"
adpatch "92/4792" "1" "packages" "apps" "Dialer"
adpatch "93/4793" "1" "packages" "apps" "Dialer"
adpatch "94/4794" "1" "packages" "services" "Telephony"
#adpatch "01/4801" "2" "packages" "apps" "Mms"
#adpatch "06/4806" "1" "packages" "apps" "Gallery2"
#adpatch "07/4807" "1" "packages" "inputmethods" "LatinIME"


exit 0