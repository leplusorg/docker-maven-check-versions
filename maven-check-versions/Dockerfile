FROM maven:3.9.11@sha256:c5fedcac64163e406b2d81d0612daed7599fa5aab2ce00258f6c639ed18efad6

HEALTHCHECK NONE

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN mkdir -m 777 /opt/maven

COPY maven-check-versions.sh /opt/maven-check-versions.sh

RUN chmod ugo+rx /opt/maven-check-versions.sh

ARG MAVEN_OPTS="-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=/opt/maven/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true"
ENV MAVEN_OPTS="${MAVEN_OPTS}"

ARG MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
ENV MAVEN_CLI_OPTS="${MAVEN_CLI_OPTS}"

USER ubuntu

WORKDIR /opt/project

CMD ["/opt/maven-check-versions.sh"]

ENTRYPOINT []
