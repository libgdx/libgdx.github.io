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
Dependency management with Gradle is easy to understand, and has many different approaches.  If you are familiar with Maven or Ivy, Gradle is fully compatible with both approaches, as well as being able to support custom approaches.  If you aren't familiar with Gradle, there are great resources on their site to learn, it is recommended you give them a read to get comfortable with Gradle.
* [Gradle's User Guide](http://www.gradle.org/docs/current/userguide/userguide.html)
* [Gradle's Dependency Management Guide](http://www.gradle.org/docs/current/userguide/dependency_management.html)
* [Declare your dependencies](http://www.gradle.org/docs/current/userguide/dependency_management.html#sec:how_to_declare_your_dependencies)

### Guide to build.gradle
Gradle projects are managed by `build.gradle` files in their root directory. If you have used the gdx-setup.jar to build your libGDX project you will notice the structure: [Structure Example](/wiki/start/project-generation#project-layout)

The root directory, and each sub directory contains a `build.gradle` file, for clarity we will define the dependencies in the root directory's `build.gradle` file. (Note it can be done in each of the `build.gradle` scripts in the sub directories, it is just cleaner and easier to follow when it is handled all in one place)

Here is a small section of the _default_ buildscript that is generated from the setup:

_Full script you will see will differ slightly depending on what other modules you have_
```groovy
//Configuration for the script itself (aka, listing the dependencies of the script that lists dependencies - InSCRIPTion!)
buildscript {
    //Defines the repositories required by this script, e.g. hosting the android plugin
    repositories {
        //local maven repository (advanced use)
        mavenLocal()
        //maven central repository, needed for the android plugin
        mavenCentral()
        //snapshot repository (in case this script depends on snapshot/prerelease artifacts)
        maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }
    }
    //Defines the artifacts this script depends on, e.g. the android plugin
    dependencies {
        //Adds the android gradle plugin as a dependency of this buildscript
        classpath 'com.android.tools.build:gradle:1.5.0'
    }
}

//Configuration common to all projects (:core, :desktop and :android in this example)
allprojects {
    //Defines gradle plugins used by all projects.
    //A plugin extends gradle with additional tasks, configurations, etc., with defaults set according to conventions.
    apply plugin: "eclipse"
    apply plugin: "idea"

    //Version of your game
    version = "1.0"
    //Defines 'extra' (custom) properties for all projects
    ext {
        appName = "the-name-of-your-game"
        //Versions of the libGDX dependencies (used further below on those 'compile' lines)
        gdxVersion = "1.9.3"
        roboVMVersion = '2.1.0'
        box2DLightsVersion = '1.4'
        ashleyVersion = '1.7.0'
        aiVersion = '1.8.0'
    }

    //Defines all repositories needed for all projects
    repositories {
        mavenLocal()
        mavenCentral()
        maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }
        maven { url "https://oss.sonatype.org/content/repositories/releases/" }
    }
}

//Configuration for the :desktop project
project(":desktop") {
    //Uses the java plugin (provides compiling, execution, etc.).
    //That one is bundled with gradle, so we didn’t have to define it in the buildscript section.
    apply plugin: "java"

    //Defines dependencies for the :desktop project
    dependencies {
        //Adds dependency on the :core project as well as the gdx lwjgl backend and native dependencies
        implementation project(":core")
        implementation "com.badlogicgames.gdx:gdx-backend-lwjgl:$gdxVersion"
        implementation "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-desktop"
    }
}

//Configuration for the :android project
project(":android") {
    //Uses the android gradle plugin (provides compiling, copying on device, etc.)
    apply plugin: "android"

    configurations { natives }

    //Defines dependencies for the :android project
    dependencies {
        //Adds dependencies on the :core project as well as the android backends and all platform natives.
        //Note the 'natives' classifier in this project.
        implementation project(":core")
        implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"                
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"
    }
}

//Configuration for the :core project
project(":core") {
    //Uses the java gradle plugin
    apply plugin: "java"

    dependencies {
        //Defines dependencies for the :core project, in this example the gdx dependency
        implementation "com.badlogicgames.gdx:gdx:$gdxVersion"
    }
}

```

### libGDX Dependencies
Dependencies are configured in the **root** `build.gradle` file as shown in the build.gradle guide above.
In order to add an external dependency to a project, you must declare the dependency correctly under the correct part of the build.script.

(Some) libGDX extensions are mavenized and pushed to the maven repo, which means we can very easily pull them into our projects from the `build.gradle` file.  You can see in the list [below](#libgdx-extensions) of the format that these dependencies take.
If you are familiar with maven, notice the format:
```groovy
compile '<groupId>:<artifactId>:<version>:<classifier>'
```

Let's take a quick example to see how this works with the root `build.gradle` file.

As mentioned earlier, you do not need to  modify the individual `build.gradle` files in each of the different platform-specific folders (e.g., -desktop, -ios, -core). You only need to modify the root `build.gradle` file.

[Here](#freetypefont-gradle) we see the dependencies for the FreeType Extension, say we want our Android project to have this dependency.  We locate our `project(":android")` stub in the root directory's `build.gradle`:
```groovy
project(":android") {
    apply plugin: "android"

    configurations { natives }

    dependencies {
        implementation project(":core")
        implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"        
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"
    }
}
```

**We know our FreeType extension has declarations:**
```groovy
implementation "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
```

**So all we need to do is whack it in the dependencies stub**

```groovy
project(":android") {
    apply plugin: "android"

    configurations { natives }

    dependencies {
        implementation project(":core")
        implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"        
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"

        implementation "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"        
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
    }
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
```groovy
implementation "com.badlogicgames.gdx:gdx-box2d:$gdxVersion"
```
**Desktop Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-box2d:$gdxVersion"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-x86_64"
```
**iOS Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-box2d-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-box2d:$gdxVersion:sources"
implementation "com.badlogicgames.gdx:gdx-box2d-gwt:$gdxVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.gdx.physics.box2d.box2d-gwt"/>`

***

#### Bullet Gradle
**Core Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-bullet:$gdxVersion"
```
**Desktop Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-bullet:$gdxVersion"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-x86_64"
```
**iOS Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-bullet-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
Not compatible!

***

#### FreeTypeFont Gradle
**Core Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"
```
**Desktop Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
```
**iOS Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-ios"
```
**iOS-MOE Dependency:**
```groovy
natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-ios"
```
**HTML Dependency:**
Not compatible!

***

#### Controllers Gradle
**Core Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-controllers:$gdxVersion"
```
**Desktop Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-controllers-desktop:$gdxVersion"
implementation "com.badlogicgames.gdx:gdx-controllers-platform:$gdxVersion:natives-desktop"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-controllers:$gdxVersion"
implementation "com.badlogicgames.gdx:gdx-controllers-android:$gdxVersion"
```
**iOS Dependency:**
Not supported, but you can still compile and run your iOS app. Controllers just won't be available

**HTML Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-controllers:$gdxVersion:sources"
implementation "com.badlogicgames.gdx:gdx-controllers-gwt:$gdxVersion"
implementation "com.badlogicgames.gdx:gdx-controllers-gwt:$gdxVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="com.badlogic.gdx.controllers.controllers-gwt"/>`

***

#### Tools Gradle
**Core Dependency:**
Don't put me in core!

**Desktop Dependency (LWJGL2 only):**
```groovy
implementation "com.badlogicgames.gdx:gdx-tools:$gdxVersion"
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
```groovy
implementation "com.badlogicgames.box2dlights:box2dlights:$box2DLightsVersion"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.box2dlights:box2dlights:$box2DLightsVersion"
```
**HTML Dependency:**
```groovy
implementation "com.badlogicgames.box2dlights:box2dlights:$box2DLightsVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name="Box2DLights"/>`

***

#### Ashley Gradle

* **Note:** This extension release cycle is not dependent on the main libGDX library, and so it is not unusual to have a new version published between two libGDX releases. If you want to pull in a new (or different) version, check https://repo1.maven.org/maven2/com/badlogicgames/ashley/ashley/ and change the `ashleyVersion` value in the `ext` section.

**Core Dependency:**
```groovy
implementation "com.badlogicgames.ashley:ashley:$ashleyVersion"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.ashley:ashley:$ashleyVersion"
```
**HTML Dependency:**
```groovy
implementation "com.badlogicgames.ashley:ashley:$ashleyVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name='com.badlogic.ashley_gwt' />`

***

#### AI Gradle

* **Note:** This extension release cycle is not dependent on the main libGDX library, and so it is not unusual to have a new version published between two libGDX releases. If you want to pull in a new (or different) version, check https://repo1.maven.org/maven2/com/badlogicgames/gdx/gdx-ai/ and change the `aiVersion` value in the `ext` section.

**Core Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-ai:$aiVersion"
```
**Android Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-ai:$aiVersion"
```
**HTML Dependency:**
```groovy
implementation "com.badlogicgames.gdx:gdx-ai:$aiVersion:sources"
```
and in `./html/src/yourgamedomain/GdxDefinition*.gwt.xml` add `<inherits name='com.badlogic.gdx.ai' />`

***



### External Dependencies
#### Adding external repositories
Gradle finds files defined as dependencies by looking through all the repositories defined in the buildscript.  Gradle understands several repository formats, which include Maven and Ivy.

Under the `allprojects` stub, you can see how repositories are defined. Here is an example:
```groovy
allprojects {    
    repositories {
        // Remote Maven repo
        maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }
        // Maven Central Repo
        mavenCentral()
        // Local Maven repo
        mavenLocal()
        // Remote Ivy dir
        ivy { url "http://some.ivy.com/repo" }
        // Local Ivy dir
        ivy { url "../local-repo" }
    }
}
```
#### Adding Dependencies
External dependencies are identified by their group, name, version and sometimes classifier attributes.

```groovy
dependencies {
    implementation group: 'com.badlogicgames.gdx', name: 'gdx', version: '1.0-SNAPSHOT', classifier: 'natives-desktop'
}
```
Gradle allows you to use shortcuts when defining external dependencies, the above configuration is the same as:

```groovy
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
```groovy
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

To do this, in your project stub in the root `build.gradle` file, locate the dependencies { } section as always, and add the following:

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: '*.jar')
}
```

This will include all the .jar files in the libs directory as dependencies.


**NOTE**: "dir" is relative to the project root, if you add the dependencies to your android project, 'libs' would need to be in the android/ directory. If you added the dependencies in the core project, 'libs' would need to be in the core/ directory.

An example with a more _complete_ script:
```groovy
project(":android") {
    apply plugin: "android"

    configurations { natives }

    dependencies {
        implementation project(":core")
        implementation "com.badlogicgames.gdx:gdx-backend-android:$gdxVersion"        
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-platform:$gdxVersion:natives-x86_64"

        implementation "com.badlogicgames.gdx:gdx-freetype:$gdxVersion"        
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-armeabi-v7a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-arm64-v8a"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86"
        natives "com.badlogicgames.gdx:gdx-freetype-platform:$gdxVersion:natives-x86_64"
        implementation fileTree(dir: 'libs', include: '*.jar')
    }
}
```

It is worth nothing that these file dependencies are not included in the published dependency descriptor for your project, but they are included in transitive project dependencies within the same build.

##### Android Pitfall
When adding `flat file` dependencies to a project, for example the core project, you would need to duplicate the dependency declaration for the android project.  This is because the Android Gradle plugin currently [can't handle](https://code.google.com/p/android/issues/detail?id=186012) transitive `flat file` dependencies.

For example, if you were to add the all the jars in your `libs` directory as dependencies for your project, you would need to do the following.

```groovy
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
We depend on the libGDX gwt backend, as well as the core project, so we have them defined in a <inherits> tag.  So when you add your dependency via methods above, you need to add it here too!

#### libGDX Extension Inherits
These are the libGDX extensions that are supported in gwt

* libGDX Core - `<inherits name='com.badlogic.gdx.backends.gdx_backends_gwt' />`
* Box2d       - `<inherits name='com.badlogic.gdx.physics.box2d.box2d-gwt' />`
* Box2dLights - `<inherits name='Box2DLights' />`
* Controllers - `<inherits name='com.badlogic.gdx.controllers.controllers-gwt' />`
* Ashley      - `<inherits name='com.badlogic.ashley_gwt' />`
* AI          - `<inherits name='com.badlogic.gdx.ai' />`

### Dependency management for libraries
If you're creating a library that people can include in their projects via gradle, you might need to replace the _implementation_ keyword by _api_.
Any dependency of your library that you declare with _api_ will be visible and usable by others that depend on your library while _implementation_ makes it only accessible for you.
