---
title: "Status Report #7: LWJGL 3"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/posts/2021-07-24/header.png
  caption: "Photo credit: [**LWJGL Project**](https://www.lwjgl.org)"
  teaser: /assets/images/posts/2021-07-24/header.png

excerpt: Find out everything about our LWJGL 3 desktop backend!

show_author: true
author_username: "crykn"
author_displayname: "damios"

tags:
  - devlog

categories: news
---

In the next release of libGDX we are switching our default desktop backend from LWJGL 2 to LWJGL 3. This Status Report is meant to provide some background information on this change.

### What is LWJGL?
The [Lightweight Java Game Library](https://www.lwjgl.org/) (LWJGL) is an [open-source](https://github.com/LWJGL/lwjgl3) Java library that provides bindings to a number of C and C++ libraries used for game development, in particular OpenGL, OpenAL and Vulkan. The desktop backends of libGDX build upon LWJGL and wrap its low-level bindings in our cross-platform compatible API to provide graphics and audio.

### Why version 3?
Version 3 of LWJGL 3 was announced at the end of 2014 and had its first release on 4 June 2016. It is a complete rewrite of LWJGL, with the biggest change being the move from LWJGL2's own windowing system to [GLFW](https://www.glfw.org). The first version of libGDX’s LWJGL 3 backend was made public back [in 2015](https://github.com/libgdx/libgdx/issues/3673) together with a call for testing. Since then we have continually improved upon this initial release.

There were a couple of reasons for us to start working on a LWJGL 3 backend, the most obvious being the discontinuation of LWJGL 2, which had its last release in January of 2015. In addition, LWJGL 3 provides considerably better support for [current JREs, macOS, Linux](https://github.com/libgdx/libgdx/issues/6426) (including [Raspberry Pis](/news/2020/08/devlog_1_road_ahead#linux-arm-builds)), and [multi-window environments](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests-lwjgl3/src/com/badlogic/gdx/tests/lwjgl3/MultiWindowTest.java).

### How can I migrate?
To switch your existing libGDX projects to the LWJGL 3 desktop backend you need to follow two steps:

1. Open your root `build.gradle` file and replace the LWJGL backend dependency:

   ```
   api "com.badlogicgames.gdx:gdx-backend-lwjgl:$gdxVersion"
   ```

   with the LWJGL 3 backend dependency:

   ```
   api "com.badlogicgames.gdx:gdx-backend-lwjgl3:$gdxVersion"
   ```

   Make sure to refresh your Gradle dependencies in your IDE.

2. Next up, you need to fix your `DesktopLauncher` class. It is located in your desktop project and should look something like this:

   ```java
   public class DesktopLauncher {
      public static void main (String[] arg) {
         LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
         new LwjglApplication(new MyGdxGame(), config);
      }
   }
   ```

   Change it to this:

   ```java
   public class DesktopLauncher {
      public static void main (String[] arg) {
         Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
         new Lwjgl3Application(new MyGdxGame(), config);
      }
   }
   ```
<br/>

### Do I need to do anything else?
If you are on Windows or Linux, you are all set!

However, if you are on **macOS**, there is another step involved in getting your applications to run with the LWJGL 3 backend. Since libGDX 1.11.0, you can either add the gdx-lwjgl3-glfw-awt-macos dependency to your desktop project (`api "com.badlogicgames.gdx:gdx-lwjgl3-glfw-awt-macos:$gdxVersion"`; on Windows and Linux the extension is ignored) or you can run the JVM with the [`-XstartOnFirstThread`](https://github.com/LWJGL/lwjgl3/blob/572f69802cb2d4930777403c73999c3e01de9d56/modules/lwjgl/glfw/src/main/java/org/lwjgl/glfw/EventLoop.java#L14-L23) argument on macOS. This ensures that your application’s `main()` method runs on the first (i.e., the AppKit) thread and will be familiar to those of you with experiences with SWT.

Typically, the argument can be set in the Launch/Run Configurations of your IDE, as is described [here](/wiki/start/import-and-running). Alternatively, if you're starting your project via Gradle, add this line to the `run` task of the desktop Gradle file:
```
    jvmArgs = ['-XstartOnFirstThread']
```
Another viable approach for _outside of your development environment_ is to just programatically restart the JVM if the argument is not present (see [here](https://github.com/crykn/guacamole/blob/master/gdx-desktop/src/main/java/de/damios/guacamole/gdx/StartOnFirstThreadHelper.java#L69) for a simple example). Alternatively, if you want to deploy your game by packaging a JRE with it (which is the recommended way to distribute your game), jpackage or packr allow you to set the JVM arguments.

### Are there any other things I need to be aware of?
- Whenever your **application is minimised**, the LWJGL 3 backend calls `ApplicationListener#resize(0, 0)`. This can lead to unexpected issues, in particular if you are (re)building framebuffers whenever the application is resized.
- The LWJGL 3 backend does [not yet](https://github.com/libgdx/libgdx/pull/6247) work with **Swing or AWT**.
- As the graphical tools in **gdx-tools** require AWT, the library has a hard dependency on LWJGL 2. If you are using one of the non-graphical tools of the gdx-tools project (in particular [TexturePacker](/wiki/tools/texture-packer#from-source)) and the LWJGL 3 backend _in the same (!) project_, you need to modify your gdx-tools dependency like this:
   ```groovy
   compile ("com.badlogicgames.gdx:gdx-tools:$gdxVersion") {
      exclude group: 'com.badlogicgames.gdx', module: 'gdx-backend-lwjgl'
   }
   ```

<br/>

And that was it for today’s Status Report – see you all in #8!
