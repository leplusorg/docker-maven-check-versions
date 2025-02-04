# Maven Check Versions

Docker container to run the Maven Versions plugin.

[![Dockerfile](https://img.shields.io/badge/GitHub-Dockerfile-blue)](https://github.com/leplusorg/docker-maven-check-versions/blob/main/maven-check-versions/Dockerfile)
[![Docker Build](https://github.com/leplusorg/docker-maven-check-versions/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-maven-check-versions/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/maven-check-versions?sort=semver)](https://hub.docker.com/r/leplusorg/maven-check-versions)

## Purpose

This containers is meant to be used in CI/CD pipeline to detect when newer versions of Maven dependencies or plugins are avaible.

## Requirements

The image comes with Maven installed so it only needs a pom.xml to analyze. However if you want to control the version of Maven to be used instead, just make sure that there is a Maven wrapper script (mvnw) pointing to that version next to the pom.xml. For more information on how to install the maven wrapper in your project, see the [documentation](https://maven.apache.org/wrapper/).

The script uses the Versions plugin (more details [here](https://www.mojohaus.org/versions-maven-plugin/)). By default Maven will use the latest version of the plugin that it supports but you can set the desired version inside your pom.xml:

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
        uses: docker://leplusorg/maven-check-versions:3.9.8@sha256:83d9758a4a0626f58376924c602919f14a782aa49e5e2bfb86de1f797de16cdd
```

This way the action can be triggered manually and otherwise it runs
automatically once per week.

## GitLab

To use this container in a GitLab step, add the following step to the stage of your choice:

```yaml
maven check versions:
  image:
    name: leplusorg/maven-check-versions:3.9.8@sha256:83d9758a4a0626f58376924c602919f14a782aa49e5e2bfb86de1f797de16cdd
  script:
    - "/opt/maven-check-versions.sh"
```

## Ignoring versions

You can define which versions should be ignored using the
`IGNORED_VERSIONS` OS environment variable which will be passed to the
maven versions plugin as `maven.version.ignore` (see
<https://www.mojohaus.org/versions/versions-maven-plugin/version-rules.html#Using_the_maven.version.ignore_property>
for details). For example, you can set `IGNORED_VERSIONS` to
`(?i).+-(alpha|beta).+,(?i).+-m\\d+,(?i).+-rc\\d+` to ignore alpha,
beta, mark or release candidate versions.

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
