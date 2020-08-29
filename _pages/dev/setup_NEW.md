---
permalink: /dev/setup2/
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

excerpt: "LibGDX offers a community-made setup tool, which automatically creates a project and downloads everything necessary."

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
To setup your first project and download the necessary dependencies, libGDX offers a community-made setup tool. You can download the setup tool on the [gdx-liftoff page](https://github.com/tommyettinger/gdx-liftoff/releases). Run the downloaded JAR file, either by double clicking or via the command line: `java -jar gdx-liftoff.jar`.

## Different platforms:
Then, plug in whatever options you see fit:
- **Desktop and/or LWJGL3** should usually be checked, so you can test on the same computer you develop on.
  - LWJGL3 is almost the same as Desktop, but because it has better support for new hardware (such as high-DPI displays), it should probably be preferred. It also allows multiple windows and drag+drop.
  - Desktop should mostly be preferred if you need to also depend on gdx-tools, such as if you need to run the texture packer at runtime. Some machines have issues with an inconsistent or very high framerate with LWJGL3, and using the "Legacy" desktop can fix that.
- **iOS** should not be checked if you aren't running MacOS (as it won't run elsewhere) and you don't intend to later build an iOS app on a Mac. It needs some large dependencies to be downloaded when you first import the project.
- **Android** should only be checked if you've set up your computer for Android development.
- **HTML** is a more-involved target, with some perfectly-normal code on all other platforms acting completely different on HTML due to the tool used, Google Web Toolkit (GWT). See [this small guide to GWT](https://github.com/libgdx/libgdx/wiki/HTML5-Backend-and-GWT-Specifics) for more information. However, it's very likely that you won't notice any difference at all, unless you try to make behavior identical on GWT and other platforms, and even then there may be nothing apparent.
  - GWT 2.9.0 is available but doesn't integrate with libGDX by default; there's a third-party [replacement to the official GWT backend](https://github.com/tommyettinger/gdx-backends#19112) that supports it with libGDX 1.9.11. Using GWT 2.9.0 allows Java 11's `var` keyword to be used, plus other Java 11 features, but doesn't change much of what's available from the standard library.

If you aren't interested in any extensions, etc. you can skip the next few subsections.

## Non-Java JVM Languages
- For dependencies, you don't need LibGDX checked (the tool is ready to download LibGDX and set it as a dependency in all cases).
- There are options to add language support for **non-Java JVM languages**; of these, Kotlin is the best-supported.
  - The HTML target won't work with non-Java languages, and others targets may be questionable.
  - Kotlin should work well on Android, Desktop (LWJGL2) and LWJGL3, and will probably work well on iOS.
  - Some third-party extensions only work with Kotlin, lke the KTX libraries.
  - Scala and Groovy should definitely work on Desktop and LWJGL3, and may work on Android and iOS.
  - Clojure may technically work on Android but is usually incredibly slow without extra steps for Android compatibility; it's doubtful if it would work on iOS. You probably shouldn't use Gradle to build Clojure projects anyway; it has its own (excellent) project manager `lein` and a simple built-in manager.

## Templates, Extensions, etc.
- In the **Templates** tab, you can select various sets of starting code that gdx-liftoff will generate in your new project. _Classic_ will show a white screen with a pixel-style face when you run, so it can be good to verify that a project works, while _ApplicationAdapter_ is probably the easiest to bring an existing game into.
- In **Advanced**, you can set the libGDX version (it defaults to 1.9.11, but can be set lower or higher) and various other versions, including the default Java compatibility. Typically, `Java version` is the minimum across all platforms, and should be 7 or more (8 is generally safe). You can set `Desktop Java version` to any version at least equal to `Java version`, and similarly for `Server Java version`; these only affect the Desktop/LWJGL3 and Server modules, respectively. You can set `Java version` to 14 if you have Java 14 installed, but it will require users to also have Java 14 or for you to distribute a Java 14 JRE with your game.
  - Distributing Java 14 is much easier now thanks to Beryx' "[Badass Runtime Plugin](https://github.com/raeleus/skin-composer/wiki/Deploying-libGDX-with-jpackage-and-Badass-Runtime),"  which may be included in future versions to help ease the process of releasing a game.

<br/>

# III. Finishing the project generation
Click generate, and very soon a window should pop up with instructions for what to do. (Generation is very fast here.) Now you'll have a project all set up with a sample.

<br/>

# IV. Importing the Project
Lastly, you need to import your project into your IDE.

In **IntelliJ IDEA or Android Studio**, you can choose to open the `build.gradle` file and select "Open as Project" to get started. In **Eclipse**, choose `File -> Import -> Gradle`, in Netbeans `File -> Open Project`.

You may need to refresh the Gradle project after the initial import, if some dependencies weren't downloaded yet. In **IntelliJ IDEA/Android Studio**, the `Reimport all Gradle projects` button is a pair of circling arrows in the Gradle tool window, which can be opened with `View -> Tool Windows -> Gradle`. In **Eclipse** right click on your project `Gradle -> Refresh Gradle Project`.

Now you can focus on getting your project [running](/dev/running/).
