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
	git remote remove $CMRepo > /dev/null 2>&1
	git remote remove $crDroidRepo > /dev/null 2>&1
	git remote add cm $CMRepoLink/$ourName.git
	git remote add upstream $crDroidRepoLink/$ourName.git
}

# Packages in perfect sync with CM. We should pull them directly from CyanogenMod and merge any conflicts (if any)
# This won't happen in near future, unless crDroid project is finished for some reason
inPerfectSyncWithCM=("android_vendor_cm")

# Packages in sync with CM, we can try to merge them automatically, if it fails wait for upstream changes
inSyncWithCM=("android_frameworks_base" "android_packages_apps_Settings")

# Packages not available in our upstream
droppedFromUpstream=("android_vendor_cm")

# Branches
crDroid="cr-4.4"
#crDroidExtra="cm-4.4"
crDroidRepo="upstream"
crDroidRepoLink="https://github.com/cristianomatos"
CM="cm-11.0"
CMRepo="cm"
CMRepoLink="https://github.com/CyanogenMod"
ourRepo="origin"

for folder in `find . -mindepth 1 -maxdepth 1 -type d` ; do
	cd $folder
	ourBranch=`git rev-parse --abbrev-ref HEAD`
	ourName=`basename "$folder"`
	if [ $INIT -eq 1 ]; then
		addUpstream
	else
		git pull $ourRepo $ourBranch
		if ! `contains "$ourName" "${droppedFromUpstream[@]}"`; then
			git pull $crDroidRepo $crDroid
			if [ $? -ne 0 ]; then
				# This is mandatory, we MUST stay in sync with upstream
				read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
			fi
		fi
		if `contains "$ourName" "${inSyncWithCM[@]}"`; then
			git pull $CMRepo $CM
			if [ $? -ne 0 ]; then
				# This is optional, we don't wan to resolve conflicts in different way and create desync
				# Reset progress and wait for upstream
				echo "Automatic Merge Failed"
				git reset --hard
				git clean -fd
			fi
		elif `contains "$ourName" "${inPerfectSyncWithCM[@]}"`; then
			# We don't want to pull upstream anymore, syncing CM is mandatory then
			git pull $CMRepo $CM
			if [ $? -ne 0 ]; then
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
