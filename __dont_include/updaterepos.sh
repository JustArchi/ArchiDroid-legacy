#!/bin/bash

INIT=0

contains () {
	local e
	for e in "${@:2}"; do 
		[[ "$e" == "$1" ]] && return 0
	done
	return 1
}

# Packages in great sync with CM, we can literally pull them from CM repo to merge changes
inSyncWithCM=("android_vendor_cm" "android_frameworks_native" "android_packages_apps_Nfc" "android_packages_providers_MediaProvider" "android_packages_inputmethods_LatinIME" "android_packages_apps_Phone" "android_packages_apps_Mms" "android_packages_apps_Gallery2" "android_packages_apps_Email" "android_packages_apps_Dialer" "android_packages_apps_Contacts" "android_packages_apps_ContactsCommon" "android_packages_apps_Calculator")

# Packages NOT in great sync with CM, we should wait for Cristiano's merges if possible
NOTinSyncWithCM=("android_frameworks_base" "android_packages_apps_Settings")

# Branches
crDroid="cr-main-10.2"
CM="cm-10.2"

# Local names
crDroidRepo="upstream"
CMRepo="cm"
ourRepo="origin"

for folder in `find . -mindepth 1 -maxdepth 1 -type d` ; do
	cd $folder
	ourBranch=`git rev-parse --abbrev-ref HEAD`
	ourName=`basename "$folder"`
	if [ $INIT -eq 1 ]; then
		git remote remove cm
		git remote remove upstream
		git remote add cm https://github.com/CyanogenMod/$ourName.git
		git remote add upstream https://github.com/cristianomatos/$ourName.git
	else
		git pull $crDroidRepo $crDroid
		if [ $? -ne 0 ]; then
			read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
		fi
		if `contains "$ourName" "${inSyncWithCM[@]}"`; then
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