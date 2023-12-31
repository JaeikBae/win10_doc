#!/usr/bin/env bash

MEM="16384"
SMP="8,cores=4"
OPT="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--mem) MEM="$2"; shift ;;
        -s|--smp) SMP="$2"; shift ;;
        -o|--opt) OPT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

qemu-system-x86_64     -vga std -nographic -k en-us -vnc :0\
    --enable-kvm -m "$MEM"     \
    -cpu "Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$OPT"     \
    -smp "$SMP"     -machine q35     -usb -device usb-kbd -device usb-tablet     \
    -smbios type=2     -drive driver=raw,media=disk,index=0,file="./win10_hdd.img"      \
    -net nic -net user \
    -cdrom "./win10_x64.iso"  -rtc base=localtime,clock=host     \
    -boot order=cd,menu=on
