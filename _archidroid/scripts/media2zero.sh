#!/tmp/bash
# Archi's Media2Zero
# JustArchi@JustArchi.net
if [ ! -d /data/media/0 ]; then
	if [ -f /data/media/0 ]; then
		rm -f /data/media/0
	fi
	cd /data/media
	FILES=`ls`
	mkdir -p /data/media/0
	
	# Just to be sure
	mkdir -p /data/media/obb
	mkdir -p /data/media/legacy
	
	for i in $FILES; do
		mv "$i" 0/
	done
fi
exit 0