#!/bin/bash 
# Optaros-archiva setup script
#
# $ARCHIVA_DATA - Archiva data folder. ie. 
# $ARCHIVA_DATA_DEV - Archiva data device
# $ARCHIVA_SRC - Archiva source folder
# $ARCHIVA_LIB_PREFIX - Archiva lib prefix
# $ARCHIVA_USER - Archiva system user

# Test for a reboot,  if this is a reboot just skip this script.
if test "$RS_REBOOT" = "true" ; then
  echo "Skip code install on reboot."
  logger -t RightScale "Skip code install on reboot."
  exit 0 
fi

# Mount archiva data 
mkdir -p $ARCHIVA_DATA
mount $ARCHIVA_DATA_DEV $ARCHIVA_DATA

# Create archiva user (@TODO maybe test if exists )
adduser --system --group --disabled-password --disabled-login $ARCHIVA_USER
chown -R $ARCHIVA_USER:$ARCHIVA_USER $ARCHIVA_DATA

# Install archiva bin
cp -a $ARCHIVA_SRC $ARCHIVA_LIB_PREFIX

# Setup and install startup script
archiva_script="/etc/init.d/archiva"
cp $ATTACH_DIR/archiva.sh.tpl $archiva_script

# Apply arguments
sed -i "s#@@ARCHIVA_DATA@@#$ARCHIVA_DATA#g" $archiva_script
sed -i "s#@@ARCHIVA_LIB_PREFIX@@#$ARCHIVA_LIB_PREFIX#g" $archiva_script
sed -i "s#@@ARCHIVA_USER@@#$ARCHIVA_USER#g" $archiva_script

chmod +x $archiva_script

# Add continuum script to boot
update-rc.d archiva defaults

# Start archiva
service archiva start

exit 0 # Smile!!

