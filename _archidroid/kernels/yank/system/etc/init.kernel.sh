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

# Script generated on 22/09/2013 at  4:30
#----------------------------------------------------

# - init.d support by kernel/ramdisk not installed
echo `date +"%F %R:%S : Init.d script execution support disabled."` >>$log_file
ls -al /system/etc/init.d >>$log_file

# - Set governor to zzmoove
echo "zzmoove" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo `date +"%F %R:%S : CPU governor set to zzmoove."` >>$log_file

# - Enable touchboost (Stock SGS3)
echo "1" > /sys/devices/virtual/misc/touchboost_switch/touchboost_switch
echo "800000" > /sys/devices/virtual/misc/touchboost_switch/touchboost_freq
echo `date +"%F %R:%S : Touchboost enabled at 800MHz."` >>$log_file

# - Set CPU max frequencies for all 4 cores
echo 1600000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo `date +"%F %R:%S : CPU max. frequency set to 1.6GHz."` >>$log_file

# - zzmoove battery profile (by yank555.lu)
echo `date +"%F %R:%S : zzmoove - yank-battery profile :"` >>$log_file

# zzmoove governor settings optimized for battery:
echo "75000" >/sys/devices/system/cpu/cpufreq/zzmoove/sampling_rate
echo `date +"%F %R:%S : zzmoove - sampling rate set to 75000."` >>$log_file
echo "1" >/sys/devices/system/cpu/cpufreq/zzmoove/sampling_down_factor
echo `date +"%F %R:%S : zzmoove - sampling down factor set to 1."` >>$log_file
echo "60" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold
echo `date +"%F %R:%S : zzmoove - up threshold set to 60."` >>$log_file
echo "40" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold
echo `date +"%F %R:%S : zzmoove - down threshold set to 40."` >>$log_file
echo "0" >/sys/devices/system/cpu/cpufreq/zzmoove/ignore_nice_load
echo `date +"%F %R:%S : zzmoove - ignore nice load set to 0."` >>$log_file
echo "10" >/sys/devices/system/cpu/cpufreq/zzmoove/freq_step
echo `date +"%F %R:%S : zzmoove - frequency step set to 10."` >>$log_file
echo "65" >/sys/devices/system/cpu/cpufreq/zzmoove/smooth_up
echo `date +"%F %R:%S : zzmoove - smooth up set to 65."` >>$log_file

# hotplug up threshold per core
echo "85" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug1
echo `date +"%F %R:%S : zzmoove - up threshold hotplug1 set to 85."` >>$log_file
echo "90" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug2
echo `date +"%F %R:%S : zzmoove - up threshold hotplug2 set to 90."` >>$log_file
echo "98" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug3
echo `date +"%F %R:%S : zzmoove - up threshold hotplug3 set to 98."` >>$log_file

echo "1000000" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug_freq1
echo `date +"%F %R:%S : zzmoove - up threshold hotplug1 freq. set to 1.0GHz."` >>$log_file
echo "1200000" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug_freq2
echo `date +"%F %R:%S : zzmoove - up threshold hotplug2 freq. set to 1.2GHz."` >>$log_file
echo "1400000" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_hotplug_freq3
echo `date +"%F %R:%S : zzmoove - up threshold hotplug3 freq. set to 1.4GHz."` >>$log_file

# hotplug down threshold per core
echo "65" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug1
echo `date +"%F %R:%S : zzmoove - down threshold hotplug1 set to 65."` >>$log_file
echo "75" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug2
echo `date +"%F %R:%S : zzmoove - down threshold hotplug2 set to 75."` >>$log_file
echo "85" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug3
echo `date +"%F %R:%S : zzmoove - down threshold hotplug3 set to 85."` >>$log_file

echo "800000" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug_freq1
echo `date +"%F %R:%S : zzmoove - down threshold hotplug1 freq. set to 800MHz."` >>$log_file
echo "1000000" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug_freq2
echo `date +"%F %R:%S : zzmoove - down threshold hotplug2 freq. set to 1.0GHz."` >>$log_file
echo "1200000" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_hotplug_freq3
echo `date +"%F %R:%S : zzmoove - down threshold hotplug3 freq. set to 1.2GHz."` >>$log_file

# hotplug block cycles
echo "0" >/sys/devices/system/cpu/cpufreq/zzmoove/hotplug_block_cycles
echo `date +"%F %R:%S : zzmoove - hotplug block cycles set to 0."` >>$log_file

# Screen off settings
echo "4" >/sys/devices/system/cpu/cpufreq/zzmoove/sampling_rate_sleep_multiplier
echo `date +"%F %R:%S : zzmoove - sampling rate sleep multiplier set to 4."` >>$log_file
echo "85" >/sys/devices/system/cpu/cpufreq/zzmoove/up_threshold_sleep
echo `date +"%F %R:%S : zzmoove - up threshold sleep set to 85."` >>$log_file
echo "75" >/sys/devices/system/cpu/cpufreq/zzmoove/down_threshold_sleep
echo `date +"%F %R:%S : zzmoove - down threshold sleep set to 75."` >>$log_file
echo "1" > /sys/devices/system/cpu/cpufreq/zzmoove/freq_step_sleep
echo `date +"%F %R:%S : zzmoove - CPU step for standby set to 1."` >>$log_file
echo "90" >/sys/devices/system/cpu/cpufreq/zzmoove/smooth_up_sleep
echo `date +"%F %R:%S : zzmoove - smooth up sleep set to 90."` >>$log_file
echo "1" >/sys/devices/system/cpu/cpufreq/zzmoove/hotplug_sleep
echo `date +"%F %R:%S : zzmoove - hotplug sleep set to 1."` >>$log_file

