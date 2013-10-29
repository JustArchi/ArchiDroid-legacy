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

if [ ! -f /system/etc/hw_config.sh ]; then
 echo "#!/system/bin/sh" > /system/etc/hw_config.sh
 echo "" >> /system/etc/hw_config.sh
fi

if [ ! -f /system/etc/hw_config.sh.CBBAK ]; then
 BUSYBOX cp -a -f /system/etc/hw_config.sh /system/etc/hw_config.sh.CBBAK 2>/dev/null
else
 BUSYBOX cp -a -f /system/etc/hw_config.sh.CBBAK /system/etc/hw_config.sh 2>/dev/null
fi

BUSYBOX chmod 755 /system/etc/hw_config.sh
BUSYBOX chown root.root /system/etc/hw_config.sh
BUSYBOX chown 0:0 /system/etc/hw_config.sh
#BUSYBOX sed -i -e "/^\#\!.*/d" /system/etc/hw_config.sh
#BUSYBOX sed -i -e "1 i\#!/system/bin/sh" /system/etc/hw_config.sh
BUSYBOX sed -i -e "/.*CrossBreeder.*/d" /system/etc/hw_config.sh
#BUSYBOX sed -i -e "1 a$ERUNSTR" /system/etc/hw_config.sh
BUSYBOX sed -i -e "\$a$ERUNSTR" /system/etc/hw_config.sh

#BUSYBOX sed -i -e "s/.*CrossBreeder.*/$ERUNSTR/" /system/etc/hw_config.sh

if ! BUSYBOX grep zzCrossBreeder /system/etc/hw_config.sh >/dev/null 2>&1; then 
  echo $RUNSTR >> /system/etc/hw_config.sh
fi

if ! BUSYBOX grep "^$RUNSTR$" /system/etc/hw_config.sh >/dev/null 2>&1; then
  echo $RUNSTR >> /system/etc/hw_config.sh
fi

