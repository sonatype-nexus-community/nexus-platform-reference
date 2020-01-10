#!/bin/bash

SCRIPTNAME=${0##*/}

#Update this with your dockerhub username or user with push pernmission to your private repo
DOCKERNAME=$USER

function print_usage() {
    echo "Please provide a version number for tagging"
    echo "$SCRIPTNAME <version>  e.g. build-iq.sh 1.41"
}

#a lot can still go wrong here but it's a start...
if [ "$1" != "" ]; then
    docker login nexus:5000
    docker push nexus:5000/$DOCKERNAME/demo-iq-server:$1
    docker push nexus:5000/$DOCKERNAME/demo-iq-server:latest
else
    print_usage 
    exit 1
fi

