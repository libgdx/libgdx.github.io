---
title: Bundling a JRE
---
Java apps need a Java Runtime Environment to run. Typically this is installed by the user and hopefully already available when they go to run your app. Unfortunately users may not have Java installed and there are differences between JREs that can cause problems with your app. These can be difficult for users to explain and worse, difficult for them to fix themselves. Also, you may require, as a minimum, a certain JRE version.

The solution is to bundle a JRE with your app. This way you know exactly what users will be running and users will have fewer problems and they will not have to install a JVM.

## Packaging
There are a number of tools available for bundling a JRE:

### [Construo](https://github.com/fourlastor-alexandria/construo?tab=readme-ov-file#construo)
The modern way to minimize and package your libGDX apps for deployment on Windows, Linux, and Mac. Simply call the corresponding gradle command for the target platform. These commands can be called from any OS:

**Mac M1** lwjgl3:packageMacM1<br>
**Mac OSX** lwjgl3:packageMacX64<br>
**Linux** lwjgl3:packageLinuxX64<br>
**Windows** lwjgl3:packageWinX64<br>

This creates a zip file in `lwjgl3/build/construo/dist` containing your game and the minimized JRE for the target platform. See [this section](https://www.youtube.com/watch?v=VF6N_X_oWr0&t=1088s) in the GDX-Liftoff video.

### [Graal Native Image](https://www.graalvm.org/latest/reference-manual/native-image/)
Graal Native Image is a way to compile Java code ahead-of-time to create a native executable. This differs from other techniques requiring you to bundle a Java JRE with your game. Native executables are much smaller and require less resources to run, starting up almost instantaneously. To enable it you must set the following in your gradle.properties file:

```
enableGraalNative=true
```

You must also have a Graal JDK installed. Please note that there is a higher burden regarding reflection/resource use and it is not expected to work out of the box. For more information take a look at the [official docs](https://graalvm.github.io/native-build-tools/latest/gradle-plugin.html)

### [Packr](https://github.com/libgdx/packr)
A packaging tool created and maintained by the libGDX team. Take a look at the [repository](https://github.com/libgdx/packr#usage) if you are interested in using it.

### [Parcl](https://github.com/mini2Dx/parcl)
A Gradle plugin that performs similar actions as launch4j. See its [README](https://github.com/mini2Dx/parcl#how-to-use) for instructions.

### [jpackage](https://docs.oracle.com/en/java/javase/14/jpackage/packaging-overview.html#GUID-C1027043-587D-418D-8188-EF8F44A4C06A)

Jpackage is a tool to provide native packaging options on Windows, MacOS and Linux introduced with [JEP-343](https://openjdk.java.net/jeps/343). It can be used to create an EXE that starts your bundled application via an embedded JRE. A significant downside is that it must be run directly on the target platforms (Windows, Linux, Mac) in order to create executables specific to those users.

See [this guide](https://github.com/raeleus/skin-composer/wiki/libGDX-and-JPackage) for more information on how to use it. A video version can be found [here](https://www.youtube.com/watch?v=R7CMXeQ11GM). Note that these guides are outdated and no longer recommended.

### [Jpackage Gradle Plugin](https://github.com/petr-panteleyev/jpackage-gradle-plugin)
A Gradle plugin that conveniently wraps jpackage in line with modern gradle standards. See its [README](https://github.com/petr-panteleyev/jpackage-gradle-plugin/blob/master/README.md) for usage instructions.

### [launch4j](http://launch4j.sourceforge.net/)
_-- seems to be no longer maintained --_

## MacOS Specifics

If you're planning to deploy to MacOS as well, [notarization](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) (MacOS 10.15+) can be an issue. See [here](https://www.joelotter.com/2020/08/14/macos-java-notarization.html) on how to notarize your libGDX app.

## Reducing Size

There are a number of files and classes that can be removed from the JRE to reduce the size. Below is a list of files to delete from the Windows JRE. Other platforms are very similar, though you may need classes on some platforms but not others (eg, xml classes are needed on Linux to use java.util.preferences). This list leaves Swing intact, if you don't need Swing the size could be reduced further.

```
**.diz
**.exe except javaw.exe
bin\client\
lib\applet\
lib\charsets.jar
lib\ext\localedata.jar
lib\management\
lib\management-agent.jar
lib\zi\
lib\rt.jar\com\sun\org\
lib\rt.jar\com\sun\xml\
lib\rt.jar\com\sun\corba\
lib\rt.jar\com\sun\media\
lib\rt.jar\com\sun\jndi\
lib\rt.jar\com\sun\imageio\
lib\rt.jar\com\sun\jmx\
lib\rt.jar\com\sun\rowset\
lib\rt.jar\com\sun\java\util\
lib\rt.jar\javax\imageio\
lib\rt.jar\javax\management\
lib\rt.jar\javax\print\
lib\rt.jar\javax\naming\
lib\rt.jar\javax\sound\
lib\rt.jar\javax\sql\
lib\rt.jar\javax\xml\
lib\rt.jar\javax\swing\plaf\nimbus\
lib\rt.jar\javax\swing\text\html\
lib\rt.jar\org\
lib\rt.jar\sun\applet\
lib\rt.jar\sun\management\
lib\rt.jar\sun\rmi\
lib\rt.jar\sun\security\jgss\
lib\rt.jar\sun\security\krb5\
lib\rt.jar\sun\security\tools\
lib\resources.jar\com\sun\corba\
lib\resources.jar\com\sun\imageio\
lib\resources.jar\com\sun\jndi\
lib\resources.jar\com\sun\org\
lib\resources.jar\com\sun\rowset\
lib\resources.jar\com\sun\servicetag\
lib\resources.jar\com\sun\xml\
lib\jsse.jar\sun\security\ssl\
```

To make this list I went through the files and JARs sorting by largest size first. I then deleted the largest files that looked like that were not needed and ran my app to make sure everything still works.

This list reduces the JRE size to about 36MB. Note that for faster start up the JRE JARs are not compressed. After zipping the entire JRE, the size is reduced to about 13.5MB. If Swing packages are also removed from rt.jar, the zipped size goes down to about 9.8MB.
