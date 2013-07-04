#!/tmp/busybox sh

set +e

export PATH=/system/etc/CrossBreeder:/tmp:$PATH:/sbin:/system/bin:/bin:/usr/bin:/usr/sbin:/system/xbin
export LD_LIBRARY_PATH=/system/etc/CrossBreeder:/tmp:$LD_LIBRARY_PATH
alias BUSYBOX='/system/etc/CrossBreeder/busybox'

#RUNSTR="( /system/etc/CrossBreeder/zzCrossBreeder 0<&- &>/dev/null 2>&1 ) &"
#ERUNSTR="\( \/system\/etc\/CrossBreeder\/zzCrossBreeder 0\<\&\- \&\>\/dev\/null 2\>\&1 \) \&"

RUNSTR="/system/etc/CrossBreeder/busybox start-stop-daemon -o -S -b -x /system/etc/CrossBreeder/zzCrossBreeder &"
ERUNSTR="\/system\/etc\/CrossBreeder\/busybox start-stop-daemon -o -S -b -x \/system\/etc\/CrossBreeder\/zzCrossBreeder \&"

#RUNSTR="/system/etc/CrossBreeder/busybox start-stop-daemon -o -S -b -x /system/etc/init.d/zzCrossBreeder_initd -- RUN"
#ERUNSTR="\/system\/etc\/CrossBreeder\/busybox start-stop-daemon -o -S -b -x \/system\/etc\/init.d\/zzCrossBreeder_initd -- RUN"

BUSYBOX mount /system
BUSYBOX mount -o rw,remount /system

umask 022

if [ ! -f /system/etc/install-recovery.sh ]; then
 echo "#!/system/bin/sh" > /system/etc/install-recovery.sh
 echo "" >> /system/etc/install-recovery.sh
fi

if [ ! -f /system/etc/install-recovery.sh.CBBAK ]; then
# BUSYBOX cp -a -f /system/etc/install-recovery.sh /system/etc/install-recovery.sh.CBBAK 2>/dev/null
 echo 
else
 BUSYBOX cp -a -f /system/etc/install-recovery.sh.CBBAK /system/etc/install-recovery.sh 2>/dev/null
fi

BUSYBOX chmod 755 /system/etc/install-recovery.sh
BUSYBOX chown root.root /system/etc/install-recovery.sh
BUSYBOX chown 0:0 /system/etc/install-recovery.sh
#BUSYBOX sed -i -e "/^\#\!.*/d" /system/etc/install-recovery.sh
#BUSYBOX sed -i -e "1 i\#!/system/bin/sh" /system/etc/install-recovery.sh
BUSYBOX sed -i -e "/.*CrossBreeder.*/d" /system/etc/install-recovery.sh
##BUSYBOX sed -i -e "1 a$ERUNSTR" /system/etc/install-recovery.sh
#BUSYBOX sed -i -e "\$a$ERUNSTR" /system/etc/install-recovery.sh

##BUSYBOX sed -i -e "s/.*CrossBreeder.*/$ERUNSTR/" /system/etc/install-recovery.sh

#if ! BUSYBOX grep zzCrossBreeder /system/etc/install-recovery.sh >/dev/null 2>&1; then 
#  echo $RUNSTR >> /system/etc/install-recovery.sh
#fi

#if ! BUSYBOX grep "^$RUNSTR$" /system/etc/install-recovery.sh >/dev/null 2>&1; then
#  echo $RUNSTR >> /system/etc/install-recovery.sh
#fi

BUSYBOX mount /cache
BUSYBOX mount /data

#if BUSYBOX grep net.dns /system/build.prop; then
#  BUSYBOX sed -i -e "/.*net.dns1.*=.*/d" /system/build.prop
#  BUSYBOX sed -i -e "/.*net.dns2.*=.*/d" /system/build.prop
#fi

total_ram=$((`BUSYBOX free | BUSYBOX grep Mem | BUSYBOX head -1 | BUSYBOX awk '{ print $2 }'`/1024))

