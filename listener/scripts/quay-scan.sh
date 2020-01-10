#!/bin/sh
#Sample payload
# {
#  “docker_url”: “quay.io/cnyanko/webhook-listener”,
#  “homepage”: “https://quay.io/repository/cnyanko/webhook-listener“,
#  “name”: “webhook-listener”,
#  “namespace”: “cnyanko”,
#  “repository”: “cnyanko/webhook-listener”,
#  “updated_tags”: [
#    “latest”
#  ]
# }
# Debugging Stuff 
echo "~~~~~~~~~~~~~~~~~Payload~~~~~~~~~~~~~~~~~"
echo $1 # Entire Payload
echo "~~~~~~~~~~~~~~~~~Docker URL~~~~~~~~~~~~~~~~~"
echo $2 # Docker URL
echo "~~~~~~~~~~~~~~~~~Updated Tags~~~~~~~~~~~~~~~~~"
echo $3 # Updated Tags
echo "~~~~~~~~~~~~~~~~~Trimmed Tags~~~~~~~~~~~~~~~~~"
trimmedTags=`echo $3 | sed 's/[][]//g'`
echo $trimmedTags
echo "~~~~~~~~~~~~~~~~~Name~~~~~~~~~~~~~~~~~"
echo $4 # Name
echo "~~~~~~~~~~~~~~~~~namespace~~~~~~~~~~~~~~~~~"
echo $5 # namespace

cd /etc/webhook;

AppID=${6/\//\_}
echo $AppID

# Valid stages are develop|build|stage-release|release|operate
Stage="stage_release"

for tag in $trimmedTags ; do
   echo "=== testing $tag ==="
   if [[ -z "$tag" ]] ; then
       echo "Tag invalid"
   else
      echo "Tag Valid - Doing Scan";
  	  DockerPull=$2:$tag;
  	  echo $DockerPull
  	  # doDockerScan $DockerPull $AppID
	  docker pull $DockerPull
	  docker save -o docker.tar $DockerPull
	  echo 'Should see a docker.tar file'
	  ls -lah
	  java -jar nexus-iq-cli.jar -s http://iq-server:8070 -i $AppID -t stage-release -a admin:admin docker.tar
	  rm docker.tar
	  docker rmi $DockerPull
	  ls -lah
   fi
done

# Docker Scan Function to Call

# doDockerScan () {
# 	echo $1
# 	docker pull $1
# 	docker save -o docker.tar $1
# 	ls -lah
# 	java -jar nexus-iq-cli.jar -s http://iq-server:8070 -i $2 -a admin:admin docker.tar
# 	rm docker.tar
# 	docker rmi $1
# 	ls -lah
# }