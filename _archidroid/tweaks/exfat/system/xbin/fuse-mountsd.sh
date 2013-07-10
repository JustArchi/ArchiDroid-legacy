#!/system/bin/sh
echo ""
echo "[fuse-mountsd v6.4] exFat+NTFS autorepair and mount script (HMkX2 CORE//XDA)"
echo "     Automated mounting and repair of alternate SD fs on GS3 CM10.1 [+AOSP Roms!]"
echo ""

#Directory security -- disable to create folder anywhere
# SET TO 0 TO DISABLE IT
dirSECURITY=1

#####################
## SETTINGS BACKUP ##
#####################

multiMOUNT=0
stagingAREA="/mnt/secure/staging"
#Entries for multi-mount function
useBYPASS=0
storageREMOUNT=0
rootREMOUNT=0

umountSET=0
bootSET=0

myVERSION=`getprop ro.build.version.release`
adbSTATUS=`getprop init.svc.adbd`
#running or stopped
adbPORT=`getprop service.adb.tcp.port`
# -1 or "" for off, ____ for enabled
if [ -z "$adbPORT" ]; then
	adbPORT=-1
fi
adbUSEPORT=$adbPORT
adbCONNECTED=0
adbSYSROOT=`getprop persist.sys.root_access`
#1=Apps 2=ADB 3=Apps+ADB
if [ -z "$adbSYSROOT" ]; then
	echo "WARNING: Your Root Permissions (persist.sys.root_access) is blank."
	echo "         Setting it to '1/Apps Only'. Change it to '0/Disaled' if you want."
	echo ""
	adbSYSROOT='1'
	#Bare minimum for people using SuperSU, since we cannot unset props from shell
fi
adbUSEROOT=$adbSYSROOT
adbRSAKEYED=0
#Flag if **WE** altered the key database
adbKEYATCONNECT=0
#Flag to check key at connect time

NOGO=''

#########################
## ADB PROXY FUNCTIONS ##
#########################

trap "adbRESET" EXIT 

adbSendCmd() {
	local ERR
	local ERRCMD
	ERRCMD="$*; echo -n \$?"
	#echo "ERRCMD is ($ERRCMD)"
	adbStartFlex
	echo "Smashing ADB command: $*"
	#adb -s localhost:"$adbUSEPORT" shell su -c "$*; echo $?"
	
	#(echo -e "Hello\nThere"|tee fuseText_pipe|sed '$d'&);TEST=$(sed -n '$ p' < fuseText_pipe)
	mkfifo "$ANDROID_CACHE"/fuseText_pipe
	
	#(adb -s localhost:"$ERRCMD" shell su -c \'$ERRCMD\'|tee "$ANDROID_CACHE"/fuseText_pipe|sed '$d'&);ERR=$(sed -n '$ p' < "$ANDROID_CACHE"/fuseText_pipe)
	adb -s localhost:"$adbUSEPORT" shell su -c \'$ERRCMD\'|tee "$ANDROID_CACHE"/fuseText_pipe|sed '$d'&
	ERR=$(cat "$ANDROID_CACHE"/fuseText_pipe|sed -n '$ p')
	
	rm "$ANDROID_CACHE"/fuseText_pipe
	if [ -z "$ERR" ] ; then
		echo ""
		echo "###########################################"
		echo "     ERROR: Root access was DENIED!!!"
		echo "    Please grant ADB Shell root access!"
		echo "###########################################"
		echo ""
		ERR=-1
		exit 1
	fi
	echo "Command smashed. ($ERR)"	
	return $ERR
}

adbStartFlex() {
	local adbRESTART=0

	#echo DEBUG: adbPort $adbPORT adbUSEPORT $adbUSEPORT
	if [ "$adbUSEROOT" != "3" ] ; then
			setprop persist.sys.root_access "3"
			adbUSEROOT=3
	fi

	if  ! [ "$adbUSEPORT" -gt 0 ] ; then
		adbUSEPORT=5556
		setprop service.adb.tcp.port "$adbUSEPORT"
		adbRESTART=1
	fi

	if [ "$adbCONNECTED" -eq 0 ] ; then
	
if [ "$adbKEYATCONNECT" -eq 1 ] ; then
	echo "ADB RSA Key workaround enabled"
	echo "   Shifting some encryption keys around..."
	
	if ! [ -f "$ANDROID_DATA/.android/adbkey.pub" ] ; then
		echo "Regenning adb RSA pubkeys in $ANDROID_DATA/.android/adbkey.pub"
		adb kill-server
		HOME="$ANDROID_DATA" adb start-server
	fi
	
	echo "Scanning $ANDROID_DATA/misc/adb/adb_keys for localhost key"
	
	grep -Fxq "$(cat $ANDROID_DATA/.android/adbkey.pub)" "$ANDROID_DATA/misc/adb/adb_keys"
	
	if [ "$?" -ne 0 ] ; then
		echo "Localhost key not in allowed adb_keys, adding it manually"
		cat "$ANDROID_DATA"/.android/adbkey.pub >> "$ANDROID_DATA"/misc/adb/adb_keys
		adbRSAKEYED=1
		adbRESTART=1
	else
		echo "Looks like Localhost key is already set! Good to go!"
	fi
fi

if [ "$adbRESTART" -eq 1 ] ; then
		adb kill-server
		stop adbd
		start adbd
		sleep 1
fi
		#adb kill-server
		HOME="$ANDROID_DATA" adb connect localhost:"$adbUSEPORT"
		echo "Verifying ADB connection:"
		sleep 1
		#Why the hell I need these I don't know... "offline" slow to connect
		adb devices
		#sleep 10
		adbCONNECTED=1
	fi

}

