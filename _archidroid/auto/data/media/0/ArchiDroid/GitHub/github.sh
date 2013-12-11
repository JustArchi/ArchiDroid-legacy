#!/bin/bash
AD="/data/media/0/ArchiDroid"
ourFolder="$AD/GitHub"
ourRepo="origin"
ourLink="git://github.com/JustArchi/ArchiDroid.git"
VERSION="$1"

if [ -z "$VERSION" ]; then
	exit 1
fi

if [ -d $ourFolder/$VERSION ]; then
	echo "Ok, repository already available with branch $VERSION. Updating..."
	cd $ourFolder/$VERSION
	git pull $ourRepo $VERSION
else
	echo "Repository isn't available yet, cloning ArchiDroid repository branch $VERSION"
	cd $ourFolder
	git clone --branch $VERSION --depth 1 $ourLink $VERSION
	cd $ourFolder/$VERSION
	git pull $ourRepo $VERSION
fi

exit 0