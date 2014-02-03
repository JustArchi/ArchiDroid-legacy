#!/sbin/sh

# exit 0 -> Zip has been called from internal sd card
# exit 1 -> Zip has been called from external sd card
# exit 2 -> I don't know where zip has been called from

if [ $(ps w | grep -i "[/]storage/sdcard1" | wc -l) -gt 0 ]; then
	# Definitely extsd
	exit 1
fi
if [ $(ps w | grep -i "[m]edia/" | wc -l) -gt 0 ]; then
	# Nearly sure intsd
	exit 0
fi

# I don't know, probably intsd
exit 2