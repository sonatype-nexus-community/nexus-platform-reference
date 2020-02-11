#!/bin/sh
cd /home/nexus
java -jar -Djava.security.egd=file:/dev/./urandom intsvc.jar
