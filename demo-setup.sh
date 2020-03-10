#!/usr/bin/env bash

# Stands up test environment and builds nginx container to put our config in
# docker-compose up -d

until curl --fail --insecure http://localhost:8081; do 
  sleep 5
done

#Create Docker repos and group
cd nexus-repository
./create.sh blobs.json
./run.sh myBlobs

./create.sh docker.json
./run.sh Docker

 ./create.sh npm.json
 ./run.sh npm
