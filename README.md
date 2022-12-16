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
