#!/sbin/sh

BB=/system/xbin/busybox
SKYDLOGFILE="/data/skydragonsettings.log"

$BB mount -o remount,rw /system
$BB mount -o remount,rw /

$BB rm -rf /data/skydragonsettings.log
$BB rm -rf /data/skydragonkernel.log
$BB rm -rf /data/skydragonOS.log
$BB rm -rf /data/skydkernel.log
$BB rm -rf /data/sdkernel.log

# Tweak VM
$BB echo 200 > /proc/sys/vm/dirty_expire_centisecs
$BB echo 20 > /proc/sys/vm/dirty_background_ratio
$BB echo 40 > /proc/sys/vm/dirty_ratio
$BB echo 0 > /proc/sys/vm/swappiness
$BB echo VM Tweaked at $(date) >> $SKYDLOGFILE;

# Allow untrusted apps to read from debugfs
if [ -e /system/lib/libsupol.so ]; then
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow debuggerd app_data_file dir search" \
	"allow sensors diag_device chr_file { read write open ioctl }" \
	"allow sensors sensors capability net_raw" \
	"allow init kernel security setenforce" \
	"allow netmgrd netmgrd netlink_xfrm_socket nlmsg_write" \
	"allow netmgrd netmgrd socket { read write open ioctl }"
fi;

# Init.d/su.d support
$BB run-parts /system/su.d

# Google Services battery drain fixer by Alcolawl@xda
pm enable com.google.android.gms/.update.SystemUpdateActivity
pm enable com.google.android.gms/.update.SystemUpdateService
pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
pm enable com.google.android.gsf/.update.SystemUpdateActivity
pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
pm enable com.google.android.gsf/.update.SystemUpdateService
pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver
$BB echo Battery Drain Fixed at $(date) >> $SKYDLOGFILE;

#Script created by Alcolawl - 1/06/2016
echo ----------------------------------------------------
echo Applying 'GhostPepper' Interactive Governor Settings
echo ----------------------------------------------------
#Apply settings to LITTLE cluster
echo Applying settings to LITTLE cluster
#Temporarily change permissions to governor files for the LITTLE cluster to enable Interactive governor
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu1/online								#Online Core 1
chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu2/online								#Online Core 2
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu3/online								#Online Core 3
chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
#Tweak Interactive Governor
echo 95 460800:20 600000:35 672000:52 768000:66 864000:79 960000:92 1248000:96 1344000:98 1478400:99 1555200:100 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
echo -1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo 200 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo 60000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
#Apply settings to Big cluster
echo Applying settings to Big cluster
#Temporarily change permissions to governor files for the Big cluster to enable Interactive governor
echo 1 > /sys/devices/system/cpu/cpu4/online								#Online Core 4
chmod 644 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu5/online								#Online Core 5
chmod 644 /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
#Temporarily change permissions to governor files for the Big cluster to lower minimum frequency to 384MHz
chmod 644 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 384000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq			#Core 4 Minimum Frequency = 384MHz
chmod 444 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
echo 384000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq			#Core 5 Minimum Frequency = 384MHz
chmod 444 /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
echo 384000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq			#Core 6 Minimum Frequency = 384MHz
chmod 444 /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
echo 384000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq			#Core 7 Minimum Frequency = 384MHz
chmod 444 /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
#Tweak Interactive Governor
echo 24 480000:16 633600:29 768000:40 864000:52 960000:63 1248000:71 1344000:80 1440000:88 1536000:94 1632000:97 1728000:98 1824000:99 1948000:100 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
echo -1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
echo 384000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
echo 200 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
#Enable Input Boost for LITTLE cluster @672MHz for 40ms
echo 0:672000 1:672000 2:672000 3:672000 4:0 5:0 6:0 7:0 > /sys/module/cpu_boost/parameters/input_boost_freq
echo 0 > /sys/module/cpu_boost/parameters/boost_ms
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
#Disable TouchBoost
echo Disabling TouchBoost
echo 0 > /sys/module/msm_performance/parameters/touchboost
#Disable Core Control and Enable Thermal Throttling allowing for longer sustained performance
echo Disabling Aggressive CPU Thermal Throttling
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo Y > /sys/module/msm_thermal/parameters/enabled

exit;
