#!/sbin/sh
# 
# /system/addon.d/70-gapps.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/Books.apk
app/Calendar.apk
app/CalendarProvider.apk
app/ChromeBookmarksSyncAdapter.apk
app/Currents.apk
app/GenieWidget.apk
app/Gmail2.apk
app/GmsCore.apk
app/GoogleBackupTransport.apk
app/GoogleContactsSyncAdapter.apk
app/GoogleEars.apk
app/GoogleEarth.apk
app/GoogleFeedback.apk
app/GoogleLoginService.apk
app/GooglePartnerSetup.apk
app/GoogleServicesFramework.apk
app/GoogleTTS.apk
app/Hangouts.apk
app/Keep.apk
app/LatinImeGoogle.apk
app/Magazines.apk
app/Maps.apk
app/MediaUploader.apk
app/Music2.apk
app/NetworkLocation.apk
app/OneTimeInitializer.apk
app/Phonesky.apk
app/PlayGames.apk
app/PlusOne.apk
app/QuickSearchBox.apk
app/SetupWizard.apk
app/Street.apk
app/talkback.apk
app/Videos.apk
app/VoiceSearchStub.apk
app/Wallet.apk
app/Youtube.apk
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/com.google.widevine.software.drm.xml
etc/permissions/features.xml
etc/preferred-apps/google.xml
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
framework/com.google.widevine.software.drm.jar
lib/libAppDataSearch.so
lib/libearthandroid.so
lib/libearthmobile.so
lib/libfilterpack_facedetect.so
lib/libfrsdk.so
lib/libgames_rtmp_jni.so
lib/libgoggles_clientvision.so
lib/libgoogle_recognizer_jni_l.so
lib/libjni_t13n_shared_engine.so
lib/libjni_unbundled_latinimegoogle.so
lib/libocrclient.so
lib/libpatts_engine_jni_api.so
lib/libplus_jni_v8.so
lib/librs.antblur.so
lib/librs.antblur_constant.so
lib/librs.antblur_drama.so
lib/librs.drama.so
lib/librs.film_base.so
lib/librs.fixedframe.so
lib/librs.grey.so
lib/librs.image_wrapper.so
lib/librs.retrolux.so
lib/librsjni.so
lib/libRSSupport.so
lib/libspeexwrapper.so
lib/libvcdecoder_jni.so
lib/libvideochat_jni.so
lib/libvorbisencoder.so
lib/libwebp_android.so
lib/libwebrtc_audio_coding.so
lib/libwebrtc_audio_preprocessing.so
lib/libWVphoneAPI.so
usr/srec/en-US/c_fst
usr/srec/en-US/classifier
usr/srec/en-US/clg
usr/srec/en-US/compile_grammar.config
usr/srec/en-US/contacts.abnf
usr/srec/en-US/dict
usr/srec/en-US/dictation.config
usr/srec/en-US/dnn
usr/srec/en-US/endpointer_dictation.config
usr/srec/en-US/endpointer_voicesearch.config
usr/srec/en-US/ep_acoustic_model
usr/srec/en-US/g2p_fst
usr/srec/en-US/google_hotword.config
usr/srec/en-US/grammar.config
usr/srec/en-US/hclg_shotword
usr/srec/en-US/hmm_symbols
usr/srec/en-US/hmmlist
usr/srec/en-US/hotword_normalizer
usr/srec/en-US/hotword_word_symbols
usr/srec/en-US/metadata
usr/srec/en-US/norm_fst
usr/srec/en-US/normalizer
usr/srec/en-US/offensive_word_normalizer
usr/srec/en-US/phone_state_map
usr/srec/en-US/phonelist
usr/srec/en-US/rescoring_lm
usr/srec/en-US/wordlist
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    rm -f system/app/LatinIME.apk
    rm -f /system/lib/libjni_latinime.so
	if (grep -qi "flo" /proc/cpuinfo ); then
	  echo "Removing Wallet"
	  rm -f /system/app/Wallet.apk
	  rm -f /system/lib/libocrclient.so
	fi
	if (grep -qi "deb" /proc/cpuinfo ); then
	  echo "Removing Wallet"
	  rm -f /system/app/Wallet.apk
	  rm -f /system/lib/libocrclient.so
	fi
;;
esac
