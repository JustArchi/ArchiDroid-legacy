#!/sbin/sh
mkdir /tmp/rdnew
cd /tmp/rdnew
gunzip -c < /tmp/boot.img-ramdisk.gz | /tmp/cpio -i
cp -r /tmp/res /tmp/rdnew/
cp -r /tmp/sbin /tmp/rdnew/
if ! grep -q temasek.sh /tmp/rdnew/init.rc; then
		cat <<EOF >> /tmp/rdnew/init.rc

service temasekinit /sbin/temasek.sh
    class core
    user root
    oneshot
EOF
fi
find . | /tmp/cpio -co | gzip -c > /tmp/boot.img-rdnew.gz
echo \#!/sbin/sh > /tmp/createnewboot.sh
echo /tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/boot.img-rdnew.gz --cmdline \"$(cat /tmp/boot.img-cmdline)\" --base $(cat /tmp/boot.img-base) --output /tmp/newboot.img >> /tmp/createnewboot.sh
chmod 777 /tmp/createnewboot.sh
/tmp/createnewboot.sh
return $?
