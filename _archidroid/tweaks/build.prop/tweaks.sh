#!/sbin/sh

echo "
####################################
### ArchiDroid build.prop Tweaks ###

# Feel free to experiment with these tweaks if you know what you're doing


# Make launcher resident in memory. Reduces ram for performance
#ro.HOME_APP_ADJ=1

# Define other apps resident in memory. Name is located in /data/data
#sys.keep_app_1=com.android.your.app
#sys.keep_app_2=com.nonandroid.other.app

# Allow purging of assets
persist.sys.purgeable_assets=1

# Make sure HD Voice is enabled if available
ro.ril.enable.amr.wideband=1

# RIL and Baseband tweaks, may cause better battery life and/or better signal, proceed with caution
#ro.ril.fast.dormancy.rule=0
#ro.config.hw_fast_dormancy=0
#persist.cust.tel.eons=1

# Disable Sending Usage Data
ro.config.nocheckin=1

# Less battery drain in deep sleep. WARNING! sleep_mode=1 is called deeper sleep and may cause more battery drain during wakelocks!
#pm.sleep_mode=1
ro.ril.power_collapse=1
wifi.supplicant_scan_interval=180
#ro.mot.eri.losalert.delay=1000

# Disable Error Checking, may improve performance for cost of stability
#ro.kernel.android.checkjni=0
#ro.kernel.checkjni=0
#profiler.force_disable_err_rpt=1
#profiler.force_disable_ulog=1
#logcat.live=disable
#persist.android.strictmode=0

# Disable Google's location service
#ro.com.google.locationfeatures=0
#ro.com.google.networklocation=0


### ArchiDroid build.prop Tweaks ###
####################################
" >> /system/build.prop