#!/tmp/packing/sbin/busybox sh

rm -rf /tmp/packing
rm -rf /tmp/extracted
rm -rf /tmp/bootimg
rm -f /tmp/mkbootimg
rm -f /tmp/bootimgtools
rm -f /tmp/PSN_AGNi_assembler.sh
rm -f /tmp/reseter.sh

# Make sure of right ownership in /data/media
chown -R media_rw:media_rw /data/media
