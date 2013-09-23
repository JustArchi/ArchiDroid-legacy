#!/bin/sh
# Thanks to KCS42 @ XDA
# Minor improvements by JustArchi

if [ -z `which git` ] || [ -z `which zip` ]; then
  echo "No git or no zip"
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
HASH=$(git rev-parse --short HEAD)
DATE=$(date +"%y.%m.%d")
VERSION=$(grep -E ini_set.*rom_version META-INF/com/google/android/aroma-config \
          | sed -e 's/.*rom_version",\ *//' -e 's/.//' -e 's/".*//')
FILENAME='ArchiDroid_'${BRANCH}'_v'${VERSION}'-'${HASH}'.zip'

cd ..`dirname $0`
git pull
if [ $? -ne 0 ]; then
  git pull origin $BRANCH
fi

if [ ! -f ${FILENAME} ]; then
  zip -r -db -dd -du ${FILENAME} . -x \_\_dont_include\* .git\* ArchiDroid*.zip \.*.swp zip.sh
else
  echo Version already zipped.
fi
exit 0