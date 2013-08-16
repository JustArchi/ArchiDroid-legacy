#!/tmp/bash

if [ ! -d /data/media/0/ArchiDroid ]; then
	mkdir -p /data/media/0/ArchiDroid
fi

case "$1" in
  install)
	touch /data/media/0/ArchiDroid/INSTALL
  ;;
  update)
    touch /data/media/0/ArchiDroid/UPDATE
  ;;
  *)
    echo "Error 1"
    exit 1
esac

exit 0
