---
title: Using libGDX with other JVM languages
---
libGDX is mainly a Java-based framework. However, because Java produces Java bytecodes, and the virtual machine runs these bytecodes, it is possible to run libGDX in any JVM language with proper Java interoperability.

Some target platforms can’t run Java bytecodes directly, and so have more specific compilation requirements. Using a language other than Java may affect support for these platforms.

## Language interoperability guides

* [Clojure](http://clojure.org/java_interop)
    * [Using libGDX with Clojure](/wiki/jvm-langs/using-libgdx-with-clojure)
* [Kotlin](http://confluence.jetbrains.com/display/Kotlin/Java+interoperability)
    * [Using libGDX with Kotlin](/wiki/jvm-langs/using-libgdx-with-kotlin)
* [Scala](http://www.scala-lang.org/old/faq/4)
    * [Using libGDX with Scala](/wiki/jvm-langs/using-libgdx-with-scala)
* [Python](https://jython.readthedocs.io/en/latest/JythonAndJavaIntegration/) (Jython)
    * [Using libGDX with Python](/wiki/jvm-langs/using-libgdx-with-python)
* [Ruby](https://github.com/jruby/jruby/wiki/CallingJavaFromJRuby) (JRuby)

## Target platform compatibility

### Desktop

This works out of the box, as the desktop libGDX back-end uses the JVM that you have installed on your computer, which is most likely either OpenJDK or Oracle JDK. Both of these JVMs support polyglot code, as they run on `.class` files, not Java source code.

### Android

This works for many languages, but it is sometimes unavailable. For best results, search on your favorite search engine “[JVM language of choice] on Android”.

Some examples:

* [Lein-droid for Clojure](https://github.com/clojure-android/lein-droid/wiki/Tutorial)
* [SBT-Android for Scala](https://github.com/scala-android/sbt-android)
* [Kotlin on Android using the Kotlin plugin of IntelliJ IDEA](http://blog.jetbrains.com/kotlin/2013/08/working-with-kotlin-in-android-studio/) Kotlin has full support for Android and Java 6, with the same codebase/featureset.

### iOS-ROBOVM

The ROBOVM backend is a JVM on iOS which executes Java bytecode. This should work, but has not been tested!

### HTML/GWT

Because libGDX uses GWT, JVM languages other than Java **cannot use the HTML5 target** of libGDX. GWT [transpiles](http://en.wikipedia.org/wiki/Source-to-source_compiler) Java to JavaScript, as opposed to Java bytecode (`.class` files) to JavaScript code. There are a few reasons for this, quickly outlined by a Google employee [here](https://groups.google.com/d/msg/google-web-toolkit/SIUZRZyvEPg/OaCGAfNAzzEJ).

This could theoretically be fixed for JVM languages that have their own JavaScript back-ends, such as [Scala](https://www.scala-js.org/) and [Kotlin](https://kotlinlang.org/docs/tutorials/create-library-js.html). Your libGDX project’s build system would have to be changed to integrate with those back-ends instead of with GWT.

## Examples

Many people have used libGDX in their JVM language of choice. Here are some examples.

* [Scala](https://github.com/ajhager/libgdx-sbt-project.g8)
* [Ruby](https://github.com/kabbotta/LibGDX-and-Ruby)
* [Ruby on Android with Ruboto](https://github.com/ashes999/libgdx-ruboto)
* [Kotlin](/wiki/jvm-langs/using-libgdx-with-kotlin#examples-of-libgdx-projects-using-kotlin)

TODO (find some recent examples, would love contributions!)


## Reference

https://web.archive.org/web/20201031162718/https://www.badlogicgames.com/wordpress/?p=2750
