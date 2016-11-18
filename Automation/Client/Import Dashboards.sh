if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo Importing Dashboards and Indexes
/usr/share/filebeat/scripts/import_dashboards
echo Done Importing ... Restarting Filebeat
/etc/init.d/filebeat restart
