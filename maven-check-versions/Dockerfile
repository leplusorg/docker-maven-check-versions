FROM maven:3.9.8@sha256:de18e4e51396ad9266f76669779ed6d6b49fbb0f45ed6f39169d87378d548d7d

HEALTHCHECK NONE

ENTRYPOINT []

COPY maven-check-versions.sh /opt/

ARG MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true"
ENV MAVEN_OPTS="${MAVEN_OPTS}"

ARG MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
ENV MAVEN_CLI_OPTS="${MAVEN_CLI_OPTS}"

USER ubuntu

WORKDIR /home/ubuntu

CMD ["/opt/maven-check-versions.sh"]
