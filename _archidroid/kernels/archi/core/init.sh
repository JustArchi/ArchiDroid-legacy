#!/sbin/sh

#     _             _     _ _  __                    _
#    / \   _ __ ___| |__ (_) |/ /___ _ __ _ __   ___| |
#   / _ \ | '__/ __| '_ \| | ' // _ \ '__| '_ \ / _ \ |
#  / ___ \| | | (__| | | | | . \  __/ |  | | | |  __/ |
# /_/   \_\_|  \___|_| |_|_|_|\_\___|_|  |_| |_|\___|_|
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

set -e

KERNEL="/dev/block/mmcblk0p5" # THIS IS FOR SAMSUNG GALAXY S3 I9300 ONLY
AK="/tmp/archikernel"
AKDROP="$AK/drop"

exec 1>"$AK/ArchiKernel.log"
exec 2>&1

date
echo "ArchiKernel flasher ready!"
echo "Safety check: ON, flasher will immediately terminate in case of ANY error"

if [ ! -f "$AK/mkbootimg-static" -o ! -f "$AK/unpackbootimg-static" ]; then
	echo "FATAL ERROR: No bootimg tools?!"
	exit 1
else
	chmod 755 "$AK/mkbootimg-static" "$AK/unpackbootimg-static"
fi

echo "Pulling boot.img from $KERNEL"
if [ ! -z "$(which dump_image)" ]; then
	dump_image "$KERNEL" "$AK/boot.img"
else
	dd if="$KERNEL" of="$AK/boot.img"
fi

mkdir -p "$AKDROP"
echo "Unpacking pulled boot.img"
"$AK/unpackbootimg-static" -i "$AK/boot.img" -o "$AKDROP"
echo "Combining ArchiKernel zImage and current kernel ramdisk"
"$AK/mkbootimg-static" \
	--kernel "$AK/zImage" \
	--ramdisk "$AKDROP/boot.img-ramdisk.gz" \
	--cmdline "$(cat $AKDROP/boot.img-cmdline)" \
	--board "$(cat $AKDROP/boot.img-board)" \
	--base "$(cat $AKDROP/boot.img-base)" \
	--pagesize "$(cat $AKDROP/boot.img-pagesize)" \
	--kernel_offset "$(cat $AKDROP/boot.img-kerneloff)" \
	--ramdisk_offset "$(cat $AKDROP/boot.img-ramdiskoff)" \
	--tags_offset "$(cat $AKDROP/boot.img-tagsoff)" \
	--output "$AK/newboot.img"

echo "newboot.img ready!"

echo "FLASHING newboot.img on $KERNEL"
if [ ! -z "$(which flash_image)" ]; then
	flash_image "$KERNEL" "$AK/newboot.img"
else
	dd if="$AK/newboot.img" of="$KERNEL"
fi

echo "Everything finished successfully!"
touch "$AK/_OK"
date

sync
exit 0
