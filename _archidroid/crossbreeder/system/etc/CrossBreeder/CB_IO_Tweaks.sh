#!/system/etc/CrossBreeder/busybox sh

alias BUSYBOX='/system/etc/CrossBreeder/busybox'
alias [='BUSYBOX ['
alias [[='BUSYBOX [['
alias ECHO='BUSYBOX timeout -t 1 -s KILL /system/etc/CrossBreeder/busybox echo'
alias LS='BUSYBOX ls'

if [ ! -f /system/etc/CrossBreeder/START_TWEAKING_IO ]; then
  return 0
fi

for i in `LS /sys/devices/virtual/bdi/*/read_ahead_kb 2>/dev/null`; do ECHO 4096 > $i 2>/dev/null; done
for i in `LS /sys/devices/virtual/bdi/*/min_ratio 2>/dev/null`; do ECHO 0 > $i 2>/dev/null; done
ECHO 0 > /sys/devices/virtual/bdi/default/max_ratio

total_ram=$((`BUSYBOX free | BUSYBOX grep Mem | BUSYBOX head -1 | BUSYBOX awk '{ print $2 }'`/1024))

if [ "$total_ram" -lt 512 ]; then
  for i in `LS /sys/devices/virtual/bdi/*/max_ratio 2>/dev/null`; do ECHO 95 > $i 2>/dev/null; done
  ECHO 95 > /sys/devices/virtual/bdi/default/max_ratio
else
  for i in `LS /sys/devices/virtual/bdi/*/max_ratio 2>/dev/null`; do ECHO 97 > $i 2>/dev/null; done
  ECHO 97 > /sys/devices/virtual/bdi/default/max_ratio
fi

DATADEV=`BUSYBOX mount | BUSYBOX grep " on /data " | BUSYBOX awk '{ print $1 }' | BUSYBOX awk -F'/' '{ print $NF }'`

DONE=0
if [ -e /sys/block/$DATADEV/bdi/max_ratio ]; then
  ECHO 99 > /sys/block/$DATADEV/bdi/max_ratio 2>/dev/null
  DONE=1
fi

if [ -e /sys/devices/virtual/block/$DATADEV/bdi/max_ratio ]; then 
  ECHO 99 > /sys/devices/virtual/block/$DATADEV/bdi/max_ratio 2>/dev/null
  DONE=1
fi

for i in `LS /sys/block/*/$DATADEV/../bdi/max_ratio 2>/dev/null`; do 
  ECHO 99 > $i 2>/dev/null; 
  DONE=1; 
done

INTERNAL=`BUSYBOX echo $DATADEV | BUSYBOX cut -d'p' -f1`
if [ -e /sys/block/$INTERNAL/bdi/max_ratio ]; then
  ECHO 99 > /sys/block/$INTERNAL/bdi/max_ratio 2>/dev/null
  DONE=1
fi

if [ $DONE -eq 0 ]; then
  if [ "$total_ram" -lt 512 ]; then
    for i in `LS /sys/devices/virtual/bdi/*/max_ratio 2>/dev/null`; do ECHO 90 > $i 2>/dev/null; done
    ECHO 95 > /sys/devices/virtual/bdi/default/max_ratio
  else
    for i in `LS /sys/devices/virtual/bdi/*/max_ratio 2>/dev/null`; do ECHO 95 > $i 2>/dev/null; done
    ECHO 97 > /sys/devices/virtual/bdi/default/max_ratio
  fi
  if [ -e /sys/devices/virtual/bdi/179:0/max_ratio ]; then
    ECHO 99 > /sys/devices/virtual/bdi/179:0/max_ratio 2>/dev/null
  fi
  if [ -e /sys/block/mmcblk0/bdi/max_ratio ]; then 
    ECHO 99 > /sys/block/mmcblk0/bdi/max_ratio 2>/dev/null
  fi
fi

for i in `BUSYBOX find /sys/block/*`; do
  BUSYBOX hdparm -a 4096 $i >/dev/null 2>&1
done

#STL=`LS -d /sys/block/stl* 2>/dev/null`;
#BML=`LS -d /sys/block/bml* 2>/dev/null`;
#MMC=`LS -d /sys/block/mmc* 2>/dev/null`;
#ZRM=`LS -d /sys/block/zram* 2>/dev/null`;
#MTD=`LS -d /sys/block/mtd* 2>/dev/null`;
#RAM=`LS -d /sys/block/ram* 2>/dev/null`;
#LP=`LS -d /sys/block/loop* 2>/dev/null`;

LIST=`LS -d /sys/block/* 2>/dev/null`;

#for i in $STL $BML $MMC $ZRM $MTD $RAM $LP;
for i in $LIST;
do
#	if [ -e $i/queue/rotational ]; 
#	then
#		ECHO 0 > $i/queue/rotational; 
#	fi;
##	if [ -e $i/queue/nr_requests ];
##	then
##		ECHO 1024 > $i/queue/nr_requests;
##	fi;
#	if [ -e $i/queue/iosched/back_seek_penalty ];
#	then 
#		ECHO 1 > $i/queue/iosched/back_seek_penalty;
#	fi;
#	if [ -e $i/queue/iosched/low_latency ];
#	then
#		ECHO 1 > $i/queue/iosched/low_latency;
#	fi;
#	if [ -e $i/queue/iosched/slice_idle ];
#	then 
#		ECHO 1 > $i/queue/iosched/slice_idle; 
#	fi;
#	if [ -e $i/queue/iosched/fifo_batch ];
#	then
#		ECHO 4 > $i/queue/iosched/fifo_batch;
#	fi;
#	if [ -e $i/queue/iosched/writes_starved ];
#	then
#		ECHO 4 > $i/queue/iosched/writes_starved;
#	fi;
#	if [ -e $i/queue/iosched/quantum ];
#	then
#		ECHO 8 > $i/queue/iosched/quantum;
#	fi;
#	if [ -e $i/queue/iosched/rev_penalty ];
#	then
#		ECHO 1 > $i/queue/iosched/rev_penalty;
#	fi;
#	if [ -e $i/queue/iosched/hp_read_quantum ];
#	then
#	ECHO "20"   >  $i/queue/iosched/hp_read_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/rp_read_quantum ];
#	then
#	ECHO "20"   >  $i/queue/iosched/rp_read_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/hp_swrite_quantum ];
#	then
#	ECHO "5"   >  $i/queue/iosched/hp_swrite_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/rp_write_quantum ];
#	then
#	ECHO "4"   >  $i/queue/iosched/rp_write_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/rp_swrite_quantum ];
#	then
#	ECHO "4"   >  $i/queue/iosched/rp_swrite_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/lp_read_quantum ];
#	then
#	ECHO "2"   >  $i/queue/iosched/lp_read_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/lp_swrite_quantum ];
#	then
#	ECHO "2"   >  $i/queue/iosched/lp_swrite_quantum;   
#	fi;
#	if [ -e $i/queue/iosched/read_idle ];
#	then
#	ECHO "5"   >  $i/queue/iosched/read_idle;   
#	fi;
#	if [ -e $i/queue/iosched/read_idle_freq ];
#	then
#	ECHO "15"   >  $i/queue/iosched/read_idle_freq;   
#	fi;
#	if [ -e $i/queue/iostats ];
#	then
#		ECHO "0" > $i/queue/iostats;
#	fi;
#	if [ -e $i/queue/rq_affinity ];
#	then
#	ECHO "1"   >  $i/queue/rq_affinity;   
#	fi;
	if [ -e $i/queue/read_ahead_kb ];
	then
		ECHO "4096" >  $i/queue/read_ahead_kb;
	fi;
	if [ -e $i/bdi/read_ahead_kb ];
        then
                ECHO "4096" >  $i/bdi/read_ahead_kb;
        fi;
#       ECHO "1"   >  $i/queue/nomerges
done;
