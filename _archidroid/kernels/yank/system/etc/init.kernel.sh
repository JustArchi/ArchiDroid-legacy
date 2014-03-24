#!/system/bin/sh
#--------------------------------------------------
# Yank555.lu - generated kernel options init script
#--------------------------------------------------

log_file="/data/kernel-boot.log"

echo "----------------------------------------------------" >$log_file
echo "Yank555.lu - execution of kernel options init script" >>$log_file
echo "----------------------------------------------------" >>$log_file
echo "Kernel version : `uname -a`" >>$log_file

echo `date +"%F %R:%S : Waiting for Android to start..."` >>$log_file

# Wait until we see some android processes to consider boot is more or less complete (credits to AndiP71)
while ! /sbin/pgrep com.android ; do
  sleep 1
done

echo `date +"%F %R:%S : Android is starting up, let's wait another 10 seconds..."` >>$log_file

# Now that is checked, let's just wait another tiny little bit
sleep 10

echo `date +"%F %R:%S : Starting kernel configuration..."` >>$log_file

# Script generated on 24/03/2014 at 17:40
#----------------------------------------------------

# - Enabled init.d scripts support by kernel/ramdisk
echo `date +"%F %R:%S : Init.d script execution support enabled."` >>$log_file
mount -o remount,rw /system
chgrp -R 2000 /system/etc/init.d
chmod -R 755 /system/etc/init.d
mount -o remount,ro /system
echo `date +"%F %R:%S : Init.d scripts permissions reset to 0:2000 755."` >>$log_file
ls -al /system/etc/init.d >>$log_file
echo `date +"%F %R:%S : Init.d starting execution..."` >>$log_file
/system/xbin/busybox run-parts /system/etc/init.d
echo `date +"%F %R:%S : Init.d execution finished."` >>$log_file

# - Set governor to zzmoove
echo "zzmoove" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo `date +"%F %R:%S : CPU governor set to zzmoove."` >>$log_file

# - Enable touchboost
echo "1" > /sys/devices/virtual/misc/touchboost_switch/touchboost_switch
echo "600000" > /sys/devices/virtual/misc/touchboost_switch/touchboost_freq
echo `date +"%F %R:%S : Touchboost enabled at 600MHz."` >>$log_file

# - CPU Idle Mode
echo "2" > /sys/module/cpuidle_exynos4/parameters/enable_mask
echo `date +"%F %R:%S : CPU Idle mode set to Idle + LPA."` >>$log_file

# - Multicore Powersave Mode
echo "0" > /sys/devices/system/cpu/sched_mc_power_savings
echo `date +"%F %R:%S : CPU Multicore Powersave mode set to Off."` >>$log_file

# - Set CPU max frequencies for all 4 cores
echo 1600000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo `date +"%F %R:%S : CPU max. frequency set to 1.6GHz."` >>$log_file

# - zzmoove ZaneZam battery plus profile
echo "5" > /sys/devices/system/cpu/cpufreq/zzmoove/profile_number
echo `date +"%F %R:%S : zzmoove - ZaneZam battery plus profile."` >>$log_file

# - Set CPU max frequency in standby
echo `date +"%F %R:%S : zzmoove - keep profile setting for CPU max. in standby."` >>$log_file

# use profile for fast scaling up when screen is on
echo `date +"%F %R:%S : zzmoove - keep profile setting for fast scaling up when screen on."` >>$log_file

# use profile for fast scaling down when screen is on
echo `date +"%F %R:%S : zzmoove - keep profile setting for fast scaling down when screen on."` >>$log_file

# use profile for fast scaling up when screen is off
echo `date +"%F %R:%S : zzmoove - keep profile setting for fast scaling up when screen off."` >>$log_file

# use profile for fast scaling down when screen is off
echo `date +"%F %R:%S : zzmoove - keep profile setting for fast scaling down when screen off."` >>$log_file

# - zRam activation - 200Mb
if [ -e /sys/block/zram0/disksize ] ; then

  swapoff /dev/block/zram0
  swapoff /dev/block/zram1
  swapoff /dev/block/zram2
  swapoff /dev/block/zram3

  echo 1 > /sys/block/zram0/reset
  echo 1 > /sys/block/zram1/reset
  echo 1 > /sys/block/zram2/reset
  echo 1 > /sys/block/zram3/reset

  echo 52428800 > /sys/block/zram0/disksize
  echo 52428800 > /sys/block/zram1/disksize
  echo 52428800 > /sys/block/zram2/disksize
  echo 52428800 > /sys/block/zram3/disksize

  mkswap /dev/block/zram0
  mkswap /dev/block/zram1
  mkswap /dev/block/zram2
  mkswap /dev/block/zram3

  swapon -p 2 /dev/block/zram0
  swapon -p 2 /dev/block/zram1
  swapon -p 2 /dev/block/zram2
  swapon -p 2 /dev/block/zram3
  
fi
echo `date +"%F %R:%S : 200Mb (4x50Mb) Zram Support enabled."` >>$log_file

# - Hardswap by Yank555.lu not installed
echo `date +"%F %R:%S : Hardswap Support disabled."` >>$log_file

# - swappiness set to 80
echo 80 > /proc/sys/vm/swappiness;
echo `date +"%F %R:%S : Swappiness set to 80."` >>$log_file

