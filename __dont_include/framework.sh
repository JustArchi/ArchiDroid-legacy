#!/bin/bash
rm -rf apktool/place-apk-here-to-batch-optimize/
mkdir -p apktool/place-apk-here-to-batch-optimize/original
cp ../system/framework/framework-res.apk apktool/place-apk-here-to-batch-optimize/framework-res.apk
7za x -o"apktool/place-apk-here-to-batch-optimize/original" apktool/place-apk-here-to-batch-optimize/framework-res.apk
cd apktool
chmod +x archi2.sh
cp ../default_wallpaper.jpg place-apk-here-to-batch-optimize/original/res/drawable-xhdpi/default_wallpaper.jpg
./archi2.sh
exit 0
