---
title: "Creating a Project"
redirect_from:
  - /dev/project_generation/
  - /dev/project-generation/
---

To setup your first project and download the necessary dependencies, libGDX offers a setup tool.

{% include setup_flowchart.html current='1' %}

1. Download the libGDX Project Setup Tool:

<a href="/assets/downloads/legacy_setup/gdx-setup_latest.jar" class="btn btn--success" style="margin-right: 10px">Stable Release</a>
<a href="https://libgdx-nightlies.s3.eu-central-1.amazonaws.com/libgdx-runnables/gdx-setup.jar" class="btn btn--success">Nightly Version</a>

2. Open your command line tool, go to the download folder and run <br>`java -jar ./gdx-setup_latest.jar`

This will open the following setup that will allow you to generate your project:

![](https://i.imgur.com/nI5lQKT.jpg){: style="width: 700px;" }

**Note:** Instead of the User Interface of the Setup Tool you can also use the [command-line](/wiki/start/project-setup-via-command-line) to create your project.
{: .notice--primary}

You are asked to provide the following parameters:
* **Name**: the name of the application; lower case with minuses is usually a good idea, e.g. `my-game`
* **Package**: the Java package under which your code will reside, e.g. `com.badlogic.mygame`
* **Game Class**: the name of the main game Java class of your app, e.g. `MyGame`
* **Destination**: the folder where your app will be created
* **Android SDK**: the location of your Android SDK. With Android Studio, to find out where it is, start Android Studio and click "Configure" -> "SDK Manager". By default it is in `/Users/username/Library/Android/sdk` <br>

![](https://i.imgur.com/re4m4ZW.png){: style="width: 700px;" }
![](https://i.imgur.com/Y4F3UsH.png){: style="width: 700px;" }

* **Sub Projects**: libGDX is cross-platform. By default, all the target platforms are included (Desktop; Android; iOS; HTML). There is no need to change the default value unless you are sure you will never compile for a specific target.

**Note:** iOS projects can only be compiled on macOS.
{: .notice--info}

* **extensions**: the extensions offered are:<br>
    **[Bullet](/wiki/extensions/physics/bullet/bullet-physics)**: 3D Collision Detection and Rigid Body Dynamics Library.<br>
    **[FreeType](/wiki/extensions/gdx-freetype)**: Scalable font. Great to manipulate font size dynamically. However be aware that it does not work with HTML target if you cross compile for that target.<br>
    **Tools**: Set of tools including: particle editor (2d/3d), bitmap font and image texture packers.<br>
    **[Controller](/wiki/input/controllers)** Library to handle controllers (e.g.: XBox 360 controller).<br>
    **[Box2d](/wiki/extensions/physics/box2d)**: Box2D is a 2D physics library.<br>
    **[Box2dlights](https://github.com/libgdx/box2dlights)**: 2D lighting framework that uses box2d for raycasting and OpenGL ES 2.0 for rendering.<br>
    **[Ashley](https://github.com/libgdx/ashley)**: A tiny entity framework.<br>
    **[Ai](https://github.com/libgdx/gdx-ai)**: An artificial intelligence framework.<br>

By clicking "Show Third Party Extensions" you can access a list of community-made libGDX extensions. If you want to add extensions later on, please take a look at [this](/wiki/articles/dependency-management-with-gradle#libgdx-extensions) wiki page.

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

core/
    build.gradle           <- Gradle build file for core project*
    src/                   <- Source folder for all your game's code

desktop/
    build.gradle           <- Gradle build file for desktop project*
    src/                   <- Source folder for your desktop project, contains LWJGL launcher class

android/
    build.gradle           <- Gradle build file for android project*
    AndroidManifest.xml    <- Android specific config
    assets/                <- contains for your graphics, audio, etc.  Shared with other projects.
    res/                   <- contains icons for your app and other resources
    src/                   <- Source folder for your Android project, contains android launcher class

html/
    build.gradle           <- Gradle build file for the html project*
    src/                   <- Source folder for your html project, contains launcher and html definition
    webapp/                <- War template, on generation the contents are copied to war. Contains startup url index page and web.xml

ios/
    build.gradle           <- Gradle build file for the iOS project*
    src/                   <- Source folder for your iOS project, contains launcher
```

## What is Gradle?
libGDX projects are [Gradle](http://www.gradle.org/) projects, which makes managing dependencies and building considerably easier.

Gradle is a **dependency management** system and thus provides an easy way to pull in third-party libraries into your project, without having to manually download them. Instead, Gradle just needs you to provide it with the names and versions of the libraries you want to include in your application. This is all done in the Gradle configuration files. Adding, removing and changing the version of a third-party library is as easy as changing a few lines in that configuration file. The dependency management system will pull in the libraries you specified from a central repository (in our case [Maven Central](http://search.maven.org/)) and store them in a directory outside of your project. Find out more in our [wiki](/wiki/articles/dependency-management-with-gradle).
{: .notice--info}

In addition, Gradle is also a **build system** helping with building and packaging your application, without being tied to a specific IDE. This is especially useful if you use a build or continuous integration server, where IDEs aren't readily available. Instead, the build server can call the build system, providing it with a build configuration so it knows how to build your application for different platforms. If you want to know more about deploying your application, take a look [here](/wiki/deployment/deploying-your-application).
{: .notice--info}

**Now you are ready to [import the project into your IDE and run it](/wiki/start/import-and-running).**
