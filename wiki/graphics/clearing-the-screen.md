---
title: Clearing the screen
---
To clear the screen in libGDX is not unlike clearing the screen in a regular OpenGL application. The only difference is in how one accesses the OpenGL context.

The following example accesses the context in an OpenGL ES2 application to clear the frame and depth buffers, setting the color buffer to a solid red color:

```java
@Override
public void render() {

  Gdx.gl.glClearColor( 1, 0, 0, 1 );
  Gdx.gl.glClear( GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT );

  // scene render code...
}
```

Simply set the desired clear color and then call `glClear()` with the desired buffers to clear. You are then free to render a fresh frame with new scene graphics.