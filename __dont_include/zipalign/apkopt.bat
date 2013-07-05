:: 
:: Short script by coolbho3000 to optimize all PNGs in all APKs in this directory
:: 
@echo off
if (%1)==() GOTO END
@echo Optimizing %1...
md "%~dp0apkopt_temp_%~n1"
md "%~dp0original"
md "%~dp0optimized"
7za x -o"%~dp0apkopt_temp_%~n1" %1
:: 
:: -o99 specifies how much the PNG is optimized. Lower numbers will make the optimization process faster, higher numbers will result in smaller PNGs.
::
roptipng -o99 "%~dp0apkopt_temp_%~n1\**\*.png"
copy /b %1 "%~dp0original"
del /q %1
:: 
:: -mx5 indicates the ZIP's compression level. Set this from -mx0 to -mx9, higher compression levels may not work!
:: 
7za a -tzip %~dp0optimized\%~n1.unaligned.apk "%~dp0apkopt_temp_%~n1\*" -mx9 
rd /s /q "%~dp0apkopt_temp_%~n1"
::
:: runs zipalign
::
zipalign -v 4 %~dp0optimized\%~n1.unaligned.apk %~dp0optimized\%~n1.apk
del /q %~dp0optimized\%~n1.unaligned.apk
@echo Optimization complete for %1

copy /b %~dp0optimized\%~n1.apk %1
rmdir /s /q "optimized"
rmdir /s /q "original"

:END