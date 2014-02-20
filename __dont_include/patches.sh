#!/bin/bash
GERRIT="https://gerrit.omnirom.org"

cd /root/android/omni

adpatch() {
	# Prepare variables and path
	NUMBER="$1"
	PATCHSET="$2"
	shift 2
	GENERIC="android"
	GOBACK=0
	for i in "$@"; do
		cd $i
		GENERIC+="_$i"
		GOBACK=`expr $GOBACK + 1`
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
	for i in `seq 1 $GOBACK`; do
		cd ..
	done
}

# Multi-Window
# https://gerrit.omnirom.org/#/c/1510/
#adpatch "10/1510" "21" "frameworks" "base"

# All Animations
#adpatch "51/4251" "36" "frameworks" "base" # https://gerrit.omnirom.org/#/c/4251/
#adpatch "50/4250" "14" "packages" "apps" "Settings" # https://gerrit.omnirom.org/#/c/4250/
#adpatch "49/4249" "32" "packages" "apps" "OmniGears" # https://gerrit.omnirom.org/#/c/4249/

exit 0