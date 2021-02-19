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

     - File > Open > libGDX root build.gradle
     - Import all projects
     - Wait until everything is synced and indexed
     - View > Tool Windows > Gradle, sync gradle button
     - Make sure the Gradle sync succeeds, if not resolve the issues at hand.
     - Go into preferences and turn off configure on demand

    b) **Via Eclipse:** File > Import > Gradle > Gradle project

If you encounter any issues while setting up your development environment for libGDX, please join our community on [Discord](/community/discord/) to ask for help.

<br/>

# Tests
All of the projects are hooked up and ready to test given that you have set up your system correctly, so give them a go.

**LWJGL/LWJGL3:** Run the `LwjglTestStart` class located in tests/gdx-tests/gdx-tests-lwjgl/src by right clicking and running. You should get _assets not found_ when you try to run a test, so edit the run configuration and point it to the correct assets folder (`tests/gdx-tests-android/assets`). For IntelliJ:

![](/assets/images/dev/source/0.png)

**Android:** Use the following command to install the tests on the test device:
```
./gradlew tests:gdx-tests-android:installDebug
```

**GWT:** Start the test server as follows:
```
./gradlew tests:gdx-tests-gwt:superDev
```

<br/>

# Building
To use your local changes in another project, you can install libGDX to your local maven repository by running the following command:
```
mvn install
```

This will build and install libGDX and all core components to your local maven repository with the current version declared in the pom.xml files.

<br/>

# Natives
If you want to build the libGDX natives yourself, you can find [instructions](/dev/natives/) here.
