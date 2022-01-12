---
title: Taking a Screenshot
---
Screenshots are easy in libGDX!

## Post processing to guarantee clarity

This will guarantee your screenshots look like just like what the user expects:

```java
byte[] pixels = Pixmap.createFromFrameBuffer(0, 0, Gdx.graphics.getBackBufferWidth(), Gdx.graphics.getBackBufferHeight(), true);

// This loop makes sure the whole screenshot is opaque and looks exactly like what the user is seeing
for (int i = 4; i <= pixels.length; i += 4) {
    pixels[i - 1] = (byte) 255;
}

Pixmap pixmap = new Pixmap(Gdx.graphics.getBackBufferWidth(), Gdx.graphics.getBackBufferHeight(), Pixmap.Format.RGBA8888);
BufferUtils.copy(pixels, 0, pixmap.getPixels(), pixels.length);
PixmapIO.writePNG(Gdx.files.external("mypixmap.png"), pixmap);
pixmap.dispose();
```

## No post-processing

If you have no layered transparency, here's a more compact and efficient way:

```java
Pixmap pixmap = Pixmap.createFromFrameBuffer(0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
PixmapIO.writePNG(Gdx.files.external("mypixmap.png"), pixmap, Deflater.DEFAULT_COMPRESSION, true);
pixmap.dispose();
```
