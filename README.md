# Elastic-Stack-5.0
This is a Documentation / Walkthrough on how to install Elastic Stack on Ubuntu 16.04 Server.

##Elastic Stack 5.0 Installation Guide 

###Author  Dimitris Filippou

####Minimum System Requirements
    OS: Ubuntu 16.04
    RAM: 4GB
    CPU: 2


| Software      | Version       |
| ------------- | ------------- |
| Elasticsearch | 5.0.0         |
| Logstash      | 5.0.0         |
| Kibana        | 5.0.0         |
| Beats         | 5.0.0         |
| X-Pack        | 5.0.0         |
| Nginx         | 1.10.0        |
| Java          | 1.8.0_111     |
 
##   Follow These Steps To Get A Full ELK Installation
 
   + Lets Begin

   Java Setup
   ----------
   +  sudo apt-get update
   +  sudo apt-get install openjdk-8-jre

   NginX Setup
   ----------- 
   +  sudo apt-get install nginx
   +  sudo -v
   +  Get this command from http://pastebin.com/pTwwUpUQ (Markup Issue)
   +  sudo nano /etc/nginx/sites-available/default
   +  sudo nginx -t
   +  sudo systemctl restart nginx
   +  sudo ufw allow 'Nginx Full' 

   Enable Root
   -----------
   +  sudo -s

   Elastic Search Setup
   --------------------
   +  curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.0.deb
   +  dpkg -i elasticsearch-5.0.0.deb 
   +  /etc/init.d/elasticsearch start
   +  curl http://127.0.0.1:9200 (Testing Purposes)
   +  systemctl enable elasticsearch [Optional]

   Logstash Setup
   --------------
   +  curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.deb
   +  dpkg -i logstash-5.0.0.deb 
   +  nano /etc/logstash/conf.d/logstash.conf
   +  cd /usr/share/logstash/bin
   +  ./logstash-plugin update logstash-input-beats
   +  systemctl enable logstash
   +  systemctl start logstash

   Kibana Setup
   ------------
   +  cd ~ && curl -L -O https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz
   +  tar -xvf kibana-5.0.0-linux-x86_64.tar.gz kibana-5.0.0-linux-x86_64/
   +  ./kibana-5.0.0-linux-x86_64/bin/kibana         (Debug Mode)
   +  nohup ./kibana-5.0.0-linux-x86_64/bin/kibana & (Production Mode)
   
   X-Pack Setup
   ------------
   + /etc/init.d/elasticsearch stop
   + cd /usr/share/elasticsearch/bin
   + ./elasticsearch-plugin install x-pack
   + /etc/init.d/elasticsearch start
   + cd /home/YOUR NAME/kibana-5.0.0-linux-x86_64/bin
   + ./kibana-plugin install x-pack
   + [To Import License Refer To X-Pack/license_import.sh]

   Filebeat Setup (Each Server) [Optional]
   ---------------------------------------
   +  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
   +  dpkg -i filebeat-5.0.0-amd64.deb 
   +  nano /etc/filebeat/filebeat.yml
   +  /etc/init.d/filebeat start
   +  /usr/share/filebeat/scripts/import_dashboards 
   +  systemctl enable filebeat [Optional]
  
   Metricbeat Setup (Each Server) [Optional]
   -----------------------------------------
   +  wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.0.0-amd64.deb
   +  dpkg -i metricbeat-5.0.0-amd64.deb 
   +  nano /etc/metricbeat/metricbeat.yml
   +  /etc/init.d/metricbeat start
   +  /usr/share/metricbeat/scripts/import_dashboards 
   +  systemctl enable metricbeat [optional]
