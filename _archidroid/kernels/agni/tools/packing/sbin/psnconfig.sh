#!/sbin/busybox sh

#### PSN>> pureCM configurator

###Mali 400MP GPU threshold
echo "40% 32% 60% 55% 60% 55% 60% 55%" > /sys/class/misc/gpu_control/gpu_clock_control

# enable idle+LPA
echo 2 > /sys/module/cpuidle_exynos4/parameters/enable_mask

# setting sched_mc_power_savings off default
echo 0 >  /sys/devices/system/cpu/sched_mc_power_savings

#### MISC settings
echo "0" > /sys/class/misc/touchboost_switch/touchboost_switch
echo "0" > /sys/class/misc/touchwake/enabled
echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_earlysuspend
echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active

# setting up swappiness
echo 30 > /proc/sys/vm/swappiness

# MDNIE Hijack
echo 0 > /sys/class/mdnie/mdnie/hijack
echo 0 > /sys/class/mdnie/mdnie/sharpen
echo 0 > /sys/class/mdnie/mdnie/black

#Lights up on h/w keys or screen touch (default)
echo 1 > /sys/class/sec/sec_touchkey/touch_led_on_screen_touch

# setting default charging current
echo 1000 > /sys/devices/platform/samsung-battery/dcp_ac_chrg_curr
echo 475 > /sys/devices/platform/samsung-battery/sdp_chrg_curr
echo 475 > /sys/devices/platform/samsung-battery/cdp_chrg_curr
echo 0 > /sys/devices/platform/samsung-battery/ignore_unstable_power

#LMK minfree
chmod 664 /sys/module/lowmemorykiller/parameters/minfree
echo "12288,15360,18432,21504,24576,30720" > /sys/module/lowmemorykiller/parameters/minfree

# PSN>> ZRAM activator 300 MB
#Zram0
swapoff /dev/block/zram0
echo 1 > /sys/block/zram0/reset
echo 78643200 > /sys/block/zram0/disksize
echo 1 > /sys/block/zram0/initstate
mkswap /dev/block/zram0
swapon -p 2 /dev/block/zram0
#Zram1
swapoff /dev/block/zram1
echo 1 > /sys/block/zram1/reset
echo 78643200 > /sys/block/zram1/disksize
echo 1 > /sys/block/zram0/initstate
mkswap /dev/block/zram1
swapon -p 2 /dev/block/zram1
#Zram2
swapoff /dev/block/zram2
echo 1 > /sys/block/zram2/reset
echo 78643200 > /sys/block/zram2/disksize
echo 1 > /sys/block/zram2/initstate
mkswap /dev/block/zram2
swapon -p 2 /dev/block/zram2
#Zram3
swapoff /dev/block/zram3
echo 1 > /sys/block/zram3/reset
echo 78643200 > /sys/block/zram3/disksize
echo 1 > /sys/block/zram3/initstate
mkswap /dev/block/zram3
swapon -p 2 /dev/block/zram3

#### EFS backup
if [ ! -f /data/.AGNi/efsbackup.tar.gz ];
then
  mkdir /data/media/0/AGNi_efs_backup
  chmod 775 /data/.AGNi
  /sbin/busybox tar zcvf /data/.AGNi/efsbackup.tar.gz /efs
  /sbin/busybox cat /dev/block/mmcblk0p3 > /data/.AGNi/efsdev-mmcblk0p3.img
  /sbin/busybox gzip /data/.AGNi/efsdev-mmcblk0p3.img
  /sbin/busybox cp /data/.AGNi/* /data/media/0/AGNi_efs_backup/
  chmod 777 /data/media/0/AGNi_efs_backup/efsdev-mmcblk0p3.img
  chmod 777 /data/media/0/AGNi_efs_backup/efsbackup.tar.gz
fi


