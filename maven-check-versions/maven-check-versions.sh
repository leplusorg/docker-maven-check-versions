#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

shopt -s lastpipe

# debug mode is off by default
if [ -z "${DEBUG+x}" ]; then
	DEBUG=false
fi

# Honoring GitHub runner debug mode
if [ -n "${ACTIONS_RUNNER_DEBUG+x}" ] && [ "${ACTIONS_RUNNER_DEBUG}" = true ]; then
	DEBUG=true
elif [ -n "${RUNNER_DEBUG+x}" ] && [ "${RUNNER_DEBUG}" = true ]; then
	DEBUG=true
fi

if [ "${DEBUG}" = true ]; then
	set -o xtrace
	# If maven wrapper debugging is not already configured, let's
	# turn it on too.
	if [ -n "${MVNW_VERBOSE+x}" ]; then
	    MVNW_VERBOSE=true
	fi
	\echo "DEBUG: current working directory = $(pwd)"
	\echo 'DEBUG:'
	# shellcheck disable=SC2012
	\ls -hal | \sed -e 's/^/DEBUG: /'
	\echo 'DEBUG:'
fi

if [ -f mvnw ]; then
	if [ "${DEBUG}" = true ]; then
		\echo 'DEBUG: using existing maven wrapper'
	fi
	cmd='./mvnw'
	# Ensure maven wrapper work directory is somewhere we have
	# write permissions
	MAVEN_USER_HOME='/opt/maven'
	if [ -n "${MAVEN_CONFIG+x}" ]; then
		# resolve conflict with mvnw
		unset MAVEN_CONFIG
	fi
else
	\echo 'DEBUG: using docker-provided maven command'
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
