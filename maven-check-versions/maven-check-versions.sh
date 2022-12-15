#!/bin/bash
# shellcheck disable=SC2086
set -euo pipefail
set -x
IFS=$'\n\t'

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
    elif [[ "${l}" == *"BUILD FAILURE"* ]]; then
	rc=$((rc+1))
    fi
done <<< "$(./mvnw ${MAVEN_CLI_OPTS} versions:display-dependency-updates versions:display-plugin-updates versions:display-property-updates)"

exit ${rc}
