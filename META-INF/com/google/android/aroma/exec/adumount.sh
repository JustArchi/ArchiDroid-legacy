#!/sbin/sh

# JustArchi@JustArchi.net

# Used by ArchiDroid for providing universal device-based paths
# Usage: adumount.sh *path*, f.e. adumount.sh /storage/sdcard1

AUTO="/efs /system /cache /preload /data /storage/sdcard1" # Filesystems which should be unmounted automatically when no argument is given, typically every partition excluding images

GOTBUSYBOX=false
GOTMOUNT=false
LOG="/tmp/archidroid_mount.log" # We can use /dev/null if not required

ADMOUNTED() {
	if [ `mount | grep -i "$1" | wc -l` -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

ADUMOUNT() {
	if (ADMOUNTED "$1"); then
		if $GOTBUSYBOX; then
			busybox umount -f "$1" >/dev/null 2>&1
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through busybox umount" >> $LOG
				return 0
			fi
		fi
		if $GOTMOUNT; then
			umount -f "$1" >/dev/null 2>&1
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through umount" >> $LOG
				return 0
			fi
		fi
		# Ok, I give up
		if (ADMOUNTED "$1"); then
			echo "ERROR: Could not unmount $1" >> $LOG
			return 1
		fi
	else
		echo "$1 is already unmounted" >> $LOG
	fi
	return 0
}

if [ ! -z `which busybox` ]; then
	GOTBUSYBOX=true
fi
if [ ! -z `which mount` ]; then
	GOTMOUNT=true
fi
if (! $GOTBUSYBOX && ! $GOTMOUNT); then
	# This should never happen, but safety check is always good
	echo "FATAL ERROR, NO BUSYBOX NEITHER MOUNT" >> $LOG
	exit 1
fi

if [ -z "$1" ]; then
	# No argument given, umount AUTO
	for mnt in $AUTO; do
		ADUMOUNT "$mnt"
	done
else
	ADUMOUNT "$1"
fi

exit 0