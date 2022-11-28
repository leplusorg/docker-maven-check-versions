# Maven Check Versions

Docker container to run the Maven Versions plugin.

[![Docker Build](https://github.com/leplusorg/docker-maven-check-versions/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-maven-check-versions/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Build](https://img.shields.io/docker/cloud/build/leplusorg/maven-check-versions)](https://hub.docker.com/r/leplusorg/maven-check-versions)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/maven-check-versions?sort=semver)](https://hub.docker.com/r/leplusorg/maven-check-versions)

## Purpose

This containers is meant to be used in CI/CD pipeline to detect when newer versions of Maven dependencies or plugins are avaible.

## Requirements

Your project must use the Maven wrapper (i.e. the mvnw script must be present at the root of your project). For more information on how to install the maven wrapper in your project, see the [documentation](https://maven.apache.org/wrapper/).

The script uses the Versions plugin (more details [here](https://www.mojohaus.org/versions-maven-plugin/)).

## GitHub

To use this container in a GitHub worklow, add the following action file `.github/workflows/maven-check-versions.yml` to your project:

```yaml
---
name: Maven Check Versions

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    container:
      image: leplusorg/maven-check-versions:latest
    steps:
      - uses: actions/checkout@v3
      - name: Check the versions
        run: /opt/maven-check-versions.sh
```

## GitLab

To use this container in a GitLab step, add the following step to the stage of your choice:

```yaml
maven check versions:
  image:
    name: leplusorg/maven-check-versions:latest
  script:
    - '/opt/maven-check-versions.sh'
```
