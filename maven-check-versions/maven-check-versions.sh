#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

shopt -s lastpipe

# debug mode is off by default
if [ -z "${DEBUG+x}" ]; then
	DEBUG=false
fi

# Honoring GitHub runner debug mode
if [ -n "${RUNNER_DEBUG+x}" ] && [ "${RUNNER_DEBUG}" = 1 ]; then
	DEBUG=true
fi

if [ "${DEBUG}" = true ]; then
	set -o xtrace
	# If maven wrapper debugging is not already configured, let's
	# turn it on too.
	if [ -n "${MVNW_VERBOSE+x}" ]; then
		export MVNW_VERBOSE=true
	fi
fi

# Support working_directory input if used as GitHub action
if [ -n "${INPUT_WORKING_DIRECTORY+x}" ]; then
	if [ "${DEBUG}" = true ]; then
		echo "DEBUG: changing working directory to: ${INPUT_WORKING_DIRECTORY}"
	fi
	cd "${INPUT_WORKING_DIRECTORY}"
fi

if [ "${DEBUG}" = true ]; then
	echo "DEBUG: current working directory = $(pwd)"
	echo 'DEBUG:'
	# shellcheck disable=SC2012
	\ls -hal | \sed -e 's/^/DEBUG: /'
	echo 'DEBUG:'
fi

if [ -f mvnw ]; then
	if [ "${DEBUG}" = true ]; then
		echo 'DEBUG: using existing maven wrapper'
	fi
	cmd='./mvnw'
	# Ensure maven wrapper work directory is somewhere we have
	# write permissions
	export MAVEN_USER_HOME="/opt/maven/.m2"
	if [ -n "${MAVEN_CONFIG+x}" ]; then
		# resolve conflict with mvnw
		unset MAVEN_CONFIG
	fi
else
	if [ "${DEBUG}" = true ]; then
		echo 'DEBUG: using docker-provided maven command'
	fi
	cmd=$(\which mvn)
fi

if [ -z "${IGNORED_VERSIONS+x}" ]; then
	IGNORED_VERSIONS=''
fi

if [ -z "${MAVEN_CLI_OPTS+x}" ]; then
	opts=()
else
	IFS=' ' read -r -a opts <<<"${MAVEN_CLI_OPTS}"
fi

rc=0

"${cmd}" "-Dmaven.version.ignore=${IGNORED_VERSIONS}" "${opts[@]+"${opts[@]}"}" \
	versions:display-dependency-updates \
	versions:display-plugin-updates \
	versions:display-property-updates |
	while read -r l; do
		echo "${l}"
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
