#!/bin/bash
cd ..

# Let's make it more universal (also benefit temasek's users) because I'm not using updater-script anyway
cp META-INF/com/google/android/updater-script updater-script-archi
cp __dont_include/_updater-scripts/temasek/updater-script META-INF/com/google/android/updater-script
zip -0 -r rom.zip system META-INF
cp updater-script-archi META-INF/com/google/android/updater-script
rm -f updater-script-archi
# That was easy, eh? ;)

# Cleanup, updates and patching
cd __dont_include/auto-patcher
rm -rf tmp* adpatch*
rm -f rom.zip log*.txt restore-cm*.zip update-cm*.zip autopatcher.zip
mv ../../rom.zip rom.zip
git pull origin master
./batch.sh
./auto_patcher rom.zip openpdroid cm

# Let's keep flashable zips for temasek's users
rm -f ../temasek-openpdroid/update-cm*.zip ../temasek-openpdroid/restore-cm*.zip
cp update-cm*.zip restore-cm*.zip ../temasek-openpdroid/

# And let's finally patch ArchiDroid
unzip update-cm*.zip -d adpatch
rm -rf ../../_archidroid/tweaks/openpdroid/system
cp -R adpatch/system ../../_archidroid/tweaks/openpdroid

# Cleanup
rm -rf tmp* adpatch*
rm -f rom.zip log*.txt restore-cm*.zip update-cm*.zip autopatcher.zip
exit 0