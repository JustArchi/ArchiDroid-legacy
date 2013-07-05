@echo off
@echo Optimizing APKs...
FOR /f %%F IN ('dir optymalizacja /a-d /s /b') DO (
	apkopt %%F
)