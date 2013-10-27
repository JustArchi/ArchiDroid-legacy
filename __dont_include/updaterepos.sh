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
inPerfectSyncWithCM=("android_vendor_cm" "android_frameworks_native" "android_packages_apps_Nfc" "android_packages_providers_MediaProvider" "android_packages_inputmethods_LatinIME" "android_packages_apps_Phone" "android_packages_apps_Mms" "android_packages_apps_Gallery2" "android_packages_apps_Email" "android_packages_apps_Dialer" "android_packages_apps_Contacts" "android_packages_apps_ContactsCommon" "android_packages_apps_Calculator")

# Packages not in perfect sync with CM but still good enough. For these we should sync automatically only non-conflicting commits and eventually cherry-pick the rest, as we should stay in sync with the upstream.
inSyncWithCM=("android_frameworks_base" "android_packages_apps_Settings")

# Packages NOT in great sync with CM, we should wait for upstream merges
NOTinSyncWithCM=("")

# Branches
crDroid="cr-main-10.2"
crDroidRepo="upstream"
crDroidRepoLink="https://github.com/cristianomatos"
CM="cm-10.2"
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
		git pull $crDroidRepo $crDroid
		if [ $? -ne 0 ]; then
			read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
		fi
		if `contains "$ourName" "${inPerfectSyncWithCM[@]}"`; then
			git pull $CMRepo $CM
		elif `contains "$ourName" "${inSyncWithCM[@]}"`; then
			git pull -s ours $CMRepo $CM
		fi
		if [ $? -ne 0 ]; then
			read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
		fi
		git push $ourRepo $ourBranch
		if [ $? -ne 0 ]; then
			read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
		fi
	fi
	cd ..
done
exit 0
