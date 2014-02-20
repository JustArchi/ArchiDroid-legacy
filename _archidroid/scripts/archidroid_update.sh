#!/sbin/sh

AD="/data/media/0/ArchiDroid"

touch $AD/UPDATE
if [ "$1" == "force" ]; then
	touch $AD/FORCE
fi

sync
exit 0