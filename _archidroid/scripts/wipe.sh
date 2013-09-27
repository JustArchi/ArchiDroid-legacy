#!/sbin/sh
# Remove content of /data partition excluding data/media files
# By Kryten2k35
##
cd /data

# Added by JustArchi
for i in `find /data -iname ".*" -maxdepth` ; do
  rm -fR "$i"
done

for i in `ls` ; do
	if [ "$i" != "media" ]
		then rm -fR "$i"
	fi
done