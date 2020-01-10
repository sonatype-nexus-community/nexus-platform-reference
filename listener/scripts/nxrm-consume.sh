#!/bin/sh
echo "******* THIS IS A NEXUS REPO HOOK*******"
echo "1 = ";$1
echo $2
echo $3
echo $4

AppID=${3/\//\_}
echo $AppID

cd /etc/webhook;
docker login https://registry.mycompany.com:5000 -u admin -p admin123
docker pull registry.mycompany.com:5000/$3:$4
docker save -o $AppID.tar registry.mycompany.com:5000/$3:$4
java -jar nexus-iq-cli.jar -s http://iq-server:8070 -i $AppID -t release -a admin:admin $AppID.tar
ls -la
rm $AppID.tar
#docker rmi registry.mycompany.com:5000/$3:$4
ls -la
echo "******* END DEBUG ***********"

