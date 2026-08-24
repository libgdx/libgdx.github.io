---
title: Bitmap fonts
---
libGDX makes use of bitmap files (PNGs) to render fonts. Each glyph in the font has a corresponding TextureRegion.

[BitmapFont class](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g2d/BitmapFont.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g2d/BitmapFont.java)

BitmapFont was refactored for the libGDX 1.5.6 release. [This blog post](https://web.archive.org/web/20200928220256/https://www.badlogicgames.com/wordpress/?p=3658) has details about the changes and also a small example showing how to move from pre 1.5.6 code to the new API.

A tutorial on using BitmapFont is available on [https://libgdxinfo.wordpress.com](https://libgdxinfo.wordpress.com/basic-label/)

## File format specifications for the font file

References point to bmFont being originally created by Andreas Jönsson over at [AngelCode](https://www.angelcode.com/)

[BMFont](https://www.angelcode.com/products/bmfont/doc/file_format.html) - the original specification for the file format.

## Tools for Creating Bitmaps

* [Hiero](/wiki/tools/hiero) - a utility for converting a system font to a bitmap
* [Skin Composer](/wiki/tools/skin-composer) - includes a BitmapFont editor and Image font generator
* [BMFont](https://www.angelcode.com/products/bmfont/) - a Windows tool with supersampling features for smoother glyphs
* [bmGlyph](https://www.bmglyph.com/) - a macOS tool with support for custom images
* [fontwriter](https://github.com/tommyettinger/fontwriter) - a command line tool to generate fonts for use with the [TextraTypist](https://github.com/tommyettinger/textratypist) or [BitmapFontBridge](https://github.com/tommyettinger/BitmapFontBridge) libraries

## Other Tools

[FreeTypeFontGenerator](https://web.archive.org/web/20200423064636/ttp://www.badlogicgames.com/wordpress/?p=2300) - generating bitmaps for fonts instead of supplying a pre-rendered bitmap made by utilities like Hiero

Examples
: [(more)](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/extensions/InternationalFontsTest.java)

```java
FreeTypeFontGenerator generator = new FreeTypeFontGenerator(Gdx.files.internal("unbom.ttf"));
parameter.size = 18;
parameter.characters = "한국어/조선말";
BitmapFont koreanFont = generator.generateFont(parameter);
generator.dispose();
```

[Distance field fonts](/wiki/graphics/2d/fonts/distance-field-fonts) - useful for scaling/rotating fonts without ugly artifacts

## Fonts in 3D space
While libGDX does not support placing text in 3D space directly, it is still possible to do so relatively easily. Check [this gist](https://gist.github.com/Darkyenus/e9427b0655816d2a521227cb9313d303) for an example. Note that such text won't be occluded by objects in front of it, as `SpriteBatch` draws with constant `z`, but it would not be hard to fix that with a custom shader, that would set the appropriate 'z' from an uniform.

## Fixed-Width Fonts
Fonts that need to be displayed with the same width for every glyph present a special problem. The initial blank space at left before narrow chars such as `|` won't be shown by default, and the narrow char will "cling" to just after the previous char, without the intended blank space. This also can cause issues with the width of that char being smaller, and that makes multiple lines of text unaligned with each other. There's an existing `BitmapFont#setFixedWidthGlyphs(CharSequence)` method, which solves all this for the chars you have in the given `CharSequence` (usually a String). The catch is, you need to list every glyph in the font that needs to have the same width, and this can be a significant hassle for large fonts. If you're sticking to ASCII or a small extension of it, Hiero has ASCII and NeHe buttons to fill the text field with those common smaller character sets, and you can copy that text into a String you pass to `setFixedWidthGlyphs()`. If you have a fixed-width font where the list of all chars that you could use is very large or unknown, you can use this code to set every glyph to fixed-width, using the largest glyph width for every glyph:

```java
public static void setAllFixedWidth(BitmapFont font) {
    BitmapFont.BitmapFontData data = font.getData();
    int maxAdvance = 0;
    for (int index = 0, end = 65536; index < end; index++) {
        BitmapFont.Glyph g = data.getGlyph((char) index);
        if (g != null && g.xadvance > maxAdvance) maxAdvance = g.xadvance;
    }
    for (int index = 0, end = 65536; index < end; index++) {
        BitmapFont.Glyph g = data.getGlyph((char) index);
        if (g == null) continue;
        g.xoffset += (maxAdvance - g.xadvance) / 2;
        g.xadvance = maxAdvance;
        g.kerning = null;
        g.fixedWidth = true;
    }
}
```
