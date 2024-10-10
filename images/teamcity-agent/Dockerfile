ARG TEAMCITY_SERVER_VERSION=2021.1.2
FROM jetbrains/teamcity-agent:${TEAMCITY_SERVER_VERSION}
USER buildagent
RUN curl -L -X GET -o /services/nexus-cli.jar https://download.sonatype.com/clm/scanner/latest.jar;