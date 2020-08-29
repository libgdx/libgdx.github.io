---
permalink: /dev/setup/
title: "Setup"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"
  actions:
    - label: "Download gdx-liftoff"
      url: "https://github.com/tommyettinger/gdx-liftoff/releases"

excerpt: "libGDX offers a community-made setup tool, which automatically creates a project and downloads everything necessary."

toc: true
toc_sticky: false

---

{% include breadcrumbs.html %}

If this is your first time using libGDX, you're at the right place. The following article details how you can get your fist libGDX project up and running.

# I. Getting a Proper Development Environment
First off, you need an IDE (Integrated Development Environments), basically an editor for your java files, which makes developing java applications more convenient in various ways. The java world offers a lot of different IDEs, so feel free to choose whichever you like most:

## (1.) IDEA
- [JDK 8+](https://adoptopenjdk.net)
- IDE itself: [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=windows) (community edition is sufficient)
- For Android: [Android SDK](https://developer.android.com/studio/releases/platform-tools)
- For iOS: [RoboVM OSS Intellij plugin](http://robovm.mobidevelop.com)

## (2.) Android Studio
- IDE itself: [Android Studio](https://developer.android.com/studio)
- Android: is offered out-of-the-box
- For iOS: [RoboVM OSS Intellij plugin](http://robovm.mobidevelop.com)

## (3.) Eclipse
- [JDK 8+](https://adoptopenjdk.net)
- IDE itself: [Eclipse](https://www.eclipse.org/downloads/)
- Android: not officially supported.
- For iOS: [RobovmOSS Eclipse plugin](http://robovm.mobidevelop.com)

## (4.) Netbeans
- [JDK 8+](https://adoptopenjdk.net)
- IDE itself: [Netbeans](https://netbeans.apache.org/download/index.html)
- Android: not officially supported.
- iOS: not officially supported.

## (5.) No IDE = Commandline
- [JDK 8+](https://adoptopenjdk.net)
- For Android: [Android SDK](https://developer.android.com/studio/releases/platform-tools)
- Set the ANDROID_HOME environment variable, or use gradle.properties

<br/>

# II. Creating a New Project
To setup your first project and download the necessary dependencies, libGDX offers a setup tool. See [here](https://github.com/libgdx/libgdx/wiki/Project-Setup-Gradle) on how to use it.

<br/>

# III. Finishing the project generation
Click generate. Now you'll have a project all set up with a sample.

<br/>

# IV. Importing the Project
Lastly, you need to import your project into your IDE.

In **IntelliJ IDEA or Android Studio**, you can choose to open the `build.gradle` file and select "Open as Project" to get started. In **Eclipse**, choose `File -> Import -> Gradle`, in Netbeans `File -> Open Project`.

You may need to refresh the Gradle project after the initial import, if some dependencies weren't downloaded yet. In **IntelliJ IDEA/Android Studio**, the `Reimport all Gradle projects` button is a pair of circling arrows in the Gradle tool window, which can be opened with `View -> Tool Windows -> Gradle`. In **Eclipse** right click on your project `Gradle -> Refresh Gradle Project`.

Now you can focus on getting your project [running](/dev/running/).
