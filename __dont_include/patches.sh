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
adpatch "10/1510" "18" "frameworks" "base"

# All Animations
adpatch "51/4251" "36" "frameworks" "base" # https://gerrit.omnirom.org/#/c/4251/
#adpatch "50/4250" "14" "packages" "apps" "Settings" # https://gerrit.omnirom.org/#/c/4250/
adpatch "49/4249" "32" "packages" "apps" "OmniGears" # https://gerrit.omnirom.org/#/c/4249/

# TRDS
adpatch "88/4788" "3" "frameworks" "base" # https://gerrit.omnirom.org/#/c/4788/
#adpatch "90/4790" "5" "packages" "apps" "Settings" # https://gerrit.omnirom.org/#/c/4790/
adpatch "91/4791" "1" "frameworks" "native" # https://gerrit.omnirom.org/#/c/4791/
adpatch "12/4912" "1" "development" # https://gerrit.omnirom.org/#/c/4912/
adpatch "89/4789" "2" "frameworks" "base" # https://gerrit.omnirom.org/#/c/4789/

adpatch "92/4792" "3" "packages" "apps" "Dialer" # https://gerrit.omnirom.org/#/c/4792/
adpatch "11/4911" "2" "packages" "apps" "Dialer" #https://gerrit.omnirom.org/#/c/4911/
adpatch "94/4794" "2" "packages" "services" "Telephony" # https://gerrit.omnirom.org/#/c/4794/

adpatch "01/4901" "1" "packages" "apps" "Mms" # https://gerrit.omnirom.org/#/c/4901/
adpatch "06/4906" "1" "packages" "apps" "Mms" # https://gerrit.omnirom.org/#/c/4906/
adpatch "07/4907" "1" "packages" "apps" "Mms" #https://gerrit.omnirom.org/#/c/4907/
adpatch "08/4908" "1" "packages" "apps" "Mms" #https://gerrit.omnirom.org/#/c/4908/
adpatch "09/4909" "1" "packages" "apps" "Mms" #https://gerrit.omnirom.org/#/c/4909/
adpatch "10/4910" "1" "packages" "apps" "Mms" #https://gerrit.omnirom.org/#/c/4910/

adpatch "06/4806" "1" "packages" "apps" "Gallery2" #https://gerrit.omnirom.org/#/c/4806/
adpatch "07/4807" "1" "packages" "inputmethods" "LatinIME" #https://gerrit.omnirom.org/#/c/4807/

exit 0