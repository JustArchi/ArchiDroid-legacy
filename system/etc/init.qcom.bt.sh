#!/system/bin/sh

BLUETOOTH_SLEEP_PATH=/proc/bluetooth/sleep/proto
LOG_TAG="qcom-bluetooth"
LOG_NAME="${0}:"

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

failed ()
{
  loge "$1: exit code $2"
  exit $2
}

# Note that "hci_qcomm_init -e" prints expressions to set the shell variables
# BTS_DEVICE, BTS_TYPE, BTS_BAUD, and BTS_ADDRESS.

POWER_CLASS=`getprop qcom.bt.dev_power_class`
LE_POWER_CLASS=`getprop qcom.bt.le_dev_pwr_class`
TRANSPORT=`getprop ro.qualcomm.bt.hci_transport`

#find the transport type
logi "Transport : $TRANSPORT"

setprop bluetooth.status off

case $POWER_CLASS in
  1) PWR_CLASS="-p 0" ;
     logi "Power Class: 1";;
  2) PWR_CLASS="-p 1" ;
     logi "Power Class: 2";;
  3) PWR_CLASS="-p 2" ;
     logi "Power Class: CUSTOM";;
  *) PWR_CLASS="";
     logi "Power Class: Ignored. Default(1) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "Power Class: To override, Before turning BT ON; setprop qcom.bt.dev_power_class <1 or 2 or 3>";;
esac

case $LE_POWER_CLASS in
  1) LE_PWR_CLASS="-P 0" ;
     logi "LE Power Class: 1";;
  2) LE_PWR_CLASS="-P 1" ;
     logi "LE Power Class: 2";;
  3) LE_PWR_CLASS="-P 2" ;
     logi "LE Power Class: CUSTOM";;
  *) LE_PWR_CLASS="-P 1";
     logi "LE Power Class: Ignored. Default(2) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "LE Power Class: To override, Before turning BT ON; setprop qcom.bt.le_dev_pwr_class <1 or 2 or 3>";;
esac

eval $(/system/bin/hci_qcomm_init -e $PWR_CLASS $LE_PWR_CLASS && echo "exit_code_hci_qcomm_init=0" || echo "exit_code_hci_qcomm_init=1")

case $exit_code_hci_qcomm_init in
  0) logi "Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS";;
  *) failed "Bluetooth QSoC firmware download failed" $exit_code_hci_qcomm_init;
     setprop bluetooth.status off;
     exit $exit_code_hci_qcomm_init;;
esac

setprop bluetooth.status on

logi "start bluetooth smd transport"

exit 0
