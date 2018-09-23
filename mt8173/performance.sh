#!/system/bin/sh
echo ==========Disable thermal==========
system/bin/thermal_manager /system/etc/.tp/.ht120.mtc
echo ==========Disable power throttle==========
echo 2 0 > /sys/devices/platform/battery_throttle/battery_throttle_mode
echo ==========Disable DVFS/Hotplug==========
echo 0 > /proc/hps/enabled
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo ==========Set GPU 600Mhz==========
echo 598000 1125 > /proc/gpufreq/gpufreq_fixed_freq_volt
