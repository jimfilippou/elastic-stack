#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo Starting Elastic Search...
/etc/init.d/elasticsearch start
sleep 10
echo Starting Logstash...
systemctl start logstash.service
sleep 10
echo Starting Filebeat...
/etc/init.d/filebeat start
sleep 10
echo Starting Kibana...
nohup ./kibana-5.0.0-linux-x86_64/bin/kibana &