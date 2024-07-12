---
title: "Creating a Project"
description: "The libGDX setup tool takes care of all the steps involved in setting up a libGDX Gradle project."
redirect_from:
  - /dev/project_generation/
  - /dev/project-generation/
---

To setup your first project and download the necessary dependencies, libGDX offers a setup tool.

{% include setup_flowchart.html current='1' %}

1. Download the libGDX Project Setup Tool called gdx-liftoff.

    <!--<a href="/assets/downloads/legacy_setup/gdx-setup_latest.jar" class="btn btn--success" style="margin-right: 10px">Stable Release</a>
    <a href="https://libgdx-nightlies.s3.amazonaws.com/libgdx-runnables/gdx-setup.jar" class="btn btn--success">Nightly Version</a>-->
    <!--<a href="https://libgdx-nightlies.s3.amazonaws.com/libgdx-runnables/gdx-setup.jar" class="btn btn--success">Download</a>-->
    <a href="https://github.com/libgdx/gdx-liftoff/releases" class="btn btn--success">Download gdx-liftoff</a>
2. The file will be in the Assets section of the release.  Download the file that ends in `.jar`.

3. Double-click the downloaded file. If this doesn't work, open your command line tool and go to the download folder where you saved the .jar file.  Run the command <br>`java -jar gdx-liftoff-x.x.x.x.jar`. Replace the 'x' with the version you downloaded.  For example 'gdx-liftoff-1.12.1.11.jar'.
   <br>On Linux, you might need to right-click the file, select "Properties" and then check "Allow executing the file as program" in the "Permission" tab.

This will open the following setup that will allow you to generate your project:

