#!/sbin/sh
busybox echo "" >> /system/build.prop
busybox echo "###AC!D Sound Tweaks by knight47@TEAM AC!D###" >> /system/build.prop
busybox echo "ro.audio.samplerate=48000" >> /system/build.prop
busybox echo "persist.audio.vr.enable=false" >> /system/build.prop
busybox echo "persist.htc.audio.pcm.samplerate=48000" >> /system/build.prop
busybox echo "persist.audio.vr.enable=false" >> /system/build.prop
busybox echo "persist.audio.handset.mic=analog" >> /system/build.prop
busybox echo "htc.audio.swalt.enable=1" >> /system/build.prop
busybox echo "htc.audio.swalt.mingain=14512" >> /system/build.prop
busybox echo "htc.audio.alc.enable=1" >> /system/build.prop
busybox echo "af.resample=52000" >> /system/build.prop
busybox echo "persist.audio.SupportHTCHWAEC=1" >> /system/build.prop
busybox echo "###AC!D Sound Tweaks by krabappel2548 R-ikfoot###" >> /system/build.prop
busybox echo "ro.service.swiqi2.supported=true" >> /system/build.prop
busybox echo "persist.service.swiqi2.enable=1" >> /system/build.
busybox echo "#Sony Xloud & Clearbass +" >> /system/build.prop
busybox echo "ro.semc.sound_effects_enabled=true" >> /system/build.prop
busybox echo "ro.semc.xloud.supported=true" >> /system/build.prop
busybox echo "persist.service.xloud.enable=1" >> /system/build.prop
busybox echo "ro.semc.enhance.supported=true" >> /system/build.prop
busybox echo "persist.service.enhance.enable=1" >> /system/build.prop
busybox echo "ro.semc.clearaudio.supported=true" >> /system/build.prop
busybox echo "persist.service.clearaudio.enable=1" >> /system/build.prop
busybox echo "ro.sony.walkman.logger=1" >> /system/build.prop
busybox echo "persist.service.walkman.enable=1" >> /system/build.prop
busybox echo "ro.somc.clearphase.supported=true" >> /system/build.prop
busybox echo "persist.service.clearphase.enable=1" >> /system/build.prop
busybox echo "#Resampling" >> /system/build.prop
busybox echo "af.resampler.quality=255" >> /system/build.prop
busybox echo "persist.af.resampler.quality=255" >> /system/build.prop
busybox echo "persist.audio.samplerate=48000" >> /system/build.prop
busybox echo "persist.af.resample=52000" >> /system/build.prop
busybox echo "ro.audio.pcm.samplerate=48000" >> /system/build.prop
busybox echo "persist.dev.pm.dyn_samplingrate=1" >> /system/build.prop
busybox echo "#System prop to select MPQAudioPlayer by default on mpq8064" >> /system/build.prop
busybox echo "mpq.audio.decode=true" >> /system/build.prop
busybox echo "#Awesome Beats Engine" >> /system/build.prop
busybox echo "persist.audio.fluence.mode=endfire" >> /system/build.prop
busybox echo "persist.audio.hp=true" >> /system/build.prop
busybox echo "htc.audio.global.state=0" >> /system/build.prop
busybox echo "htc.audio.lpa.a2dp=0" >> /system/build.prop
busybox echo "htc.audio.global.profile=0" >> /system/build.prop
busybox echo "htc.audio.q6.topology=0" >> /system/build.prop
busybox echo "htc.audio.enable_dmic=1" >> /system/build.prop
busybox echo "persist.htc.audio.pcm.samplerate=44100" >> /system/build.prop
busybox echo "persist.htc.audio.pcm.channels=2" >> /system/build.prop
busybox echo "htc.audio.swalt.mingain=14512" >> /system/build.prop
busybox echo "htc.audio.swalt.enable=1" >> /system/build.prop
busybox echo "htc.audio.alc.enable=1" >> /system/build.prop

busybox echo "" >> /system/build.prop
