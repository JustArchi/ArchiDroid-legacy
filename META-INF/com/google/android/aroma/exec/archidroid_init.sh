#!/sbin/sh

# Mounts
# Used by ArchiDroid for providing universal device-based paths
fs="ext4" # Filesystem of blocks
efs="/dev/block/mmcblk0p3" # Ultra important, USED
boot="/dev/block/mmcblk0p5" # ROM's kernel image, not used
recovery="/dev/block/mmcblk0p6" # Recovery image, not used
radio="/dev/block/mmcblk0p7" # Modem image, not USED
cache="/dev/block/mmcblk0p8" # Temporary cache, not used
system="/dev/block/mmcblk0p9" # Main system partition, used
preload="/dev/block/mmcblk0p10" # Preload, SELinux, not used
data="/dev/block/mmcblk0p12" # Internal SD Card, USED
extsd="/dev/block/mmcblk1p1" # External SD Card, not used

AD="/data/media/0/ArchiDroid"

# Prepare all used mounts
# Firstly try to mount automatically, eventually fallback to predefined blocks
mount -t auto /data > /dev/null 2>&1
mount -t $fs $data /data > /dev/null 2>&1
mount -t auto /efs > /dev/null 2>&1
mount -t $fs $efs /efs > /dev/null 2>&1
mount -t auto /system > /dev/null 2>&1
mount -t $fs $system /system > /dev/null 2>&1

# Init
mkdir -p $AD
mkdir -p $AD/AromaPreset/1.X

exit 0