adbRESET() {
	local adbRESTART=0

	echo "Resetting ADB loopback connection/root security to PRIOR..."
	
	if [ "$adbCONNECTED" -ne 0 ] ; then
		adb disconnect localhost:"$adbUSEPORT"
		adbCONNECTED=0

		if [ "$adbRSAKEYED" -ne 0 ] ; then
			#echo "(Removing added RSA key) COMMENT THIS OUT"
			sed -i "\|$(cat $ANDROID_DATA/.android/adbkey.pub)|d" "$ANDROID_DATA/misc/adb/adb_keys"
			adbRESTART=1
		fi
		
		if [ "$adbPORT" -le 0 ] ; then
			setprop service.adb.tcp.port "$adbPORT"
			adbRESTART=1
		fi
		
		if [ "$adbRESTART" -eq 1 ] ; then
			stop adbd
			start adbd
		fi
	fi
	
	if [ "$adbUSEROOT" -ne "$adbSYSROOT" ] ; then
		setprop persist.sys.root_access "$adbSYSROOT"
	fi

	
	if [ "$adbSTATUS" == "stopped" ] ; then
		adb kill-server
		stop adbd
	fi
	
	if [ "$storageREMOUNT" -eq 1 ] ; then
			mount -r -o remount /storage
	fi
	
	if [ "$rootREMOUNT" -eq 1 ] ; then
			mount -r -o remount /
	fi
}

