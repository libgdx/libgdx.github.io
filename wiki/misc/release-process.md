---
title: Release Process
---
1. Update the version strings in Java files to the next release version as illustrated in [this commit](https://github.com/libgdx/libgdx/commit/9db88c56730e9beb308858e74fa5c90f4ac9307c)
2. Create a [new release on GitHub](https://github.com/libgdx/libgdx/releases)
3. A new GitHub "Build and publish" workflow build with event "release" will be started that builds and publishes everything to SonaType and AWS. Wait for the build to finish.
4. Log into http://oss.sonatype.com (ask Mario for username:password) and do what's described at https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-8a.ReleaseIt

The credentials for SonaType are available from Mario Zechner (badlogicgames@gmail.com)
