---
title: Threading
---
All of the `ApplicationListener` methods are called on the same thread. This thread is the rendering thread on which OpenGL calls can be made. For most games it is sufficient to implement both logic updates and rendering in the `ApplicationListener.render()` method, and on the rendering thread.

Any graphics operations directly involving OpenGL need to be executed on the rendering thread. Doing so on a different thread results in undefined behaviour. This is due to the OpenGL context only being active on the rendering thread. Making the context current on another thread has its problems on a lot of Android devices, hence it is unsupported.

To pass data to the rendering thread from another thread we recommend using [`Application.postRunnable()`](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Application.java#L188). This will run the code in the Runnable in the rendering thread in the next frame, before `ApplicationListener.render()` is called.

```java
new Thread(new Runnable() {
   @Override
   public void run() {
      // do something important here, asynchronously to the rendering thread
      final Result result = createResult();
      // post a Runnable to the rendering thread that processes the result
      Gdx.app.postRunnable(new Runnable() {
         @Override
         public void run() {
            // process the result, e.g. add it to an Array<Result> field of the ApplicationListener.
            results.add(result);
         }
      });
   }
}).start();
```

## Which libGDX classes are Thread-safe? ##
No class in libGDX is thread-safe unless **explicitly marked** as thread-safe in the class documentation!

Particularly, you should never perform multi-threaded operations on anything that is graphics or audio related, e.g. use scene2D components from multiple threads.

## HTML5 ##
JavaScript is inherently single-threaded. As such, one of the [limitations of the HTML 5 backend](/wiki/html5-backend-and-gwt-specifics#differences-between-gwt-and-desktop-java) is that threading is not possible. [Web Workers](http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html) might be an option in the future, however, data is passed via message passing between thread. Java uses different threading primitives and mechanisms, porting threading code to Web Workers will not be straight forward.
