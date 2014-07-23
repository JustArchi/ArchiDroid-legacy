#!/system/bin/sh

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

setprop gsm.version.baseband `strings /dev/block/platform/msm_sdcc.1/by-name/modem  | grep "M8930B-" | head -1`
