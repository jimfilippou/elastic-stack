#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo Killing Elastic Search...
/etc/init.d/elasticsearch stop
echo Killing Logstash...
systemctl stop logstash.service
echo Killing Filebeat...
/etc/init.d/filebeat stop
echo Kibana Is Not A Process