#if [ "$total_ram" -lt 400 ]; then
#  touch /system/etc/CrossBreeder/STOP_ADBLOCK 
#fi

if [ -f /data/STOP_TWEAKING_ME ]; then return 0; fi

#for m in $(BUSYBOX mount | BUSYBOX grep ext[3-4] | BUSYBOX awk '{ print $1 }' | BUSYBOX sort | BUSYBOX uniq);
#do
#  tune2fs -o journal_data_writeback $m >/dev/null 2>&1;
#done;


UPDATE_TABLES() {
  VARIABLE=$1
  VAL=$2
  BUSYBOX sync; sqlite3 /data/data/com.android.providers.settings/databases/settings.db "PRAGMA journal_mode=OFF;update system set value=$VAL where name=\"$VARIABLE\";"
  BUSYBOX sync; sqlite3 /data/data/com.android.providers.settings/databases/settings.db "PRAGMA journal_mode=OFF;update global set value=$VAL where name=\"$VARIABLE\";"
  BUSYBOX sync

  VAL1=""
  VAL1=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db "select value from global where name=\"$VARIABLE\";" 2>/dev/null`
  if [ "$VAL1" = "" ]; then 
    ID=""
    ID=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select max(_id)+100 from global;' 2>/dev/null`
    if [ "$ID" != "" ]; then 
      BUSYBOX sync; sqlite3 /data/data/com.android.providers.settings/databases/settings.db "PRAGMA journal_mode=OFF;insert into global values(\"$ID\",\"$VARIABLE\",\"$VAL\");"
      BUSYBOX sync;
    fi
  fi

  VAL1=""
  VAL1=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db "select value from system where name=\"$VARIABLE\";" 2>/dev/null`
  if [ "$VAL1" = "" ]; then 
    ID=""
    ID=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select max(_id)+100 from system;' 2>/dev/null`
    if [ "$ID" != "" ]; then 
      BUSYBOX sync; sqlite3 /data/data/com.android.providers.settings/databases/settings.db "PRAGMA journal_mode=OFF;insert into system values(\"$ID\",\"$VARIABLE\",\"$VAL\");"
      BUSYBOX sync;
    fi
  fi
return 0
}

if [ ! -f /data/data/com.android.providers.settings/databases/settings.db.CBBAK ]; then
 BUSYBOX cp -a -f /data/data/com.android.providers.settings/databases/settings.db /data/data/com.android.providers.settings/databases/settings.db.CBBAK 2>/dev/null
fi

if [ "$total_ram" -gt 600 ]; then
  VALUE=""
  VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from global where name="transition_animation_scale";' 2>/dev/null`
  if [ "$VALUE" = "" ]; then 
    VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from system where name="transition_animation_scale";' 2>/dev/null`
  fi
  if [ "$VALUE" != "0.0" ]; then VALUE="0.5"; else VALUE="0.0"; fi
  UPDATE_TABLES "transition_animation_scale" $VALUE

  VALUE=""
  VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from global where name="window_animation_scale";' 2>/dev/null`
  if [ "$VALUE" = "" ]; then 
    VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from system where name="window_animation_scale";' 2>/dev/null`
  fi
  if [ "$VALUE" != "0.0" ]; then VALUE="0.5"; else VALUE="0.0"; fi
  UPDATE_TABLES "window_animation_scale" $VALUE

  VALUE=""
  VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from global where name="animator_duration_scale";' 2>/dev/null`
  if [ "$VALUE" = "" ]; then 
    VALUE=`sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'select value from system where name="animator_duration_scale";' 2>/dev/null`
  fi
  if [ "$VALUE" != "0.0" ]; then VALUE="0.5"; else VALUE="0.0"; fi
  UPDATE_TABLES "animator_duration_scale" $VALUE
else
  UPDATE_TABLES "transition_animation_scale" 0
  UPDATE_TABLES "window_animation_scale" 0
  UPDATE_TABLES "animator_duration_scale" 0
fi

sync; sync; 

#sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'update global set value=1 where name="development_settings_enabled";'
#sqlite3 /data/data/com.android.providers.settings/databases/settings.db 'update system set value=1 where name="development_settings_enabled";'

if [ -f /system/build.prop.CBBAK ]; then
  cp /system/build.prop /system/build.prop.CBBAK 2>/dev/null
  BUSYBOX cp -a -f /system/build.prop /system/build.prop.CBBAK 2>/dev/null
fi

if BUSYBOX grep -i c2cef309-c307-4080-8163-1e1208119365 /system/build.prop >/dev/null 2>&1; then
  BUSYBOX sed -i '/#<c2cef309-c307-4080-8163-1e1208119365>/,/#<\/c2cef309-c307-4080-8163-1e1208119365>/d' /system/build.prop
fi

if BUSYBOX grep -i a65d346e-5494-40cd-aa25-ad2b91ff3a59 /system/build.prop >/dev/null 2>&1; then
  BUSYBOX sed -i '/#<a65d346e-5494-40cd-aa25-ad2b91ff3a59>/,/#<\/a65d346e-5494-40cd-aa25-ad2b91ff3a59>/d' /system/build.prop
fi

if BUSYBOX grep -i 485f6283-03f8-4fba-90ec-d6519033bc71 /system/build.prop >/dev/null 2>&1; then
  BUSYBOX sed -i '/#<485f6283-03f8-4fba-90ec-d6519033bc71>/,/#<\/485f6283-03f8-4fba-90ec-d6519033bc71>/d' /system/build.prop
fi

#if [ -f /system/etc/hw_config.sh.CBBAK ]; then
# BUSYBOX mv -f /system/etc/hw_config.sh.CBBAK /system/etc/hw_config.sh
#fi

if BUSYBOX grep -i CrossBreeder /system/etc/hw_config.sh >/dev/null 2>&1; then
  BUSYBOX sed -i -e "/.*CrossBreeder.*/d" /system/etc/hw_config.sh
fi

#if [ "$total_ram" -lt 1024 ]; then 
if [ "$total_ram" = "DISABLED" ]; then 
  total_heap=$(($(($total_ram*16/100+1))/2*2));
  total_heap_new=0;                                                                                                               
  if [ "$total_heap" = "" ]; then return 0; fi
  total_heap_new=$(($total_heap + 0)) 2>/dev/null;
  if [ "$total_heap_new" = "" ]; then return 0; fi
  if [ "$total_heap_new" = "0" ]; then return 0; fi

  BUSYBOX echo -e "#<c2cef309-c307-4080-8163-1e1208119365>\ndalvik.vm.heapgrowthlimit=${total_heap}m\n#</c2cef309-c307-4080-8163-1e1208119365>" >> /system/build.prop

  BUSYBOX echo -e "#<a65d346e-5494-40cd-aa25-ad2b91ff3a59>\ndalvik.vm.heapsize=${total_heap}m\n#</a65d346e-5494-40cd-aa25-ad2b91ff3a59>" >> /system/build.prop

  BUSYBOX echo -e "#<485f6283-03f8-4fba-90ec-d6519033bc71>\npersist.sys.vm.heapsize=${total_heap}m\n#</485f6283-03f8-4fba-90ec-d6519033bc71>" >> /system/build.prop
fi

#BUSYBOX rm -f /data/dalvik-cache/*Settings.apk*
#BUSYBOX rm -f /data/dalvik-cache/*SettingsProvider.apk*
BUSYBOX rm -f /data/dalvik-cache/*
BUSYBOX mount /cache
#BUSYBOX rm -f /cache/dalvik-cache/*Settings.apk*
#BUSYBOX rm -f /cache/dalvik-cache/*SettingsProvider.apk*
BUSYBOX rm -f /cache/dalvik-cache/*
BUSYBOX mount /sd-ext
#BUSYBOX rm -f /sd-ext/dalvik-cache/*Settings.apk*
#BUSYBOX rm -f /sd-ext/dalvik-cache/*SettingsProvider.apk*
BUSYBOX rm -f /sd-ext/dalvik-cache/*