analyzePhone() {

	local mtdEX=0
	local mmcBLK0EX=0
	local mmcBLK1EX=0
	local isEXTERNAL=0
	local isSECONDARY=0
	local RESULT
	local RESULT2
	
#######################################
## Basic checks to set env variables ##	
#######################################

if [ -z "$ANDROID_CACHE" ]; then
	echo "(Warning!) ANDROID_CACHE is not defined!"
	if [ -d "/cache" ] ; then
		ANDROID_CACHE="/cache"
		echo "   Recovered... /cache exists"
	else
		echo "ERROR! /cache does not exist, exiting..."
		exit 1
	fi
	
fi

if [ -z "$ANDROID_STORAGE" ]; then
	echo "(Warning!) ANDROID_STORAGE is not defined!"
	if [ -d "/storage" ] ; then
		ANDROID_STORAGE="/storage"
		echo "   Recovered... /storage exists"
	else
		echo "ERROR! /storage does not exist, exiting..."
		exit 1
	fi
	
fi	

if [ -z "$ANDROID_DATA" ]; then
	echo "(Warning!) ANDROID_DATA is not defined!"
	if [ -d "/data" ] ; then
		ANDROID_DATA="/data"
		echo "   Recovered... /data exists"
	else
		echo "ERROR! /data does not exist, exiting..."
		exit 1
	fi
	
fi	

##########################
## Scan for what exists ##
##########################

		echo -n "(1) Checking for MTDblock: "
		cat /proc/partitions|grep mtdblock 1>/dev/null
		RESULT="$?"	
		if [ "$RESULT" -eq 0 ] ; then
			echo "(YES)"
			mtdEX=1
		else
			echo "(no)"
		fi
	
		echo -n "(2) Checking for mmcblk0: "
		cat /proc/partitions|grep "mmcblk0$" 1>/dev/null
		RESULT="$?"
		if [ "$RESULT" -eq 0 ] ; then
			echo "(YES)"
			mmcBLK0EX=1
		else
			echo "(no)"
		fi
		
		echo -n "(3) Checking for mmcblk1: "
		cat /proc/partitions|grep "mmcblk1$" 1>/dev/null
		RESULT="$?"		
		if [ "$RESULT" -eq 0 ] ; then
			echo "(YES)"
			mmcBLK1EX=1
		else
			echo "(no)"
		fi

		echo -n "(4) Checking for SECONDARY_STORAGE: "
		if [ ! -z "$SECONDARY_STORAGE" ] ; then
			echo "(YES)"
			isSECONDARY=1
		else
			echo "(no)"
		fi
		
		echo -n "(5) Checking for EXTERNAL_STORAGE: "
		if [ ! -z "$EXTERNAL_STORAGE" ] ; then
			echo "(YES)"
			isEXTERNAL=1
		else
			echo "(no)"
		fi
	
		echo -n "(6) Checking for rw-able $ANDROID_STORAGE: "
		cat /proc/mounts|grep " $ANDROID_STORAGE .*rw" 1>/dev/null
		RESULT="$?"		
		mountpoint -q "$ANDROID_STORAGE"
		RESULT2="$?"
		
		if [ "$RESULT2" -ne 0 ] ; then
			echo "(n/a)"
		elif [ "$RESULT" -eq 0 ] ; then
			echo "(YES)"
		else
			echo "(no)"
			  storageREMOUNT=1			
		fi	

		echo -n "(7) Checking for rw-able /: "
		cat /proc/mounts|grep " / .*rw" 1>/dev/null
		RESULT="$?"		
		if [ "$RESULT" -eq 0 ] ; then
			echo "(YES)"
		else
			echo "(no)"
			  rootREMOUNT=1			
		fi		
	
	echo ""
###################################
## Annoying error-checking logic ##
###################################
	
if [ "$mmcBLK1EX" -eq 1 ] ; then

	echo "<<mmcblk1 exists..>>"
	
	NOGO=" -e mtdblock -e mmcblk0"
	if [ "$isEXTERNAL" -eq 0 ]; then
		echo "(Warning!) EXTERNAL_STORAGE is not defined!"
		if [ -d "$ANDROID_STORAGE/sdcard0" ] ; then
			SECONDARY_STORAGE="$ANDROID_STORAGE/sdcard0"
			echo "   Recovered... $ANDROID_STORAGE/sdcard0 exists"
		else
			echo "ERROR! $ANDROID_STORAGE/sdcard0 does not exist, exiting..."
			exit 1
		fi
		
	fi
	
	if [ "$isSECONDARY" -eq 0 ]; then
		echo "(Warning!) SECONDARY_STORAGE is not defined!"
		if [ -d "$ANDROID_STORAGE/sdcard1" ] ; then
			SECONDARY_STORAGE="$ANDROID_STORAGE/sdcard1"
			echo "   Recovered... $ANDROID_STORAGE/sdcard1 exists"
		else
			echo "ERROR! $ANDROID_STORAGE/sdcard1 does not exist, exiting..."
			exit 1
		fi
		
	fi
	
elif [ "$mmcBLK0EX" -eq 1 ] ; then

	echo "<<mmcblk0 exists..>>"
	
	if [ "$mtdEX" -eq 1 ] ; then
	
		NOGO="$NOGO"' -e mtdblock'
		echo "<<mtd exists..>>"
		
		if [ "$isSECONDARY" -eq 1 ] ; then
		
			echo "<<secondary exists..>>"
			
			NOGO="$NOGO"' -e mmcblk0'
			echo "ERROR! You have a MTD device with internal + external storage,"
			echo "but mmcblk1 isn't here! Did you plug in a card?"
			
		else
		
			echo "<<secondary DOES NOT exist..>>"
			
			if [ "$isEXTERNAL" -eq 1 ] ; then
			
				echo "<<external exists..>>"
				
				echo "WARNING! You have a MTD device with external storage only,"
				echo "pointing SECONDARY_STORAGE at EXTERNAL_STORAGE!"
				SECONDARY_STORAGE="$EXTERNAL_STORAGE"

			else
			
				echo "<<external DOES NOT exist..>>"
				
				echo "WARNING! You have a MTD device with external storage only,"
				echo "but EXTERNAL_STORAGE is not defined!"
				echo "Pointing both SEC and EXT at $ANDROID_STORAGE/sdcard0"
				
				echo "(Warning!) EXTERNAL_STORAGE is not defined!"
				if [ -d "$ANDROID_STORAGE/sdcard0" ] ; then
					EXTERNAL_STORAGE="$ANDROID_STORAGE/sdcard0"
					SECONDARY_STORAGE="$ANDROID_STORAGE/sdcard0"
					echo "   Recovered... $ANDROID_STORAGE/sdcard0 exists"
				else
					echo "ERROR! $ANDROID_STORAGE/sdcard0 does not exist, exiting..."
					exit 1
				fi
			fi
		fi
		
		
	else
		
		echo "<<mtdblock does NOT exist>>"
		
		NOGO=' -e mmcblk0'
		
		if [ "$isSECONDARY" -eq 1 ] ; then
		
			echo "<<secondary exists..>>"
			
			echo "ERROR! You have a mmcblk0 device with internal + external storage,"
			echo "but mmcblk1 isn't here! Did you plug in a card?"
		else
			
			echo "<<secondary DOES NOT exist...>>"
			
			if [ "$isEXTERNAL" -eq 1 ] ; then
			
				echo "<<external exists..>>"
				
				echo "WARNING! You have a mmcblk0 device with external storage only,"
				echo "YOU DON'T HAVE AN SD CARD SLOT, or a card is not plugged in!"
				
				SECONDARY_STORAGE="$EXTERNAL_STORAGE"

			else
			
				echo "<<external DOES NOT exist..>>"
				
				echo "WARNING! You have a mmcblk0 device but"
				echo "EXTERNAL_STORAGE and SECONDARY_STORAGE are not defined!"
				echo "Checking both SEC and EXT at $ANDROID_STORAGE"
				
				echo "(Warning!) EXTERNAL_STORAGE is not defined!"
				if [ -d "$ANDROID_STORAGE/sdcard0" ] ; then
					EXTERNAL_STORAGE="$ANDROID_STORAGE/sdcard0"
					echo "   Recovered... $ANDROID_STORAGE/sdcard0 exists"
				else
					echo "ERROR! $ANDROID_STORAGE/sdcard0 does not exist, exiting..."
					exit 1
				fi
				
				echo "(Warning!) SECONDARY_STORAGE is not defined!"
				if [ -d "$ANDROID_STORAGE/sdcard1" ] ; then
					SECONDARY_STORAGE="$ANDROID_STORAGE/sdcard1"
					echo "   Recovered... $ANDROID_STORAGE/sdcard1 exists"
				else
					echo "ERROR! $ANDROID_STORAGE/sdcard1 does not exist, falling back to EXT..."
					SECONDARY_STORAGE="$EXTERNAL_STORAGE"
				fi
				
			fi
		fi
	
	fi
fi
	

		
##############################################################
##         Fuckit, this will work until version 10.         ##
## Do you really want to see 50+ lines of version checking? ##
##############################################################

if [[ "$myVERSION" < "4.2" ]] && [[ "$myVERSION" > "4.0.9" ]] ; then
  echo ""
  echo "You are running CM10 / 4.1 ?"
  echo "   Bypassing ADB code..."
  useBYPASS=0
  
  #SECONDARY_STORAGE="/storage/sdcard1"
  #EXTERNAL_STORAGE="/storage/sdcard0"

fi

if [[ "$myVERSION" > "4.1.9" ]] ; then
  echo ""
  echo "You are running CM10.1 / 4.2+ ?"
  echo "   Enabling ADB code..."
  useBYPASS=1
fi


if [[ "$myVERSION" > "4.2.1" ]] ; then
	echo ""
	echo "You have teh 4.2.2+ ADB RSA bug -- poor you."
	echo "     Setting flag to apply the workaround..."
	adbKEYATCONNECT=1
fi

cat /proc/partitions|grep mtdblock
RESULT="$?"

if [ "$RESULT" -eq 0 ] ; then
	echo ""
	echo "====================================="
	echo "     WARNING EXPERIMENTAL METHOD"
	echo ""
	echo "      You are using an OLD phone."
	echo "====================================="
	echo ""
fi


}

