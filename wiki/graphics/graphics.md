---
title: Graphics
---
# REWRITE THIS
This page needs to be rewritten.

# Introduction

The [Graphics](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Graphics.html) module provides information about the current device display and application window as well as information about and access to the current OpenGL context. Specifically, information regarding screen size, pixel density, and frame-buffer properties such as color-depth, depth/stencil buffers, and anti-aliasing capabilities can all be found within this class. As with other common modules, access is provided via static fields of the [Gdx class](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Gdx.html).

# OpenGL Context

A particular use of this module concerns more direct access to the current OpenGL context for lower-level commands and queries.

The following example accesses the context in an OpenGL ES2 application to set the viewport and clear the frame and depth buffers:

```java
Gdx.gl20.glViewport( 0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight() );
Gdx.gl20.glClearColor( 0, 0, 0, 1 );
Gdx.gl20.glClear( GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT );
```

Note the use of `getWidth()` / `getHeight()` to access the current application window dimensions in setting the viewport as well as the use of constants from the `GL20` class just as one would do in a regular OpenGL program. A key advantage in libGDX is the ability to access low level functionality whenever higher level abstraction does not suffice.

Each version of OpenGL ES is available through its own respective interface as well as a GLCommon ( **that doesn't exist, this article needs to be rewritten!** ) interface for version agnostic commands. Note that use of [GL20](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/GL20.html) requires instructing the application to use OpenGL ES2 upon start-up.

Access to the OpenGL Utility class ( **that doesn't exist, this article needs to be rewritten!** ) is also provided, although this functionality may be better handled through Libgdx's own [Orthographic](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/OrthographicCamera.java) and [Perspective](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/PerspectiveCamera.java) camera classes. There is also a simple method for querying support for named extensions in `supportsExtension()`. Just supply the name of the extension to determine support on the current device.

# Frame Time

One particularly useful method in the Graphics class is `getDeltaTime()`, which provides the time elapsed since the last rendered frame. This can be useful for time-based animation when frame independence is not necessary. For instance [Actor](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/scenes/scene2d/Actor.java) or [UI](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/#gdx%2Fscenes%2Fscene2d%2Fui) animation in a [Stage](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/scenes/scene2d/Stage.java) instance might be controlled by a call such as the following in the application's render method:

```java
stage.act( Math.min( Gdx.graphics.getDeltaTime(), 1/30 ) );
```

Notice the use of a maximum time step of 1/30 seconds. This is to avoid potentially large jerks in the resulting animation. This illustrates the fact that while `getDeltaTime()` can be useful for simple animations, it is still frame dependent and more sensitive actions such as game logic or physics simulation may benefit from [other timing strategies](https://gafferongames.com/post/fix_your_timestep/).

Another useful method is `getFramesPerSecond()`, which returns a running average of the current frame-rate for simple diagnostic purposes. However for more serious profiling efforts, the use of [FPSLogger](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/FPSLogger.java) is recommended.

# Platform Differences

On the desktop, the Graphics class also provides the ability to set a window's icon and title values. Obviously these methods have no effect on platforms which lack an icon or title.

The methods `setDisplayMode()` and `setVSync()` set the display mode to full-screen/windowed and enable/disable vertical display sync respectively. Keep in mind these methods have effects only on certain platforms.
