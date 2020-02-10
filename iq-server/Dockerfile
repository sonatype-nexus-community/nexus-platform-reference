FROM sonatype/nexus-iq-server:1.84.0

# Install Git client
USER root
RUN yum -y install --disableplugin=subscription-manager git && \
    yum clean all

USER nexus
COPY config.yml /etc/nexus-iq-server/

HEALTHCHECK CMD curl http://localhost:8071/ping