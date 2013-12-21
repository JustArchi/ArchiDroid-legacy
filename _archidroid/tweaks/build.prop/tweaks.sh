#!/sbin/sh
echo "
############################
### ArchiDroid build.prop Tweaks ###

# Feel free to experiment with these tweaks if you know what you're doing


# Define apps as resident in memory. Name is located in /data/data
#sys.keep_app_1=com.android.your.app
#sys.keep_app_2=com.nonandroid.other.app

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


# Usually you don't want to change values below


# Audio tweaks, gathered by me from the entire internet. Most credits to AC!D Team, AwesomeBeats and many more
af.resample=52000
af.resampler.quality=255

alsa.mixer.capture.bt.sco=BTHeadset
alsa.mixer.capture.earpiece=Mic
alsa.mixer.capture.headset=Mic
alsa.mixer.capture.master=Mic
alsa.mixer.capture.speaker=Mic
alsa.mixer.playback.bt.sco=BTHeadset
alsa.mixer.playback.earpiece=Earpiece
alsa.mixer.playback.headset=Headset
alsa.mixer.playback.master=Speaker
alsa.mixer.playback.speaker=Speaker

mpq.audio.decode=true

persist.af.resample=52000
persist.af.resampler.quality=255
persist.audio.fluence.mode=endfire
persist.audio.handset.mic=analog
persist.audio.hp=true
persist.audio.samplerate=48000
persist.audio.vr.enable=false
persist.audio.SupportHTCHWAEC=1
persist.dev.pm.dyn_samplingrate=1
persist.htc.audio.pcm.channels=2
persist.htc.audio.pcm.samplerate=48000
persist.service.swiqi2.enable=1
persist.service.xloud.enable=1
persist.service.enhance.enable=1
persist.service.clearaudio.enable=1
persist.service.walkman.enable=1
persist.service.clearphase.enable=1

ro.audio.pcm.samplerate=48000
ro.audio.samplerate=48000
ro.semc.clearaudio.supported=true
ro.semc.enhance.supported=true
ro.semc.sound_effects_enabled=true
ro.semc.xloud.supported=true
ro.service.swiqi2.supported=true
ro.somc.clearphase.supported=true
ro.sony.walkman.logger=1
ro.sound.alsa=snd_pcm
ro.sound.driver=alsa

### ArchiDroid build.prop Tweaks ###
############################
" >> /system/build.prop
exit 0
