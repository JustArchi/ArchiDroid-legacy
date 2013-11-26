#!/bin/bash

INIT=0

contains () {
	local e
	for e in "${@:2}"; do
		[[ "$e" == "$1" ]] && return 0
	done
	return 1
}

addUpstream () {
	#ourBranch=`git rev-parse --abbrev-ref HEAD`
	ourName=`basename "$folder"`
	git remote remove $OMNIRepo > /dev/null 2>&1
	git remote add $OMNIRepo $OMNIRepoLink/$ourName.git
}

# Packages in perfect sync with CM. We should pull them directly from OMNI and merge any conflicts (if any)
# This won't happen in near future, unless crDroid project is finished for some reason
inPerfectSyncWithOMNI=("android_vendor_cm")

# Packages not available in our upstream
droppedFromUpstream=("android_vendor_cm")

# Branches
OMNI="android-4.4"
OMNIRepo="omni"
OMNIRepoLink="https://github.com/omnirom"
ourRepo="origin"
ourRepoLink="https://github.com/JustArchi"

for folder in `find . -mindepth 1 -maxdepth 1 -type d` ; do
	cd $folder
	git checkout $OMNI
	ourBranch=`git rev-parse --abbrev-ref HEAD`
	ourName=`basename "$folder"`
	if [ $INIT -eq 1 ]; then
		addUpstream
	else
		git pull $ourRepo $ourBranch
		if ! `contains "$ourName" "${droppedFromUpstream[@]}"`; then
			git pull $OMNIRepo $OMNI
			if [ $? -ne 0 ]; then
				# This is mandatory, we MUST stay in sync with upstream
				read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
			fi
		fi
		git push $ourRepo $ourBranch
		if [ $? -ne 0 ]; then
			read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
		fi
	fi
	cd ..
done
exit 0
