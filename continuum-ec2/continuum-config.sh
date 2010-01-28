#!/bin/bash 
# Optaros-continuum setup script
#
# Required env: 
# $CONTINUUM_DATA - Path to continuum data. ie. /var/continuum/
# $CONTINUUM_DATABASE - Database Name
# $CONTINUUM_DATABASE_HOST
# $CONTINUUM_DATABASE_PASSWORD
# $CONTINUUM_DATABASE_PORT 
# $CONTINUUM_DATABASE_USER
# $CONTINUUM_LIB_PREFIX - ie. /opt/
# $CONTINUUM_SRC - Continuum source folder. ie. /tmp/continuum_src
# $CONTINUUM_USER - System user. ie. continuum
# $ATTACH_DIR - RightScale artifact. ie. './' or $(dirname $0)
#
# Required packages: openjdk-6-jre libpg-java maven2
# Note: 
#  - Tested on postgresql.
#  - Tested on ubuntu hardy/intrepid/jaunty/karmic.
#

# Create continuum user (@TODO maybe test if exists )
adduser --system --group --disabled-password --disabled-login $CONTINUUM_USER

# Install continuum bin
cp -a $CONTINUUM_SRC $CONTINUUM_LIB_PREFIX
chown -R $CONTINUUM_USER:$CONTINUUM_USER $CONTINUUM_LIB_PREFIX

# Setup CONTINUUM_DATA dir
mkdir -p /mnt/continuum /mnt/continuum/logs
cp -a $CONTINUUM_LIB_PREFIX/conf /mnt/continuum/
chown -R $CONTINUUM_USER:$CONTINUUM_USER /mnt/continuum/
ln -s /mnt/continuum $CONTINUUM_DATA

# Setup and install startup script
continuum_script="/etc/init.d/continuum"
cp $ATTACH_DIR/continuum.sh.tpl $continuum_script

# Apply arguments
sed -i "s#@@CONTINUUM_DATA@@#$CONTINUUM_DATA#g" $continuum_script
sed -i "s#@@CONTINUUM_LIB_PREFIX@@#$CONTINUUM_LIB_PREFIX#g" $continuum_script
sed -i "s#@@CONTINUUM_USER@@#$CONTINUUM_USER#g" $continuum_script

chmod +x $continuum_script

# Add postgres.jar to wraper's classpath
classpath_index=$(grep wrapper.java.classpath $CONTINUUM_DATA/conf/wrapper.conf|wc -l)
let classpath_index=classpath_index+1
echo "wrapper.java.classpath.$classpath_index=/usr/share/java/postgresql.jar">>$CONTINUUM_DATA/conf/wrapper.conf

# DB connection details
config_db="<New class=\"org.postgresql.ds.PGSimpleDataSource\"> \
<Set name=\"serverName\">$CONTINUUM_DATABASE_HOST</Set> \
<Set name=\"databaseName\">$CONTINUUM_DATABASE</Set> \
<Set name=\"user\">$CONTINUUM_DATABASE_USER</Set> \
<Set name=\"password\">$CONTINUUM_DATABASE_PASSWORD</Set> \
<Set name=\"portNumber\">$CONTINUUM_DATABASE_PORT</Set></New>"

block_start='New class="org.apache.derby.jdbc.EmbeddedDataSource"'
block_stop='<\/New'

sed_script=":t;/$block_start/,/$block_stop/ {
 /$block_stop/!{N;bt;};/.*/c\
 $config_db
}"

sed -i -e "$sed_script" $CONTINUUM_DATA/conf/jetty.xml

# Add continuum script to boot
update-rc.d continuum defaults

# Start continuum
service continuum start

exit 0 # Smile!!

