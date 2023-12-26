---
title: Taking a Screenshot
---
Screenshots are easy in libGDX!

## No post-processing

The basic way of taking a screenshot is to call `Pixmap.createFromFrameBuffer` (formerly: `ScreenUtils#getFrameBufferPixmap`) and then write that pixmap to the disk:

```java
Pixmap pixmap = Pixmap.createFromFrameBuffer(0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
PixmapIO.writePNG(Gdx.files.external("mypixmap.png"), pixmap, Deflater.DEFAULT_COMPRESSION, true);
pixmap.dispose();
```

## Post processing to guarantee clarity

However, if your screens have layered transparency, you need to postprocess the screenshot to remove any transparency. Otherwise the screenshots won't look like what the user is expecting:

```java
Pixmap pixmap = Pixmap.createFromFrameBuffer(0, 0, Gdx.graphics.getBackBufferWidth(), Gdx.graphics.getBackBufferHeight());
ByteBuffer pixels = pixmap.getPixels();

// This loop makes sure the whole screenshot is opaque and looks exactly like what the user is seeing
int size = Gdx.graphics.getBackBufferWidth() * Gdx.graphics.getBackBufferHeight() * 4;
for (int i = 3; i < size; i += 4) {
	pixels.put(i, (byte) 255);
}

PixmapIO.writePNG(Gdx.files.external("mypixmap.png"), pixmap, Deflater.DEFAULT_COMPRESSION, true);
pixmap.dispose();
```

The **GWT backend has some limitations** in this regard, which require additional steps outlined [here](https://github.com/libgdx/libgdx.github.io/pull/108#issuecomment-1175176650).
