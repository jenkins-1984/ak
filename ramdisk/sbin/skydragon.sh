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

exit;
