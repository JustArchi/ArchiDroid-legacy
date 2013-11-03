#!/system/bin/sh
# Startup script for Secure Storage processes #

echo Secure Storage startup script is called...

# Set property for Secure Storage
setprop ro.securestorage.version 1.0.0

# Create working directory
mkdir -p /dev/.secure_storage
chmod 0711 /dev/.secure_storage
chown system.system /dev/.secure_storage

# Restorecon for SE Android
restorecon -R /dev/.secure_storage

# Set property for Secure Storage
setprop ro.securestorage.ready true
