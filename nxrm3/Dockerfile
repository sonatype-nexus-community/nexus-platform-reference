ARG NEXUS_REPOSITORY_VERSION=3.33.0
FROM sonatype/nexus3:${NEXUS_REPOSITORY_VERSION}
ARG NEXUS_CASC_PLUGIN_VERSION=3.33.0.1
USER root
RUN set -eux; \
    curl -L -f -o /opt/sonatype/nexus/deploy/nexus-casc-plugin-${NEXUS_CASC_PLUGIN_VERSION}-bundle.kar \
    https://repo1.maven.org/maven2/io/github/asharapov/nexus/nexus-casc-plugin/${NEXUS_CASC_PLUGIN_VERSION}/nexus-casc-plugin-${NEXUS_CASC_PLUGIN_VERSION}-bundle.kar;
USER nexus