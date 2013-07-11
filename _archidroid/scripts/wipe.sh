#!/tmp/bash
# Remove content of /data partition excluding data/media files
# By Kryten2k35
##
cd /data

# Added by JustArchi
find /data -iname ".*" -maxdepth 1 -delete

FILES=(*)

for i in *; do
	if [ "$i" != "media" ]
		then rm -fR "$i"
	fi
done