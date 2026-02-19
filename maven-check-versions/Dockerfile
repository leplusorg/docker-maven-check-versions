FROM maven:3.9.12@sha256:0d5663a8e729e61f18354d68d2b082865d8874586eba5e5fd8cc649129259713

HEALTHCHECK NONE

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

COPY maven-check-versions.sh /opt/maven-check-versions.sh

RUN chmod ugo+rx /opt/maven-check-versions.sh

ARG MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=/opt/maven/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true"
ENV MAVEN_OPTS="${MAVEN_OPTS}"

ARG MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
ENV MAVEN_CLI_OPTS="${MAVEN_CLI_OPTS}"

RUN mkdir -m 777 /opt/maven

ARG MAVEN_USER_HOME="/opt/maven/.m2"
ENV MAVEN_USER_HOME="${MAVEN_USER_HOME}"

USER ubuntu

WORKDIR /opt/project

ENTRYPOINT ["/opt/maven-check-versions.sh"]

CMD []
