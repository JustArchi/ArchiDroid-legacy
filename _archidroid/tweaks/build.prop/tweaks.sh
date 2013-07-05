#!/sbin/sh

# Extra tweaks for build.prop
echo "# EXTRA TWEAKS" >> /system/build.prop

echo "# Disable Sending Usage Data" >> /system/build.prop
echo "ro.config.nocheckin=1" >> /system/build.prop

echo "# Deeper Sleep" >> /system/build.prop
echo "pm.sleep_mode=1" >> /system/build.prop

echo "# Disable Kernel Error Checking" >> /system/build.prop
echo "ro.kernel.android.checkjni=0" >> /system/build.prop

