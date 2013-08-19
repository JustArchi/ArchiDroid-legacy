#!/bin/bash
cd ..
zip -0 -r rom.zip system META-INF
cd __dont_include/auto-patcher
rm -rf tmp* adpatch*
rm -f rom.zip log*.txt restore-cm*.zip update-cm*.zip autopatcher.zip
mv ../../rom.zip rom.zip
git pull origin master
./batch.sh
./auto_patcher rom.zip openpdroid cm
unzip update-cm*.zip -d adpatch
cd adpatch
rm -rf ../../../_archidroid/tweaks/openpdroid/system
cp -R system ../../../_archidroid/tweaks/openpdroid
cd ..
rm -rf tmp* adpatch*
rm -f rom.zip log*.txt restore-cm*.zip update-cm*.zip autopatcher.zip
exit 0