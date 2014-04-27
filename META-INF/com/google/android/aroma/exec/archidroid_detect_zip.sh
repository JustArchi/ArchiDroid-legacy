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

# exit 0 -> Zip has been called from internal sd card
# exit 1 -> Zip has been called from external sd card
# exit 2 -> I don't know where zip has been called from

if [ "$(ps w | grep -qi "[e]xtsdcard/"; echo $?)" -eq 0 ] || [ "$(ps w | grep -qi "[s]dcard1/"; echo $?)" -eq 0 ]; then # We can't use pgrep here due to limited busybox, SC2009
	# Definitely extsd
	exit 1
elif [ "$(ps w | grep -qi "[d]ata/media/"; echo $?)" -eq 0 ] || [ "$(ps w | grep -qi "[s]dcard/"; echo $?)" -eq 0 ]; then # We can't use pgrep here due to limited busybox, SC2009
	# Definitely intsd
	exit 0
fi

# I don't know, probably intsd
sync
exit 2
