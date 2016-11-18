if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo [*] Downloading Filebeat...
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
echo [*] Installing Filebeat...
dpkg -i filebeat-5.0.0-amd64.deb
echo Filebeat Installed. Make sure you UPDATE the filebeat.yml CONFIGURATION
 