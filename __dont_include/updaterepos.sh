#!/bin/bash

INIT=0
TRUSTUPSTREAM=0
for ARG in "$@"; do
	case "$ARG" in
		init|INIT) INIT=1 ;;
		trustupstream|TRUSTUPSTREAM) TRUSTUPSTREAM=1 ;;
	esac
done

contains () {
	for e in "${@:2}"; do
		[[ "$e" = "$1" ]] && return 0
	done
	return 1
}

addUpstream () {
	ourName="$(basename "$folder")"
	#if contains "$ourName" "${aospForks[@]}"; then
		#git remote remove "$AOSPRepo" > /dev/null 2>&1
		#ourName="$(echo "$ourName" | sed 's/android/platform/g')"
		#ourName="$(echo "$ourName" | tr '_' '/')"
		#git remote add "$AOSPRepo" "$AOSPRepoLink/$ourName.git"
	#else
		git remote remove "$CUSTOMRepo" > /dev/null 2>&1
		git remote add "$CUSTOMRepo" "$CUSTOMRepoLink/$ourName.git"
	#fi
}

# Packages available only in AOSP sources, which we eventually want to sync
#aospForks=("")

# Abandoned
#droppedFromUpstream=("")

# Branches
CUSTOM="cm-11.0"
CUSTOMRepo="cm"
CUSTOMRepoLink="https://github.com/CyanogenMod"

AOSP="master"
AOSPRepo="aosp"
AOSPRepoLink="https://android.googlesource.com"

ourRepo="origin"
ourSshRepo="ssh"
ourRepoLink="https://github.com/JustArchi"

# This is done via more flexible .netrc
#if ! (pgrep ssh-agent); then
	#eval `ssh-agent -s`
	#ssh-add
#fi

if [[ "$TRUSTUPSTREAM" -eq 1 ]]; then
	CUSTOMRepo="upstream"
	if [[ "$INIT" -eq 1 ]]; then
		exit 0
	fi
fi

find . -mindepth 1 -maxdepth 1 -type d | while read folder; do
	cd "$folder" || continue
	ourBranch="$(git rev-parse --abbrev-ref HEAD)"
	if [[ "$ourBranch" != "$CUSTOM" ]]; then
		git checkout "$CUSTOM"
	fi
	ourName="$(basename "$folder")"
	if [[ "$INIT" -eq 1 ]]; then
		addUpstream
	else
		git pull "$ourRepo" "$ourBranch"
		#if ! contains "$ourName" "${droppedFromUpstream[@]}"; then
			#if contains "$ourName" "${aospForks[@]}"; then
				#git pull "$AOSPRepo" "$AOSP"
			#else
				git pull "$CUSTOMRepo" "$CUSTOM"
			#fi
			if [ $? -ne 0 ]; then
				# This is mandatory, we MUST stay in sync with upstream
				git reset --hard
				git clean -fd
				read -p "Something went wrong, tell me when you're done, master!" -s
			fi
		#fi
		git push "$ourRepo" "$ourBranch" || read -p "Something went wrong, tell me when you're done, master!" -s
	fi
	cd ..
done
exit 0
