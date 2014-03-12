#!/sbin/busybox sh

#Exynos 4412 Default scaling-frequency(I930x)
echo "1400000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
