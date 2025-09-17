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
	# shellcheck disable=SC2012 # [Use find instead of ls]: overkill
	\ls -hal | \sed -e 's/^/DEBUG: /'
	echo 'DEBUG:'
fi

if [ -f mvnw ] || [ -f mvnw.sh ]; then
	if [ "${DEBUG}" = true ]; then
		echo 'DEBUG: using project maven wrapper'
	fi
	if [ -f mvnw ]; then
		cmd='./mvnw'
	else
		cmd='./mvnw.sh'
	fi
	if [ -n "${MAVEN_CONFIG+x}" ]; then
		# resolve conflict with mvnw
		unset MAVEN_CONFIG
	fi
else
	if [ "${DEBUG}" = true ]; then
		echo 'DEBUG: using maven distribution'
	fi
	cmd="${MAVEN_HOME}/bin/mvn"
fi

if [ -z "${MAVEN_OPTS+x}" ]; then
	MAVEN_OPTS='-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Dorg.slf4j.simpleLogger.showDateTime=true -Djava.awt.headless=true'
fi

if [ -z "${MAVEN_CLI_OPTS+x}" ]; then
	opts=('--batch-mode' '--errors' '--fail-at-end' '--show-version')
else
	IFS=' ' read -r -a opts <<<"${MAVEN_CLI_OPTS}"
fi

if [ -z "${MAVEN_CLI_EXTRA_OPTS+x}" ]; then
	extra_opts=('-DprocessDependencyManagementTransitive=false')
else
	IFS=' ' read -r -a extra_opts <<<"${MAVEN_CLI_EXTRA_OPTS}"
fi

rc=0

"${cmd}" "${opts[@]}" "${extra_opts[@]}" \
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
