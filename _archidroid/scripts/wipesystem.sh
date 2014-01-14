#!/sbin/sh

# Delete whole system content
rm -fR /system/*
for i in `find /system -iname ".*" -maxdepth 1`; do
	rm -fR "$i"
done

sync
exit 0