echo `date +"%F %R:%S : zzmoove - yank-battery profile applied."` >>$log_file

# - Set CPU max frequency in standby
echo "600000" > /sys/devices/system/cpu/cpufreq/zzmoove/freq_limit_sleep
echo `date +"%F %R:%S : zzmoove - CPU freq. max for standby set to 600MHz."` >>$log_file

# use 1 step up/down fast scaling when screen is on
echo "5" > /sys/devices/system/cpu/cpufreq/zzmoove/fast_scaling
echo `date +"%F %R:%S : zzmoove - 1 step up/down fast scaling enabled."` >>$log_file

# Do not use fast scaling when screen is off
echo "0" > /sys/devices/system/cpu/cpufreq/zzmoove/fast_scaling_sleep
echo `date +"%F %R:%S : zzmoove - fast scaling for standby disabled."` >>$log_file

# Use early demand
echo "1" > /sys/devices/system/cpu/cpufreq/zzmoove/early_demand
echo `date +"%F %R:%S : zzmoove - early demand enabled."` >>$log_file

# Early demand : set threshold to 50%
echo "50" > /sys/devices/system/cpu/cpufreq/zzmoove/grad_up_threshold
echo `date +"%F %R:%S : zzmoove - early demand threshold set to 50%."` >>$log_file

# - zRam activation - 200Mb
if [ -e /sys/block/zram0/disksize ] ; then
  swapoff /dev/block/zram0
  echo 1 > /sys/block/zram0/reset
  echo 209715200 > /sys/block/zram0/disksize
  echo 1 > /sys/block/zram0/initstate
  swapon /dev/block/zram0
fi
echo `date +"%F %R:%S : 200Mb Zram Support enabled."` >>$log_file

# - Hardswap by Yank555.lu not installed
echo `date +"%F %R:%S : Hardswap Support disabled."` >>$log_file

# - swappiness set to 80
echo 80 > /proc/sys/vm/swappiness;
echo `date +"%F %R:%S : Swappiness set to 80."` >>$log_file

# - Enable custom current forced fast charge
echo 2 > /sys/kernel/fast_charge/force_fast_charge
echo `date +"%F %R:%S : Fast Charge - Custom Current Mode enabled."` >>$log_file
echo 1000 > /sys/kernel/fast_charge/usb_charge_level
echo `date +"%F %R:%S : Fast Charge - USB charge level set to 1000mA/h."` >>$log_file
echo 1000 > /sys/kernel/fast_charge/ac_charge_level
echo `date +"%F %R:%S : Fast Charge - AC charge level set to 1000mA/h."` >>$log_file

echo 475 > /sys/kernel/fast_charge/wireless_charge_level
echo `date +"%F %R:%S : Fast Charge - Wireless charge level set to 475mA/h."` >>$log_file
# - Enable dynamic deferred file sync (by faux123)
#     While screen is on, file sync is temporarily deferred, when screen
#     is turned off, a flush is called to synchronize all outstanding writes.
echo 1 > /sys/kernel/dyn_fsync/Dyn_fsync_active
echo `date +"%F %R:%S : Dynamic Deferred File Sync enabled."` >>$log_file

# - Disable touch wake
echo 0 > /sys/class/misc/touchwake/disabled
echo `date +"%F %R:%S : Touch Wake disabled."` >>$log_file

# - Disable Hardwarekeys light on screen touch
echo 0 > /sys/class/sec/sec_touchkey/touch_led_on_screen_touch
echo `date +"%F %R:%S : Hardwarekeys light on screen touch disabled."` >>$log_file

# - Handle Hardwarekeys light by ROM (newer CM)
echo 0 > /sys/class/sec/sec_touchkey/touch_led_handling
echo `date +"%F %R:%S : Hardwarekeys light handled by ROM (newer CM)."` >>$log_file

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

# - Set GPU frequencies to Yank (108MHz, 200MHz, 333MHz, 440MHz, 600MHz)
echo "108 200 333 440 600" > /sys/class/misc/gpu_clock_control/gpu_control
echo `date +"%F %R:%S : GPU frequencies set to Yank (108MHz, 200MHz, 333MHz, 440MHz, 600MHz)."` >>$log_file

# - Set GPU frequency thresholds to medium (38%, 35%, 38%, 44%, 46%, 46%, 50%, 50%)
echo "38% 35% 38% 44% 46% 46% 50% 50%" > /sys/class/misc/gpu_clock_control/gpu_control
echo `date +"%F %R:%S : GPU frequency thresholds set to medium (38%, 35%, 38%, 44%, 46%, 46%, 50%, 50%)."` >>$log_file

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
