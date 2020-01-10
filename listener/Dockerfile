FROM    almir/webhook

RUN     apk update && apk upgrade && apk add openjdk8-jre

COPY 		hooks/*.json /etc/webhook/
COPY		scripts/*.sh /etc/webhook/

COPY		nexus-iq-cli-*.jar /etc/webhook/nexus-iq-cli.jar
