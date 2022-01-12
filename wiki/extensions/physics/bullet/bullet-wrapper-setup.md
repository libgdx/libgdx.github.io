---
title: Bullet Wrapper Setup
---
The Bullet wrapper (`gdx-bullet` extension) is currently supported on desktop, android and ios. The Bullet wrapper isn't supported for GWT at the moment.

The easiest method to setup your project to use the Bullet Wrapper is by using the [setup utility](/wiki/start/project-generation) which has an option to include the gdx-bullet extension.

The instruction for manually adding the Bullet Wrapper to your Gradle project can be found [here](/wiki/articles/dependency-management-with-gradle#bullet-gradle)

If you're not using Gradle, then you can manually add it:
* To use bullet physics in your project, you’ll need to add gdx-bullet.jar to your core project. Alternatively you can add the gdx-bullet project to the projects of the build path of your main project.
* For your desktop project you’ll need to add the gdx-bullet-natives.jar to the libraries.
* For your android project you’ll need to copy the armeabi/libgdx-bullet.so and armeabi-v7a/libgdx-bullet.so files to the libs folder in your android project.