getParts() {
	local IFS_BAK="$IFS"
	local i
	local partN
	local partNp1
	

	if [ -z "$NOGO" ] ; then
			echo ""
			echo "###########################################"
			echo "      ERROR: could not find NOGO zone!"
			echo "       Please report this to XDA!"
			echo "###########################################"
			echo ""
			echo "Exiting...."
			exit 1
	else
		echo "NOGO Zone set as: ($NOGO)"
	fi
	
	IFS=$'\n'
	myPARTS=( $(eval "cat /proc/partitions|grep -v $NOGO -e mtdblock -e ram -e swap -e dm- -e loop|tail -n+3|tr -s ' '") )
	#myPARTS=( $(cat /proc/partitions|grep -e mmcblk1|tail -n+3|tr -s ' ') )
	IFS=$IFS_BAK

	echo "Analyzing /proc/partitions structure:"
	for i in  $(seq 0 1 $(( ${#myPARTS[@]} - 1 )) ) ; do
		echo "Index $i is: ${myPARTS[$i]}"
		partN="$(echo ${myPARTS[$i]}|cut -d ' ' -f 4)"
		partNp1="$(echo ${myPARTS[$i+1]}|cut -d ' ' -f 4)"
		if [[ "$partNp1" == "$partN"* ]]; then
			echo "     Sub-partition detected at $partN / $partNp1"
			unset myPARTS[$i]
		fi
	done
	myPARTS=( "${myPARTS[@]}" )
	#Repack array
}

analyzeDevice() {
	#analyzeDevice "/dev/block/${partNAME[$i]}" analyzedPARTS[$i]
	#string = "DEVICE mountFS mountCMD mountPARM fixCMD"
	
	local blockDEV="$1"
	local __partENTRY="$2"
	local devSIG
	local mountFS
	local mountCMD
	local mountPARM
	local fixCMD
	local retVAR
	
	#eval $__partENTRY="'This is a test\tblah'"	
		
	#echo ""
	#echo "Analyzing $blockDEV for filesystem..."

	#devSIG=`head -c 8 $blockDEV|tail -c 4`
	devSIG=`dd if="$blockDEV" bs=1 count=4 skip=4 2>/dev/null`
	#'XFAT' = EXFAT, 'TFS ' = NTFS
	
case "$devSIG" in
	"XFAT")
		#echo "Device is exFAT!!!!"
		mountFS="exfat"
		mountCMD="mount.exfat-fuse"
		mountPARM="-o rw,dirsync,noatime,umask=0"
		fixCMD="fixmyexfat.sh"
    ;;
	#"2" | "3")
	"TFS ")
		#echo "Device is NTFS!!!!"
		mountFS="ntfs"
		mountCMD="mount.ntfs-3g"
		mountPARM="-o rw,dirsync,noatime,umask=0"
		fixCMD="ntfsfix"
    ;;
	"kdos" | "SDOS" | "SWIN")
		#echo "Device is FAT(32?)!!!!"
		mountFS="fat32"
		mountCMD="mount -t vfat"
		mountPARM="-o rw,dirsync,gid=1015,fmask=0702,dmask=0702,utf8"
		#rw,dirsync,gid=1015,fmask=0702,dmask=0702,utf8
		#dirsync,nosuid,nodev,noexec,gid=1015,fmask=0702,dmask=0702,allow_utime=0020,shortname=mixed,utf8
		fixCMD="fsck_msdos -n"
		#Change this to -y if you want to blow shit up (see: CyanogenMod)
	;;
	*)
		
		#echo "Device is UNKNOWN!!!! (Could be EXT4??)"

		####################################
		##  BLKID Identification Routines ##
		####################################
		
		RESULT=$(blkid $blockDEV | sed 's!\(.*\):.*TYPE="\(.*\)".*!\1: \2!' | cut -d ' ' -f 2)

		case "$RESULT" in 
			"ext4")
				#echo "Device is ext4!!!!"
				mountFS="ext4"
				mountCMD="mount -t ext4"
				#mountPARM="-o rw,nosuid,nodev,noatime,user_xattr,barrier,noauto_da_alloc"
				#mountPARM="-o rw,nosuid,nodev,noatime,barrier=0,journal_async_commit,data=ordered,noauto_da_alloc,discard"
				mountPARM="-o rw,nosuid,nodev,noatime,barrier=1"
				#I have no idea what I am doing.... top one crashes, bottom one works. *Shrug*
				fixCMD="e2fsck"
			;;
			"ext3")
				#echo "Device is ext3!!!!"
				mountFS="ext3"
				mountCMD="mount -t ext3"
				mountPARM="-o rw,nosuid,nodev,noatime,barrier=1"
				fixCMD="e2fsck"
			;;			
			"ext2")
				#echo "Device is ext2!!!!"
				mountFS="ext2"
				mountCMD="mount -t ext2"
				mountPARM="-o rw,nosuid,nodev,noatime,barrier=1"
				fixCMD="e2fsck"
			;;
			"vfat")
				#echo "Device is vfat!!!!"
				mountFS="vfat"
				mountCMD="mount -t vfat"
				mountPARM="-o rw,dirsync,gid=1015,fmask=0702,dmask=0702,utf8"
				fixCMD="fsck_msdos -n"
				## Copied from FAT32 section -- should cover nonstandard formats ##
			;;
			*)
				mountFS="unknown"
				mountCMD="mount"
				mountPARM="-o rw"
				fixCMD="echo No fix for unknown FS: "
			;;
		esac

    ;;
