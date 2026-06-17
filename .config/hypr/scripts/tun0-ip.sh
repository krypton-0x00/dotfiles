#!/bin/bash

# Get tun0 IP (if exists)
TUN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -n "$TUN_IP" ]; then
    echo -n "$TUN_IP" | wl-copy
    notify-send -t 0 -u low "VPN Connected (tun0)" "IP: $TUN_IP\n(Copied to clipboard)"
else
    notify-send -t 3000 -u normal "VPN Disconnected" "tun0 interface not found"
fi
