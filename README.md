# Maven Check Versions

Multi-platform Docker container to run the Maven Versions plugin.

[![Dockerfile](https://img.shields.io/badge/GitHub-Dockerfile-blue)](maven-check-versions/Dockerfile)
[![Docker Build](https://github.com/leplusorg/docker-maven-check-versions/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-maven-check-versions/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/maven-check-versions?sort=semver)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/10080/badge)](https://bestpractices.coreinfrastructure.org/projects/10080)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/leplusorg/docker-maven-check-versions/badge)](https://securityscorecards.dev/viewer/?uri=github.com/leplusorg/docker-maven-check-versions)

## Purpose

This containers is meant to be used in CI/CD pipeline to detect when newer versions of Maven dependencies or plugins are avaible.

## Requirements

The image comes with Maven installed so it only needs a pom.xml to analyze. However if you want to control the version of Maven to be used instead, just make sure that there is a Maven wrapper script (mvnw) pointing to that version next to the pom.xml. For more information on how to install the maven wrapper in your project, see the [documentation](https://maven.apache.org/wrapper/).

The script uses the [Versions plugin](https://www.mojohaus.org/versions-maven-plugin/)). By default Maven will use the latest version of the plugin that it supports but you can set the desired version inside your pom.xml:

```xml
<properties>
  ...
  <maven.versions.plugin>2.14.0</maven.versions.plugin>
  ...
</properties>
...
<build>
  <pluginManagement>
    <plugins>
      ...
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>versions-maven-plugin</artifactId>
        <version>${maven.versions.plugin}</version>
      </plugin>
      ...
    </plugins>
  </pluginManagement>
</build>
```

## GitHub

To use this container in a GitHub worklow, add the following action file `.github/workflows/maven-check-versions.yml` to your project:

```yaml
---
name: Maven Check Versions

on:
  schedule:
    - cron: "0 0 * * 0"
  workflow_dispatch:

permissions: {}

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7
      - name: Check the versions
        uses: docker://leplusorg/maven-check-versions:3.9.11@sha256:abdd53328be1c87d7bf21b868d47d7934b28dfc66e168d9625877616ab14d6da
        env:
          MAVEN_CLI_EXTRA_OPTS: "-DprocessDependencyManagementTransitive=false '-Dmaven.version.ignore=(?i).+-(alpha|beta).+,(?i).+-m\\d+,(?i).+-rc\\d+'"
```

This way the action can be triggered manually and otherwise it runs
automatically once per week.

## GitLab

To use this container in a GitLab step, add the following step to the stage of your choice:

```yaml
maven check versions:
  image:
    name: leplusorg/maven-check-versions:3.9.11@sha256:abdd53328be1c87d7bf21b868d47d7934b28dfc66e168d9625877616ab14d6da
  script:
    - "/opt/maven-check-versions.sh"
  variables:
    MAVEN_CLI_EXTRA_OPTS: "-DprocessDependencyManagementTransitive=false '-Dmaven.version.ignore=(?i).+-(alpha|beta).+,(?i).+-m\\d+,(?i).+-rc\\d+'"
```

## Ignoring versions

You can define which versions should be ignored using the
`maven.version.ignore` system property (see here for
[details](https://www.mojohaus.org/versions/versions-maven-plugin/version-rules.html#Using_the_maven.version.ignore_property)). To
set `maven.version.ignore` inside the Docker container, you need to
override the default `MAVEN_CLI_EXTRA_OPTS` OS environment variable which
will be passed to the maven CLI command. For example, you can set
`MAVEN_CLI_EXTRA_OPTS` to `-DprocessDependencyManagementTransitive=false -Dmaven.version.ignore=(?i).+-(alpha|beta).+,(?i).+-m\\d+,(?i).+-rc\\d+`
to ignore transitive dependencies and all alpha, beta, mark or release
candidate versions.

## Manually using Docker

**Mac/Linux**

```bash
docker run --rm -t --user="$(id -u):$(id -g)" -v "$(pwd):/opt/project" leplusorg/maven-check-versions
```

**Windows**

In `cmd`:

```batch
docker run --rm -t -v "%cd%:/opt/project" leplusorg/maven-check-versions
```

In PowerShell:

```pwsh
docker run --rm -t -v "${PWD}:/opt/project" leplusorg/maven-check-versions
```

If you want to provide your own Maven distribution, you can mount it
into the Docker immage and point to it using the `MAVEN_HOME`
environment variable:

```bash
docker run --rm -t --user="$(id -u):$(id -g)" -e "MAVEN_HOME=/opt/maven/dist" -v "${HOME}/apache-maven-3.9.11:/opt/maven/dist" -v "$(pwd):/opt/project" leplusorg/maven-check-versions
```

The location of the Maven configuration and cache is controlled by the
`MAVEN_CONFIG` environment variable (default is `/opt/maven/.m2`). If
you overwrite it, make sure that your user has write permissions
for the chosen location.

## Software Bill of Materials (SBOM)

To get the SBOM for the latest image (in SPDX JSON format), use the
following command:

```bash
docker buildx imagetools inspect leplusorg/maven-check-versions --format '{{ json (index .SBOM "linux/amd64").SPDX }}'
```

Replace `linux/amd64` by the desired platform (`linux/amd64`, `linux/arm64` etc.).

## Provenance

To get the provenance for the latest image (in JSON format), use the
following command:

```bash
docker buildx imagetools inspect leplusorg/maven-check-versions --format '{{ json .Provenance }}'
```

## Sigstore

[Sigstore](https://docs.sigstore.dev) is trying to improve supply
chain security by allowing you to verify the origin of an
artifact. You can verify that the image that you use was actually
produced by this repository. This means that if you verify the
signature of the Docker image, you can trust the integrity of the
whole supply chain from code source, to CI/CD build, to distribution
on Maven Central or wherever you got the image from.

You can use the following command to verify the latest image using its
sigstore signature attestation:

```bash
cosign verify leplusorg/maven-check-versions --certificate-identity-regexp 'https://github\.com/leplusorg/docker-maven-check-versions/\.github/workflows/.+' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
```

The output should look something like this:

```text
Verification for index.docker.io/leplusorg/xml:main --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The code-signing certificate was verified using trusted certificate authority certificates

[{"critical":...
```

For instructions on how to install `cosign`, please read this [documentation](https://docs.sigstore.dev/cosign/system_config/installation/).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Security

Please read [SECURITY.md](SECURITY.md) for details on our security policy and how to report security vulnerabilities.

## Code of Conduct

Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details on our code of conduct.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
