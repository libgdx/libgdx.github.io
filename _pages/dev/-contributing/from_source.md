---
permalink: /dev/from-source/
redirect_from:
  - /dev/from_source/
title: "From Source"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

sidebar:
  nav: "dev"
---

{% include breadcrumbs.html %}

# Setting the Project Up
If you want to work on the code of libGDX itself, you need to get it set up on your local machine. For this, Android Studio is strongly recommended as IDE!

If you want to submit code back to the project, please also take a moment to review our [guidelines](/dev/contributing/).

1. Fork libGDX and clone the repo:
```
git clone git://github.com/libgdx/libgdx.git
cd libgdx
```
2. Fetch the native binaries, which were built on the snapshot build server. Even if you plan on building natives later yourself, it's recommended to bring these down so you can test your development environment is setup correctly before moving to the next step.
```
./gradlew fetchNatives
```
3. Importing the project:

    a) **Via IntelliJ/Android Studio:**

     - File -> Open -> libGDX root `build.gradle`
     - Import all projects
     - Wait until everything is synced and indexed
     - View -> Tool Windows -> Gradle, sync gradle button
     - Make sure the Gradle sync succeeds, if not resolve the issues at hand.
     - Go into preferences and turn off configure on demand

    b) **Via Eclipse:** File -> Import -> Gradle -> Gradle project

     If you don't want to use Gradle in Eclipse, executing `./gradlew cleanEclipse eclipse` will generate the necessary project files.

If you encounter any issues while setting up your development environment for libGDX, please join our community on [Discord](/community/discord/) to ask for help.

<br/>

# Tests
If you set everything up correctly, you can try to give the libGDX tests a go.

**LWJGL/LWJGL3:** Run the `LwjglTestStart` class located in tests/gdx-tests/gdx-tests-lwjgl/src (or tests/gdx-tests/gdx-tests-lwjgl3/src respectively) by right clicking and running. You should get _assets not found_ when you try to run a test, so edit the run configuration and point it to the correct assets folder (`tests/gdx-tests-android/assets`). For IntelliJ:

![](/assets/images/dev/source/0.png)

You can directly run individual tests and/or configure the test starter by setting its program arguments: `[options] [Test class name]`, possible options being:

- `--gl30` enable GLES 3 with core profile 3.2 (default is GLES 2.0)
- `--glErrors` enable GLProfiler and log any GL errors (default is disabled)

**Android:** Use the following command to install the tests on the test device:
```
./gradlew tests:gdx-tests-android:installDebug
```

**GWT:** To access the tests at [`http://localhost:8080/index.html`](http://localhost:8080/index.html), start a local server as follows:
```
./gradlew tests:gdx-tests-gwt:superDev
```

<br/>

# Building
To use your local changes in another project, you can install libGDX to your local maven repository by running the following command:
```
./gradlew publishToMavenLocal
```

This will build and install libGDX and all core components to your local maven repository with the current version declared in the gradle.properties file. If you are working with an older branch of libGDX, try `mvn install` instead.

<br/>

# Natives
If you want to build the libGDX natives yourself, you can find [instructions](/dev/natives/) here.
