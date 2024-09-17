FROM maven:3.9.9@sha256:52fe1d4631cd565953e61dbd3f6fb930ae5960ea61526776222c6da5dbb9ac59

HEALTHCHECK NONE

ENTRYPOINT []

COPY maven-check-versions.sh /opt/

ARG MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true"
ENV MAVEN_OPTS="${MAVEN_OPTS}"

ARG MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
ENV MAVEN_CLI_OPTS="${MAVEN_CLI_OPTS}"

USER ubuntu

WORKDIR /opt/project

CMD ["/opt/maven-check-versions.sh"]
