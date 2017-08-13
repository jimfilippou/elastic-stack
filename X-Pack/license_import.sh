# With this you can import the license to XPACK

if [ ! -f license.json ]; then
    echo "License not found!"
    exit 1
fi
echo Importing License...
curl -XPUT -u elastic 'http://127.0.0.1:9200/_xpack/license' -d @license.json
echo Importing License acknowledge=true ...
curl -XPUT -u elastic 'http://127.0.0.1:9200/_xpack/license?acknowledge=true' -d @license.json
