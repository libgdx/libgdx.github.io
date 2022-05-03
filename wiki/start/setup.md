---
title: "Set Up a Dev Env"
description: "Before you can get your first libGDX project up and running, you need to set up your development environment. The first step in doing this is choosing an IDE: Android Studio, IntelliJ IDEA or Eclipse are among the most common choices for this."
redirect_from:
  - /dev/setup/
---

If this is your first time using libGDX, you're at the right place. The following steps detail how you can get your first libGDX project up and running.

{% include setup_flowchart.html current='0' %}

Before you can get started with libGDX, you need to set up an IDE (Integrated Development Environment). It is basically an editor for your java files, which makes developing java applications considerably more convenient in various ways. **If you already have an IDE installed, you can skip to the next [step](/wiki/start/project-generation).**

The java world offers a lot of different IDEs. All of them will have minor advantages and disadvantages, but in the end they all do their job, so feel free to choose whichever you like most.

## (1.) Android Studio
For newcomers wanting to not only target desktop, but mobile platforms as well, **we recommend Android Studio**.
{: .notice--info}

- JDK: is provided by Android Studio
- IDE itself: [Android Studio](https://developer.android.com/studio)
- Android: is offered out-of-the-box
- For iOS: [RoboVM OSS IntelliJ plugin](http://robovm.mobidevelop.com)

## (2.) IDEA
- JDK 8+: there are different distributions, but [Adoptium](https://adoptium.net/) should fit your needs

   Since Gradle does <u>not</u> support JDK 18 yet, libGDX projects will not work with it either. As a consequence, you are advised to use **JDK 8-17**!
   {: .notice--warning}
- IDE itself: [IntelliJ IDEA](https://www.jetbrains.com/idea/download/) (the "Community" edition is sufficient)
- For Android: [Android SDK](https://developer.android.com/studio/releases/platform-tools)
- For iOS: [RoboVM OSS IntelliJ plugin](http://robovm.mobidevelop.com)

## (3.) Eclipse
- JDK 8+: there are different distributions, but [Adoptium](https://adoptium.net/) should fit your needs

   Since Gradle does <u>not</u> support JDK 18 yet, libGDX projects will not work with it either. As a consequence, you are advised to use **JDK 8-17**!
   {: .notice--warning}
- IDE itself: [Eclipse](https://www.eclipse.org/downloads/)
- Android: not officially supported, but you may have success with [Andmore](https://projects.eclipse.org/projects/tools.andmore) or tinkering around with an older [ADT](https://marketplace.eclipse.org/content/android-development-tools-eclipse) version
- For iOS: [RoboVM OSS Eclipse plugin](http://robovm.mobidevelop.com)

## (4.) Other IDEs
Of course you can also use any other IDE for Java, e.g. NetBeans, Visual Studio Code or even AIDE. However, as those are not commonly used in the libGDX community, it may prove difficult to get any help if IDE-specific issues arise!
{: .notice--info}
- [NetBeans](https://netbeans.apache.org/download/index.html) requires the NetBeans Gradle Plugin; Android and iOS are not officially supported
- Visual Studio Code requires extensions to support Java; see the [Coding Pack for Java](https://code.visualstudio.com/docs/java/java-tutorial#_coding-pack-for-java); Android and iOS are not officially supported
- [AIDE](https://play.google.com/store/apps/details?id=com.aide.ui) does only support Android development; libGDX's JAR files can be found [here](https://repo1.maven.org/maven2/com/badlogicgames/gdx/)

## (5.) No IDE
It is also possible to develop libGDX applications entirely without any IDE, just using a simple editor like Notepad or [Vim](https://www.vim.org). This is **not** recommended, because IDEs provide some very convenient features, such as code completion and error checking. However, if you insist on doing so: libGDX applications are Gradle applications, so they can be built and executed via the commandline.
{: .notice--info}

- JDK 8+: there are different distributions, but [Adoptium](https://adoptium.net/) should fit your needs

   Since Gradle does <u>not</u> support JDK 18 yet, libGDX projects will not work with it either. As a consequence, you are advised to use **JDK 8-17**!
   {: .notice--warning}
- For Android: [Android SDK](https://developer.android.com/studio/releases/platform-tools)
- Set the ANDROID_HOME environment variable, or use gradle.properties

<br/>

**Now that you have a development environment, you can create your very first libGDX project. libGDX offers a setup tool for that, which generates all the necessary files. To get started with it, take a look [here](/wiki/start/project-generation).**
