---
title: Updating libGDX
description: "Updting libGDX, its dependencies and the Gradle Wrapper itself is straight-forward. Start by opening up the build.gradle file in the root of your project."
---
* [**Switching libGDX Versions**](#switching-libgdx-versions)
* [**Updating Gradle Itself**](#updating-gradle-itself)

# Switching libGDX Versions
libGDX's Gradle based projects make it very easy to switch between libGDX versions. In general you'll be interested in two types of libGDX builds:

* Release builds: these are considered stable. You can see the available release versions on [Maven Central](https://search.maven.org/search?q=g:com.badlogicgames.gdx%20AND%20a:gdx).
* Nightly builds: also known as SNAPSHOT builds in Maven lingo. These are cutting edge versions of libGDX that are built on every change to the source repository. Snapshot builds also have a version number of the form `x.y.z-SNAPSHOT`, e.g. `1.9.10-SNAPSHOT`. You can find the latest SNAPSHOT version string [here](https://github.com/libgdx/libgdx/blob/master/gradle.properties#L8).

Your Gradle based project makes it very easy to switch between releases and nightly builds. Open up the `gradle.properties` file in the root of your project, and locate the following line:

```groovy
gdxVersion=1.12.1
```

The version you see may be higher than `1.12.1`. Once you've located that string, you can simply change it to the latest release (or an older release) or to the current SNAPSHOT version. You may also have to update other versions and dependencies based on the [versions listing](/dev/versions/). Once edited, save the `gradle.properties` file.

The next step is dependent on your IDE:

* **Eclipse**: Select all your projects in the package explorer, right click, then click `Gradle -> Refresh All`. This will download the libGDX version you specified in `gradle.properties` and wire up the JAR files with your projects correctly.
* **IntelliJ IDEA** / **Android Studio**: will usually detect that your `gradle.properties` has been updated and show a refresh button. Just click it and IDEA will update libGDX to the version you specified in `gradle.properties`. Go into the Gradle tasks panel/tool view and click the refresh button. Running a task like 'builddependents' also tends to do this.
* **Netbeans**: in the "Projects" view, right-click the top-most project node and select "Reload Project". All sub-projects will also be reloaded with the new files.
* **Command Line**: invoking any of the tasks will usually check for changes in dependency versions and redownload anything that changed.

## Replacing additional files

You may need to replace additional files for some releases. They are listed here:

#### Update to release 1.9.13+
Since version 1.9.13, breaking changes and corresponding migration steps are explicitly mentioned in our changelogs. Take a look at them [here](/news/changelog/).

#### Update to release 1.9.12

* HTML: You can delete the soundmanager files for HTML Project and the references in index.html
* HTML: You should update code in HTMLLauncher according to setup template

#### Update to release 1.9.6
* Replace soundmanager files for HTML project, otherwise Web Application might not start. See [#2246](https://github.com/libgdx/libgdx/pull/4426).

## Gradle Versions Plugin

In the spirit of the Maven Versions Plugin, the [Gradle Versions Plugin](https://github.com/ben-manes/gradle-versions-plugin) provides a simple `dependencyUpdates` task to determine which dependencies have updates.

# Updating Gradle Itself
You may also want to update your Gradle version.

## Gradle Wrapper
Essentially, the Gradle Wrapper (`./gradlew`) is a script that invokes a declared version of Gradle, downloading it beforehand if necessary. It is the recommended way to execute any Gradle build, because it does away with complex setups and allows any developer to get a project up and running in no time. Alternatively, you can use a system Gradle installation.

To update the Gradle Wrapper version that is embedded (and stored in your repository), you can run the following command,

```
./gradlew wrapper --gradle-version #{GRADLE_VERSION}
```

where `#{GRADLE_VERSION}` is your preferred Gradle version. We advise you to use the one specified [here](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-setup/res/com/badlogic/gdx/setup/resources/gradle/wrapper/gradle-wrapper.properties#L3) for our setup tool.

As an alternative, you can specify a Gradle distribution by URL (take a look [here](https://services.gradle.org) for official distributions):

```
./gradlew wrapper --gradle-distribution-url #{GRADLE_DISTRIBUTION_URL}
```

## Additional Steps
Since Gradle updates often introduce breaking changes, you might need to take additional steps to get your project running again after an update. Usually, we recommend just recreating your project structure with Gdx-Liftoff and then copying over your dependencies and code.  
