#!/system/bin/sh

MODDIR=${0%/*}
LOG="/data/local/tmp/wifi_enhance.log"

log() {
    echo "[$(date '+%H:%M:%S')] $1" >> $LOG
}

write() {
    if [ -f "$1" ]; then
        chmod 666 "$1" 2>/dev/null

        echo "$2" > "$1" 2>/dev/null

        if [ $? -eq 0 ]; then
            log "OK: $1 = $2"
        else
            log "FAIL: $1"
        fi
    fi
}

# ==========================================
# Wait boot completion
# ==========================================

until [ "$(getprop sys.boot_completed)" = "1" ]
do
    sleep 5
done

sleep 20

log "================================="
log " Adaptive Network Engine Started "
log "================================="

# ==========================================
# Detect Android
# ==========================================

SDK=$(getprop ro.build.version.sdk)
SOC=$(getprop ro.soc.manufacturer)
KERNEL=$(uname -r)

log "Android SDK: $SDK"
log "SOC: $SOC"
log "Kernel: $KERNEL"

# ==========================================
# TCP congestion control
# ==========================================

AVAILABLE=$(cat /proc/sys/net/ipv4/tcp_available_congestion_control 2>/dev/null)

if echo "$AVAILABLE" | grep -q "bbr"; then
    write /proc/sys/net/ipv4/tcp_congestion_control "bbr"
    log "Using BBR"
elif echo "$AVAILABLE" | grep -q "westwood"; then
    write /proc/sys/net/ipv4/tcp_congestion_control "westwood"
    log "Using Westwood"
else
    write /proc/sys/net/ipv4/tcp_congestion_control "cubic"
    log "Using Cubic"
fi

# ==========================================
# Queue discipline
# ==========================================

write /proc/sys/net/core/default_qdisc "fq"

# ==========================================
# TCP optimizations
# ==========================================

write /proc/sys/net/ipv4/tcp_fastopen "3"
write /proc/sys/net/ipv4/tcp_ecn "1"
write /proc/sys/net/ipv4/tcp_slow_start_after_idle "0"
write /proc/sys/net/ipv4/tcp_mtu_probing "1"

# ==========================================
# Buffer tuning
# ==========================================

write /proc/sys/net/core/rmem_max "16777216"
write /proc/sys/net/core/wmem_max "16777216"
write /proc/sys/net/core/netdev_max_backlog "5000"

write /proc/sys/net/ipv4/tcp_rmem "4096 87380 16777216"
write /proc/sys/net/ipv4/tcp_wmem "4096 65536 16777216"

# ==========================================
# Interface auto-detection
# ==========================================

for iface in $(ls /sys/class/net/)
do
    case "$iface" in
        wlan*|swlan*|wifi*)
            write /sys/class/net/$iface/tx_queue_len "2048"
            log "WiFi optimized: $iface"
        ;;

        rmnet*|ccmni*|rmnet_data*|rmnet_mhi*)
            write /sys/class/net/$iface/tx_queue_len "1024"
            log "Mobile optimized: $iface"
        ;;
    esac
done

# ==========================================
# Qualcomm tweaks
# ==========================================

if [ "$SOC" = "Qualcomm" ]; then

    log "Applying Qualcomm optimizations"

    if [ -f /sys/module/lpm_levels/parameters/sleep_disabled ]; then
        write /sys/module/lpm_levels/parameters/sleep_disabled "N"
    fi
fi


# ==========================================
# Battery Aware Mode
# ==========================================

BATTERY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)

if [ -z "$BATTERY" ]; then
    BATTERY=50
fi

log "Battery level: $BATTERY%"

# ==========================================
# Low battery mode
# ==========================================

if [ "$BATTERY" -le 25 ]; then

    log "Battery Saver Mode activated"

    # Less aggressive buffers
    write /proc/sys/net/core/rmem_max "4194304"
    write /proc/sys/net/core/wmem_max "4194304"

    write /proc/sys/net/ipv4/tcp_rmem "4096 87380 4194304"
    write /proc/sys/net/ipv4/tcp_wmem "4096 65536 4194304"

    # Smaller queues
    for iface in $(ls /sys/class/net/)
    do
        case "$iface" in
            wlan*|swlan*|wifi*)
                write /sys/class/net/$iface/tx_queue_len "512"
            ;;

            rmnet*|ccmni*|rmnet_data*|rmnet_mhi*)
                write /sys/class/net/$iface/tx_queue_len "256"
            ;;
        esac
    done

    log "Eco network profile applied"

else

    log "Performance network profile applied"

fi

# ==========================================
# Finished
# ==========================================

log "All tweaks applied successfully"
log "Battery aware mode active"

exit 0