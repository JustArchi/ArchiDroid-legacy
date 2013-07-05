CZYOPTI=0
CZYPNGCRUSH=1
LICZBA=7

ILE=0
if [ $CZYOPTI -eq 1 ] ; then
find ./test -iname "*.png" | while read PNG_FILE ; do
	while [ $ILE -ge $LICZBA ] ; do
		sleep 1
		ILE=`ps aux | grep [o]ptipng | wc -l`
	done
	if [ `echo "$PNG_FILE" | grep -c "\.9\.png$"` -eq 0 ] ; then
		optipng -o99 "$PNG_FILE" &
		#pngcrush -rem alla -reduce -brute "$PNG_FILE" tmp_img_file.png;
		#mv -f tmp_img_file.png $PNG_FILE;
	fi
	ILE=`ps aux | grep [o]ptipng | wc -l`
done;
ILE=0
fi

if [ $CZYPNGCRUSH -eq 1 ] ; then
find ./test -iname "*.png" | while read PNG_FILE ; do
        #while [ $ILE -ge $LICZBA ] ; do
        #        sleep 1
        #        ILE=`ps aux | grep [p]ngcrush | wc -l`
        #done
        if [ `echo "$PNG_FILE" | grep -c "\.9\.png$"` -eq 0 ] ; then
                pngcrush -rem alla -reduce -brute -ow "$PNG_FILE" > /dev/null 2>&1 &
        fi
        #ILE=`ps aux | grep [p]ngcrush | wc -l`
done;
ILE=0
fi
