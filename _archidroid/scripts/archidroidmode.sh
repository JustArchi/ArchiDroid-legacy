#!/tmp/bash

rm -Rf /data/media/0/archidroid
mkdir -p /data/media/0/archidroid

case "$1" in
  install)
	touch /data/media/0/archidroid/INSTALL
  ;;
  update)
    touch /data/media/0/archidroid/UPDATE
  ;;
  *)
    echo "Error 1"
    exit 1
esac

exit 0
