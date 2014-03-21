#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Used by ArchiDroid for providing universal device-based paths
# Usage: adumount.sh *path*, f.e. adumount.sh /storage/sdcard1

# These are absolute paths without slashes, for example /storage/sdcard1 is storagesdcard1, because you can't use / in variables
efs="/dev/block/mmcblk0p3" # EFS, if available
boot="/dev/block/mmcblk0p5" # ROM's kernel image
recovery="/dev/block/mmcblk0p6" # Recovery image
radio="/dev/block/mmcblk0p7" # Modem image
cache="/dev/block/mmcblk0p8" # Cache partition
system="/dev/block/mmcblk0p9" # System partition
preload="/dev/block/mmcblk0p10" # Preload partition (also SELinux)
data="/dev/block/mmcblk0p12" # Data and internal memory
storagesdcard1="/dev/block/mmcblk1p1" # External memory, if available
AUTO="/efs /system /cache /preload /data /storage/sdcard1" # Filesystems which should be unmounted automatically when no argument is given, typically every partition excluding images

GOTBUSYBOX=false
GOTMOUNT=false
LOG="/tmp/archidroid_mount.log" # We can use /dev/null if not required

ADMOUNTED() {
	if [ $(mount | grep -i "$1" | wc -l) -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

ADUMOUNT() {
	if (ADMOUNTED "$1"); then
		MNTPATH=$(echo $1 | sed 's/\///g')
		eval "MNTPATH=\$$MNTPATH"
		if $GOTBUSYBOX; then
			busybox umount -f "$1" >/dev/null 2>&1
			busybox umount -f "$MNTPATH" >/dev/null 2>&1 # This is required for freeing up block path completely, used for example in reformatting
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through busybox umount" >> $LOG
				return 0
			fi
		fi
		if $GOTMOUNT; then
			umount -f "$1" >/dev/null 2>&1
			umount -f "$MNTPATH" >/dev/null 2>&1 # This is required for freeing up block path completely, used for example in reformatting
			if !(ADMOUNTED "$1"); then
				echo "Successfully unmounted $1 through umount" >> $LOG
				return 0
			fi
		fi
		# Ok, I give up
		echo "ERROR: Could not unmount $1" >> $LOG
		return 1
	else
		echo "$1 is already unmounted" >> $LOG
	fi
	return 0
}

if [ ! -z $(which busybox) ]; then
	GOTBUSYBOX=true
fi
if [ ! -z $(which mount) ]; then
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

sync
exit 0