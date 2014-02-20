#!/sbin/sh
echo "
############################
### ArchiDroid build.prop Tweaks ###

# Feel free to experiment with these tweaks if you know what you're doing

# Turn on Navigation Bar
#qemu.hw.mainkeys=0

# Turn off screen-on animations, they're not working properly and may cause freezes in some scenarios
persist.sys.screen_on=none

# Define apps as resident in memory. Name is located in /data/data
#sys.keep_app_1=com.android.your.app
#sys.keep_app_2=org.nonandroid.other.long.app

# Force using HW/GPU Acceleration even if apps don't support it
# Warning! It may NOT be a good idea to enable this, use with caution
#debug.composition.type=gpu

# Allow purging of assets
# CyanogenMod Only
persist.sys.purgeable_assets=1

# Make sure HD Voice is enabled if available
ro.ril.enable.amr.wideband=1

# Fast Dormancy toggle. If your provider doesn't support it then it may be better for you to uncomment these lines
#ro.ril.fast.dormancy.rule=0

# This value controls deep sleep function in your ROM
#sleep_mode=0 -> Collapse Suspend. Standard deep sleep. Default value
#sleep_mode=1 -> Full Collapse. Deeper sleep. It'll aggresively try to power off as much cpu cores as possible, improving battery life in deep sleep. Default ArchiDroid value
#sleep_mode=2 -> Sleep. CPU is still on, but put into low power mode, all registers are still saved, thus all apps are in fact working and they're not suspended. May be ultra useful for disabling wake up lag. Default ArchiDroid ZeroWakeUp value
#sleep_mode=3 -> Slow Clock And Wait For Interrupt. Same as putting CPU into lower frequencies than usual
#sleep_mode=4 -> Wait For Interrupt. No deep sleep at all, same as you'd keep screen on whole the time. Drains battery a lot
#
# 1 (AD Default) > 0 (Default) > 2 (AD ZeroWakeUp) > 3 > 4
# Battery > Performance
#
pm.sleep_mode=1

# This value controls RIL deep sleep
# Usually you don't want to change that
ro.ril.power.collapse=1

# Scan Wi-Fi less often
wifi.supplicant_scan_interval=300

# Disable Error Checking, may improve performance for cost of stability
# Kernel Side
ro.kernel.android.checkjni=0
# Android Side
dalvik.vm.checkjni=false
#profiler.force_disable_err_rpt=1
#profiler.force_disable_ulog=1
#logcat.live=disable
#persist.android.strictmode=0

# Disable Google's location service
#ro.com.google.locationfeatures=0
#ro.com.google.networklocation=0

### ArchiDroid build.prop Tweaks ###
############################
" >> /system/build.prop

sync
exit 0