esac

	retVAR="$blockDEV\t$mountFS\t$mountCMD\t$mountPARM\t$fixCMD"
	#echo $retVAR
	eval $__partENTRY="'$retVAR'"
}

testMountDevice() {
	#testMountDevice analyzedPARTS[$i]
	#string = "DEVICE mountFS mountCMD mountPARM fixCMD <mountTARGET>"
	
	local __partENTRY="$1"
	
	local blockDEV
	local mountFS
	local mountCMD
	local mountPARM
	local fixCMD
	local mntTARGET=''
	
	local blockNAME
	local retVAR
	
	#echo "Parameters are ($1) ($2)"
	retVAR=$(eval echo '"${'$__partENTRY'}"')
	#echo "retVAR is $retVAR"	
	blockDEV=$(echo "$retVAR"|cut -d $'\t' -f 1)
	mountFS=$(echo "$retVAR"|cut -d $'\t' -f 2)
	mountCMD=$(echo "$retVAR"|cut -d $'\t' -f 3)
	mountPARM=$(echo "$retVAR"|cut -d $'\t' -f 4)
	fixCMD=$(echo "$retVAR"|cut -d $'\t' -f 5)

	blockNAME=$(echo "$blockDEV"|sed -n 's/\(.*\)\/\(.*\)/\2/p')
	
	echo ""
	echo "Attempting test mount of $blockDEV at $stagingAREA:"
	echo "($blockDEV)($mountFS) ($mountCMD) ($mountPARM) ($fixCMD)" 
	
	mountpoint -q "$stagingAREA" && umount "$stagingAREA"
	$mountCMD -o ro "$blockDEV" "$stagingAREA" 2>&1
	RESULT="$?"
	
	if [ "$RESULT" -ne "0" ]; then
		echo "Test mount failure, reason unknown. (Nonempty? Bad header? Wrong FS?)"

		echo "BROKEN BROKEN BROKEN - Debug is enabled. Header is as follows:"
		dd if="$blockDEV" bs=512 count=1 skip=0|hexdump -C
		echo ""

		echo "Unmounting and running repair command [$fixCMD]"
		mountpoint -q "$stagingAREA" && umount "$stagingAREA"
		$fixCMD "$blockDEV"
		
		echo "Attempting (1) remount, else skipping entirely"
		$mountCMD -o ro "$blockDEV" "$stagingAREA" 2>&1
		RESULT="$?"
		
		if [ "$RESULT" -ne "0" ]; then
			echo "I tried. It failed. Removing from mount queue."
			mountpoint -q "$stagingAREA" && umount "$stagingAREA"
			return 1
		else
			echo "Repair successful."
		fi
		
	else
		echo "Success, moving to retrieve MultiMount (if needed)..."
		
		echo "WORKS WORKS WORKS - Debug is enabled. Header is as follows: <MUTED>"
		#dd if="$blockDEV" bs=512 count=1 skip=0|hexdump -C
		echo ""
	fi

	if [ -e "$stagingAREA/.mounthere" ] ; then
		mntTARGET="$(head -n 1 $stagingAREA/.mounthere 2>/dev/null)"
	else
		mntTARGET=""
	fi
	
	if [ "$mntTARGET" == "skip" -o "$mntTARGET" == "SKIP" ] ; then
		echo "Read a SKIP directive from .monthere file!"
		mountpoint -q "$stagingAREA" && umount "$stagingAREA"
		return 3
	fi
	
	if [ -e "$stagingAREA/.mounthere" ] && [ ! -d "$mntTARGET" ] && [[ "$mntTARGET" != "$ANDROID_STORAGE/"* ]] ; then
		if [ "$dirSECURITY" -ne 0 ] ; then
			echo "Invalid directory read from .mounthere file: ($mntTARGET)"
			echo "     (Doesn't exist AND/OR isn't located in $ANDROID_STORAGE/)"
			echo "     SECURITY: if valid dirname, you have to create it first!"
			mntTARGET=""
		else
			echo "=========================================="
			echo "   WARNING: Directory Security DISABLED!"
			echo "    Allowing creation of ($mntTARGET)"
			echo "=========================================="
		fi
	fi
	
	if [ "$umountSET" -eq 1 ] && [ -e "$stagingAREA/.mounthere" ] && [ -d "$mntTARGET" ] && [[ "$mntTARGET" == "$ANDROID_STORAGE/"* ]] && [[ "$mntTARGET" != "$SECONDARY_STORAGE" ]] && [[ "$mntTARGET" != "$EXTERNAL_STORAGE" ]]; then
			echo "     [[ StorageSec: Umount says to delete this... RMDIRing passively! ]]"
			rmdir "$mntTARGET"
	fi
	
	
	if [ -z "$mntTARGET" -a "$multiMOUNT" -eq 0 ] ; then
		mntTARGET="$SECONDARY_STORAGE"
		echo "Defaulting to $mntTARGET"
		
	elif [ -z "$mntTARGET" -a "$multiMOUNT" -eq 1 ] ; then
		mntTARGET="$ANDROID_STORAGE/$blockNAME"
		echo "MultiMount designated, but no/invalid directory given."
		echo "Defaulting to $mntTARGET"
		
		if [ "$umountSET" -eq 1 ] ; then
			echo "     [[ DefaultSec: Umount says to delete this... RMDIRing passively! ]]"
			rmdir "$mntTARGET"
		fi
	fi
	
	retVAR="$blockDEV\t$mountFS\t$mountCMD\t$mountPARM\t$fixCMD\t$mntTARGET"
	#retVAR="$retVAR\t$mntTARGET" <- DO NOT USE... keeps addingggggg
	#echo "$retVAR"

	eval $__partENTRY="'$retVAR'"
	
	umount "$stagingAREA"
	return 0	

}

