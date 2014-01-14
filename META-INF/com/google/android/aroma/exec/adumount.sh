#!/sbin/sh

# JustArchi@JustArchi.net

# Used by ArchiDroid for providing universal device-based paths
# Usage: adumount.sh *path*, f.e. adumount.sh /storage/sdcard1

AUTO="/efs /system /cache /preload /data /storage/sdcard1" # Filesystems which should be unmounted automatically when no argument is given, typically every partition excluding images

GOTBUSYBOX=false
GOTMOUNT=false

ADMOUNTED() {
	if [ `mount | grep -i "$1" | wc -l` -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

ADUMOUNT() {
	if (ADMOUNTED "$1"); then
		# Automatic filesystem
		if $GOTBUSYBOX; then
			busybox umount "$1" >/dev/null 2>&1
			if !(ADMOUNTED "$1"); then
				echo "Unmounted $1 through busybox umount"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			umount "$1" >/dev/null 2>&1
			if !(ADMOUNTED "$1"); then
				echo "Unmounted $1 through umount"
				return 0
			fi
		fi
		# Ok, I give up
		if (ADMOUNTED "$1"); then
			echo "Could not unmount $1"
			return 1
		fi
	else
		echo "$1 is already unmounted"
	fi
	return 0
}

if [ ! -z `which busybox` ]; then
	echo "Got busybox!"
	GOTBUSYBOX=true
fi
if [ ! -z `which mount` ]; then
	echo "Got mount!"
	GOTMOUNT=true
fi
if (! $GOTBUSYBOX && ! $GOTMOUNT); then
	# This should never happen, but safety check is always good
	echo "FATAL ERROR, NO BUSYBOX NEITHER MOUNT"
	exit 1
fi

if [ -z "$1" ]; then
	# No argument given, umount AUTO
	for mnt in $AUTO; do
		if [ ! -z "$mnt" ]; then
			ADUMOUNT "$mnt"
		fi
	done
else
	ADUMOUNT "$1"
fi

exit 0