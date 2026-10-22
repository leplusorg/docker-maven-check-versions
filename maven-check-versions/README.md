# maven-check-versions image

Build context for the `leplusorg/maven-check-versions` container image. See the
[root readme](../README.md) for what the image does and how to run it.

## Files

- `Dockerfile` — the image definition, based on the official `maven` image. It
  installs `maven-check-versions.sh` as the entrypoint and runs it from
  `/opt/project`.
- `docker-compose.test.yml` — the smoke test run in CI against the built image:
  the `sut` service checks that the container runs as the non-root user (UID
  1000), then runs the script on a minimal `pom.xml`.
- `maven-check-versions.sh` — the entrypoint. It runs the Versions Maven Plugin
  (`display-dependency-updates`, `display-plugin-updates`,
  `display-property-updates`) on the project in the working directory, using the
  project's Maven wrapper if it has one, and exits with a non-zero code if any
  update is available or an error occurs.

This image has no package manifest: everything in it comes from the `maven` base
image.