scrubMount() {
	local searchSTR="$1"
	local blockDEV
	local mntTARGET
	local RESULT
	local resGREP
	local IFS_BAK="$IFS"
	local i
	
	echo "Scrub received for searchSTR ($searchSTR)"
	IFS=$'\n'
	resGREP=( $(cat /proc/mounts|grep "$searchSTR") )
	IFS=$IFS_BAK
	
	#resGREP=$(cat /proc/mounts|grep "$searchSTR")

for i in "${resGREP[@]}" ; do
	blockDEV=$(echo "$i"|cut -d ' ' -f 1)
	mntTARGET=$(echo "$i"|cut -d ' ' -f 2)
	
	echo "Scrubbing mount table of entries ($mntTARGET) on device [$blockDEV]"
	
	
	if [ "$useBYPASS" -eq 0 ] ; then
		echo "Attempting standard mount check of ($mntTARGET)..."
		mountpoint "$mntTARGET"
		RESULT="$?"
	else
		echo "Attempting ADB mount check of ($mntTARGET)..."
		adbSendCmd "mountpoint $mntTARGET"
		RESULT="$?"
	fi
	
	echo -e "Result is ($RESULT)"

	#CHANGE
	if [ "$RESULT" -eq 0 ] ; then
		echo "It appears $mntTARGET is already mounted. (Unmounting)"

		if [ "$useBYPASS" -eq 0 ]; then
			echo "Attempting standard umount..."
			umount "$mntTARGET"
		else
			echo "Attempting ADB umount..."
			adbSendCmd "umount $mntTARGET 2>&1"
		fi
		
		[ "$bootSET" -eq 0 ] &&  am broadcast -a android.intent.action.MEDIA_UNMOUNTED -d file://"$mntTARGET"
		#am broadcast -a android.intent.action.MEDIA_EJECT -d file:///$mntTARGET	   
	else
	   echo "$mntTARGET is not mounted. (OK)"
	fi
done


}

