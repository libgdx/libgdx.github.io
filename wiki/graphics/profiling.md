---
title: Profiling
---
This article describes the little helpers and utilities that might come in handy in case you are running into performance problems and need to start profiling your game.

# FPSLogger

The [`FPSLogger`](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/FPSLogger.html) is a simple helper class to log the frames per seconds achieved. Just invoke the `log()` method in your rendering method. The output will be logged once per second.

# PerformanceCounter

The [`PerformanceCounter`](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/PerformanceCounter.html) keeps track of the time and load (percentage of total time) a specific task takes. Call `start()` just before starting the task and `stop()` right after. You can do this multiple times if required. Every render or update call `tick()` to update the values. The `time` FloatCounter provides access to the minimum, maximum, average, total and current time the task takes. Likewise for the `load` value, which is the percentage of the total time.

# OpenGL
## Profiling
Profiling the actual OpenGL calls that happen while your game is running is often not very easy to do, since libGDX tries to abstract all those low-level things away. In order to enable the collection of these information, there is the [`GLProfiler`](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/profiling/GLProfiler.html).

To enable it you have to call the static method `GLProfiler.enable()`. Behind the scenes this will replace the original `GL20` and `GL30` instances (`Gdx.gl` etc.) with the profilers.

Now those will be active and start to monitor the actual GL calls (and GL errors, see below) for you. One information you might be interested in, could be the amount of texture bindings that happen, which are costly and might slow down your game. To optimize this, you might start to use a `TextureAtlas`. To prove with actual numbers that the texture bindings become less, you can read the static field `GLProfiler.textureBindings` from the profiler.

You might also implement something like view frustum culling to render only those things that are visible on the screen. The static field `GLProfiler.drawCalls` will show the results of these kind of optimizations.

Currently the following informations are provided by the profiler:
- Amount of total OpenGL calls
- Amount of draw calls
- Amount of texture bindings
- Amount of shader switches
- Amount of used vertices

`GLProfiler.vertexCount` is actually a [`FloatCounter`](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/FloatCounter.html). Besides `GLProfiler.vertexCount.total` it has more information like `GLProfiler.vertexCount.min`, `GLProfiler.vertexCount.max` or `GLProfiler.vertexCount.average`, which are the values based on individual drawcalls.

In order to reset all these numbers once you have read and displayed them (probably once per frame), you have to call the `GLProfiler.reset()` method. To completely disable the profiling and replace the profilers with the original `GL20` and `GL30` instances, use `GLProfiler.disable()`.

*Note that in case you are using `Gdx.graphics.getGL20()` or `Gdx.graphics.getGL30()` you are bypassing the profiler and that's why you should use `Gdx.gl20` or `Gdx.gl30` directly.*

To see how to use this you can have a look at the [Benchmark3DTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/g3d/Benchmark3DTest.java)

## Error checking _(since 1.6.5)_
`GLProfiler` has one more useful feature and that is error checking.

Almost all GL calls can in some circumstances produce errors. These errors are not thrown or logged like Java errors, but they have to be explicitly checked for (`Gdx.gl.getError()`), so they can be hard to find. Enabled `GLProfiler` (see above on how to enable) will automatically check for GL errors after every GL call and report it, so you don't have to.

By default, encountered errors will be printed to console (using `Gdx.app.error`). However, this can be customized (for example for your own logging/crash reporting system) by setting up a different error listener in [`GLProfiler.listener`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/profiling/GLProfiler.html#listener).

If you want to know where exactly did the error happen in your code, you may want to use the [`GLErrorListener.THROWING_LISTENER`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/profiling/GLErrorListener.html#THROWING_LISTENER) which throws an exception on any GL error. Error listener callback is called inside GL call, so the stack trace will reveal where exactly things went wrong. _(Throwing an exception on GL error will most likely crash your application in case of errors, so it is not used by default.)_

For example use and testing, there is a [GLProfilerErrorTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/GLProfilerErrorTest.java)

# apitrace

[apitrace](https://github.com/apitrace/apitrace) is an open source cross platform debugger and profiler for OpenGL. You run the tracer to record the state and each call (including contents of buffers). You then run the viewing tool will read the trace and playback any state at any point in time. It breaks down the cpu/gpu time, every single OpenGL call. You can see the contents of the framebuffer and each texture bound at any point you choose.

Running:
For linux, do:
```apitrace trace java -cp /home/me/my-app/desktop/build/libs/*.jar  -Dorg.lwjgl.opengl.libname=/usr/lib/apitrace/wrappers/glxtrace.so com.my.app.desktop.DesktopLauncher```
 
Then just exit your app (if you want), run ```qapitrace``` and open that trace file.
