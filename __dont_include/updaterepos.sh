#!/bin/bash

for folder in `find . -mindepth 1 -maxdepth 1 -type d` ; do
	cd $folder
	BRANCH=`git rev-parse --abbrev-ref HEAD`
	git pull upstream $BRANCH
	if [ $? -ne 0 ]; then
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	git push origin $BRANCH
	if [ $? -ne 0 ]; then
		read -p "Something went wrong, please check and tell me when you're done, master!" -n1 -s
	fi
	cd ..
done
exit 0