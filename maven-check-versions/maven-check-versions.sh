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
	IFS=' ' read -r -a opts <<<"${MAVEN_CLI_OPTS}"
fi

rc=0

"${cmd}" "${opts[@]}" \
	versions:display-dependency-updates \
	versions:display-plugin-updates \
	versions:display-property-updates |
	while read -r l; do
		\echo "${l}"
		if [[ "${l}" == *"[ERROR]"* ||
			"${l}" == *"has a newer version:"* ||
			"${l}" == *"have newer versions:"* ||
			"${l}" == *"update is available:"* ||
			"${l}" == *"updates are available:"* ||
			"${l}" == *"BUILD FAILURE"* ]]; then
			rc=$((rc + 1))
		fi
	done

exit ${rc}
