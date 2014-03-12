#!/sbin/busybox sh

#### AGNi FRANDOM REPLACEMENT FOR RANDOM

if [ -f /system/etc/init.d/S80enable_001bkfrandomlagfix_020-on ]; then
	chmod 666 /dev/frandom;
	chmod 666 /dev/erandom;
	mv /dev/random /dev/random.orig && ln /dev/frandom /dev/random;
	chmod 666 /dev/random;
	mv /dev/urandom /dev/urandom.orig && ln /dev/erandom /dev/urandom;
	chmod 666 /dev/urandom;
fi;
