#!/sbin/sh

# ArchiDroid OTA
echo "# ArchiDroid OTA" >> /system/build.prop
echo "# Please don't remove these lines, they're needed for OTA" >> /system/build.prop
echo "updateme.name=ArchiDroid2" >> /system/build.prop
echo "updateme.version=2.0.0" >> /system/build.prop
echo "# Thank you!" >> /system/build.prop