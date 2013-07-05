@echo off
@echo Optimizing APKs...
FOR /R /f "optymalizacja" %%F IN (%~dp0*.apk) DO (
	echo %%F
)
pause