![Setup UI](https://github.com/libgdx/gdx-liftoff/raw/master/.github/screenshot.png){: style="width: 500px;" }

**Note:** Instead of the User Interface of the Setup Tool you can also use the [command-line](/wiki/start/project-setup-via-command-line) to create your project.
{: .notice--primary}

You are asked to provide the following parameters:
* **PROJECT NAME**: the name of the application; lower case with minuses is usually a good idea, e.g. `my-game`
* **PACKAGE**: the Java package under which your code will reside, e.g. `com.badlogic.mygame`
* **MAIN CLASS**: the name of the main game Java class of your app, e.g. `MyGame`
<br><br>
* **PROJECT OPTIONS**: will take you to a new screen where you can configure the project to your needs.  See the <a href="https://github.com/libgdx/gdx-liftoff/blob/master/Guide.md">Gdx-LiftOff Guide</a> for more information.
* **QUICK PROJECT**: will create a project with the default settings.

  <!--* **Game class**: the name of the main game class, e.g. `MyGame`
  * **Main class package**: the package of the main game class, e.g. `com.badlogic.mygame`
  * **Gradle version**: the version of Gradle to use. The default value is the latest stable version.
  * **LibGDX version**: the version of libGDX to use. The default value is the latest stable version.
  * **Language**: the programming language to use. The default value is Java.
  * **Extensions**: the official extensions to include in your project. By default, none are selected.
  * **Advanced settings**: will take you to a new screen where you can set the following parameters:
    * **Build tools version**: the version of the Android build tools to use. The default value is the latest stable version.
    * **API level**: the Android API level to target. The default value is 28.
    * **Min API level**: the minimum Android API level to support. The default value is 9.
    * **Target API level**: the target Android API level. The default value is 28.
    * **Permissions**: the permissions to include in the Android manifest. By default, none are selected.
    * **Dependencies**: the dependencies to include in the project. By default, none are selected.
    * **Gradle plugins**: the Gradle plugins to include in the project. By default, none are selected.-->


<!--* **Output folder**: the folder where your app will be created
* **Android SDK**: the location of your Android SDK. With Android Studio, to find out where it is, start Android Studio and click "Configure" (on recent versions, this is replaced by a three dots icon at the top right) -> "SDK Manager". By default the locations are:
  * Linux: `~/Android/Sdk`
  * Mac: `~/Library/Android/sdk`
  * Windows: `%LOCALAPPDATA%\Android\Sdk` -->



![Android Studio welcome screen](/assets/images/dev/setup/1.png){: style="width: 700px;" }
![Android Studio SDK manager](/assets/images/dev/setup/2.png){: style="width: 700px;" }

* **Supported Platforms**: libGDX is cross-platform. By default, all the target platforms are included as sub projects (Desktop; Android; iOS; HTML). There is no need to change the default value unless you are sure you will never compile for a specific target.

**Note:** To compile your game for iOS you need Xcode, which is only available on macOS!
{: .notice--info}

* **Official Extensions**: the extensions offered are:<br>
  * **[Bullet](/wiki/extensions/physics/bullet/bullet-physics)**: 3D Collision Detection and Rigid Body Dynamics Library.<br>
  * **[FreeType](/wiki/extensions/gdx-freetype)**: Scalable font. Great to manipulate font size dynamically. However be aware that it does not work with HTML target if you cross compile for that target.<br>
  * **Tools**: Set of tools including: particle editor (2d/3d), bitmap font and image texture packers.<br>
  * **[Controller](/wiki/input/controllers)** Library to handle controllers (e.g.: XBox 360 controller).<br>
  * **[Box2d](/wiki/extensions/physics/box2d)**: Box2D is a 2D physics library.<br>
  * **[Box2dlights](https://github.com/libgdx/box2dlights)**: 2D lighting framework that uses box2d for raycasting and OpenGL ES 2.0 for rendering.<br>
  * **[Ashley](https://github.com/libgdx/ashley)**: A tiny entity framework.<br>
  * **[Ai](https://github.com/libgdx/gdx-ai)**: An artificial intelligence framework.<br>

By clicking "Show Third-Party Extensions" you can access a list of community-made libGDX extensions. If you want to add extensions later on, please take a look at [this](/wiki/articles/dependency-management-with-gradle#libgdx-extensions) wiki page.

When ready, click "Generate".

**Note:** You may get a message indicating that you have a more recent version of Android build tools or Android API than the recommended. This is not a blocking message and you may continue.
{: .notice--info}

## Project Layout
This will create a directory called `mygame` with the following layout:

```
settings.gradle            <- definition of sub-modules. By default core, desktop, android, html, ios
build.gradle               <- main Gradle build file, defines dependencies and plugins
gradlew                    <- local Gradle wrapper
gradlew.bat                <- script that will run Gradle on Windows
gradle                     <- script that will run Gradle on Unix systems
local.properties           <- IntelliJ only file, defines Android SDK location

assets/                    <- contains your graphics, audio, etc.

core/
    build.gradle           <- Gradle build file for core project
    src/                   <- Source folder for all your game's code

desktop/
    build.gradle           <- Gradle build file for desktop project
    src/                   <- Source folder for your desktop project, contains LWJGL launcher class

android/
    build.gradle           <- Gradle build file for android project
    AndroidManifest.xml    <- Android specific config
    res/                   <- contains icons for your app and other resources
    src/                   <- Source folder for your Android project, contains android launcher class

html/
    build.gradle           <- Gradle build file for the html project
    src/                   <- Source folder for your html project, contains launcher and html definition
    webapp/                <- War template, on generation the contents are copied to war. Contains startup url index page and web.xml

ios/
    build.gradle           <- Gradle build file for the iOS project
    src/                   <- Source folder for your iOS project, contains launcher
```

## What is Gradle?
libGDX projects are [Gradle](https://gradle.org/) projects, which makes managing dependencies and building considerably easier.

Gradle is a **dependency management** system and thus provides an easy way to pull in third-party libraries into your project, without having to manually download them. Instead, Gradle just needs you to provide it with the names and versions of the libraries you want to include in your application. This is all done in the Gradle configuration files. Adding, removing and changing the version of a third-party library is as easy as changing a few lines in that configuration file. The dependency management system will pull in the libraries you specified from a central repository (in our case [Maven Central](https://search.maven.org/)) and store them in a directory outside of your project. Find out more in our [wiki](/wiki/articles/dependency-management-with-gradle).
{: .notice--info}

In addition, Gradle is also a **build system** helping with building and packaging your application, without being tied to a specific IDE. This is especially useful if you use a build or continuous integration server, where IDEs aren't readily available. Instead, the build server can call the build system, providing it with a build configuration so it knows how to build your application for different platforms. If you want to know more about deploying your application, take a look [here](/wiki/deployment/deploying-your-application).
{: .notice--info}

**Now you are ready to [import the project into your IDE and run it](/wiki/start/import-and-running).**
