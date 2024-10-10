ARG NEXUS_DOCKER_IMAGE_ORGANIZATION
ARG NEXUS_REPOSITORY_VERSION
FROM ${NEXUS_DOCKER_IMAGE_ORGANIZATION}/nexus3:${NEXUS_REPOSITORY_VERSION}
ARG NEXUS_CASC_PLUGIN_VERSION
USER root
RUN set -eux; \
    curl -L -f -o /opt/sonatype/nexus/deploy/nexus-casc-plugin-${NEXUS_CASC_PLUGIN_VERSION}-bundle.kar \
    https://repo1.maven.org/maven2/io/github/asharapov/nexus/nexus-casc-plugin/${NEXUS_CASC_PLUGIN_VERSION}/nexus-casc-plugin-${NEXUS_CASC_PLUGIN_VERSION}-bundle.kar;
USER nexus