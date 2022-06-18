---
title: Taking a Screenshot
---
Screenshots are easy in libGDX!

## Post processing to guarantee clarity

This will guarantee your screenshots look like just like what the user expects:

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

## No post-processing

If you have no layered transparency, here's a more compact and efficient way:

```java
Pixmap pixmap = Pixmap.createFromFrameBuffer(0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
PixmapIO.writePNG(Gdx.files.external("mypixmap.png"), pixmap, Deflater.DEFAULT_COMPRESSION, true);
pixmap.dispose();
```
