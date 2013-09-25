ArchiDroid_FstrimData - From Android 4.3 I'm happy to include fstrim "on demand" to ArchiDroid. By executing this script you call fstrim() on /data partition. If you want to learn more google "TRIM".

ArchiDroid_FstrimAll - Same as above but also calls fstrim() on /cache /preload /system /efs in addition to /data. This is NOT recommended by me, as these partitions are RARELY being used in terms of writing but sometimes it may be useful to fstrim them as well.

# Please note that you SHOULD NOT fstrim too often. I'd say once per month is more than enough. I'd also advise to avoid other fstrim apps/scripts such as "LagFix", as my scripts do the same "on demand" and in natively way implemented directly in kernel.


ArchiDroid_OnlineNandroidBackup - Creates a CWM bacup "on the fly" without needing to enter recovery. Thanks to Online Nandroid tool, which is now inside a rom as well (type onandroid -h to learn more)

ArchiDroid_RemoveArchiDroid - Removes ArchiDroid folder completely and reboots into recovery, allowing you to flash other ROM without any junk left by ArchiDroid. Please don't use this script during updates and cleaning, as ArchiDroid needs this folder.

ArchiDroid_RestoreEFS - Restores /efs from backup made during flashing of ArchiDroid and reboots the system. Many people wanted to have such feature so here it is.

ArchiDroid_TemporaryUnroot - Performs temporary unrooting "on the fly". This allows opening/using some apps which require the device to be unrooted. Works only with poorly-designed apps.