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
#debug.performance.tuning=1
#video.accelerate.hw=1

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

# Less battery drain in deep sleep. WARNING! These tweaks enable so-called deeper sleep and may cause more battery drain during wakelocks!
# If you're using your device often and it doesn't sleep at all it may be better for you to comment these lines or even change sleep mode to 2 or 3, as it's better for device to avoid massive wakelocks if possible.
#pm.sleep_mode=0 -> Collapse Suspend (Default, standard deep sleep)
#pm.sleep_mode=1 -> Full Collapse (It'll aggresively try to power off as much cpu cores as possible, improving battery life in deep sleep)
#pm.sleep_mode=2 -> Sleep (CPU is still on, but put into low power mode, all registers are still saved, thus all apps are in fact working and they're not suspended)
#pm.sleep_mode=3 -> Slow Clock And Wait For Interrupt (Lower frequency and lower voltage. May be ultra useful for disabling wakeup lag for some users)
#pm.sleep_mode=4 -> Wait For Interrupt (No deep sleep at all, same as you'd keep screen on whole the time. Drains battery a lot)
#
# 4 > 3 > 2 > 0 (Default) > 1
# Performance > Battery
#
pm.sleep_mode=1
ro.ril.power.collapse=1
ro.ril.disable.power.collapse=0

# Scan Wi-Fi less often
wifi.supplicant_scan_interval=180
#ro.mot.eri.losalert.delay=1000

# Disable Error Checking, may improve performance for cost of stability
# Kernel Side
ro.kernel.android.checkjni=0
ro.kernel.checkjni=0
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

# Probably not needed but who knows...
htc.audio.alc.enable=1
htc.audio.enable_dmic=1
htc.audio.global.profile=0
htc.audio.global.state=0
htc.audio.lpa.a2dp=0
htc.audio.q6.topology=0
htc.audio.swalt.enable=1
htc.audio.swalt.mingain=14512

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