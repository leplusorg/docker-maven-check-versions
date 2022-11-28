#!/bin/bash
# shellcheck disable=SC2086
set -euo pipefail
IFS=$'\n\t'

# shellcheck disable=SC2034
MAVEN_OPTS='-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Djava.awt.headless=true'
MAVEN_CLI_OPTS='--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true'

rc=0

while read -r l; do
    \echo "${l}"
    if [[ "${l}" == *"[ERROR]"* ]]; then
	rc=$((rc+1))
    elif [[ "${l}" == *"has a newer version:"* ]]; then
	rc=$((rc+1))
    elif [[ "${l}" == *"have newer versions:"* ]]; then
	rc=$((rc+1))
    elif [[ "${l}" == *"update is available:"* ]]; then
	rc=$((rc+1))
    elif [[ "${l}" == *"updates are available:"* ]]; then
	rc=$((rc+1))
    fi
done <<< "$(./mvnw ${MAVEN_CLI_OPTS} versions:display-dependency-updates versions:display-plugin-updates versions:display-property-updates)"

exit ${rc}
