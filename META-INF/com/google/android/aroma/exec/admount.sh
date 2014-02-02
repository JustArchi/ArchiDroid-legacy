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
LOG="/tmp/archidroid_mount.log" # We can use /dev/null if not required

ADMOUNTED() {
	if [ `mount | grep -i "$1" | wc -l` -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

ADMOUNT() {
	if !(ADMOUNTED "$1"); then
		mkdir -p "$1"
		# Stage 1, let's use automatic filesystem and block path, as recovery should have valid fstab file. This will be enough in most scenarios.
		if $GOTBUSYBOX; then
			busybox mount -t auto "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 1: Successfully mounted $1 through busybox mount" >> $LOG
				return 0
			fi
		fi
		if $GOTMOUNT; then
			mount -t auto "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 1: Successfully mounted $1 through mount" >> $LOG
				return 0
			fi
		fi
		# Stage 2, mounted device isn't available in fstab and/or recovery can't mount it without such information. This is typical for f2fs, as fstab has ext4 declared. In addition to Stage 1, we'll provide block path, this should be enough.
		if !(ADMOUNTED "$1"); then
			if $GOTBUSYBOX; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				busybox mount -t auto "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Stage 2: Successfully mounted $1 through busybox mount and $MNTPATH" >> $LOG
					return 0
				fi
			fi
			if $GOTMOUNT; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				mount -t $auto "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Stage 2: Successfully mounted $1 through mount and $MNTPATH" >> $LOG
					return 0
				fi
			fi
		fi
		# Stage 3, we failed using automatic filesystem, so we'll now use full mount command. This is our last chance.
		if !(ADMOUNTED "$1"); then
			if $GOTBUSYBOX; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				busybox mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Stage 3: Successfully mounted $1 through busybox mount, using $fs filesystem and $MNTPATH" >> $LOG
					return 0
				fi
			fi
			if $GOTMOUNT; then
				MNTPATH=`echo $1 | sed 's/\///g'`
				eval "MNTPATH=\$$MNTPATH"
				mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
				if (ADMOUNTED "$1"); then
					echo "Stage 3: Successfully mounted $1 through mount, using $fs filesystem and $MNTPATH" >> $LOG
					return 0
				fi
			fi
		fi
		# Stage 4, we're out of ideas
		if !(ADMOUNTED "$1"); then
			echo "Stage 4: ERROR! Could not mount $1" >> $LOG
			return 1
		fi
	else
		echo "$1 is already mounted" >> $LOG
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
	# No argument given, mount AUTO
	for mnt in $AUTO; do
		ADMOUNT "$mnt"
	done
else
	ADMOUNT "$1"
fi

exit 0