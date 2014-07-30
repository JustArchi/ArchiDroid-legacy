#!/tmp/packing/sbin/busybox sh

#### AGNi pureSTOCK (psndna88@gmail.com)
#### AGNi Kernel-Assembler

#### DEFINE AGNi pureSTOCK version info ########################################################################
AGNI_PURESTOCK_VER="3.8.4"
AGNI_PURECM_SELINUX="DISABLED"
DEVICE_MODEL="I9300"
DEVICE_NAME="m0"
BOOT_PARTITION="/dev/block/mmcblk0p5"
AGNI_ASSEMBLER_VER="1.0"
#############################################################################################################
#### DEFINE MKBOOTIMG PARAMETERS (Device specifics) #########################################################
MK_BASE=10000000
MK_RAMADDR=11000000
MK_PAGESIZE=2048
MK_CMDLINE=""
#############################################################################################################

ROM_BUILD_PROP="/system/build.prop"
AGNI_LOG_FILE="/data/.AGNi/AGNi_pureSTOCK_install.log"

ln -s /tmp/bootimgtools /tmp/mkbootimg;
chmod +x /tmp/mkbootimg;

mkdir -p /data/.AGNi
mkdir -p /tmp/extracted
mkdir -p /tmp/bootimg
chmod -R 777 /tmp/packing
chmod -R 777 /tmp/extracted
chmod -R 777 /tmp/bootimg

touch $AGNI_LOG_FILE
chmod 777 $AGNI_LOG_FILE

echo " " > $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
echo "			AGNi pureSTOCK Installer LOG                                 " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "Dated: `date` " >> $AGNI_LOG_FILE
echo "   pureSTOCK version		: v$AGNI_PURESTOCK_VER" >> $AGNI_LOG_FILE
echo "   Kernel Assembler version	: v$AGNI_ASSEMBLER_VER" >> $AGNI_LOG_FILE
echo "   SELINUX status		: $AGNI_PURESTOCK_SELINUX" >> $AGNI_LOG_FILE
echo "   Target device model(s)	: $DEVICE_MODEL" >> $AGNI_LOG_FILE
echo "   Target device name(s)	: $DEVICE_NAME" >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "ROM BUILD INFO :-" >> $AGNI_LOG_FILE
echo "  `grep ro.build.user $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.host $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.date= $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.display.id $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.version.release $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.product.model $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.product.device= $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE

mkdir -p /tmp/extracted/dev
mkdir -p /tmp/extracted/data
mkdir -p /tmp/extracted/proc
mkdir -p /tmp/extracted/sys
mkdir -p /tmp/extracted/system
mkdir -p /tmp/extracted/preload
mkdir -p /tmp/extracted/cache
cp -rf /tmp/packing/* /tmp/extracted
cd /tmp/extracted/sbin; ln -s ../init ueventd; ln -s ../init watchdogd;
cd /tmp/extracted/sbin; ln -s busybox sh;
cd /tmp/extracted/sbin; ln -s busybox mount;
cd /tmp/extracted/sbin; ln -s mount.exfat fsck.exfat; ln -s mount.exfat mkfs.exfat;
chmod 644 /tmp/extracted/*
chmod 777 /tmp/extracted/init
chmod -R 777 /tmp/extracted/res
chmod -R 777 /tmp/extracted/sbin
chmod -R 775 /tmp/extracted/lib
echo " RAMDISK has been prepared successfully ! " >> $AGNI_LOG_FILE

echo "  " >> $AGNI_LOG_FILE
echo " Packing AGNi RAMDISK... " >> $AGNI_LOG_FILE
cd /tmp/extracted; find . | cpio -o -H newc | gzip > /tmp/bootimg/ramdisk.gz;
echo " Packed AGNi RAMDISK ! " >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/bootimg/zImage`" >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/bootimg/ramdisk.gz`" >> $AGNI_LOG_FILE

echo "   " >> $AGNI_LOG_FILE
echo " Assembling AGNi boot.img for flashing... " >> $AGNI_LOG_FILE
chmod 644 /tmp/bootimg/*
/tmp/mkbootimg --kernel /tmp/bootimg/zImage --ramdisk /tmp/bootimg/ramdisk.gz --base $MK_BASE --ramdiskaddr $MK_RAMADDR --pagesize $MK_PAGESIZE --cmdline "$MK_CMDLINE" -o /tmp/boot.img;
chmod 644 /tmp/boot.img
echo " AGNi boot.img ready to flash ! " >> $AGNI_LOG_FILE
echo "		base		: $MK_BASE " >> $AGNI_LOG_FILE
echo "		ramdiskaddr	: $MK_RAMADDR " >> $AGNI_LOG_FILE
echo "		pagesize	: $MK_PAGESIZE " >> $AGNI_LOG_FILE
echo "		cmdline		: $MK_CMDLINE " >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/boot.img`" >> $AGNI_LOG_FILE

##### Optional placing copy of boot.img  ###########################################################
if [ -f /data/.AGNi/copy_bootimg ];
	then
	mkdir -p /data/.AGNi/pureSTOCK_boot.img_copy
	rm /data/.AGNi/pureSTOCK_boot.img_copy/boot.img
	cp /tmp/boot.img /data/.AGNi/pureSTOCK_boot.img_copy/boot.img
	chmod -R 777 /data/.AGNi
	echo " Placed copy of boot.img !  " >> $AGNI_LOG_FILE
	echo "	=====>	Size: `du -h /data/.AGNi/pureSTOCK_boot.img_copy/boot.img`" >> $AGNI_LOG_FILE
fi
echo "   " >> $AGNI_LOG_FILE
echo " END OF LOG. Dated: `date` " >> $AGNI_LOG_FILE
echo "   " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
#############################################################################################################
