---
title: Using libGDX with Kotlin
---
[Kotlin](https://kotlinlang.org) is a modern statically typed JVM language from [JetBrains](https://www.jetbrains.com), the creators of [IntelliJ IDEA](https://www.jetbrains.com/idea/) (Kotlin supports Eclipse too). If you’re a C# user or appreciate its features, you will feel more at home as Kotlin has many features C# has.

Due to how GWT works, you will not be able to use the HTML5 target with Kotlin. [TeaVM](https://github.com/konsoletyper/teavm) is a replacement for GWT that allows for Kotlin source files. [libGDX support](https://github.com/xpenatan/gdx-teavm) is a work-in-progress, however it builds and can make functional games for the web. You can enable it through the platforms menu in Gdx-Liftoff.

# About the Kotlin language

Notable features:

* Null-safe types (more compile-time errors instead of always runtime ones)
* Higher-order functions
* Lambdas that work well (closures, which Java doesn’t really have)
* Cleaner syntax than Java (semi-colons are optional; `new` keyword isn't there, because it’s unnecessary)
* Extension functions (like C# has), so you can extend with static methods and create e.g. `"a string".myCustomFunction()`
* String interpolation: `println("size is ${list.size} out of $maxElements")`
* Operator overloading
* Target Java 6 transparently, without the same loss of features like you get in Java. This makes it especially attractive for Android.
* 100% interoperable with your Java libraries, and even other Java source files in your project. Seamlessly. Has a button to convert existing Java code to Kotlin too.
* Properties - no need to write boilerplate getters and setters
* Ranges and range operator: `if (x in 0..10) println("in range!")`
* Inlined methods, which make it possible to reduce method counts, as well as optimize methods using lambdas
* And more - see language reference docs.

It also does not force much of anything upon you like some other languages. That is, you can create Kotlin code that is much like the same Java code (without lambdas, no higher order functions, same class/OOP design, etc). It’s a more pragmatic language, rather than academic/forceful.

See the [Kotlin Language Reference Docs](https://kotlinlang.org/docs/reference/) for deciding on and learning the language. You can also read the [Kotlin comparison to Java](https://kotlinlang.org/docs/reference/comparison-to-java.html).

# Migrating an existing project to Kotlin

This guide describes how to migrate an existing libGDX project to Kotlin. You can also start with a [fresh application](https://libgdx.com/dev/project-generation/).

* [Configure Gradle](#configure-gradle)
  * [Setup the Kotlin Gradle plugin](#set-up-the-kotlin-gradle-plugin)
  * [Apply the Kotlin Gradle Plugin](#apply-the-kotlin-gradle-plugin)
  * [Configuring Dependencies](#configuring-dependencies)
* [Convert Your Code From Java to Kotlin](#convert-your-code-from-java-to-kotlin)
* [Build and Run](#build-and-run)
* [Examples of libGDX projects using Kotlin](#examples-of-libgdx-projects-using-kotlin)

## Configure Gradle

UPDATE: Gdx-Liftoff has an option to enable Kotlin support in new projects and will handle most of the configuration for you. These instructions remain for posterity.
{: .notice--warning}

This step basically includes following the [instructions from the official Kotlin manual](https://kotlinlang.org/docs/reference/using-gradle.html).

### Set up the kotlin-gradle plugin

Add the following to your parent project’s `build.gradle`:

```Groovy
buildscript {
    ext.kotlinVersion = '<version to use>'

    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion"
    }
}
```

Since most likely you already got the `buildscript` block in your Gradle config, make sure to only add the sub-items accordingly.

### Apply the kotlin-gradle plugin

Replace all occurrences of `apply plugin: "java"` with `apply plugin: "kotlin"`. Check your parent project's `build.gradle` as well as your sub-projects (core, desktop, ios, android).

In the android sub-project, add `apply plugin: "kotlin-android"` after the `apply plugin: "android"` line.

### Configuring Dependencies

Add Kotlin’s stdlib to your core project's dependencies list:

```Groovy
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlinVersion"
}
```

If you intend to use Kotlin’s reflection capabilities as well, add the respective library too:

```Kotlin
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-reflect:$kotlinVersion"
}
```

#### Note for IntelliJ IDEA users

If you made IntelliJ IDEA automatically configure `build.gradle` for you, and chose Kotlin 1.1 or higher version, it might add this dependency:

```Kotlin
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jre8:$kotlinVersion"
}
```

If you're targeting platforms that don't support Java 8 library, such as most Android phones, it won't compile. You may need to replace it with `kotlin-stdlib` library.

## Convert your code from Java to Kotlin

You do not need to migrate all or any of your Java code right away. Both languages are fully interoperable with each other.

However, if you decide to migrate your Java code to Kotlin, IntelliJ IDEA has a handy function for that.

Open any Java file, e.g. your `DesktopLauncher` and select *Code → Convert Java File to Kotlin File* from the menu. Repeat this process for every file you want to migrate. While it is still in its infancy so it won't be error proof, but it will help you come up with more idiomatic ways of coding your project. There will be some errors, specifically with some `Class<>` usage, and Java code that it could not deduce null safety (because that information is lacking from Java).

## Build and run

That’s it. You successfully enabled Kotlin in your libGDX application. Build and run your project to verify that everything works.

## Kotlin libGDX extensions

- [KTX](https://github.com/libktx/ktx) is a set of libraries that aim to make most aspects of libGDX more Kotlin-friendly thanks to extension functions, utility classes and so on. It includes utilities for assets management, LibGDX custom collections, Box2D, coroutines, math-related classes, actors, i18n, dependency injection, GUI type-safe building and more.

# Examples of libGDX projects using Kotlin

These are some examples of projects that are using Kotlin, to help give you ideas on how to structure, take advantage of language features, as well as simple stuff such as build system.

* [Ore Infinium](https://github.com/sreich/ore-infinium) (desktop, moderate size, uses artemis-odb, kryonet, ktx, protobuf)
* [HitKlack](https://github.com/TobseF/hitklack) (desktop & android, small size, code examples to explain Kotlin's features)
* [SplinterSweets](https://github.com/reime005/splintersweets) (desktop, android, iOS (Multi-OS Engine), Google Play Games and Admob integration, small sized and simple)
* [Herring.io](https://github.com/czyzby/egu2016), [Neighbourhood Watch](https://github.com/czyzby/egu-2016) (desktop, made by a single team in under 30 hours using [KTX](https://github.com/libktx/ktx) on _EGU Jam 2016_)
* [Horde!](https://github.com/czyzby/bialjam17) (desktop, made in under 40 hours, won BialJam 2017) 
* [BlockBunny](https://github.com/haxpor/blockbunny) (desktop (with controller support), android, iOS (Multi-OS Engine) / with optimization, changes and improvement from original ForeignGuyMike's tutorial video)
* [OMO](https://github.com/haxpor/omo) (PC, Android, and iOS (Multi-OS Engine) / with changes and improvements on top of ForeignGuyMike's original project)
* [Asteroids](https://github.com/haxpor/asteroids) (PC, Android, and iOS (Multi-OS Engine) / gamepad support, with changes and improvements on top of ForeignGuyMike's original project)
* [Unciv](https://github.com/yairm210/Unciv) (PC, Android / Open-source Android/Desktop remake of Civ V)