scriptOrDie() {
echo "\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x5f\x20\x20\x20\x5f\x5f\x20\x20\x5f\x5f\x5f\x5f\x5f\x5f\x20\x20\x20\x20\x20\x20\x5f\x5f\x5f\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0a\x20\x20\x20\x20\x20\x2f\x5c\x20\x20\x2f\x5c\x2f\x5c\x2f\x5c\x20\x7c\x20\x7c\x20\x5f\x5f\x20\x5c\x2f\x20\x2f\x5f\x5f\x5f\x20\x5c\x20\x20\x20\x20\x2f\x20\x5f\x5f\x5c\x5f\x5f\x5f\x20\x20\x5f\x20\x5f\x5f\x20\x5f\x5f\x5f\x20\x0a\x20\x20\x20\x20\x2f\x20\x2f\x5f\x2f\x20\x2f\x20\x20\x20\x20\x5c\x7c\x20\x7c\x2f\x20\x2f\x5c\x20\x20\x2f\x20\x20\x5f\x5f\x29\x20\x7c\x20\x20\x2f\x20\x2f\x20\x20\x2f\x20\x5f\x20\x5c\x7c\x20\x27\x5f\x5f\x2f\x20\x5f\x20\x5c\x0a\x20\x20\x20\x2f\x20\x5f\x5f\x20\x20\x2f\x20\x2f\x5c\x2f\x5c\x20\x5c\x20\x20\x20\x3c\x20\x2f\x20\x20\x5c\x20\x2f\x20\x5f\x5f\x2f\x20\x5f\x2f\x20\x2f\x5f\x5f\x5f\x20\x28\x5f\x29\x20\x7c\x20\x7c\x20\x7c\x20\x20\x5f\x5f\x2f\x0a\x20\x20\x20\x5c\x2f\x20\x2f\x5f\x2f\x5c\x2f\x20\x20\x20\x20\x5c\x2f\x5f\x7c\x5c\x5f\x5c\x5f\x2f\x5c\x5f\x5c\x5f\x5f\x5f\x5f\x5f\x28\x5f\x29\x5f\x5f\x5f\x5f\x2f\x5c\x5f\x5f\x5f\x2f\x7c\x5f\x7c\x20\x20\x5c\x5f\x5f\x5f\x7c\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x0a"

echo "==========================================================="
echo "      Process complete! Buy me a beer if this worked!"
echo "==========================================================="
}

bug() {
echo "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"|base64 -d > $EXTERNAL_STORAGE/$(echo "\x62\x75\x67\x2e\x70\x6e\x67")
echo "\x0a\x0a\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x77\x61\x72\x6e\x69\x6e\x67\x0a\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x3d\x0a\x20\x20\x79\x6f\x75\x72\x20\x69\x6e\x74\x65\x72\x6e\x61\x6c\x20\x73\x74\x6f\x72\x61\x67\x65\x20\x68\x61\x73\x20\x62\x65\x65\x6e\x20\x62\x75\x67\x67\x65\x64\x0a\x0a"
}

##################
## MAIN PROGRAM ##
##################

if [ "$1" == "debug" ] ; then
	bug
	exit 3
fi

if ! [ "$(whoami)" == "root" ] ; then
	echo "BREAK! Must be run as ROOT"
	exit 1

#Attempt to elevate - related to mount bug below
	#echo "Attempting to elevate to root...."
	#su 
	#^^ will hang at prompt
	#if ! [ "$(whoami)" == "root" ] ; then
	#	echo "Elevation failed, exiting."
	#	exit 1
	#else
	#	echo "Elevation successful, proceeding."
	#fi
fi

analyzePhone


if [ -z "$SECONDARY_STORAGE" ]; then
	echo "(Error!) SECONDARY_STORAGE is not defined, will you need to hard-code it?"
	exit 1
	#Hard-coded override, left blank for now
	#SECONDARY_STORAGE="/storage/sdcard1"	
fi




if [ "$storageREMOUNT" -eq 1 ] ; then
		mount -rw -o remount /storage
fi

if [ "$rootREMOUNT" -eq 1 ] ; then
		mount -rw -o remount /
fi

if [ "$1" == "boot" ]; then
    useBYPASS=0
	bootSET=1
fi

if [ "$1" == "umount" ] ; then
	umountSET=1
fi

#####################
## Partition logic ##
#####################

		cat /proc/partitions
		echo "~~"
		cat /proc/mounts
		#echo "~~"
		#mount
		echo "~~"
		blkid
		echo "~~"
		echo ""
		mountpoint -n /system

echo ""
getParts

if [ "${#myPARTS[@]}" -le 0 ] ; then
	echo "Error! No valid partitions detected!"
	echo "     Exiting!"
	echo ""
	echo "====================================="
	echo "     Did you remember to plug in"
	echo "             an SD card?"
	echo "====================================="
	echo ""
	exit 1
fi


##########################
##   Filesystem logic   ##
##########################

echo ""
echo "~~~~~~~~~ Beginning FS Logic ~~~~~~~~~"
local mountFS
local blockNAME

