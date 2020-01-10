#!/bin/bash
# construct a list of application artifacts to be scanned by nexus-iq
# Include ear, war, tar, and tar.gz files
#
APP_LIST=$(mktemp -t applicationsXXXX.lst)
find /opt/sonatype-work/nexus/storage/releases -type f -name '*[ewt]ar' |grep -v '/.nexus/' >$APP_LIST
find /opt/sonatype-work/nexus/storage/releases -type f -name '*tar.gz' |grep -v '/.nexus/' >>$APP_LIST
sort -u $APP_LIST -o $APP_LIST

# construct a file containing only the groupId/artifactId portion of the full artifact name.
# we will use the file to find the most recent version of each artifact
GA_LIST=$(mktemp -t group-artifactXXXX.lst)
xargs -l1 dirname <$APP_LIST | xargs -l1 dirname | sort -u >$GA_LIST

# detect and eliminate duplicate artifactID
## Starting with version 1.48, application names can be 200 characters.
## We can extend application names (artifactId) by appending the groupId making
## all application names unique.  No need to remove duplicates now.
# GA_LIST_UNIQUE=$(mktemp -t group-artifact-uniqueXXXX.lst)
# sed -r 's/(.*)\/(.*)/\0 \2/' $GA_LIST|sort  -b  -k 2 -u|cut -d' ' -f1 |sort >$GA_LIST_UNIQUE
# GA_LIST=$GA_LIST_UNIQUE

# find latest release of each application
RELEASE_LIST=$(mktemp -t application-releaseXXXX.lst)
xargs -l1 -i{} <$GA_LIST >>$RELEASE_LIST \
bash -c "artifact={};\
  app=\$(basename \$artifact);\
  egrep \"\$artifact/[^/]+/\$app-\" $APP_LIST | sort | tail -1"
cat >dataloader.csv <<HEADER
# First Line always ignored by dataloader.
# OrgName (req), Policy (opt), AppName (req), AppID (req), "Tag1,Tag2" (opt), Artifact (req), scan stage (req), Contact username (opt), Comment
HEADER
xargs -l1 -i{} <$RELEASE_LIST >>dataloader.csv \
bash -c 'artifact={};\
  path=${artifact#/opt/sonatype-work/nexus/storage/releases/};\
  v=$(dirname $path);\
  id=$(dirname $v);\
  org=$(dirname $id);\
  orgName=${org//\//.};\
  app=$(basename $id);\
  appName=${app}.${orgName};\
  appId=${app}.${orgName};\
  echo "${orgName}, ,${appName}, ${appId}, , $artifact, release, ,"'

