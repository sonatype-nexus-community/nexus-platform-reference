#!/bin/bash
docker build -t webhook-listener:test .
docker build -t nexus:18444/webhook-listener:test14 .
docker push nexus:18444/webhook-listener:test14