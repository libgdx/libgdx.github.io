---
title: Updating LibGDX
---
* [**Switching libGDX Versions**](#switching-libgdx-versions)
* [**Gradle Wrapper and Updating it**](#gradle-wrapper-and-updating-it)
* [**Gradle Versions Plugin and Updating Your Dependencies**](#gradle-versions-plugin-and-updating-your-dependencies)

# Switching libGDX Versions
libGDX's Gradle based projects make it very easy to switch between libGDX versions. In general you'll be interested in two types of libGDX builds:

* Release builds: these are considered stable. You can see the available release versions on [Maven Central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.badlogicgames.gdx%22%20AND%20a%3A%22gdx%22).
* Nightly builds: also known as SNAPSHOT builds in Maven lingo. These are cutting edge versions of libGDX that are built on every change to the source repository. Snapshot builds also have a version number of the form `x.y.z-SNAPSHOT`, e.g. `1.9.10-SNAPSHOT`. You can find the latest SNAPSHOT version string [here](https://github.com/libgdx/libgdx/blob/master/gradle.properties#L8).

Your Gradle based project makes it very easy to switch between releases and nightly builds. Open up the `build.gradle` file in the root of your project, and locate the following line:

```groovy
 gdxVersion = "1.5.2"
```

The version you see will most certainly be higher than `1.5.2`. Once you've located that string, you can simply change it to the latest release (or an older release) or to the current SNAPSHOT version. You may also have to update other modules in that same section of the `build.gradle` file, based on the [versions listing](/dev/versions/). Once edited, save the `build.gradle` file. For a much easier way to update your dependencies (automatically find the newest version of each), see [Gradle versions plugin](#gradle-versions-plugin-and-updating-your-dependencies).

The next step is dependent on your IDE:

* **Eclipse**: Select all your projects in the package explorer, right click, then click `Gradle -> Refresh All`. This will download the libGDX version you specified in `build.gradle` and wire up the JAR files with your projects correctly.
* **Intellij IDEA**: will usually detect that your `build.gradle` has been updated and show a refresh button. Just click it and IDEA will update libGDX to the version you specified in `build.gradle`. Go into the gradle tasks panel/tool view and click the refresh button. Running a task like 'builddependents' also tends to do this.
* **Netbeans**: in the "Projects" view, right-click the top-most project node and select "Reload Project".  All sub-projects will also be reloaded with the new files.
* **Command Line**: invoking any of the tasks will usually check for changes in dependency versions and redownload anything that changed.

### Replacing additional files

You may need to replace additional files for some releases. They are listed here:

#### Update to release 1.9.13+
Since version 1.9.13, breaking changes and corresponding migration steps are explicitly mentioned in our changelogs. Take a look at them [here](/news/changelog/).

#### Update to release 1.9.12

* HTML: You can delete the soundmanager files for HTML Project and the references in index.html
* HTML: You should update code in HTMLLauncher according to setup template

#### Update to release 1.9.6
* Replace soundmanager files for HTML project, otherwise Web Application might not start. See [#2246](https://github.com/libgdx/libgdx/pull/4426).

## Gradle Wrapper and Updating It
Essentially, the gradle wrapper (`./gradlew`) is pretty standard for Gradle projects. You don't have to use it and can use a system Gradle installation. But basically, it's a very lightweight wrapper which will download the version of gradle you want into the project dir. This means that anyone can just clone your code, run `./gradlew` and it will automatically download said version of Gradle. No need for complex setup, etc.

Though, gradle releases new versions quite steadily, so over the months/years, the version that is embedded (and stored in your repository), is old. You can just run following command line:

```
./gradlew wrapper --gradle-version #{GRADLE_VERSION}
```

Or if you want to specify a Gradle distribution by URL(find official distributions [here](https://services.gradle.org)):

```
./gradlew wrapper --gradle-distribution-url #{GRADLE_DISTRIBUTION_URL}
```

To upgrade your Gradle wrapper.


## Gradle Versions Plugin And Updating Your Dependencies

If you're used to Maven, you are probably familiar with this already. The Gradle versions plugin allows one to run `gradle dependencyUpdates` and it will return a list of dependencies you are using that need updating, and what the newest version is (configurable). The output can either be text/stdout, json, xml, etc.

For more info, see: https://github.com/ben-manes/gradle-versions-plugin
