---
permalink: /dev/from_source/
title: "From Source"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

toc: true
toc_sticky: false
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

    a) <u>Via IntelliJ/Android Studio:</u>

     - File > Open > libGDX root build.gradle
     - Import all projects
     - Wait until everything is synced and indexed
     - View > Tool Windows > Gradle, sync gradle button
     - Make sure the Gradle sync succeeds, if not resolve the issues at hand.
     - Go into preferences and turn off configure on demand
     - Try running the LwjglTestStart class located in tests/gdx-tests/gdx-tests-lwjgl/src by right clicking and running
     - You should get assets not found when you try to run a test, edit the run configuration and point it to the correct assets folder (tests/gdx-tests-android/assets)

![](/assets/images/dev/source/0.png)

  b) <u>Via Eclipse:</u> File > Import > Gradle > Gradle project

# Building
All of the other projects are hooked up and ready to test given that you have set up your system correctly, so give them a go.

Its recommended to run the android and gwt tests on command line with the following:

```
./gradlew tests:gdx-tests-android:installDebug

./gradlew tests:gdx-tests-gwt:superDev
```

To use your local changes in another project, you can install libGDX to your local maven repository by running the following command:
```
mvn install
```

This will build and install libGDX and all core components to your local maven repository with the current version declared in the pom.xml files.

# Natives
If you want to build the libGDX natives yourself, you can find [instructions](/dev/natives/) here.
