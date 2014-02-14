#!/sbin/sh

reboot recovery &

# In some recent versions of CWM, reboot recovery command isn't working properly, it's stuck
# We should keep this fallback for a while
# If reboot in fact works, 5 seconds will be enough to sync and reboot device
sleep 5
sync
echo 1 > /proc/sys/kernel/sysrq # HARD
echo b > /proc/sysrq-trigger # REBOOT

exit 0