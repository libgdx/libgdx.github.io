---
title: Project Setup via Command Line
# Not listed in ToC
---
## Creating a libGDX project using the command line

This section describes how you can create a libGDX project from the command line. This is not required if you use the setup tool's wizard. The following arguments are to be specified:

* **dir**: the directory to write the project to, relative or absolute
* **name**: the name of the application, lower-case with minuses is usually a good idea, e.g. `mygame`
* **package**: the Java package under which your code will live, e.g. `com.badlogic.mygame`
* **mainClass**: the name of the main ApplicationListener of your app, e.g. `MyGame`
* **sdkLocation**: the location of your Android SDK, IntelliJ uses this if ANDROID_HOME is not set
* **excludeModules**: the modules to exclude (lwjgl2; lwjgl3; Android; iOS; HTML) separated by ';' and not case sensitive, e.g. `Android;ios`. Optional. Default it includes all the modules
* **extensions**: the extensions to include (same name as in GUI: Bullet; Freetype; Tools; Controllers; Box2d; Box2dlights; Ashley; Ai) separated by ';' and not case sensitive, e.g. `box2d;box2dlights;Ai`. Optional

Putting it all together, you can run the project generator on the command line as follows:

`java -jar gdx-setup.jar --dir mygame --name mygame --package com.badlogic.mygame --mainClass MyGame --sdkLocation mySdkLocation [--excludeModules <modules>] [--extensions <extensions>]`
