FROM maven:3.9.9@sha256:8472bdbac39626b70d2efcf87e23468ff0bea9ba48c35181b07e6932b5fda001

HEALTHCHECK NONE

RUN mkdir -p /opt/maven && chmod 777 /opt/maven

COPY maven-check-versions.sh /opt/

ARG MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=/opt/maven/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true"
ENV MAVEN_OPTS="${MAVEN_OPTS}"

ARG MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
ENV MAVEN_CLI_OPTS="${MAVEN_CLI_OPTS}"

USER ubuntu

WORKDIR /opt/project

CMD ["/opt/maven-check-versions.sh"]

ENTRYPOINT []
