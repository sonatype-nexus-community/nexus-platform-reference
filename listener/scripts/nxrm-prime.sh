#!/bin/sh
PORT=8081
NEXUS=http://nexus:$PORT/repository/
REPO="$1/"
GroupID="$2/"
ArtifactID="$3/"
VersionID="$4/"
#GroupID=$(sed -i -e 's/\./\//g' $($GroupID))

GroupID=${GroupID/\./\/}
echo $GroupID

echo "******* THIS IS A NEXUS REPO HOOK*******"
echo $1 #Repo - e.g. maven-releases
echo $2 #groupId - com.mycompany
echo $3 #artifactID -  fancyWidget
echo $4 #versionID -  1.0.0
cd /etc/webhook;
echo $NEXUS$REPO$GroupID$ArtifactID$VersionID
wget $NEXUS$REPO$GroupID$ArtifactID$VersionID

echo "******* END DEBUG ***********"

