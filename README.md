# Wi-Fi | 4G Enhanced v4 – Magisk Module
ПРОВЕРЯЛ В ПОЛЕ И ПРОДОЛЖАЮ ТЕСТЫ НА 18.08.2026. Там где айфон 15 показывает нет сигнала, мой дроид показывает мне места рилсы
Adaptive network optimization module for Android 13–16.  
Designed to improve Wi-Fi, LTE/5G and VPN responsiveness, reduce latency and stabilize network behavior without aggressive legacy tweaks.

Optimized for Qualcomm devices such as the Poco F3 (Snapdragon 870), while remaining compatible with most modern Android devices.

---

# Features

## Modern TCP/IP tuning
- Adaptive congestion control:
  - BBR (preferred)
  - Westwood fallback
  - Cubic fallback
- fq queue discipline
- TCP Fast Open
- ECN support
- MTU probing for mobile/VPN stability
- Optimized TCP buffers for Android 13+

## Wi-Fi / Mobile optimization
- Automatic interface detection:
  - wlan*
  - rmnet*
  - ccmni*
  - swlan*
- Dynamic queue tuning
- Better latency handling
- Reduced bufferbloat

## VPN optimization
Improves stability and responsiveness for:
- WireGuard
- OpenVPN
- AmneziaWG
- V2Ray/Xray
- Hysteria
- TUIC

Especially beneficial on LTE/5G mobile networks.

## Battery Aware Mode
- Automatically reduces tuning aggressiveness on low battery
- Avoids aggressive wakelocks
- No background ping watchdog loops
- Deep sleep friendly

## Qualcomm enhancements
- Safe Qualcomm-specific tuning
- VoLTE / VoWiFi compatibility hints
- IWLAN support

## Safe design
- Checks file existence before writing
- Non-destructive tuning
- No dangerous MTU forcing
- No fake LTE category hacks
- Logging enabled for troubleshooting

---

# Compatibility

Supports:
- Android 13–16
- Magisk 23+
- KernelSU
- APatch

Tested on:
- Poco F3
- HyperOS


Should also work on:
- Samsung
- Pixel
- OnePlus
- Xiaomi
- Motorola
- MediaTek devices
- Other Qualcomm devices

---

# Installation

1. Download the latest `wifienhan_vX.X.zip` from Releases
2. Open Magisk / KernelSU / APatch
3. Install from storage
4. Reboot device

---

# Logs

Module log:
```bash
/data/local/tmp/wifi_enhance.log
