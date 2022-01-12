---
title: Java Development Kit   Selection
---
 * [Introduction](#introduction)
 * [Background](#background)
 * [Distributions](#distributions)
 * [Versions](#versions)
 

Caveat: At the release of this wiki page, Java 15 is the current released Java Development Kit (JDK).

# Introduction #
Every project will require the use of at least one Java Development Kit (JDK). This is the source, root, or core 
of the code that will be used in each project. It may be a quick decision to just select the most recent JDK, though
this might end in frustration and confusion during the build process. This wiki will review the different JDK versions
and distributions. Yes, even distributions are different! Distributions are provided by various companies and
may contain additional features from the root JDK. The wiki page objective is to remove any confusion about
which version or distribution to use.


# Background #
#### Distribution
Various distributions from vendors existed prior to [Oracle](https://www.oracle.com/index.html) changing its licensing 
structure and were used for various reasons, such as using variation(s) of the Java Virtual Machine (JVM) for 
performance. So what does this mean for you as a developer for yourself or your company? Well we have good news 
about which JDK to choose. Free open source distributions exist for commercial use. These will be listed in 
[Distributions](#distributions).

* [Oracle - JDK Licensing - FAQs](https://www.oracle.com/java/technologies/javase/jdk-faqs.html) 
* [Lakesidesoftware - Article - 2019](https://www.lakesidesoftware.com/blog/java-did-what-understanding-how-2019-java-licensing-changes-impact-you)
* [Aspera - Article - 2019](https://www.aspera.com/en/blog/oracle-will-charge-for-java-starting-in-2019/)



#### Version
With the change of the licensing model [Oracle](https://www.oracle.com/index.html) also updated their release pipeline
to include regular feature updates at a faster rate. The overall goal of the JDK development team is to move 
forward with the bigger Java Enhancement Proposals (JEPs) ([Valhalla](http://openjdk.java.net/projects/valhalla/),
 [Panama](http://openjdk.java.net/projects/panama/)) by working out the foundational JEPs. Some smaller but related
 features that are foundational to the bigger JEPs are ([Records](https://openjdk.java.net/jeps/384), 
 [Sealed Classes](https://openjdk.java.net/jeps/360)) will be released in between the major features.
 
* [All JEPs](https://openjdk.java.net/jeps/0)


# Versions #
Since each platform that Java works on is different the code; translation may leaves features out or may not be capable
of being emulated from the desktop to mobile or web. Thus, if developing on a specific platform, you
may not have much of a choice on which Java versions. As a developer you may also be faced with having to use multiple
JDKs to support the features and/or debugging capabilities required by the project. Most of the versions listed 
will be Long Term Supported (LTS). Hot swapping code is a feature that allows one to compile and swap code
during runtime debugging. This feature enhanced by using Dynamic Code Execution Virtual Machine (DCEVM). This is 
technically a separate distribution [DCEVM](http://dcevm.github.io/). Some developers will use JDK 8 for language
compatibility, JDK 11 for DCEVM and JDK 14 for packaging.

Note: LTS (Long Term Support)

| Version  | Desktop  | Android  | iOS   | HTML | DCEVM | ARM |Notes |
|:---:     |:---:     |:---:     |:---:  |:---: |:---:  |:---:|:---  |
| 7        |  X       |  X       | X     | X    | X     |     |
| 8        |  X       |  X       | X     | X    | X     |     | LTS - Most compatible
| 9        |  X       |          |       | X    |       |     | Modules - Oracle Licensing Changed
| 11       |  X       |          |       | X    | X     |     | LTS & HTML Support with 3rd Party Backend
| 15       |  X       |          |       |      |       |     | JPackage
| 16       |          |          |       |      |       |     | TBD - March - Sept 2021
| 17       |          |          |       |      |       |     | TBD - Sept 2021 - ? (LTS)

Of these versions it is recommended to use LTS versions & distributions. This way any issues that arise in the 
JDK will be fixed or supported by the companies involved in the JDK maintenance.

# Distributions # 
JDKs Distribution info can be found here [sdkman.io - JDKs](https://sdkman.io/jdks).
