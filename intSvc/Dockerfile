FROM openjdk:8-jre-slim

RUN useradd --home-dir /home/nexus --create-home -U nexus

RUN apt-get update; apt-get install curl -y

ENV PATH "$PATH:/home/nexus"

COPY files/start.sh /home/nexus/start.sh
RUN chmod +x /home/nexus/start.sh

USER nexus
RUN cd /home/nexus/; mkdir -p work
COPY --chown=nexus:nexus files/iqapplication.properties /home/nexus/iqapplication.properties
COPY --chown=nexus:nexus files/mapping.json /home/nexus/mapping.json
COPY --chown=nexus:nexus files/SonatypeFortifyIntegration*.jar /home/nexus/intsvc.jar

ENTRYPOINT ["/home/nexus/start.sh"]