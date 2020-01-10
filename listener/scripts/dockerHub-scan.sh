#!/bin/sh
#exec > /etc/webhook/output.log 2>&1

echo $1
echo $2
echo $3
cd /etc/webhook;
docker pull nexus:18444/$2:$3
docker save -o docker.tar $2:$3
java -jar nexus-iq-cli.jar -s http://iq-server:8070 -i juice-shop -a admin:admin123 docker.tar
ls -la
rm docker.tar
docker rmi $2:$3
ls -la
