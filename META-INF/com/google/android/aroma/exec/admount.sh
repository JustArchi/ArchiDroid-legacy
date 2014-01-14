#!/sbin/sh

# JustArchi@JustArchi.net

# Used by ArchiDroid for providing universal device-based paths
# Usage: admount.sh *path*, f.e. admount.sh /storage/sdcard1

# These are absolute paths without slashes, for example /storage/sdcard1 is storagesdcard1, because you can't use / in variables
fs="ext4" # Filesystem
efs="/dev/block/mmcblk0p3" # EFS, if available
boot="/dev/block/mmcblk0p5" # ROM's kernel image
recovery="/dev/block/mmcblk0p6" # Recovery image
radio="/dev/block/mmcblk0p7" # Modem image
cache="/dev/block/mmcblk0p8" # Cache partition
system="/dev/block/mmcblk0p9" # System partition
preload="/dev/block/mmcblk0p10" # Preload partition (also SELinux)
data="/dev/block/mmcblk0p12" # Data and internal memory
storagesdcard1="/dev/block/mmcblk1p1" # External memory, if available
AUTO="/efs /system /cache /preload /data /storage/sdcard1" # Filesystems which should be mounted automatically when no argument is given, typically every partition excluding images

GOTBUSYBOX=false
GOTMOUNT=false

ADMOUNTED() {
	if [ `mount | grep -i "$1" | wc -l` -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

ADMOUNT() {
	if !(ADMOUNTED "$1"); then
		# Automatic filesystem
		if $GOTBUSYBOX; then
			busybox mount -t auto "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Mounted $1 through automatic busybox mount"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			mount -t auto "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Mounted $1 through automatic mount"
				return 0
			fi
		fi
		# Still not mounted?
		if !(ADMOUNTED "$1"); then
			# OK, fallback to predefined values then
			if $GOTBUSYBOX; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				busybox mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Mounted $1 through predefined busybox mount using $fs and $MNTPATH"
					return 0
				fi
			fi
			if $GOTMOUNT; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Mounted "$1" through predefined mount using $fs and $MNTPATH"
					return 0
				fi
			fi
		fi
		# Ok, I give up
		if !(ADMOUNTED "$1"); then
			echo "Could not mount $1"
			return 1
		fi
	else
		echo "$1 is already mounted"
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
	# No argument given, mount AUTO
	for mnt in $AUTO; do
		if [ ! -z "$mnt" ]; then
			ADMOUNT "$mnt"
		fi
	done
else
	ADMOUNT "$1"
fi

exit 0