<div align="center">


 
 
![alt text](https://3.bp.blogspot.com/-3gz5Ot9YHmE/WGf8k9D6mzI/AAAAAAAAAMk/rO2hxFdTQhouAdowiU3om8ulGcRHzjqdwCLcB/s640/elastic-stack-5-0-diagram-thumb.jpg "Elastic Stack")




<br>

</div>

## Elastic Stack 5.0 Installation Guide 


| Software      | Version       |
| ------------- | ------------- |
| Elasticsearch | 5.0.0         |
| Logstash      | 5.0.0         |
| Kibana        | 5.0.0         |
| Beats         | 5.0.0         |
| X-Pack        | 5.0.0         |
| Nginx         | 1.10.0        |
| Java          | 1.8.0_111     |
 
## Introduction and overview

The Elastic Stack we are going to set up is splited into 3 severs for the sake of simplicity. One server is for logstash, one for elastic search and one for kibana front-end, however you can put everything in a single vps but it's not recommended. We will be distributing mostly log data.

## Setting up Elastic Search

First of all elasticsearch is powered with Java so lets get it to our server.

`apt-get install openjdk-8-jre-headless`

Elastic company maintains a .deb file to install elasticsearch on debian based systems so lets grab that .deb

`wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.0.deb`

Let's install it

`dpkg -i elasticsearch-5.0.0.deb`

Ok, before launching it let's see the configuration

`nano /etc/elasticsearch/elasticsearch.yml`

Hmm... seems like too much configuration stuff, but don't worry just uncomment and use these

`cluster.name: "example"`

`node.name: "example"`

`network.host: "your elasticsearch server ip"`

Now let's change max memmory mapping

`sysctl -w vm.max_map_count = 262144`

Start elasticsearch

`service elasticsearch start`

Ensure elasticsearch is working

`curl http://127.0.0.1:9200`

Make elasticsearch start on boot

`systemctl enable elasticsearch`

All set! continue to Logstash

## Setting up Logstash

Logstash also needs java to power itself so get it

`apt-get install openjdk-8-jre-headless`

We will install logstash from public reposiories and not through .deb like we did last time, just follow along.

`wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -`

`echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list
`

Finally let's install it

`apt-get update && apt-get install logstash`

Logstash is downloaded and installed, but is it working correctly? Let's find out.

Go to this directory 

`cd /usr/share/logstash`

And execute logstash programmatically

`bin/logstash -e 'input { stdin { } } output { elasticsearch { hosts => ["ip-of-elasticsearch:9200"] } }'`

What we did here? we started a cli-like software that lets us send messages over elasticsearch. Ok when you are able to type, type a random message and press enter, then exit with ctrl + C.

Soooo... we sent the message to elasticsearch, but is it there? lets see.

Open postman or a tool of your choice, we are going to send a GET request to elasticsearch server

`http://ip-of-elasticsearch:9200/logstash-*/_search`

You should now see the message you sent before

Lets now make logstash run on boot

`systemctl enable logstash`

And finally launch logstash

`service logstash start`

Continue to kibana setup

## Setting up Kibana

Kibana is really easy to set up, and it doesn't require java at all!

Lets get the public repos, follow along

`wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -`

`echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list`

Now install it

`apt-get update && apt-get install kibana`

Edit the configurations

`nano /etc/kibana/kibana.yml`

You only have to edit these:

`server.host: "kibanaserver"`

`server.name: "hostname"`

`elasticsearch.url: "http://elasticsearchserver:9200"`

Save the file and now we are ready to launch kibana

`service kibana start`


## Setting up Nginx

Why do i need Nginx?

Well by default kibana is accessible to everyone, do you want that?

If you don't then configure nginx to ask for a password and then forward to actual kibana application

Use the default nginx configuration i provided

+  sudo apt-get install nginx
+  sudo -v
+  Get this command from http://pastebin.com/pTwwUpUQ (Markup Issue)
+  sudo nano /etc/nginx/sites-available/default
+  sudo nginx -t
+  sudo systemctl restart nginx
+  sudo ufw allow 'Nginx Full' 


## Setting up Filebeat

Filebeat does not require java, plus it's lightweight so don't worry about anything related to performance.

Like the old days add the apt repositories

`wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -`

`echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list`

Now install it

`apt-get update && apt-get install filebeat`

Time to configure

`nano /etc/filebeat/filebeat.yml`

Use this configuration to start

```
paths:
  - /var/log/syslog
document_type: syslog
```

Then comment out output.elasticsearch line and the hosts line below it. We will be forwarding to logstash so uncomment output.logstash line and hosts line below it and replace with logstash ip

Now move to logstash server and open a console

Let's connfigure beats to filter the incoming data.

`nano /etc/logstash/conf.d/beats.conf`

There is no filter section to the current configuration so add this block!


```
filter {

  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog:timestamp"} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
    }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }

}
```

Restart logstash

`service logstash stop` 

`service logstash stop` 

Move back to filebeat server. Lets load the templates!

`cd /etc/filebeat`

`curl -XPUT 'http://elasticsearchserver:9200/_template/filebeat' -d@/etc/filebeat/filebeat.template.json`

Make it run on boot

`systemctl enable filebeat`

Start

`service filebeat start`

Now open your browser and navigate to kibana front-end

Go to management

![alt text](http://i.imgur.com/gMkov24.png "Elastic Stack")

Go to Index Patterns

![alt text](http://i.imgur.com/XRPsJAx.png "Elastic Stack")

Add a new index

![alt text](http://i.imgur.com/RPM4CIC.png "Elastic Stack")

Make sure Index name or pattern is **filebeat-***

![alt text](http://i.imgur.com/RS4UDq2.png "Elastic Stack")

Go ahead, visualize your data 💩 !


## X-Pack Setup

+ /etc/init.d/elasticsearch stop
+ cd /usr/share/elasticsearch/bin
+ ./elasticsearch-plugin install x-pack
+ /etc/init.d/elasticsearch start
+ cd /home/YOUR NAME/kibana-5.0.0-linux-x86_64/bin
+ ./kibana-plugin install x-pack
+ [To Import License Refer To X-Pack/license_import.sh]

## Metricbeat Setup (Each Server) [Optional]

+  wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.0.0-amd64.deb
+  dpkg -i metricbeat-5.0.0-amd64.deb 
+  nano /etc/metricbeat/metricbeat.yml
+  /etc/init.d/metricbeat start
+  /usr/share/metricbeat/scripts/import_dashboards 
+  systemctl enable metricbeat [optional]


Feel free to open an issue if something isn't working, things change and i tested it a long time ago, but i will be maintaining it for a long time. 
