#!/tmp/packing/sbin/busybox sh

#### AGNi pureCM (psndna88@gmail.com)
#### AGNi Kernel-Patcher (based on original implementation for GT-S5830)

#### DEFINE AGNi pureCM version info ########################################################################
AGNI_PURECM_VER="2.8.3"
AGNI_PURECM_SELINUX="PERMISSIVE"
DEVICE_MODEL="I9300"
DEVICE_NAME="m0"
BOOT_PARTITION="/dev/block/mmcblk0p5"
AGNI_PATCHER_VER="4.3.4"
#############################################################################################################
#### DEFINE MKBOOTIMG PARAMETERS (Device specifics) #########################################################
MK_BASE=40000000
MK_RAMADDR=41000000
MK_PAGESIZE=2048
MK_CMDLINE="console=ttySAC2,115200"
#############################################################################################################

ROM_BUILD_PROP="/system/build.prop"
AGNI_LOG_FILE="/data/.AGNi/AGNi_pureCM_install.log"

ln -s /tmp/bootimgtools /tmp/mkbootimg;
ln -s /tmp/bootimgtools /tmp/unpack_bootimg;
chmod +x /tmp/mkbootimg;
chmod +x /tmp/unpack_bootimg;

mkdir -p /data/.AGNi
mkdir -p /tmp/oldboot
mkdir -p /tmp/extracted
mkdir -p /tmp/workboot
mkdir -p /tmp/bootimg
chmod -R 777 /tmp/packing
chmod -R 777 /tmp/oldboot
chmod -R 777 /tmp/workboot
chmod -R 777 /tmp/extracted
chmod -R 777 /tmp/bootimg

RAMFS_EXTRACT_FAIL="0"
touch $AGNI_LOG_FILE
chmod 777 $AGNI_LOG_FILE

echo " " > $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
echo "			AGNi pureCM Installer LOG                                 " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "Dated: `date` " >> $AGNI_LOG_FILE
echo "   pureCM version		: v$AGNI_PURECM_VER" >> $AGNI_LOG_FILE
echo "   Kernel Patcher version	: v$AGNI_PATCHER_VER" >> $AGNI_LOG_FILE
echo "   SELINUX status		: $AGNI_PURECM_SELINUX" >> $AGNI_LOG_FILE
echo "   Target device model(s)	: $DEVICE_MODEL" >> $AGNI_LOG_FILE
echo "   Target device name(s)	: $DEVICE_NAME" >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE
echo "ROM BUILD INFO :-" >> $AGNI_LOG_FILE
echo "  `grep ro.cm.version $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.modversion $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.cm.display.version $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.user $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.host $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.date= $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.display.id $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.build.version.release $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.product.model $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.product.device= $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo "  `grep ro.cm.device $ROM_BUILD_PROP` " >> $AGNI_LOG_FILE
echo " " >> $AGNI_LOG_FILE

echo " Extracting existing flashed boot.img... " >> $AGNI_LOG_FILE
dd if=$BOOT_PARTITION of=/tmp/oldboot/boot.img bs=$MK_PAGESIZE;
echo " Extracted existing flashed boot.img ! " >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/oldboot/boot.img`" >> $AGNI_LOG_FILE

echo " Extracting contents of existing flashed boot.img... " >> $AGNI_LOG_FILE
/tmp/unpack_bootimg -i /tmp/oldboot/boot.img -o /tmp/oldboot;
mv /tmp/oldboot/boot.img-zImage /tmp/oldboot/old_zImage
mv /tmp/oldboot/boot.img-ramdisk.gz /tmp/oldboot/old_ramdisk.gz
echo " Extracted contents of existing flashed boot.img ! " 	>> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/oldboot/old_zImage`" >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/oldboot/old_ramdisk.gz`" >> $AGNI_LOG_FILE

echo " Extracting RAMDISK from existing flashed kernel... " >> $AGNI_LOG_FILE
cd /tmp/extracted; gunzip -c /tmp/oldboot/old_ramdisk.gz | cpio -i || RAMFS_EXTRACT_FAIL=1
if ! [ "$RAMFS_EXTRACT_FAIL" == "1" ];
	then
	echo " Extracted RAMDISK from existing flashed kernel ! " >> $AGNI_LOG_FILE
	else
	echo " Extracting RAMDISK Failed, unsupported & non-standard ramdisk ! " >> $AGNI_LOG_FILE && exit 1
fi

