---
title: Frame buffer objects
---
Framebuffers allow users to render stuff to a texture instead of to the screen (= the backbuffer). This can prove useful in various ways, for example to perform post processing effects.

## How to use framebuffers

Let's create a `FrameBuffer`:

```java
FrameBuffer fbo = new FrameBuffer(Format.RGBA8888, 1024, 720, false);
```

Now, to render anything to the framebuffer, it has to be bound (via `begin()` and `end()`):

```java
fbo.begin();
Gdx.gl.glClearColor(1, 1, 1, 1);
Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

batch.begin();
batch.draw(anyCoolSprite, 0, 0);
batch.end();

fbo.end();
```

To retrieve the stuff rendered to the framebuffer, one has to call `getColorBufferTexture()`:

```java
Texture texture = fbo.getColorBufferTexture();
TextureRegion textureRegion = new TextureRegion(texture);
textureRegion.flip(false, true);
```

As you can see above, the texture is flipped via use of a TextureRegion. This is done, because the framebuffer textures are generally upside-down.

If you just want to draw the framebuffer's texture on screen, you can also use this to flip the texture:
```java
batch.draw(fbo.getColorTexture(), x, y, w, h, 0, 0, 1, 1)
```

## Common Issues
### Nesting
Please note, that the default framebuffers of libGDX cannot be nested (i.e. used _inside_ of each other). This is due to `FrameBuffer.end()` always binding the back buffer, even if it wasn't the previously bound buffer. A detailed description of this can be found [here](https://github.com/crykn/libgdx-screenmanager/wiki/Custom-FrameBuffer-implementation#the-problem). To work around this problem, FrameBuffer can be extended and the `end()` method overridden. If you don't want to implement this yourself, there are some community options.

### Hdpi
If you're having an hdpi display, rendering scene2d stuff inside of a framebuffer causes problems with clipping, which is used, for example, in dialogs. To fix this, either set the size of your framebuffer to the real pixel size (instead of the logical size):

```java
FrameBuffer fbo = new FrameBuffer(Format.RGBA8888, HdpiUtils.toBackBufferX(currentWidth), HdpiUtils.toBackBufferY(currentHeight), false);
```

or temporarily switch the hdpi mode:

```java
HdpiUtils.setMode(HdpiMode.Pixels);
fbo.begin();
stage.draw();
fbo.end();
HdpiUtils.setMode(HdpiMode.Logical);
```

## Further resources
- [A LWJGL tutorial regarding framebuffers (has a libGDX version of the used code as well)](https://github.com/mattdesl/lwjgl-basics/wiki/FrameBufferObjects)