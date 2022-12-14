FROM openjdk:21-slim

COPY maven-check-versions.sh /opt/

ENV MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true" \
    MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"

RUN /opt/maven-check-versions.sh
