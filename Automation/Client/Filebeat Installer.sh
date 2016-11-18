if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
echo [*] ${CYAN}Downloading${NC} Filebeat...
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
echo [*] ${CYAN}Installing${NC} Filebeat...
dpkg -i filebeat-5.0.0-amd64.deb
echo Filebeat Installed. Make sure you ${RED}UPDATE${NC} the filebeat.yml ${RED}CONFIGURATION${NC}
