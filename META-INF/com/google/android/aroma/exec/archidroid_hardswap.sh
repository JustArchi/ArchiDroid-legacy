#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ADMOUNTED() {
	return "$(mount | grep -qi "$1"; echo $?)"
}

if ! ADMOUNTED "$1"; then
	echo "Sorry, $1 partition is not available for your device, you can't change hardswap here"  # This will be useful i.e. for devices without external sd card
	exit 1
fi

echo "Removing $1/ArchiDroid.swp"
rm -f "$1/ArchiDroid.swp"

if [ "$2" -ne 0 ]; then
	echo "Checking free space..."
	FREESPACE="$(df -m "$1" | tail -n 1 | awk '{print $4}')"
	echo "Required: $2"
	echo "Available: $FREESPACE"
	if [ "$FREESPACE" -lt "$2" ]; then
		echo "Sorry, it looks like your partition is out of space"
		exit 2
	fi
	echo "Creating $1/ArchiDroid.swp with $2 size"
	dd if=/dev/zero of="$1/ArchiDroid.swp" bs=1M count="$2"
	mkswap "$1/ArchiDroid.swp"
	chown root:root "$1/ArchiDroid.swp" # We don't want to create
	chmod 0600 "$1/ArchiDroid.swp" # A potential security risk
fi

echo "Done!"

sync
exit 0
