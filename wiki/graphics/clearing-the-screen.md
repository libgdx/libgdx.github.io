---
title: Clearing the screen
---
When rendering a new screen, we should clear the old screen first, i.e. dispose the current data held in the color buffer etc. In the following example, we'll clear both the color and depth buffer and set the color buffer to a solid red color (r: `1`, g: `0`, b: `0`, a: `1`). After that, we can start rendering stuff over our red background:

```java
@Override
public void render() {
  ScreenUtils.clear(1, 0, 0, 1, true);

  // Rendering stuff...
}
```

Simply call `ScreenUtils#clear` with the desired clear color and `clearDepth` true to clear the depth buffer as well. You are then free to render a fresh frame with new scene graphics. Internally, this code calls  `Gdx.gl.glClearColor( 1, 0, 0, 1 )` and `Gdx.gl.glClear( GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT )`. You can fall back to this if you need more granular control over the clearing, for example if you want to clear the stencil buffer (`GL20.GL_STENCIL_BUFFER_BIT`) as well.
