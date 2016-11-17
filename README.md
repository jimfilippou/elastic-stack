# Elastic-Stack-5.0
This is a Documentation / Walkthrough on how to install Elastic Stack on Ubuntu 16.04 Server.



##Elastic Stack 5.0 Installation Guide 

| Software      | Version       |
| ------------- | ------------- |
| Elasticsearch | 5.0.0         |
| Logstash      | 5.0.0         |
| Kibana        | 5.0.0         |
| Beats         | 5.0.0         |
| Nginx         | 1.10.0        |
| Java          | 1.8.0_111     |
  
| Platform      | Version       | Architecture |
| --------------| ------------- | ------------ |
| Ubuntu        | 16.04         | x86_64       |

* Author       : D.Filippou        

   Java Setup
   ----------
   +  sudo apt-get update
   +  sudo apt-get install openjdk-8-jre
   
   NginX Setup
   ----------- 
   +  sudo apt-get install nginx
   +  sudo -v
   +  echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users
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

   Logstash Setup
   --------------
   +  curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.deb
   +  dpkg -i logstash-5.0.0.deb 
   +  nano /etc/logstash/conf.d/logstash.conf
   +  cd /usr/share/logstash/bin
   +  ./logstash-plugin update logstash-input-beats
   +  systemctl start logstash

   Kibana Setup
   ------------
   +  cd ~ && curl -L -O https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz
   +  tar -xvf kibana-5.0.0-linux-x86_64.tar.gz kibana-5.0.0-linux-x86_64/
   +  ./kibana-5.0.0-linux-x86_64/bin/kibana

   Filebeat Setup (Each Server) [Optional]
   ---------------------------------------
   +  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
   +  dpkg -i filebeat-5.0.0-amd64.deb 
   +  nano /etc/filebeat/filebeat.yml
   +  /etc/init.d/filebeat start
   +  ./usr/share/filebeat/scripts/import_dashboards 
  
   Metricbeat Setup (Each Server) [Optional]
   -----------------------------------------
   +  wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.0.0-amd64.deb
   +  dpkg -i metricbeat-5.0.0-amd64.deb 
   +  nano /etc/metricbeat/metricbeat.yml
   +  /etc/init.d/metricbeat start
   +  ./usr/share/metricbeat/scripts/import_dashboards 
  
