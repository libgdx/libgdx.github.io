---
title: Gdx freetype
---
## Introduction

If you want to draw text in your game, you usually use a [BitmapFont](/wiki/graphics/2d/fonts/bitmap-fonts).
However, there is a downside:

* **BitmapFonts rely on an image, so you have to scale them if you want a different size, which may look ugly.**

You could just save a BitmapFont of the biggest size needed in your game then and you never have to scale up, just down, right?
Well, that's true, but downscaling by large amounts can either look aliased or slightly blurry, depending if mipmapping is used.
[Distance field fonts](https://libgdx.com/wiki/graphics/2d/fonts/distance-field-fonts) aim to solve this, but that's not what this page is about!

A BitmapFont can also take up more storage space than the corresponding TrueType Font (.ttf), though whether these fonts would require more space than gdx-freetype itself depends on your game and target platform.

The solution to your problem is the `gdx-freetype` extension:
  * ship only lightweight .ttf files with your game
  * generate a BitmapFont of your desired size on the fly
  * user might put their own fonts into your game

Tutorial available on [LibGDX.info](https://libgdx.info/basic-label/)

## Details

Since this is an extension, it is not included in your libGDX project by default. How you add the extension differs based on the setup of your project.

### How to put gdx-freetype in your project

#### For projects using Gradle

For new projects, simply select the Freetype option under extensions in the [setup UI](https://libgdx.com/dev/project-generation/).

To add to an existing Gradle project, see [Dependency management with Gradle](/wiki/articles/dependency-management-with-gradle#freetypefont-gradle).

#### HTML5

gdx-freetype is not compatible with HTML5. However, you may use the [gdx-freetype-gwt](https://github.com/intrigus/gdx-freetype-gwt) library by Intrigus to enable HTML5 functionality. Version 1.9.10.1 remains compatible with never versions of libGDX, including 1.10.0.

### How to use gdx-freetype in code

Using the gdx-freetype extension in your code is really simple.

```java
FreeTypeFontGenerator generator = new FreeTypeFontGenerator(Gdx.files.internal("fonts/myfont.ttf"));
FreeTypeFontParameter parameter = new FreeTypeFontParameter();
parameter.size = 12;
BitmapFont font12 = generator.generateFont(parameter); // font size 12 pixels
generator.dispose(); // don't forget to dispose to avoid memory leaks!
```
A much simpler way to display your font is by placing your font file in project's assets folder. You will have to modify the first line of the above code and mention just your font file name in the parameters.

The defaults for the [FreeTypeFontParameter](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/src/com/badlogic/gdx/graphics/g2d/freetype/FreeTypeFontGenerator.java):
```java
/** The size in pixels */
public int size = 16;
/** Foreground color (required for non-black borders) */
public Color color = Color.WHITE;
/** Border width in pixels, 0 to disable */
public float borderWidth = 0;
/** Border color; only used if borderWidth > 0 */
public Color borderColor = Color.BLACK;
/** true for straight (mitered), false for rounded borders */
public boolean borderStraight = false;
/** Offset of text shadow on X axis in pixels, 0 to disable */
public int shadowOffsetX = 0;
/** Offset of text shadow on Y axis in pixels, 0 to disable */
public int shadowOffsetY = 0;
/** Shadow color; only used if shadowOffset > 0 */
public Color shadowColor = new Color(0, 0, 0, 0.75f);
/** The characters the font should contain */
public String characters = DEFAULT_CHARS;
/** Whether the font should include kerning */
public boolean kerning = true;
/** The optional PixmapPacker to use */
public PixmapPacker packer = null;
/** Whether to flip the font vertically */
public boolean flip = false;
/** Whether or not to generate mip maps for the resulting texture */
public boolean genMipMaps = false;
/** Minification filter */
public TextureFilter minFilter = TextureFilter.Nearest;
/** Magnification filter */
public TextureFilter magFilter = TextureFilter.Nearest;
```

If rendering large fonts, the default PixmapPacker page size may be too small. You can provide your own PixmapPacker or use `FreeTypeFontGenerator.setMaxTextureSize` to set the default page size.

You may want to generate your font in your game's `resize ()` event to handle different window resolutions without scaling, being sure to dispose of old BitmapFonts. Your font size should be limited to what your page size can handle, especially on gdx-freetype-gwt, to avoid glitched fonts and crashes.

### Examples

```java
parameter.borderColor = Color.BLACK;
parameter.borderWidth = 3;
```
![images/border.png](/assets/wiki/images/border.png)

```java
parameter.shadowColor = Color.BLACK;
parameter.shadowOffsetX = 3;
parameter.shadowOffsetY = 3;
```
![images/shadow.png](/assets/wiki/images/shadow.png)

You can also load `BitmapFont`s generated via the FreeType extension using AssetManager. See [FreeTypeFontLoaderTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/extensions/FreeTypeFontLoaderTest.java)

### Caveats

Quoting from [https://web.archive.org/web/20201128081723/https://www.badlogicgames.com/wordpress/?p=2300](https://web.archive.org/web/20201128081723/https://www.badlogicgames.com/wordpress/?p=2300):
  * Asian scripts “might” work, see caveat above though. They contain just too many glyphs. I’m thinking about ways to fix this.
  * Right-to-left scripts like Arabic are a no-go. The layout “algorithms” in BitmapFont and BitmapFontCache have no idea how to handle that.
  * Throwing just any font at FreeType is not a super awesome idea. Some fonts in the wild are just terrible, with bad or no hinting information and will look like poopoo.

----

Download an [example](https://hg.sr.ht/~dermetfan/somelibgdxtests)
