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
	for i in `seq 1 $#`; do
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
adpatch "51/4251" "32" "frameworks" "base"
adpatch "50/4250" "10" "packages" "apps" "Settings"
adpatch "49/4249" "29" "packages" "apps" "OmniGears"

exit 0
