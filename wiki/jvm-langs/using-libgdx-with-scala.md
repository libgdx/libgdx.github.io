---
title: Using libgdx with Scala
---

Scala is a functional, object-oriented programming language for the JVM that works seamlessly with Java libraries, frameworks, and tools. It has a concise syntax and a REPL, which makes it feel like a scripting language, but it is being used in mission critical server software at companies like Twitter and LinkedIn.

Scala developers usually choose either Gradle or SBT as their build tool. This tutorial shows how to set up either of them to start using LibGDX. You may choose which one to use according to your own preferences.

*Due to how GWT works you will not be able to use the HTML5 target with Scala*

# Using libGDX and Scala with Gradle

The default build created by the gdx-setup.jar tool is the best place to start when going the Gradle route. A repo with the required modifications to the default "blank" gdx project can be found here: [gdx-scala-demo](https://github.com/LOFI/gdx-scala-demo). These changes have been outlined below.

In order to support Scala compilation you need to update the build with a couple of additions:

- <root>/gradle.properties
    - Increase the heap used by gradle (otherwise you might have trouble compiling for iOS).
- <root>/build.gradle
    - Add the Scala plugin to the `project(":core")` section: `apply plugin: "scala"`
    - In the dependencies include the scala library: `compile "org.scala-lang:scala-library:2.11.12"` (Scala 2.12.* requires java 8, but the majority of Android devices don't support it)
- <root>/core/build.gradle
    - Apply the scala plugin at the top of this file.
    - **optional** Set the src directory for scala files: `sourceSets.main.scala.srcDirs = [ "src/" ]`
- <root>/android/build.gradle
    - In the `android` section (top of the file) you need to add the following:
        ```groovy
        lintOptions {
            abortOnError false // make sure you're paying attention to the linter output!
        }

        // FIXME: How can we apply this simply for all builds? Copy-pasta makes me sad.
        buildTypes {
            release {
                minifyEnabled true
                proguardFile getDefaultProguardFile('proguard-android-optimize.txt')
                proguardFile 'proguard-project.txt'
            }
            debug {
                minifyEnabled true
                proguardFile getDefaultProguardFile('proguard-android-optimize.txt')
                proguardFile 'proguard-project.txt'
            }
        }
        ```
- <root>/android/proguard-project.txt
    - In order for Proguard to work you need to add the following lines:

        ```
        -dontwarn sun.misc.*
        -dontwarn java.lang.management.**
        -dontwarn java.beans.**
        ```
    - It might also be required to then change the line `-dontwarn com.badlogic.gdx.jnigen.BuildTarget*` to `-dontwarn com.badlogic.gdx.jnigen.*`

With all of these changes in-place you should be able to use Gradle exactly as you would otherwise from the shell or your favorite IDE.

# Using libGDX and Scala with SBT

The standard tooling for working with Scala is quite different than what Java developers will be used to. There is a project, [libgdx-sbt-project](https://github.com/ajhager/libgdx-sbt-project.g8), that provides a simple path for getting started with libGDX and Scala using standard build tools and best practices.

This tutorial assumes you have installed [sbt](https://github.com/sbt/sbt) 0.13, which are used in the Scala community for generating and interacting with projects.

## Setting up a new project

In your favourite shell type:

    $ sbt new ajhager/libgdx-sbt-project.g8

After filling in some information about your project, you can start placing your game's source files and assets in common/src/main/scala and common/src/main/resources, respectively.

**NOTICE** The setup above might not be working with iOS build. If you want to use MobiDevelop's fork of RoboVM, then one should use

1. this [fork of sbt-robovm](https://github.com/molikto/sbt-robovm), you need `sbt publish-local` this plugin yourself for now.
2. this [fork of project template](https://github.com/Darkyenus/libgdx-sbt-project.g8) and use sbt-robovm and RoboVM version 2.3.0. Then it will resolve to the plugin that get `publish-local`ed

 

## Managing your project

Update to the latest libraries:

    $ sbt
    > update 

Run the desktop project:

    > desktop/run

Package the desktop project into single jar:

    > assembly

Run the android project on a device:
  
    > android/start

Visit [android-plugin](https://github.com/jberkel/android-plugin) for a more in-depth guide to android configuration and usage.

Run the ios project on a device:

    > ios/device

Visit [sbt-robovm](https://github.com/ajhager/sbt-robovm) for a more in-depth guide to ios configuration and usage.

## Using unit tests

Run all unit tests from desktop, android and common (subdirectories src/test/scala):

    > test

Run specific set of unit tests:

    > common/test

## Using with popular IDEs

In most cases you will be able to open and edit each sub-project (like common, android or desktop), but you still need to use SBT to build the project.

See [here](https://github.com/ajhager/libgdx-sbt-project.g8/wiki/IDE-Plugins) for details about sbt plugins for each editor.

## Other resources
[Develop Games in Scala with libgdx](http://raintomorrow.cc/post/70000607238/develop-games-in-scala-with-libgdx-getting-started)