# - Disable USB forced fast charge
echo 0 > /sys/kernel/fast_charge/force_fast_charge
echo `date +"%F %R:%S : Fast Charge - disabled."` >>$log_file
echo 475 > /sys/kernel/fast_charge/usb_charge_level
echo `date +"%F %R:%S : Fast Charge - USB charge level set to 475mA/h."` >>$log_file
echo 1000 > /sys/kernel/fast_charge/ac_charge_level
echo `date +"%F %R:%S : Fast Charge - AC charge level set to 1000mA/h."` >>$log_file

echo 475 > /sys/kernel/fast_charge/wireless_charge_level
echo `date +"%F %R:%S : Fast Charge - Wireless charge level set to 475mA/h."` >>$log_file
# - Disable early suspend delay
#     When turning off the screen, don't wait for any kind of CRT animation.
echo 0 > /sys/kernel/early_suspend/early_suspend_delay
echo `date +"%F %R:%S : Early Suspend Delay set to 0ms."` >>$log_file

# - Enable dynamic deferred file sync (by faux123)
#     While screen is on, file sync is temporarily deferred, when screen
#     is turned off, a flush is called to synchronize all outstanding writes.
echo 1 > /sys/kernel/dyn_fsync/Dyn_fsync_active
echo `date +"%F %R:%S : Dynamic Deferred File Sync enabled."` >>$log_file

# - Disable touch wake
echo 0 > /sys/class/misc/touchwake/disabled
echo `date +"%F %R:%S : Touch Wake disabled."` >>$log_file

# - Enable fading notification LED
echo 1 > /sys/class/sec/led/led_fade
echo `date +"%F %R:%S : Notification LED set to fading mode."` >>$log_file

# - Enable notification LED with high intensity
echo 128 > /sys/class/sec/led/led_intensity
echo `date +"%F %R:%S : Notification LED set to high intensity."` >>$log_file

# - Enable notification LED blinking/fading at normal speed
echo 1 > /sys/class/sec/led/led_speed
echo `date +"%F %R:%S : Notification LED set to blinking/fading at normal speed."` >>$log_file

# - Enable notification LED fading in and out
echo "1 1 1 1" > /sys/class/sec/led/led_slope
echo `date +"%F %R:%S : Notification LED fading style to fading in and out."` >>$log_file

# - Do not load CIFS kernel modules on boot
echo `date +"%F %R:%S : CIFS kernel modules not loaded."` >>$log_file

# - Do not load NFS kernel modules on boot
echo `date +"%F %R:%S : NFS kernel modules not loaded."` >>$log_file

# - Do not load ntfs kernel module on boot
echo `date +"%F %R:%S : NTFS kernel module not loaded."` >>$log_file

# - Do not load isofs kernel module on boot
echo `date +"%F %R:%S : ISOFS kernel module not loaded."` >>$log_file

# - Do not load UDF kernel module on boot
echo `date +"%F %R:%S : UDF kernel module not loaded."` >>$log_file

# - Do not load XBOX 360 gamepad kernel module on boot
echo `date +"%F %R:%S : XBOX 360 gamepad support kernel module not loaded."` >>$log_file

# - Load frandom kernel module on boot
insmod /lib/modules/frandom.ko
echo `date +"%F %R:%S : frandom kernel module loaded."` >>$log_file

# Wait for everything to become ready
echo `date +"%F %R:%S : Waiting 60 seconds..."` >>$log_file
sleep 60
# Internal MMC readahead buffer size
echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
echo `date +"%F %R:%S : Internal MMC Readahead set to 512Kb."` >>$log_file

# Internal MMC I/O scheduler
echo "row" > /sys/block/mmcblk0/queue/scheduler
echo `date +"%F %R:%S : Internal MMC scheduler set to ROW."` >>$log_file

# SD card readahead buffer size
echo 1024 > /sys/block/mmcblk1/bdi/read_ahead_kb
echo `date +"%F %R:%S : External MMC Readahead set to 1024Kb."` >>$log_file

# SD card I/O scheduler
echo "cfq" > /sys/block/mmcblk1/queue/scheduler
echo `date +"%F %R:%S : External MMC scheduler set to CFQ."` >>$log_file

# - Set Android Low Memory Killer to Stock SGS3 +10Mb (in number of pages of 4Kbytes)
#     Forground apps    : 10752 pages / 42Mb
#     Visible apps      : 12800 pages / 50Mb
#     Secondary server  : 14848 pages / 58Mb
#     Hidden apps       : 16896 pages / 66Mb
#     Content providers : 18944 pages / 74Mb
#     Emtpy apps        : 20992 pages / 82Mb
chmod 664 /sys/module/lowmemorykiller/parameters/minfree
echo "10752,12800,14848,16896,18944,20992" > /sys/module/lowmemorykiller/parameters/minfree
echo `date +"%F %R:%S : Android Low Memory Killer set to Stock SGS3 +10Mb."` >>$log_file

# Don't set anything related to Boeffla Sound Engine by AndiP71 in this script, allows user scripts to set this in init.d
echo `date +"%F %R:%S : Boeffla Sound Engine not handled by kernel init script."` >>$log_file

echo `date +"%F %R:%S : Finished kernel configuration."` >>$log_file

chmod 644 $log_file

#--------------------------------------------------
# End of generated script
#--------------------------------------------------
