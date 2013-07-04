#!/system/etc/CrossBreeder/busybox sh
#ThunderBolt!
#Credits:
# zacharias.maladroit
# voku1987
# collin_ph@xda
# TAKE NOTE THAT LINES PRECEDED BY A "#" IS COMMENTED OUT!
# Modified for use with CrossBreeder

alias BUSYBOX='/system/etc/CrossBreeder/busybox'
alias [='BUSYBOX ['
alias [[='BUSYBOX [['
alias ECHO='BUSYBOX timeout -t 1 -s KILL /system/etc/CrossBreeder/busybox echo'
alias LS='BUSYBOX ls'

if [ ! -f /system/etc/CrossBreeder/START_TWEAKING_IO ]; then
  return 0
fi

STL=`LS -d /sys/block/stl* 2>/dev/null`;
BML=`LS -d /sys/block/bml* 2>/dev/null`;
MMC=`LS -d /sys/block/mmc* 2>/dev/null`;
ZRM=`LS -d /sys/block/zram* 2>/dev/null`;
MTD=`LS -d /sys/block/mtd* 2>/dev/null`;
RAM=`LS -d /sys/block/ram* 2>/dev/null`;
#LP=`LS -d /sys/block/loop* 2>/dev/null`;

# Optimize non-rotating storage; 
for i in $STL $BML $MMC $ZRM $MTD $RAM;
do
	#IMPORTANT!
	if [ -e $i/queue/rotational ]; 
	then
		ECHO 0 > $i/queue/rotational; 
	fi;
	if [ -e $i/queue/nr_requests ];
	then
		ECHO 1024 > $i/queue/nr_requests; # for starters: keep it sane
	fi;
	#CFQ specific
	if [ -e $i/queue/iosched/back_seek_penalty ];
	then 
		ECHO 1 > $i/queue/iosched/back_seek_penalty;
	fi;
	if [ -e $i/queue/iosched/low_latency ];
	then
		ECHO 1 > $i/queue/iosched/low_latency;
	fi;
	if [ -e $i/queue/iosched/slice_idle ];
	then 
		ECHO 1 > $i/queue/iosched/slice_idle; # previous: 1
	fi;
	# deadline/VR/SIO scheduler specific
	if [ -e $i/queue/iosched/fifo_batch ];
	then
		ECHO 4 > $i/queue/iosched/fifo_batch;
	fi;
	if [ -e $i/queue/iosched/writes_starved ];
	then
		ECHO 4 > $i/queue/iosched/writes_starved;
	fi;
	#CFQ specific
	if [ -e $i/queue/iosched/quantum ];
	then
		ECHO 8 > $i/queue/iosched/quantum;
	fi;
	#VR Specific
	if [ -e $i/queue/iosched/rev_penalty ];
	then
		ECHO 1 > $i/queue/iosched/rev_penalty;
	fi;
	#ROW specific
	if [ -e $i/queue/iosched/hp_read_quantum ];
	then
	ECHO "20"   >  $i/queue/iosched/hp_read_quantum;   
	fi;
	if [ -e $i/queue/iosched/rp_read_quantum ];
	then
	ECHO "20"   >  $i/queue/iosched/rp_read_quantum;   
	fi;
	if [ -e $i/queue/iosched/hp_swrite_quantum ];
	then
	ECHO "5"   >  $i/queue/iosched/hp_swrite_quantum;   
	fi;
	if [ -e $i/queue/iosched/rp_write_quantum ];
	then
	ECHO "4"   >  $i/queue/iosched/rp_write_quantum;   
	fi;
	if [ -e $i/queue/iosched/rp_swrite_quantum ];
	then
	ECHO "4"   >  $i/queue/iosched/rp_swrite_quantum;   
	fi;
	if [ -e $i/queue/iosched/lp_read_quantum ];
	then
	ECHO "2"   >  $i/queue/iosched/lp_read_quantum;   
	fi;
	if [ -e $i/queue/iosched/lp_swrite_quantum ];
	then
	ECHO "2"   >  $i/queue/iosched/lp_swrite_quantum;   
	fi;
	if [ -e $i/queue/iosched/read_idle ];
	then
	ECHO "5"   >  $i/queue/iosched/read_idle;   
	fi;
	if [ -e $i/queue/iosched/read_idle_freq ];
	then
	ECHO "15"   >  $i/queue/iosched/read_idle_freq;   
	fi;
#disable iostats to reduce overhead  # idea by kodos96 - thanks !
	if [ -e $i/queue/iostats ];
	then
		ECHO "0" > $i/queue/iostats;
	fi;
	if [ -e $i/queue/rq_affinity ];
	then
	ECHO "1"   >  $i/queue/rq_affinity;   
	fi;
# Optimize for read- & write-throughput; 
# Optimize for readahead; 
	if [ -e $i/queue/read_ahead_kb ];
	then
		ECHO "256" >  $i/queue/read_ahead_kb;
	fi;
# Commented out nomerges (Merges are good) but disable complex merges. max_sectors_kb to default - don't tweak it
          ECHO "1"   >  $i/queue/nomerges
#          ECHO "128" >  $i/queue/max_sectors_kb
	
done;
