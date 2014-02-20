#!/sbin/sh

if [ "$1" == "lock" ]; then
	chattr +i "$2"
elif [ "$1" == "unlock" ]; then
	chattr -i "$2"
else
	exit 1
fi

sync
exit 0