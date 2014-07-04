#!/system/bin/sh
# Copyright (c) 2011, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

MDM_IMAGES=/firmware/image
cd $MDM_IMAGES
ln -s $MDM_IMAGES/apps.mbn /system/etc/firmware/apps.mbn 2>/dev/null
ln -s $MDM_IMAGES/dsp1.mbn /system/etc/firmware/dsp1.mbn 2>/dev/null
ln -s $MDM_IMAGES/dsp2.mbn /system/etc/firmware/dsp2.mbn 2>/dev/null
ln -s $MDM_IMAGES/dsp3.mbn /system/etc/firmware/dsp3.mbn 2>/dev/null
ln -s $MDM_IMAGES/rpm.mbn  /system/etc/firmware/rpm.mbn  2>/dev/null
ln -s $MDM_IMAGES/sbl1.mbn /system/etc/firmware/sbl1.mbn 2>/dev/null
ln -s $MDM_IMAGES/sbl2.mbn /system/etc/firmware/sbl2.mbn 2>/dev/null
ln -s $MDM_IMAGES/efs1.mbn /system/etc/firmware/efs1.mbn 2>/dev/null
ln -s $MDM_IMAGES/efs2.mbn /system/etc/firmware/efs2.mbn 2>/dev/null
ln -s $MDM_IMAGES/efs3.mbn /system/etc/firmware/efs3.mbn 2>/dev/null
ln -s $MDM_IMAGES/acdb.mbn /system/etc/firmware/acdb.mbn 2>/dev/null
ln -s $MDM_IMAGES/mdm_acdb.img /system/etc/firmware/mdm_acdb.img 2>/dev/null


cd /


