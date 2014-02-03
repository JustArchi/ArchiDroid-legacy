#!/bin/bash

if [ "$1" == "init" ]; then
	INIT=1
else
	INIT=0
fi

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
	if `contains "$ourName" "${aospForks[@]}"`; then
		git remote remove $AOSPRepo > /dev/null 2>&1
		ourName=`echo $ourName | sed 's/android/platform/g'`
		ourName=`echo $ourName | tr '_' '/'`
		git remote add $AOSPRepo $AOSPRepoLink/$ourName.git
	else
		git remote remove $OMNIRepo > /dev/null 2>&1
		git remote add $OMNIRepo $OMNIRepoLink/$ourName.git
	fi
	#git remote remove $ourSshRepo >/dev/null 2>&1
	#git remote add $ourSshRepo git@github.com:JustArchi/ArchiDroid.git
}

# Packages available only in AOSP sources, which we eventually want to sync
aospForks=("android_frameworks_rs")

# Abandoned
droppedFromUpstream=("")

# Branches
OMNI="android-4.4"
OMNIRepo="omni"
OMNIRepoLink="https://github.com/omnirom"

AOSP="master"
AOSPRepo="aosp"
AOSPRepoLink="https://android.googlesource.com"

ourRepo="origin"
ourSshRepo="ssh"
ourRepoLink="https://github.com/JustArchi"

#if ! (pgrep ssh-agent); then
	#eval `ssh-agent -s`
	#ssh-add
#fi

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
			if `contains "$ourName" "${aospForks[@]}"`; then
				git pull $AOSPRepo $AOSP
			else
				git pull $OMNIRepo $OMNI
			fi
			if [ $? -ne 0 ]; then
				# This is mandatory, we MUST stay in sync with upstream
				git reset --hard
				git clean -fd
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
