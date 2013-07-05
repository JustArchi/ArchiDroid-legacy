#!/system/bin/sh

#L="log -p i -t fixmyexfat"
#offset 106: x00 = clean x02 = dirty unmount

echo "[fixmyexfat v6.4] exFat header repair tool for CM10.1 + AOSP ROMs (HMkX2 CORE//XDA)"
echo "                  Exponentially less fast and loose than anticipated"
echo "                  Usage: $0 <block device, eg /dev/block/mmcblk1p1>"
#$L "Called with ($*)"

mountCMD="mount.exfat-fuse"
stagingAREA="/mnt/secure/staging"

splitSafe() {
	local locA
	local lenA

	let locA=$2*4
	let lenA=$3*4

	printf -- "%s" ${1:$locA:$lenA}
}

makeSafe() {
	printf -- "%s" $1|hexdump -v -e '"\\\x" 1/1 "%02x" ""'
}

makeReadable() {
	printf -- "$*" | hexdump -v -e '" " 1/1 "%02x" ""'|cut -c 2-
}


if [ -z "$1" ]; then
	echo "[fixmyexfat] Defaulting target to GS3's mmcblk1p1"
	fixTARGET="/dev/block/mmcblk1p1"
	#exit
else
	echo "[fixmyexfat] Manual target is $1"
	fixTARGET="$1"
fi

if ! [ -b "$fixTARGET" ] ; then 
	echo "ABORT! ABORT! ABORT! $fixTARGET is not a block-special file/device, do you enter it correctly?"
	exit 1
fi

if ! [ "$(whoami)" == "root" ] ; then
	echo "ABORT! ABORT! ABORT! Must be run as ROOT"
	exit 1
fi


#ALL VARIABLES STORED IN NULLSAFE (e.g. '\x00\x00\x43') STRING FORMAT

BLKHEADER=$(dd if=$fixTARGET bs=512 count=1 skip=0 2> /dev/null|hexdump -v -e '"\\\x" 1/1 "%02x" ""')

#TEST=`splitSafe $BLKHEADER 0 8`
#printf -- %s $TEST

#TEST=$(echo -n $BLKHEADER | head -c 8 | tail -c 4|hexdump -v -e '"\\\x" 1/1 "%02x" ""')
#SEGMENT0=$(echo -n "XFAT" | hexdump -v -e '"\\\x" 1/1 "%02x" ""')
TEST=$(splitSafe $BLKHEADER 4 4)
SEGMENT0=$(makeSafe "XFAT")

if [ "$TEST" != "$SEGMENT0" ]; then
	echo "ABORT! ABORT! ABORT! $fixTARGET lacks EXFAT signature!!"
	echo "Segment 0 (4:8) [Sig] -- [$(makeReadable $SEGMENT0)] -> ($(makeReadable $TEST))"
	exit 1
fi


#sleep 5

SEGMENT1='\xeb\x76\x90\x45'
TEST=$(splitSafe $BLKHEADER 0 4)
printf "Segment 1 (0:4)   [ID]        -- [%s] -> (%s)" "$(makeReadable $SEGMENT1)" "$(makeReadable $TEST)"

#echo -n "Segment 1 is: "
#echo -ne $SEGMENT1| hexdump -Cv
#echo -n "Test 1 is: "
#echo -ne $TEST| hexdump -Cv

if [ "$TEST" == "$SEGMENT1" ] ; then
	echo " (OK)"
else
	echo " (BAD)"
	echo -n "$SEGMENT1" | dd of="$fixTARGET" bs=1 count=4 seek=0 2> /dev/null
fi
	
#sleep 5
	
#Use relative-intelligent pattern matching instead
SEGMENT2A=$(splitSafe $BLKHEADER 483 1)
SEGMENT2B=$(splitSafe $BLKHEADER 489 1)

if [ "$SEGMENT2A" == "$SEGMENT2B" ] ; then
	printf "        %s <- [SmartFill Successful!] -> %s\n" "$(makeReadable $SEGMENT2A)" "$(makeReadable $SEGMENT2B)"
	SEGMENT2=$(for i in 1 2 3 4 ; do printf "%s" "$SEGMENT2A";done)
	TEST=$(splitSafe $BLKHEADER 484 4)
	printf "Segment 2 (484:4) [SmartFill] -- [%s] -> (%s)" "$(makeReadable $SEGMENT2)" "$(makeReadable $TEST)"

	if [ "$TEST" == "$SEGMENT2" ] ; then
		echo " (OK)"
	else
		echo " (BAD)"
		echo -n "$SEGMENT2" | dd of="$fixTARGET" bs=1 count=4 seek=484 2> /dev/null
	fi
else
	printf "        %s <- [SmartFill FAILURE!] -> %s\n      Skipping Segment 2!" "$(makeReadable $SEGMENT2A)" "$(makeReadable $SEGMENT2B)"

fi


#sleep 5


#This is variable. Have to try all of them.
SEGMENT3A=$(splitSafe $BLKHEADER 507 1)
SEGMENT3FILL=$(for i in 1 2 ; do printf "%s" "$SEGMENT3A";done;printf "%s" '\x55\xaa')
TEST=$(splitSafe $BLKHEADER 508 4)
i=0
printf "     [Attempting smartmount search..] -> %s [%s lead]\n" "$(makeReadable $TEST)" "$(makeReadable $SEGMENT3A)"
for SEGMENT3 in '\x00\x00\x55\xaa' '\x1f\x2c\x55\xaa' "$SEGMENT3FILL"; do	
	#printf "%s\n" $SEGMENT3; done
	printf "Segment 3 (508:4) [Tail]      -- [%s] -> (%s)" "$(makeReadable $SEGMENT3)" "$(makeReadable $TEST)"
	echo -n "$SEGMENT3" | dd of="$fixTARGET" bs=1 count=4 seek=508 2> /dev/null
	
	#echo "Performing test-mount in local mountspace..."
	mountpoint -q "$stagingAREA" && umount "$stagingAREA"
	
	$mountCMD -o ro "$fixTARGET" "$stagingAREA" 2>&1 
	RESULT="$?"
	
	mountpoint -q "$stagingAREA" && umount "$stagingAREA"
	
	if [ "$RESULT" -ne 0 ]; then
		echo " (Fail!)"
	else
		echo " (SUCCESS!)"
		i=1
		break
	fi
done

if [ "$i" -ne 1 ]; then
	echo "----> AUTOREPAIR FAILURE. 'I deed what I cood!' <----"
fi

echo "Check complete!"