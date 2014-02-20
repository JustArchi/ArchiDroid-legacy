#!/sbin/sh

# exit 0 -> Internal error, no build.prop detected. Full wipe?
# exit 1 -> All fine, we're NOT running ArchiDroid
# exit 2 -> All fine, we're running ArchiDroid

if [ -e /system/build.prop ]; then
	# Good
	if [ $(cat /system/build.prop | grep -i "ArchiDroid" | wc -l) -gt 0 ]; then
		# Yay we're running ArchiDroid"
		exit 2
	else
		# We're not running ArchiDroid
		exit 1
	fi
else
	# Report internal error
	exit 0
fi

sync
exit 0