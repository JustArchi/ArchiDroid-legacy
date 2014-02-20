#!/sbin/sh

# JustArchi@JustArchi.net

# Used by ArchiDroid for reformatting device-based paths
# Usage: adreformat.sh *path* *fs*, f.e. adreformat /storage/sdcard1 f2fs

# Error codes:
# 0 - All fine, we've unmounted, reformatted, mounted and verified our partition
# 1 - Not enough arguments given
# 2 - No busybox and no mount
# 3 - Invalid filesystem
# 4 - Valid filesystem but no available tool for reformatting this filesystem found
# 5 - We failed to unmount partition prior to reformatting, error skipped during force
# 6 - Invalid path, our guess based on paths below failed
# 7 - We failed reformatting task, check log, this can be a serious problem
# 8 - We failed to mount partition after reformatting


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

GOTBUSYBOX=false
GOTMOUNT=false
FORCE=false

ADMOUNTED() {
	if [ $(mount | grep -i "$1" | wc -l) -gt 0 ]; then
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
				echo "Stage 1: Successfully mounted $1 through busybox mount"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			mount -t auto "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 1: Successfully mounted $1 through mount"
				return 0
			fi
		fi
		# Stage 2, mounted device isn't available in fstab and/or recovery can't mount it without such information. This is typical for f2fs, as fstab has ext4 declared. In addition to Stage 1, we'll provide block path, this should be enough.
		if $GOTBUSYBOX; then
			MNTPATH=$(echo $1 | sed 's/\///g')
			eval "MNTPATH=\$$MNTPATH"
			busybox mount -t auto "$MNTPATH" "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 2: Successfully mounted $1 through busybox mount and $MNTPATH"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			MNTPATH=$(echo $1 | sed 's/\///g')
			eval "MNTPATH=\$$MNTPATH"
			mount -t $auto "$MNTPATH" "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 2: Successfully mounted $1 through mount and $MNTPATH"
				return 0
			fi
		fi
		# Stage 3, we failed using automatic filesystem, so we'll now use full mount command. This is our last chance.
		if $GOTBUSYBOX; then
			MNTPATH=$(echo $1 | sed 's/\///g')
			eval "MNTPATH=\$$MNTPATH"
			busybox mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 3: Successfully mounted $1 through busybox mount, using $fs filesystem and $MNTPATH"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			MNTPATH=$(echo $1 | sed 's/\///g')
			eval "MNTPATH=\$$MNTPATH"
			mount -t "$fs" "$MNTPATH" "$1" >/dev/null 2>&1
			if (ADMOUNTED "$1"); then
				echo "Stage 3: Successfully mounted $1 through mount, using $fs filesystem and $MNTPATH"
				return 0
			fi
		fi
		# Stage 4, we're out of ideas
		echo "Stage 4: ERROR! Could not mount $1"
		if $FORCE; then
			return 0
		else
			exit 8
		fi
	else
		echo "$1 is already mounted"
	fi
	return 0
}

ADUMOUNT() {
	if (ADMOUNTED "$1"); then
		MNTPATH=$(echo $1 | sed 's/\///g')
		eval "MNTPATH=\$$MNTPATH"
		if $GOTBUSYBOX; then
			busybox umount -f "$1" >/dev/null 2>&1
			busybox umount -f "$MNTPATH" >/dev/null 2>&1 # This is required for freeing up block path completely, used for example in reformatting
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through busybox umount"
				return 0
			fi
		fi
		if $GOTMOUNT; then
			umount -f "$1" >/dev/null 2>&1
			umount -f "$MNTPATH" >/dev/null 2>&1 # This is required for freeing up block path completely, used for example in reformatting
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through umount"
				return 0
			fi
		fi
		# Ok, I give up
		echo "ERROR: Could not unmount $1"
		# We're reformatting the device, so this can't happen, unless force is defined
		if $FORCE; then
			return 0
		else
			exit 5
		fi
	else
		echo "$1 is already unmounted"
	fi
	return 0
}

if [ -z "$1" ] || [ -z "$2" ]; then
	# We don't have required arguments, halt
	exit 1
fi

if [ ! -z $(which busybox) ]; then
	GOTBUSYBOX=true
fi
if [ ! -z $(which mount) ]; then
	GOTMOUNT=true
fi
if (! $GOTBUSYBOX && ! $GOTMOUNT); then
	# This should never happen, but safety check is always good
	echo "FATAL ERROR, NO BUSYBOX NEITHER MOUNT"
	exit 2
fi

TOOL=""
EXTRA=""
case "$2" in
	"ext4")
		TOOL="mke2fs"
		EXTRA="-t ext4"
		;;
	"f2fs")
		TOOL="mkfs.f2fs"
		;;
	*)
		# This can't happen
		exit 3
esac

if [ "$3" == "force" ]; then
	# Ouh yeah, this will hurt
	FORCE=true
	echo "WARNING: Force mode has been enabled, prepare for mount/unmount errors!"
fi

# Check if our tool is in fact available
if [ -z $(which $TOOL) ]; then
	exit 4
fi

# Firstly, make sure that device is unmounted
ADUMOUNT "$1"

# Now guess the right path
FORMATPATH=$(echo $1 | sed 's/\///g')
eval "FORMATPATH=\$$FORMATPATH"

# If we're not satisfied with the guess, halt
if [ -z "$FORMATPATH" ]; then
	exit 6
fi

# We made our best to avoid all problems, this is the last step
echo "Reformatting!"

echo
$TOOL $EXTRA $FORMATPATH
echo

if [ $? -ne 0 ]; then
	echo "Something went wrong!"
	exit 7
fi

# Let's try to mount it now
ADMOUNT "$1"
echo "Congratulations! Reformatting of $1 to $2 ended successfully!"

sync
exit 0