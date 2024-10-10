ARG TEAMCITY_SERVER_VERSION=2021.1.2
FROM jetbrains/teamcity-server:${TEAMCITY_SERVER_VERSION}
USER tcuser

# Move the installation so that we can access at /teamcity rather than just /
RUN mv /opt/teamcity/webapps/ROOT /opt/teamcity/webapps/teamcity;