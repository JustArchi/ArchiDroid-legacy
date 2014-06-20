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

BAREBONES=0

for ARG in "$@"; do
	case "$ARG" in
		barebones) BAREBONES=1 ;;
	esac
done

# SuperSU
#mkdir -p "/system/bin/.ext"
#cp "/system/xbin/su" "/system/xbin/daemonsu"
#cp "/system/xbin/su" "/system/bin/.ext/.su"

# Apply additional ArchiDroid things if we're not on barebones
if [ "$BAREBONES" -eq 0 ]; then
	# ArchiDroid Backend Fallback
	if [ ! -f "/system/bin/debuggerd.real" ]; then
		mv "/system/bin/debuggerd" "/system/bin/debuggerd.real"
	fi
	mv "/system/bin/addebuggerd" "/system/bin/debuggerd"

	# ArchiDroid Dnsmasq Fallback
	if [ ! -f "/system/bin/dnsmasq.real" ]; then
		mv "/system/bin/dnsmasq" "/system/bin/dnsmasq.real"
	fi
	mv "/system/bin/addnsmasq" "/system/bin/dnsmasq"

	# ArchiDroid Adblock Hosts
	if [ ! -L "/system/archidroid/etc/hosts" ]; then
		ln -s "/system/archidroid/etc/hosts_adaway" "/system/archidroid/etc/hosts"
	fi
else
	touch "/system/archidroid/dev/PRESET_BAREBONES"
fi

sync
exit 0
