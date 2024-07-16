---
title: "Creating a Project"
description: "The libGDX setup tool takes care of all the steps involved in setting up a libGDX Gradle project."
redirect_from:
  - /dev/project_generation/
  - /dev/project-generation/
---

To setup your first project and download the necessary dependencies, libGDX offers a setup tool.

{% include setup_flowchart.html current='1' %}

1. Download the libGDX Project Setup Tool (gdx-liftoff).

    <a href="https://github.com/libgdx/gdx-liftoff/releases/latest" class="btn btn--success">Download gdx-liftoff</a>
2. The file will be in the Assets section of the release.  Download the file that ends in `.jar`.

3. Double-click the downloaded file. If this doesn't work, open your command line tool and go to the download folder where you saved the .jar file.  Run the command <br>`java -jar gdx-liftoff-x.x.x.x.jar`. Replace the 'x' with the version you downloaded.  For example 'gdx-liftoff-1.12.1.12.jar'.
   <br>On Linux, you might need to right-click the file, select "Properties" and then check "Allow executing the file as program" in the "Permission" tab.

This will open the following setup that will allow you to generate your project:

![Setup UI](https://github.com/libgdx/gdx-liftoff/raw/master/.github/screenshot.png){: style="width: 500px;" }

You may follow the video guide <a href="https://youtu.be/VF6N_X_oWr0">GDX-Liftoff: libGDX Project Setup</a> or proceed with the following steps.

## Project
You are asked to provide the following parameters:

* **PROJECT NAME**: the name of the application. This can contain letters, numbers, underscores, and dashes, e.g. `YourProjectName`<br>
* **PACKAGE**: the Java package under which your code will reside, e.g. `io.github.some_example_name`<br>
* **MAIN CLASS**: the name of the main game Java class of your app, e.g. `Main`<br>

## Add-Ons
Clicking the Project Options button will take you to the Add-Ons screen:

* **Platforms**: The backends that your project will support. Core is required for all projects. Desktop is highly recommended for testing. Otherwise, select the additional platforms for the kinds of devices you want to support.<br>

**Note:** To compile your game for iOS you need Xcode, which is only available on macOS!
{: .notice--info}

* **Languages**: The languages besides Java that you want to include in the project (Groovy, Kotlin, Scala).<br>
* **Extensions**: Officially supported add-ons that extend the functionality of libGDX.
  * **[Ashley](https://github.com/libgdx/ashley)**: A tiny entity framework.<br>
  * **[Box2dlights](https://github.com/libgdx/box2dlights)**: 2D lighting framework that uses box2d for raycasting and OpenGL ES 2.0 for rendering.<br>
  * **[Ai](https://github.com/libgdx/gdx-ai)**: An artificial intelligence framework.<br>
  * **[Box2d](/wiki/extensions/physics/box2d)**: Box2D is a 2D physics library.<br>
  * **[Bullet](/wiki/extensions/physics/bullet/bullet-physics)**: 3D Collision Detection and Rigid Body Dynamics Library.<br>
  * **[Controllers](https://github.com/libgdx/gdx-controllers?tab=readme-ov-file#%EF%B8%8F-game-controller-extension-for-libgdx-version-2)** Library to handle controllers (e.g.: XBox 360 controller).<br>
  * **[FreeType](/wiki/extensions/gdx-freetype)**: Scalable font. Great to manipulate font size dynamically. However be aware that it does not work with HTML target if you cross compile for that target.<br>
  * **Tools**: Set of tools including: particle editor (2d/3d), bitmap font and image texture packers.<br>
* **Template**: Defines the base classes to be included in your project.<br>

## Third-Party
Proceeding to the next screen takes you to the Third-Party screen. These are additional extensions that are not provided by the official libGDX maintainers:

* **Search**: You may type the name or keyword of a third party library to filter the list.<br>
* **Show only selected**: Use this option to filter for only libraries you have selected. This makes it easier to deselect any libraries you no longer want.<br>
* If you want to add extensions later on, please take a look at [this](/wiki/articles/dependency-management-with-gradle#libgdx-extensions) wiki page.<br>

## Settings
The final screen allows you to set versions and other options:

* **libGDX Version**: The official version of libGDX to be included in your project. The latest stable version is `1.12.1`. To implement the latest changes and bugfixes, use `1.12.2-SNAPSHOT`. Keep in mind that snapshot builds may be unstable and subject to API breaking changes.<br>
* **Java Version**: The version of Java to be used to build your project.<br> 
  * `8` is the recommendation for most projects.<br>
  * Use `7` if you want to support old Android devices or iOS.<br>
  * `11` is supported on desktop and HTML. Note that the GWT (HTML5) only supports a [subset of Java libraries](https://www.gwtproject.org/doc/latest/DevGuideCodingBasicsCompatibility)<br>
  * The latest versions of Java like `22` are only supported on desktop<br>
* **App Version**: The version number of your game used throughout your project. See [semantic versioning](https://semver.org/).<br>
* **Add GUI Assets**: Adds a general use Scene2D UI skin.<br>
* **Add README**: Adds a basic README file with placeholder text. Read the tips in the README to learn about helpful Gradle commands.<br>
* **Add Gradle Tasks**: Add optional Gradle commands to be executed after the project is generated.<br>
* **Project Path**: The destination folder for the project.<br>
* **Android SDK Path**: If you selected Android as a target platform, you must provide the path to it here.<br>
  * Linux default path: `~/Android/Sdk`<br>
  * Mac default path: `~/Library/Android/sdk`<br>
  * Windows: `%LOCALAPPDATA%\Android\Sdk`<br>
  * You can find out where it is in Android Studio by clicking "More Actions" in the welcome screen and selecting “SDK Manager”.<br>

## Project Generation
After you click generate, you will be presented with a project summary screen:

* Any errors during the file generation process will be listed here with a stack trace.<br>
* You can open your project directly in IntelliJ IDEA if you have it installed.<br>
* Click "New Project" to begin the process from the beginning.

## Project Layout
The process of project generation will create a directory with the following layout:

```
gradle.properties          <- global variables used to define version numbers throughout the project
settings.gradle            <- definition of sub-modules. By default core, desktop, android, html, ios
build.gradle               <- main Gradle build file
gradlew                    <- local Gradle wrapper
gradlew.bat                <- script that will run Gradle on Windows
local.properties           <- IntelliJ only file, defines Android SDK location

assets/                    <- contains your graphics, audio, etc.

core/
    build.gradle           <- Gradle build file for core project. Defines dependencies throughout the project.
    src/                   <- Source folder for all your game's code

lwjgl3/
    build.gradle           <- Gradle build file for desktop project. Defines desktop only dependencies.
    src/                   <- Source folder for your desktop project, contains LWJGL launcher class

android/
    build.gradle           <- Gradle build file for android project. Defines Android only dependencies.
    AndroidManifest.xml    <- Android specific config
    res/                   <- contains icons for your app and other resources
    src/                   <- Source folder for your Android project, contains android launcher class

html/
    build.gradle           <- Gradle build file for the html project. Defines GWT only dependencies.
    src/                   <- Source folder for your html project, contains launcher and html definition
    webapp/                <- War template, on generation the contents are copied to war. Contains startup url index page and web.xml

ios/
    build.gradle           <- Gradle build file for the iOS project. Defines iOS only dependencies.
    src/                   <- Source folder for your iOS project, contains launcher
```

## What is Gradle?
libGDX projects are [Gradle](https://gradle.org/) projects, which makes managing dependencies and building considerably easier.

Gradle is a **dependency management** system and thus provides an easy way to pull in third-party libraries into your project, without having to manually download them. Instead, Gradle just needs you to provide it with the names and versions of the libraries you want to include in your application. This is all done in the Gradle configuration files. Adding, removing and changing the version of a third-party library is as easy as changing a few lines in that configuration file. The dependency management system will pull in the libraries you specified from a central repository (in our case [Maven Central](https://search.maven.org/)) and store them in a directory outside of your project. Find out more in our [wiki](/wiki/articles/dependency-management-with-gradle).
{: .notice--info}

In addition, Gradle is also a **build system** helping with building and packaging your application, without being tied to a specific IDE. This is especially useful if you use a build or continuous integration server, where IDEs aren't readily available. Instead, the build server can call the build system, providing it with a build configuration so it knows how to build your application for different platforms. If you want to know more about deploying your application, take a look [here](/wiki/deployment/deploying-your-application).
{: .notice--info}

**Now you are ready to [import the project into your IDE and run it](/wiki/start/import-and-running).**
