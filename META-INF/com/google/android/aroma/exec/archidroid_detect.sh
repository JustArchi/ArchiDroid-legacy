#!/sbin/sh

# exit 0 -> Internal error, no build.prop detected. Full wipe?
# exit 1 -> All fine, we're NOT running ArchiDroid
# exit 2 -> All fine, we're running ArchiDroid

mount -t auto /system > /dev/null 2>&1
if [ -e /system/build.prop ]; then
	# Good
	if [ `cat /system/build.prop | grep -i "ArchiDroid" | wc -l` -gt 0 ]; then
		# Yay we're running ArchiDroid"
    umount /system > /dev/null 2>&1
		exit 2
	else
		# We're not running ArchiDroid
    umount /system > /dev/null 2>&1
		exit 1
	fi
else
	# Report internal error
  umount /system > /dev/null 2>&1
	exit 0
fi