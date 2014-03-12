### AGNi reset oc-uv on boot failure

if [ -d "/data/media/0" ] && [ ! -f $AGNi_RESETER_CM ] ; then
	cp /res/reseter/AGNi_reset_oc-uv_on_boot_failure.zip $AGNi_RESETER_CM
	chmod 775 $AGNi_RESETER_CM
fi
