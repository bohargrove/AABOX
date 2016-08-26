#!/bin/bash
#########################################################################
#
#  smart_Gsm
#
#########################################################################
#
#
#  1. Put your device in debugging mode
#
#
#########################################################################

echo "[*]"
echo "[*] smart_Gsm"
echo "[*] Press enter to root your phone..."

read -n 1

echo "[*]"

platform=`uname`
if [ $(uname -p) = 'powerpc' ]; then
        echo "[-] PowerPC is not supported."
        exit 1
fi

if [ "$platform" = 'Darwin' ]; then
        adb="./adb.osx"
        version="OS X"
else
        adb="./adb.linux"
        version="Linux"
fi
chmod +x $adb

$adb kill-server

echo "[*] Waiting for device..."
$adb wait-for-device

echo "[*] Device found."

echo "[*] Pushing exploit..."
$adb push pwn /data/local/tmp/
$adb shell chmod 755 /data/local/tmp/pwn

echo "[*] Pushing root tools..."
$adb push su /data/local/tmp/
$adb push busybox /data/local/tmp/
$adb install Superuser.apk

echo "[*] Rooting phone..."
$adb shell /data/local/tmp/pwn

echo "[*] Cleaning up..."
$adb shell rm /data/local/tmp/pwn
$adb shell rm /data/local/tmp/su
$adb shell rm /data/local/tmp/busybox

echo "[*] Exploit complete. Press enter to reboot and exit."
read -n 1
$adb reboot
$adb kill-server