for i in  $(seq 0 1 $(( ${#myPARTS[@]} - 1 )) ) ; do
	blockNAME[$i]="$(echo ${myPARTS[i]}|cut -d ' ' -f 4)"
	#"dev/block/blockNAME mountFS mountCMD mountPARM fixCMD"
	#analyzedPARTS[$i]=$(analyzeDevice "/dev/block/${blockNAME[$i]}")
	
	analyzeDevice "/dev/block/${blockNAME[$i]}" analyzedPARTS[$i]
	echo "Index ($i) - [${analyzedPARTS[$i]}]"
	
	mountFS=$(echo ${analyzedPARTS[$i]}|cut -d $'\t' -f 2)
	if [ $mountFS == "unknown" ] ; then
		echo "     Warning: /dev/block/$blockNAME is of unknown/unimplemented filesystem"
		echo "             PLEASE REPORT THIS TO XDA THREAD so I can add support."
		dd if=/dev/block/${blockNAME[$i]} bs=512 count=1 skip=0|hexdump -C
		unset analyzedPARTS[$i]
	fi
	
done
analyzedPARTS=( "${analyzedPARTS[@]}" )

if [ "${#analyzedPARTS[@]}" -le 0 ] ; then
	echo "Error! No RECOGNIZED filesystems after filtering!"
	echo "     Exiting!"
	echo ""
	echo "====================================="
	echo "     Is the SD card formatted with"
	echo "        supported filesystems?"
	echo "====================================="
	echo ""
	exit 1
fi


if [ "${#myPARTS[@]}" -gt 1 ] ; then
	echo "Warning! Multiple valid partitions detected!"
	echo "     Initiating multi-mount protocol."
	multiMOUNT=1
fi


################################################
## Test Mount/Repair and Multimount Retrieval ##
################################################
#multiMOUNT=1
local mntTARGET
local blockDEV

echo ""
echo "~~~~~~~~~ Beginning Test Mount/Repair ~~~~~~~~~"
scrubMount " $SECONDARY_STORAGE "
#Only need this is F/s uses bloody VOLD179:67 name!!

for i in  $(seq 0 1 $(( ${#analyzedPARTS[@]} - 1 )) ) ; do
	blockDEV=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 1)
	echo "===== [Cycling $blockDEV] ====="
	
	scrubMount "$blockDEV "
	testMountDevice analyzedPARTS[$i]
	
	RESULT="$?"
	mntTARGET=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 6)
	
	if [ "$RESULT" -ne 0 ] ; then
		echo "Test mount/repair failure. Removing element."
		unset analyzedPARTS[$i]
		continue
	else
		echo "Test mount/repair success. Target is $mntTARGET"
	fi
done
analyzedPARTS=( "${analyzedPARTS[@]}" )

if [ "${#analyzedPARTS[@]}" -le 0 ] ; then
	echo "Error! No FUNCTIONAL filesystems after test mounts!"
	echo "     Exiting!"
	echo ""
	exit 1
fi

#####################################
## Quick hack to unmount everyting ##
#####################################

if [ "$umountSET" -eq 1 ] ; then
	echo ""
	echo "Executing emergency bailout/simulate universal 'umount'"
	echo ""
	chown system:system $SECONDARY_STORAGE
	chmod 0 $SECONDARY_STORAGE
	scriptOrDie
	exit 0
fi


#######################
## Esta ocupado, eh? ##
#######################

local mountCMD
local mountPARM

echo ""
echo "~~~~~~~~~ Beginning target creation/scrub ~~~~~~~~~"

for i in  $(seq 0 1 $(( ${#analyzedPARTS[@]} - 1 )) ) ; do
	blockDEV=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 1)
	mountCMD=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 3)
	mountPARM=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 4)
	mntTARGET=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 6)
	
	#CHECK
	if [ ! -d "$mntTARGET" ] ; then
		echo "Creating directory stucture to $mntTARGET"
		mkdir -p "$mntTARGET"
	fi
	
	scrubMount " $mntTARGET "
done


######################
## Final mount code ##
######################

echo ""
echo "~~~~~~~~~ Beginning Final Mount Sequence ~~~~~~~~~"
echo "Check complete, mounting and initializing..."

for i in  $(seq 0 1 $(( ${#analyzedPARTS[@]} - 1 )) ) ; do
	blockDEV=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 1)
	mountCMD=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 3)
	mountPARM=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 4)
	mntTARGET=$(echo "${analyzedPARTS[$i]}"|cut -d $'\t' -f 6)

	mountCMDFULL="$mountCMD $mountPARM $blockDEV $mntTARGET"
	echo ""
	echo "############## Index ($i) - $blockDEV ##############"
	echo $mountCMDFULL
	if [ "$useBYPASS" -eq 0 ]; then
		$mountCMDFULL 2>&1
	else
		echo "Attempting ADB bypass..."
		adbSendCmd "$mountCMDFULL ; sleep 1 2>&1"
	fi
	[ "$bootSET" -eq 0 ] && (sleep 2; am broadcast -a android.intent.action.MEDIA_MOUNTED -d file://"$mntTARGET" > /dev/null 2>&1)&
	
done

if [ "$bootSET" -eq 0 ]; then
	if [ "$useBYPASS" -eq 0 ] ; then
		echo "Kicking vold normally..."
		sleep 2; vold 2>&1
	else
		echo "Kicking vold via ADB bypass..."
		adbSendCmd "sleep 2; vold 2>&1"
	fi
fi

scriptOrDie

exit 0

