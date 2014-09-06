#!/sbin/sh

# ArchiDroid OTA
echo "# ArchiDroid OTA" >> /system/build.prop
echo "# Please don't remove these lines, they're needed for OTA" >> /system/build.prop
echo "updateme.name=ArchiDroid2" >> /system/build.prop
echo "updateme.version=2.5.4" >> /system/build.prop
echo "updateme.otauid=archidroid2" >> /system/build.prop
echo "updateme.urlcheck=https://dl.dropboxusercontent.com/u/23869279/ArchiDroid2/OTA/update_me_check.xml" >> /system/build.prop
echo "updateme.urlelement=https://dl.dropboxusercontent.com/u/23869279/ArchiDroid2/OTA/update_me_parts.xml" >> /system/build.prop
echo "updateme.reboottype=1" >> /system/build.prop
echo "updateme.downloaddir=/mnt/sdcard/downloadDir" >> /system/build.prop
echo "updateme.disableinstalledapps=1" >> /system/build.prop
echo "updateme.disablescripts=1" >> /system/build.prop
echo "# Thank you!" >> /system/build.prop