---
title: Dependency management with Gradle
---
## Contents

* [**Useful Links**](#useful-links)
* [**Guide to build.gradle**](#guide-to-buildgradle)
* [**libGDX Dependencies**](#libgdx-dependencies)
 * [Available libGDX extensions](#libgdx-extensions)
* [**External Dependencies**](#external-dependencies)
 * [Adding Repositories](#adding-external-repositories)
 * [Mavenizing Local Dependencies](#mavenizing-local-dependencies)
 * [File Dependencies](#file-dependencies)
   * [Android pitfall](#android-pitfall)
* [**Declaring Dependencies with HTML**](#gwt-inheritance)
 * [libGDX Extension Inherits](#libgdx-extension-inherits)
* [**Dependency Management for Libraries**](#dependency-management-for-libraries)

### Useful links
Dependency management with Gradle is easy to understand, and has many different approaches. If you are familiar with Maven or Ivy, Gradle is fully compatible with both approaches, as well as being able to support custom approaches. If you aren't familiar with Gradle, there are great resources on their site to learn, it is recommended you give them a read to get comfortable with Gradle.
* [Gradle's User Guide](https://docs.gradle.org/current/userguide/userguide.html)
* [Gradle's Dependency Management Guide](https://docs.gradle.org/current/userguide/dependency_management.html)
* [Declare your dependencies](https://docs.gradle.org/current/userguide/dependency_management.html#declaring-dependencies)

### Guide to build.gradle
Gradle projects are managed by `build.gradle` files in their root directory. If you have used the gdx-setup.jar to build your libGDX project you will notice the structure: [Structure Example](/wiki/start/project-generation#project-layout)

The root directory, and each sub directory contains a `build.gradle` file, for clarity we will define the dependencies in the root directory's `build.gradle` file. (Note it can be done in each of the `build.gradle` scripts in the sub directories, it is just cleaner and easier to follow when it is handled all in one place)

Here is a small section of the _default_ buildscript that is generated from the setup:

_Full script you will see will differ slightly depending on what other modules you have_
```gradle
//Configuration for the script itself (aka, listing the dependencies of the script that lists dependencies - InSCRIPTion!)
buildscript {
    //Defines the repositories required by this script, e.g. hosting the android plugin
    repositories {
        //maven central repository, needed for the android plugin
        mavenCentral()
        //snapshot repository (in case this script depends on snapshot/prerelease artifacts)
        maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }
        gradlePluginPortal()
        //local maven repository (advanced use)
        mavenLocal()
        google()
        maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://s01.oss.sonatype.org/content/repositories/snapshots/' }
    }
    //Defines the artifacts this script depends on, e.g. the android plugin
    dependencies {
        //Adds the android gradle plugin as a dependency of this buildscript
        classpath "com.android.tools.build:gradle:8.1.4"
        classpath "org.docstr:gwt-gradle-plugin:$gwtPluginVersion"
    }
}

//Configuration common to all projects (:core, :desktop and :android in this example)
allprojects {
    //Defines gradle plugins used by all projects.
    //A plugin extends gradle with additional tasks, configurations, etc., with defaults set according to conventions.
    apply plugin: "eclipse"
    apply plugin: "idea"

    // This allows you to "Build and run using IntelliJ IDEA", an option in IDEA's Settings.
    idea {
        module {
        outputDir file('build/classes/java/main')
        testOutputDir file('build/classes/java/test')
        }
    }
}

configure(subprojects - project(':android')) {
  apply plugin: 'java-library'
  sourceCompatibility = 8
  compileJava {
    options.incremental = true
  }
  // From https://lyze.dev/2021/04/29/libGDX-Internal-Assets-List/
  // The article can be helpful when using assets.txt in your project.
  compileJava.doLast {
    // projectFolder/assets
    def assetsFolder = new File("${project.rootDir}/assets/")
    // projectFolder/assets/assets.txt
    def assetsFile = new File(assetsFolder, "assets.txt")
    // delete that file in case we've already created it
    assetsFile.delete()

    // iterate through all files inside that folder
    // convert it to a relative path
    // and append it to the file assets.txt
    fileTree(assetsFolder).collect { assetsFolder.relativePath(it) }.each {
      assetsFile.append(it + "\n")
    }
  }
}

subprojects {
    //Version of your game
    version = '1.0.0'
    ext.appName = 'MyOriginalGame'
    repositories {
        mavenCentral()
        maven { url 'https://s01.oss.sonatype.org' }
        // You may want to remove the following line if you have errors downloading dependencies.
        mavenLocal()
        maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://s01.oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://jitpack.io' }
    }
}

eclipse.project.name = 'MyOriginalGame' + '-parent'
```

### libGDX Dependencies
Dependencies are configured in the respective `build.gradle` file of each subproject. For example: `core/build.gradle`,`android/build.gradle`,`html/build.gradle`, etc.
In order to add an external dependency to a project, you must declare the dependency correctly under the correct part of the buildscript.

(Some) libGDX extensions are mavenized and pushed to the maven repo, which means we can very easily pull them into our projects from the `build.gradle` file. You can see in the list [below](#libgdx-extensions) of the format that these dependencies take.
If you are familiar with maven, notice the format:
```gradle
implementation '<groupId>:<artifactId>:<version>:<classifier>'
```

Let's take a quick example to see how this works with the android `build.gradle` file.

[Here](#freetypefont-gradle) we see the dependencies for the FreeType Extension, say we want our Android project to have this dependency:
```gradle
dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'
    implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"
    implementation project(':core')

    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"
}
```

**We know our FreeType extension has the following android declarations:**
```gradle
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
```

**So all we need to do is whack it in the dependencies stub**

```gradle
dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'
    implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"
    implementation project(':core')

    natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
    natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
    natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
    natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
    natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"
}
```

**Ensure that your Core project has the freetype extension in core/build.gradle**

```gradle
dependencies {
  api "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"
  api "com.badlogicgames.gdx:gdx:$gdxVersion"
}
```
And we are done, our android project now has the freetype dependency.
After this you will need to refresh your dependencies. Easy eh.

#### libGDX Extensions
Mavenized libGDX extensions ready to import from the `build.gradle` script include:
* [Box2D](#box2d-gradle)
* [Bullet](#bullet-gradle)
* [FreeTypeFont](#freetypefont-gradle)
* [Controllers](#controllers-gradle)
* [Tools](#tools-gradle)
* [Box2DLights](#box2dlights-gradle)
* [Ashley](#ashley-gradle)
* [AI](#ai-gradle)

#### Box2D Gradle
**Core Dependency:**
```gradle
api "com.badlogicgames.gdx:gdx-box2d:$gdxVersion"
```
**Desktop Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```gradle
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-x86_64"
```
**iOS Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-box2d:$gdxVersion:sources"
implementation("com.badlogicgames.gdx:gdx-box2d-gwt:$gdxVersion:sources") {exclude group: "com.google.gwt", module: "gwt-user"}
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.gdx.physics.box2d.box2d-gwt" />`

***

#### Bullet Gradle
**Core Dependency:**
```gradle
api "com.badlogicgames.gdx:gdx-bullet:$gdxVersion"
```
**Desktop Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```gradle
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-x86_64"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
```
**iOS Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
Not compatible!

***

#### FreeTypeFont Gradle
**Core Dependency:**
```gradle
api "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"
```
**Desktop Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```gradle
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
```
**iOS Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-ios"
```
**iOS-MOE Dependency:**
```gradle
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
Not compatible! See [gdx-freetype-gwt](https://github.com/intrigus/gdx-freetype-gwt) for an alternative.

***

#### Controllers Gradle
**Core Dependency:**
```gradle
api "com.badlogicgames.gdx-controllers:gdx-controllers-core:$gdxControllersVersion"
```
**Desktop Dependency:**
```gradle
implementation "com.badlogicgames.gdx-controllers:gdx-controllers-desktop:$gdxControllersVersion"
```
**Android Dependency:**
```gradle
implementation "com.badlogicgames.gdx-controllers:gdx-controllers-android:$gdxControllersVersion"
```
**iOS Dependency:**
```gradle
implementation "com.badlogicgames.gdx-controllers:gdx-controllers-ios:$gdxControllersVersion"
```

**HTML Dependency:**
```gradle
implementation "com.badlogicgames.gdx-controllers:gdx-controllers-core:$gdxControllersVersion:sources"
implementation("com.badlogicgames.gdx-controllers:gdx-controllers-gwt:$gdxControllersVersion:sources"){exclude group: "com.badlogicgames.gdx", module: "gdx-backend-gwt"}
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.gdx.controllers" />`  and `<inherits name="com.badlogic.gdx.controllers.controllers-gwt" />`

***

#### Tools Gradle
**Core Dependency:**
Don't put me in core!

**Desktop Dependency (LWJGL2 Legacy Desktop only):**
```gradle
api "com.badlogicgames.gdx:gdx-tools:$gdxVersion"
```
**Android Dependency:**
Not compatible!

**iOS Dependency:**
Not compatible!

**HTML Dependency:**
Not compatible!

***

#### Box2DLights Gradle
* **Note:** this extension also requires the [Box2D](#box2d-gradle) extension

**Core Dependency:**
```gradle
api "com.badlogicgames.box2dlights:box2dlights:$box2dlightsVersion"
```
**Desktop Dependency:**
No native dependency required.

**Android Dependency:**
No native dependency required.

**HTML Dependency:**
```gradle
implementation "com.badlogicgames.box2dlights:box2dlights:$box2dlightsVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="Box2DLights" />`

***

#### Ashley Gradle

* **Note:** This extension release cycle is not dependent on the main libGDX library, and so it is not unusual to have a new version published between two libGDX releases. If you want to pull in a new (or different) version, check [https://repo1.maven.org/maven2/com/badlogicgames/ashley/ashley/](https://repo1.maven.org/maven2/com/badlogicgames/ashley/ashley/) and change the `ashleyVersion` value in the `ext` section.

**Core Dependency:**
```gradle
api "com.badlogicgames.ashley:ashley:$ashleyVersion"
```

**Desktop Dependency:**
No native dependency required.

**Android Dependency:**
No native dependency required.

**HTML Dependency:**
```gradle
implementation "com.badlogicgames.ashley:ashley:$ashleyVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.ashley_gwt" />`

***

#### AI Gradle

* **Note:** This extension release cycle is not dependent on the main libGDX library, and so it is not unusual to have a new version published between two libGDX releases. If you want to pull in a new (or different) version, check [https://repo1.maven.org/maven2/com/badlogicgames/gdx/gdx-ai/](https://repo1.maven.org/maven2/com/badlogicgames/gdx/gdx-ai/) and change the `aiVersion` value in the `ext` section.

**Core Dependency:**
```gradle
api "com.badlogicgames.gdx:gdx-ai:$aiVersion"
```

**Desktop Dependency:**
No native dependency required.

**Android Dependency:**
No native dependency required.

**HTML Dependency:**
```gradle
implementation "com.badlogicgames.gdx:gdx-ai:$aiVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.gdx.ai" />`

***



### External Dependencies
#### Adding external repositories
Gradle finds files defined as dependencies by looking through all the repositories defined in the buildscript. Gradle understands several repository formats, which include Maven and Ivy.

Under the `subprojects` stub of the root build.gradle, you can see how repositories are defined. Here is an example:
```gradle
subprojects {
    version = '1.0.0'
    ext.appName = 'MyOriginalGame'
    repositories {
        mavenCentral()
        maven { url 'https://s01.oss.sonatype.org' }
        // You may want to remove the following line if you have errors downloading dependencies.
        mavenLocal()
        maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://s01.oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://jitpack.io' }f
    }
}
```
#### Adding Dependencies
External dependencies are identified by their group, name, version and sometimes classifier attributes.

```gradle
dependencies {
    implementation group: 'com.badlogicgames.gdx', name: 'gdx', version: '1.0-SNAPSHOT', classifier: 'natives-desktop'
}
```
Gradle allows you to use shortcuts when defining external dependencies, the above configuration is the same as:

```gradle
dependencies {
    implementation 'com.badlogicgames.gdx:gdx:1.0-SNAPSHOT:natives-desktop'
}
```

### Mavenizing Local Dependencies
If you would prefer to use maven repositories to manage local .jar files, these two commands will take any local .jar file and install them (and their source) to your local maven repository.

```bash
mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
```
```bash
mvn install:install-file -Dfile=<path-to-source-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging> -Dclassifier=sources
```

To then set up gradle to include your new dependency, edit your build.gradle file in the root project directory and edit the core project entry:
```gradle
project(":core") {
   ...

    dependencies {
        ...
        implementation "<group-id>:<artifact-id>:<version>"
        implementation "<group-id>:<artifact-id>:<version>:sources"
    }
}
```

After this you will need to refresh your dependencies for your IDE to see, so run:  
Command line - `$ ./gradlew --refresh-dependencies`  
Eclipse - `$ ./gradlew eclipse`  
IntelliJ - `$ ./gradlew idea`  

Also, don't forget that any dependencies added this way also need to be included in the [GWT inheritance file](#gwt-inheritance).

### File Dependencies
If you have a dependency that is not mavenized, you can still depend on them!

To do this, in your project stub in the subproject's corresponding `build.gradle` file, locate the dependencies { } section and add the following:

```gradle
dependencies {
    implementation fileTree(dir: 'libs', include: '*.jar')
}
```

This will include all the .jar files in the libs directory as dependencies.


**NOTE**: "dir" is relative to the project root, if you add the dependencies to your android project, 'libs' would need to be in the android/ directory. If you added the dependencies in the core project, 'libs' would need to be in the core/ directory.

An example with a more _complete_ script:
```gradle
project(":android") {
    apply plugin: "android"

    configurations { natives }

    dependencies {
        coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'
        implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"
        implementation project(':core')

        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"
        implementation fileTree(dir: 'libs', include: '*.jar')
    }
}
```

It is worth nothing that these file dependencies are not included in the published dependency descriptor for your project, but they are included in transitive project dependencies within the same build.

##### Android Pitfall
When adding `flat file` dependencies to a project, for example the core project, you would need to duplicate the dependency declaration for the android project. This is because the Android Gradle plugin currently [can't handle](https://code.google.com/p/android/issues/detail?id=186012) transitive `flat file` dependencies.

For example, if you were to add the all the jars in your `libs` directory as dependencies for your project, you would need to do the following.

```gradle
project(":core") {
   ...
   implementation fileTree(dir: '../libs', include: '*.jar')
   ...
}

// And also

project(":android") {
   ...
   implementation fileTree(dir: '../libs', include: '*.jar')
   ...
}
```

This is only required for the android project, all other projects inherit `flat file` dependencies OK.

### Gwt Inheritance
Gwt is special, so in order to let the GWT compiler know what modules the project depends on, and _inherits_ from, you need to let it know.

This is done in the `gwt.xml` files in the gwt sub directory. You will need to make the changes both to the `GdxDefinition.gwt.xml` and also the `GdxDefinitionSuperdev.gwt.xml`.

**The _default_ gwt.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE module PUBLIC "-//Google Inc.//DTD Google Web Toolkit trunk//EN" "http://google-web-toolkit.googlecode.com/svn/trunk/distro-source/core/src/gwt-module.dtd">
<module rename-to="html">
	<inherits name='com.badlogic.gdx.backends.gdx_backends_gwt' />
	<inherits name='MyGameName' />
	<entry-point class='com.badlogic.mygame.client.HtmlLauncher' />

	<set-configuration-property name="gdx.assetpath" value="../android/assets" />
</module>
```
We depend on the libGDX gwt backend, as well as the core project, so we have them defined in a <inherits> tag. So when you add your dependency via methods above, you need to add it here too!

#### libGDX Extension Inherits
These are the libGDX extensions that are supported in gwt

* libGDX Core - `<inherits name='com.badlogic.gdx.backends.gdx_backends_gwt' />`
* Box2d       - `<inherits name='com.badlogic.gdx.physics.box2d.box2d-gwt' />`
* Box2dLights - `<inherits name='Box2DLights' />`
* Controllers - `<inherits name='com.badlogic.gdx.controllers' />` and `<inherits name='com.badlogic.gdx.controllers.controllers-gwt' />`
* Ashley      - `<inherits name='com.badlogic.ashley_gwt' />`
* AI          - `<inherits name='com.badlogic.gdx.ai' />`

### Dependency management for libraries
If you're creating a library that people can include in their projects via gradle, you might need to replace the _implementation_ keyword by _api_.
Any dependency of your library that you declare with _api_ will be visible and usable by others that depend on your library while _implementation_ makes it only accessible for you.
