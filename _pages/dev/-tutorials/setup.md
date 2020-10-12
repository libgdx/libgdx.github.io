---
permalink: /dev/setup/
title: "Creating a Project"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

excerpt: "Before you can get started with libGDX, you need to set up a development environment for Java."

sidebar:
  nav: "dev"
---

{% include breadcrumbs.html %}

If this is your first time using libGDX, you're at the right place. The following steps detail how you can get your fist libGDX project up and running.

{% include setup_flowchart.html current='0' %}

First off, you need an IDE (Integrated Development Environments), basically an editor for your java files, which makes developing java applications more convenient in various ways. _If you already have an IDE installed, you can skip to the next [step](/dev/project_generation/)._

The java world offers a lot of different IDEs, so feel free to choose whichever you like most:

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

Now that you have a development environment, you can create your very first libGDX project. libGDX offers a setup tool for that, which generates all the necessary files. To get started with it, take a look [here](/dev/project_generation/).
