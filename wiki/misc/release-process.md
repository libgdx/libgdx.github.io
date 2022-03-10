---
title: Release Process
# Not listed in ToC
---
**Note:** This page is outdated and needs to be updated!
{: .notice--danger}

2. Setup pgp keys and settings.xml for Maven release, ask Mario
1. Disable the libGDX project on the build server
3. pull in the latest changes into your local libGDX repository
4. pull in the latest nightlies via `ant -f fetch.xml`
1. Make sure Version.java has the release version in it
10. Modify DependencyBank.java, update the libGDX version (and snapshot version) to the latest (must match Version.java),
5. `mvn release:clean`, this should print `BUILD SUCCESSFUL`, if not, you've done something wrong
6. `mvn release:prepare -DdryRun=true` to test the prepare, see http://www.jroller.com/robertburrelldonkin/entry/apache_using_dry_run_with
7. `mvn release:prepare`, enter the release version number, then make sure the new snapshot version is x.y.z+1 or x.y+1.0 if you released an API breaking change
8. `mvn release:perform`, pray that everything works
9. Log into http://oss.sonatype.com (ask Mario for username:password) and do what's described at https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-8a.ReleaseIt
11. Enable the libGDX project on the build server and wait for the libGDX to finish (this will also updated gdx-setup.jar on the server, which will use the latest libGDX version we just deployed to sonatype/maven central)
12. Download nightly, rename to libgdx-x.y.z, upload to website /usr/share/nginx/html/releases
13. Increase the libGDX version in Version.java to match the new snapshot version
14. **Update the latest libGDX release version in forum for user registration**

### If something fails
#### If `mvn release:prepare` fails
Fix the issue! Do not continue. If you do, you'll be in for a world of pain.

Issue #1: Javadoc for an artifact wasn't build
box2d-GWT had no source files in the src/ directory, only in the emulation directory. In such cases, place a dummy class in the src/ directory.

#### If `mvn release:perform` or closing and releasing the staging repository on Sonatype fails
Great, now you have a tag in Git and the versions in your pom.xml files are all kinds of fucked up! Do this:

1. Open all pom.xml files (`find . | grep pom.xml` for a list) and change the versions from x.y.z-SNAPSHOT xold.yold.zold-SNAPSHOT. E.g. if you failed to release 1.0.0, set the versions to 1.0.0-SNAPSHOT, just like before the release. You'll only have to change the version of the root pom.xml, and the versions specified for the parent in the other pom.xml files.
2. `git tag -d x.y.z`, `git push origin :x.y.z` to kill the motherfucking tag in the master repository
3. Drop the staging repository on SonaType if necessary
4. Start from the beginning, good luck
