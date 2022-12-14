#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

shopt -s lastpipe

if [ -f mvnw ]; then
  cmd='./mvnw'
  if [ -n "${MAVEN_CONFIG+x}" ]; then
    # resolve conflict with mvnw
    unset MAVEN_CONFIG
  fi
else
  cmd='mvn'
fi

if [ -z "${MAVEN_CLI_OPTS+x}" ]; then
  opts=()
else
  IFS=' ' read -r -a opts <<< "${MAVEN_CLI_OPTS}"
fi

rc=0

"${cmd}" "${opts[@]}" \
       versions:display-dependency-updates \
       versions:display-plugin-updates \
       versions:display-property-updates \
    | while read -r l; do
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
done

exit ${rc}