echo " Checking RAMDISK for conflicting contents... " >> $AGNI_LOG_FILE
if [ -d /tmp/extracted/res ] || [ -f /tmp/extracted/sbin/busybox ] || [ "`ls /tmp/extracted/sbin | grep .sh`" ];
	then
	rm -rf /tmp/extracted/res
	mkdir -p /tmp/extracted/sbin-TEMP
	cp /tmp/extracted/sbin/adbd /tmp/extracted/sbin-TEMP
	cp /tmp/extracted/sbin/cbd /tmp/extracted/sbin-TEMP
	cp /tmp/extracted/sbin/healthd /tmp/extracted/sbin-TEMP
	rm -rf /tmp/extracted/sbin/*
	cp /tmp/extracted/sbin-TEMP/* /tmp/extracted/sbin/
	rm -rf /tmp/extracted/sbin-TEMP
	echo " Removed possibly conflicting contents from RAMDISK ! " >> $AGNI_LOG_FILE
	else
	echo " No conflicting contents found ! " >> $AGNI_LOG_FILE
fi

echo " Modifying RAMDISK from existing flashed kernel... " >> $AGNI_LOG_FILE
if ! [ "`grep quick_boot.sh /tmp/extracted/init.rc`" ];
	then
	patch /tmp/extracted/init.rc -i /tmp/workboot/init.rc.patch;
	echo " Applied modification 1 to init.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep psnconfig.sh /tmp/extracted/init.rc`" ];
	then
	echo "`cat /tmp/workboot/init-append`" >> /tmp/extracted/init.rc
	echo " Applied modification 2 to init.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep init.agnimounts.rc /tmp/extracted/init.rc`" ];
	then
        awk '/init.usb.rc/{print "import /init.agnimounts.rc"} {print}' /tmp/extracted/init.rc > /tmp/extracted/init.rc-temp
	mv /tmp/extracted/init.rc-temp /tmp/extracted/init.rc
	echo " Applied modification 3 to init.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep fstab_handler.sh /tmp/extracted/init.smdk4x12.rc`" ];
	then
	awk '/mount_all/{print;print "	exec /sbin/fstab_handler.sh";next}1' /tmp/extracted/init.smdk4x12.rc > /tmp/extracted/init.smdk4x12.rc-temp
	mv /tmp/extracted/init.smdk4x12.rc-temp /tmp/extracted/init.smdk4x12.rc
	if [ "`grep init.agnimounts.rc /tmp/extracted/init.smdk4x12.rc`" ];
		then
		sed '/init.agnimounts.rc/d' /tmp/extracted/init.smdk4x12.rc > /tmp/extracted/init.smdk4x12.rc-temp
		mv /tmp/extracted/init.smdk4x12.rc-temp /tmp/extracted/init.smdk4x12.rc
	fi
	echo " Applied modification 1 to init.smdk4x12.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep AGNi-Set-SELINUX-PERMISSIVE /tmp/extracted/init.smdk4x12.rc`" ];
	then
	echo "`cat /tmp/workboot/init.smdk4x12-append`" >> /tmp/extracted/init.smdk4x12.rc
	echo " Applied modification 2 to init.smdk4x12.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep AGNI /tmp/extracted/fstab.smdk4x12`" ];
	then
	awk '/mmcblk0p9/{print "# AGNI_SYSTEM"} {print}' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	awk '/mmcblk0p12/{print "# AGNI_DATA"} {print}' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	awk '/mmcblk0p8/{print "# AGNI_CACHE"} {print}' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	awk '/mmcblk0p10/{print "# AGNI_PRELOAD"} {print}' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	sed '/mmcblk0p9/d' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	sed '/mmcblk0p12/d' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	sed '/mmcblk0p8/d' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	sed '/mmcblk0p10/d' /tmp/extracted/fstab.smdk4x12 > /tmp/extracted/fstab.smdk4x12-temp
	mv /tmp/extracted/fstab.smdk4x12-temp /tmp/extracted/fstab.smdk4x12
	echo " Applied modifications to fstab.smdk4x12 ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep f2fs /tmp/extracted/lpm.rc`" ];
	then
	awk '/mmcblk0p9/{print "    mount f2fs /dev/block/mmcblk0p9 /system ro wait noatime nodiratime inline_xattr active_logs=2"} {print}' /tmp/extracted/lpm.rc > /tmp/extracted/lpm.rc-temp
	mv /tmp/extracted/lpm.rc-temp /tmp/extracted/lpm.rc
	awk '/mmcblk0p12/{print "    mount f2fs /dev/block/mmcblk0p12 /data wait noatime nosuid nodev nodiratime inline_xattr active_logs=2"} {print}' /tmp/extracted/lpm.rc > /tmp/extracted/lpm.rc-temp
	mv /tmp/extracted/lpm.rc-temp /tmp/extracted/lpm.rc
	echo " Applied modification to lpm.rc ! " >> $AGNI_LOG_FILE
fi
if ! [ "`grep AGNi-Modified-conditional-sysinit /system/bin/sysinit`" ];
	then
	echo "`cat /tmp/workboot/system-sysinit-replace`" > /system/bin/sysinit
	echo " Applied modification to /system/bin/sysinit ! " >> $AGNI_LOG_FILE
fi
#if [ "`grep f2fs /proc/mounts`" ];
#	then
#	if [ "`grep omni $ROM_BUILD_PROP`" ] || [ "`grep slim $ROM_BUILD_PROP`" ];
#		then
#		mv -f /tmp/workboot/sepolicy /tmp/extracted/sepolicy
#		echo " Replaced sepolicy. " >> $AGNI_LOG_FILE
#	fi
#fi

mkdir -p /tmp/extracted/dev
mkdir -p /tmp/extracted/proc
mkdir -p /tmp/extracted/sys
mkdir -p /tmp/extracted/system
mkdir -p /tmp/extracted/preload
mkdir -p /tmp/extracted/cache
cp -rf /tmp/packing/* /tmp/extracted
cd /tmp/extracted/sbin; ln -s ../init ueventd; ln -s ../init watchdogd;
cd /tmp/extracted/sbin; ln -s busybox sh;
cd /tmp/extracted/sbin; ln -s mount.exfat fsck.exfat; ln -s mount.exfat mkfs.exfat;
chmod 644 /tmp/extracted/*
chmod 777 /tmp/extracted/init
chmod -R 777 /tmp/extracted/res
chmod -R 777 /tmp/extracted/sbin
echo " RAMDISK has been modified successfully ! " >> $AGNI_LOG_FILE

echo "  " >> $AGNI_LOG_FILE
echo " Packing AGNi-PATCHED RAMDISK... " >> $AGNI_LOG_FILE
cd /tmp/extracted; find . | cpio -o -H newc | gzip > /tmp/bootimg/patched-ramdisk.gz;
mv /tmp/bootimg/zImage /tmp/bootimg/new-zImage
echo " Packed AGNi-PATCHED RAMDISK ! " >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/bootimg/new-zImage`" >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/bootimg/patched-ramdisk.gz`" >> $AGNI_LOG_FILE

echo "   " >> $AGNI_LOG_FILE
echo " Assembling AGNi-PATCHED boot.img for flashing... " >> $AGNI_LOG_FILE
chmod 644 /tmp/bootimg/*
/tmp/mkbootimg --kernel /tmp/bootimg/new-zImage --ramdisk /tmp/bootimg/patched-ramdisk.gz --base $MK_BASE --ramdiskaddr $MK_RAMADDR --pagesize $MK_PAGESIZE --cmdline "$MK_CMDLINE" -o /tmp/boot.img;
chmod 644 /tmp/boot.img
echo " AGNi-PATCHED boot.img ready to flash ! " >> $AGNI_LOG_FILE
echo "		base		: $MK_BASE " >> $AGNI_LOG_FILE
echo "		ramdiskaddr	: $MK_RAMADDR " >> $AGNI_LOG_FILE
echo "		pagesize	: $MK_PAGESIZE " >> $AGNI_LOG_FILE
echo "		cmdline		: $MK_CMDLINE " >> $AGNI_LOG_FILE
echo "	=====>	Size: `du -h /tmp/boot.img`" >> $AGNI_LOG_FILE

##### Optional placing copy of old and new patched boot.imgs  ###############################################
if [ -f /data/.AGNi/copy_bootimg ];
	then
	mkdir -p /data/.AGNi/unpatched_boot.img_copy
	mkdir -p /data/.AGNi/patched_boot.img_copy
	rm /data/.AGNi/unpatched_boot.img_copy/boot.img
	rm /data/.AGNi/patched_boot.img_copy/boot.img
	cp /tmp/oldboot/boot.img /data/.AGNi/unpatched_boot.img_copy/boot.img
	cp /tmp/boot.img /data/.AGNi/patched_boot.img_copy/boot.img
	chmod -R 777 /data/.AGNi
	echo " Placed copy of old and new patched boot.imgs !  " >> $AGNI_LOG_FILE
	echo "	=====>	Size: `du -h /data/.AGNi/unpatched_boot.img_copy/boot.img`" >> $AGNI_LOG_FILE
	echo "	=====>	Size: `du -h /data/.AGNi/patched_boot.img_copy/boot.img`" >> $AGNI_LOG_FILE
fi
echo "   " >> $AGNI_LOG_FILE
echo " END OF LOG. Dated: `date` " >> $AGNI_LOG_FILE
echo "   " >> $AGNI_LOG_FILE
echo "############################################################################" >> $AGNI_LOG_FILE
#############################################################################################################
