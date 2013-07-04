#!/system/etc/CrossBreeder/busybox sh

# These are based on Thunderbolt values modified for use with CrossBreeder

#Credits to Thunderbolt team
# zacharias.maladroit
# voku1987
# collin_ph@xda

alias BUSYBOX='/system/etc/CrossBreeder/busybox'
alias [='BUSYBOX ['
alias [[='BUSYBOX [['
alias ECHO='BUSYBOX timeout -t 1 -s KILL /system/etc/CrossBreeder/busybox echo'
alias CAT='BUSYBOX timeout -t 1 -s KILL /system/etc/CrossBreeder/busybox cat'

if [[ -f /data/STOP_TWEAKING_ME && "$1" != "FORCE" ]]; then return 0; fi

if [[ -f /system/etc/CrossBreeder/STOP_TWEAKING_GOVERNOR && "$1" != "FORCE" ]]; then return 0; fi

GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
if [ "$GOVERNOR" = "smartassV2" ]; then
   GOVERNOR="smartass"
fi

for i in "" "cpu0" "cpu1" "cpu2" "cpu3" "cpu4" "cpu5" "cpu6" "cpu7" "cpu8" "cpu9" "cpu10" "cpu11" "cpu12" "cpu13" "cpu14" "cpu15"; do
DIRECTORY="/sys/devices/system/cpu/${i}/cpufreq/$GOVERNOR"

if [ -d $DIRECTORY ]; then

BUSYBOX chmod -R 777 $DIRECTORY

if [ -e $DIRECTORY/sampling_rate ]; then 
  SAMPLING_RATE=`cat $DIRECTORY/sampling_rate 2>/dev/null`
  if [ "$SAMPLING_RATE" -gt 100000 ]; then 
    ECHO "100000" > $DIRECTORY/sampling_rate 2>/dev/null
  fi
  if [ "$SAMPLING_RATE" -lt 40000 ]; then 
    ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null
  fi
fi

#if [[ "$GOVERNOR" = "interactive" && -e $DIRECTORY/timer_rate ]]; then
if [ -e $DIRECTORY/timer_rate ]; then
  SAMPLING_RATE=`cat $DIRECTORY/timer_rate 2>/dev/null`
  if [ "$SAMPLING_RATE" -gt 100000 ]; then
    ECHO "100000" > $DIRECTORY/timer_rate 2>/dev/null
  fi
  if [ "$SAMPLING_RATE" -lt 40000 ]; then
    ECHO "40000" > $DIRECTORY/timer_rate 2>/dev/null
  fi
fi
  
if [[ -f /system/etc/CrossBreeder/START_TWEAKING_GOVERNOR || "$1" = "FORCE" ]]; then 

if [ "$GOVERNOR" = "interactive" ]; then
        ECHO "90" > $DIRECTORY/go_maxspeed_load 2>/dev/null
        ECHO "90" > $DIRECTORY/go_hispeed_load 2>/dev/null
        ECHO "10000" > $DIRECTORY/min_sample_time 2>/dev/null
        ECHO "40000" > $DIRECTORY/timer_rate 2>/dev/null
elif [ "$GOVERNOR" = "ondemand" ]; then
        ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
#        ECHO "0" > $DIRECTORY/powersave_bias 2>/dev/null
        ECHO "10" > $DIRECTORY/down_differential 2>/dev/null
        ECHO "1" > $DIRECTORY/sampling_down_factor 2>/dev/null
#        ECHO "1" > $DIRECTORY/io_is_busy 2>/dev/null
        ECHO "0" > $DIRECTORY/ignore_nice_load 2>/dev/null
        ECHO "100000" > $DIRECTORY/sampling_rate 2>/dev/null
        ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null
elif [ "$GOVERNOR" = "ondemandx" ]; then
        ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
        ECHO "50" > $DIRECTORY/powersave_bias 2>/dev/null
        ECHO "15" > $DIRECTORY/down_differential 2>/dev/null
        ECHO "1" > $DIRECTORY/sampling_down_factor 2>/dev/null
        ECHO "0" > $DIRECTORY/ignore_nice_load 2>/dev/null
        ECHO "100000" > $DIRECTORY/sampling_rate 2>/dev/null
        ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null                                        
elif [ "$GOVERNOR" = "conservative" ]; then
        ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
	ECHO "75" > $DIRECTORY/down_threshold 2>/dev/null 
        ECHO "100" > $DIRECTORY/freq_step 2>/dev/null 
elif [ "$GOVERNOR" = "lulzactive" ]; then
	ECHO "85" > $DIRECTORY/inc_cpu_load 2>/dev/null
	ECHO "1" > $DIRECTORY/pump_down_step 2>/dev/null
elif [ "$GOVERNOR" = "smartass" ]; then
	ECHO "500000" > $DIRECTORY/awake_ideal_freq 2>/dev/null
	CAT /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > $DIRECTORY/sleep_ideal_freq 2>/dev/null
	ECHO "800000" > $DIRECTORY/sleep_wakeup_freq 2>/dev/null
	ECHO "85" > $DIRECTORY/max_cpu_load 2>/dev/null
	ECHO "75" > $DIRECTORY/min_cpu_load 2>/dev/null
	ECHO "200000" > $DIRECTORY/ramp_down_step 2>/dev/null
	ECHO "0" > $DIRECTORY/ramp_up_step 2>/dev/null
elif [ "$GOVERNOR" = "abyssplug" ]; then
	ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
	ECHO "40" > $DIRECTORY/down_threshold 2>/dev/null
	ECHO "5" > $DIRECTORY/hotplug_in_sampling_periods 2>/dev/null
	ECHO "20" > $DIRECTORY/hotplug_out_sampling_periods 2>/dev/null
	ECHO "10" > $DIRECTORY/down_differential 2>/dev/null
	ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null
elif [ "$GOVERNOR" = "pegasusq" ]; then
	ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
	ECHO "10" > $DIRECTORY/down_differential 2>/dev/null
	ECHO "1" > $DIRECTORY/sampling_down_factor 2>/dev/null
	ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null
	ECHO "100" > $DIRECTORY/freq_step 2>/dev/null
	ECHO "5" > $DIRECTORY/cpu_up_rate 2>/dev/null
	ECHO "20" > $DIRECTORY/cpu_down_rate 2>/dev/null
	ECHO "100000" > $DIRECTORY/freq_for_responsiveness 2>/dev/null
elif [ "$GOVERNOR" = "hotplug" ]; then
	ECHO "85" > $DIRECTORY/up_threshold 2>/dev/null
	ECHO "40" > $DIRECTORY/down_threshold 2>/dev/null
	ECHO "5" > $DIRECTORY/hotplug_in_sampling_periods 2>/dev/null
	ECHO "20" > $DIRECTORY/hotplug_out_sampling_periods 2>/dev/null
	ECHO "10" > $DIRECTORY/down_differential 2>/dev/null
	ECHO "40000" > $DIRECTORY/sampling_rate 2>/dev/null
fi

fi

BUSYBOX chmod 644 $DIRECTORY/*
BUSYBOX chmod 755 $DIRECTORY

fi

done