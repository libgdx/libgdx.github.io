---
title: Pixmaps
---
# Introduction #

A [Pixmap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Pixmap.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/Pixmap.java) encapsulates image data resident in memory. It supports simple file loading and draw operations for basic image manipulation. The most typical use is preparation of an image for upload to the GPU by wrapping in a 
[Texture](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/Texture.java) instance. There are also methods for image saving/loading through the 
[PixmapIO](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/PixmapIO.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/PixmapIO.java) class. PixmapIO supports uncompressed [PNG](http://en.wikipedia.org/wiki/Portable_Network_Graphics) as well as _CIM_, a compression format peculiar to libGDX which is useful for quick storage access such as during state saving/loading between application focus changes.

*As a Pixmap resides in native heap memory it must be disposed of by calling `dispose()` when no longer needed to prevent memory leaks.*

# Pixmap Creation #

Pixmaps can be created from a _byte array_ containing image data encoded as [JPEG](http://en.wikipedia.org/wiki/Jpeg), [PNG](http://en.wikipedia.org/wiki/Portable_Network_Graphics) or [BMP](http://en.wikipedia.org/wiki/BMP_file_format), a 
[FileHandle](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/files/FileHandle.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/files/FileHandle.java), or a specification of dimensions and a format. Once created it can be further manipulated before being uploaded to an OpenGL [Texture](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/Texture.java)  for rendering or saved for some future use.

The following example creates a 64x64 32-bit RGBA Pixmap, draws a filled green circle inside it, uploads it to a Texture and then disposes of the memory:

```java
Pixmap pixmap = new Pixmap( 64, 64, Format.RGBA8888 );
pixmap.setColor( 0, 1, 0, 0.75f );
pixmap.fillCircle( 32, 32, 32 );
Texture pixmaptex = new Texture( pixmap );
pixmap.dispose();
```

Note that the memory of the Pixmap is no longer needed after being wrapped in the Texture and uploaded to the GPU. It is therefore disposed of. Note also that this Texture will be _unmanaged_ as it was not created from a persistent file, but a volatile piece of memory which was subsequently discarded.

The next example shows a pause/resume life cycle of a typical Android application:

```java

FileHandle dataFile = Gdx.files.external( dataFolderName + "current.cim" );

@Override
public void pause() {
  Pixmap pixmap;
  // do something with pixmap...
  PixmapIO.writeCIM( dataFile, pixmap );
}

@Override
public void resume() {

  if ( dataFile.exists() ) {
    Pixmap pixmap = PixmapIO.readCIM( dataFile );

    // do something with pixmap...
  }
}
```

In the preceding example, _pixmap_ will be written to an external location using a simple compression scheme upon application focus loss, and subsequently upon regaining focus it will be reloaded if extant at the specified location.

# Drawing #

Pixmap supports simple drawing operations such as the drawing of lines, filled or unfilled rectangles and circles, as well as the setting of individual pixels and drawing of other pixmaps. These operations are also affected by color, blending, and filters which are controlled by `setColor()`, `setBlending()`, and `setFilter()` respectively.
