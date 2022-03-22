---
title: The application framework
---
## Modules
At its core, libGDX consists of six [modules](/wiki/app/modules-overview) in the form of interfaces that provide means to interact with the operating system. Each backend implements these interfaces.

  * *[Application](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Application.java)*: runs the application and informs an API client about application level events, such as window resizing. Provides logging facilities and querying methods, e.g., memory usage.
  * *[Files](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Files.java)*: exposes the underlying file system(s) of the platform. Provides an abstraction over different types of file locations on top of a custom file handle system (which does not inter-operate with Java's File class).
  * *[Input](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Input.java)*: informs the API client of user input such as mouse, keyboard, touch or accelerometer events. Both polling and event driven processing are supported.
  * *[Net](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Net.java)*: provides means to access resources via HTTP/HTTPS in a cross-platform way, as well as create TCP server and client sockets.
  * *[Audio](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Audio.java)*: provides means to playback sound effects and streaming music as well as directly accessing audio devices for PCM audio input/output.
  * *[Graphics](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Graphics.java)*: exposes OpenGL ES 2.0 (where available) and allows querying/setting video modes and similar things.

## Starter Classes
The only platform specific code that needs to be written, are so called [starter classes](/wiki/app/starter-classes-and-configuration). For each platform that is targeted, a piece of code will instantiate a concrete implementation of the Application interface, provided by the back-end for the platform. For the desktop, this might look something like this, using the LWJGL 3 backend:

```java
public class DesktopLauncher {
   public static void main(String[] args) {
      Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
      new Lwjgl3Application(new MyGdxGame(), config);
   }
}
```

For Android, the corresponding starter class might look like this:

```java
public class AndroidStarter extends AndroidApplication {
   public void onCreate(Bundle bundle) {
      super.onCreate(bundle);
      AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
      initialize(new MyGame(), config);
   }
}
```

These two classes usually live in separate projects, e.g., a desktop and an Android project. The [Project Generation](/wiki/start/project-generation) page describes the layout of these projects.

The actual code of the application is located in a class that implements the [ApplicationListener](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/ApplicationListener.java) interface (MyGame in the above example). An instance of this class is passed to the respective initialization methods of each back-end's Application implementation (see above). The application will then call into the methods of the ApplicationListener at appropriate times (see [The Life-Cycle](/wiki/app/the-life-cycle)).

See [Starter Classes & Configuration](/wiki/app/starter-classes-and-configuration) for details on starter classes.

## Accessing Modules
The modules described earlier can be accessed via static fields of the [Gdx class](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Gdx.java). This is essentially a set of global variables that allows easy access to any module of libGDX. While generally viewed as bad coding practice, we decided on using this mechanism to ease the pain usually associated with passing around references to things that are used often in all kinds of places within the code base.

To access, for example, the audio module one can simply write the following:

```java
// creates a new AudioDevice to which 16-bit PCM samples can be written
AudioDevice audioDevice = Gdx.audio.newAudioDevice(44100, false);
```

`Gdx.audio` is a reference to the backend implementation that has been instantiated on application startup by the Application instance. Other modules are accessed in the same fashion, e.g., `Gdx.app` to get the Application, `Gdx.files` to access the Files implementation and so on.
