---
title: Hiero
---
Hiero is a bitmap font packing tool. It saves in the [Angel Code font](https://www.angelcode.com/products/bmfont/) format, which can be used by [BitmapFont](/wiki/graphics/2d/fonts/bitmap-fonts) in libGDX applications.

![](/assets/wiki/images/hiero01.png)

## Running Hiero

You can download the .jar file [here](https://libgdx-nightlies.s3.eu-central-1.amazonaws.com/libgdx-runnables/runnable-hiero.jar). Make it executable (if you are on a UNIX-like operating system) and then run it.

As Hiero still runs on our LWJGL 2 backend, it may have trouble with newer Java versions. If you want to be on the safe side, use [Adoptium's OpenJDK 8](https://adoptium.net/index.html).
{: .notice--warning}

If you are using Gradle and you added "Tools" extension to your project, you can easily run Hiero from your IDE, otherwise look at Downloading Hiero.

Example for IntelliJ IDEA: Go to the Hiero class, right click and select `Run Hiero.main()`. On the `Run configurations` popup that will appear, select the `Desktop` module, and click `Run`.

## Rasterization

Hiero has multiple options for rasterizing fonts:

 * FreeType is typically the highest quality. It makes good use of hinting, which means that small fonts are rendered nicely. The `gamma` setting controls how much antialiasing is done. The `mono` setting disables all font smooth. No other effects are supported, though glyphs can be rendered with padding and effects applied via Photoshop or other tools. Hiero uses gdx-freetype, so generated bitmap fonts will exactly match those rendered on the fly by gdx-freetype.
 * Java's font rendering provides the vector outline for the glyphs which allows various effects to be applied, such as a drop shadow, outline, etc. Output is often blurry at small sizes, but larger sizes are good quality.
 * OS native rendering is the most simplistic. It does not provide tightly fitting bounds, so glyphs take up more atlas space.

Hiero will output kerning information for fonts with kerning entries.

## Command line arguments

Hiero supports 4 command line arguments:

* `--input <file>` or `-i <file>` loads the specified `.hiero` configuration file when launching.
* `--output <file>` or `-o <file>` sets the output `.fnt` file to the specified value.
* `--batch` or `-b` makes hiero  automatically generate it's output and close to be used without human intervention.
* `--scale <scale>` or `-s <scale>` scales the font by the specified amount.

## Alternatives

### BitmapFontWriter

BitmapFontWriter is a class in gdx-tools which can write BMFont files from a BitmapFontData instance. This allows a font to be generated using FreeTypeFontGenerator, then written to a font file and PNG files. BitmapFontWriter has the benefit that it can be more easily run from scripts and can make use of FreeTypeFontGenerator's shadows and borders. Otherwise, the output is very similar to Hiero, though Hiero avoids writing a glyph image multiple times if different character codes render the same glyph.

Usage can look like this:

```java
new LwjglApplication(new ApplicationAdapter() {
	public void create () {
		FontInfo info = new FontInfo();
		info.padding = new Padding(1, 1, 1, 1);

		FreeTypeFontParameter param = new FreeTypeFontParameter();
		param.size = 13;
		param.gamma = 2f;
		param.shadowOffsetY = 1;
		param.renderCount = 3;
		param.shadowColor = new Color(0, 0, 0, 0.45f);
		param.characters = Hiero.EXTENDED_CHARS;
		param.packer = new PixmapPacker(512, 512, Format.RGBA8888, 2, false, new SkylineStrategy());

		FreeTypeFontGenerator generator = new FreeTypeFontGenerator(Gdx.files.absolute("some-font.ttf"));
		FreeTypeBitmapFontData data = generator.generateData(param);

		BitmapFontWriter.writeFont(data, new String[] {"font.png"},
			Gdx.files.absolute("font.fnt"), info, 512, 512);
		BitmapFontWriter.writePixmaps(param.packer.getPages(), Gdx.files.absolute("imageDir"), name);

		System.exit(0);
	}
});
```

### Glyph Designer

[Glyph Designer](https://www.71squared.com/glyphdesigner) is a commercial bitmap font tool designed specifically for Mac. It allows you to create beautifully styled text with custom backgrounds, gradient fills, gradient strokes & shadows. The command line interface allows you to export multi-lingual character sets and target multiple device profiles. At time of writing Glyph Designer is priced at $39.99.

### BMFont

The [BMFont](https://www.angelcode.com/products/bmfont/) tool uses FreeType. It has additional supersampling features for smoother glyphs. BMFont does not support effects like drop-shadows or outlines, but glyphs can be output with padding and effects applied with Paint.NET, Photoshop, etc.

BMFont is Windows only but can be run using [Wine](https://www.winehq.org/). There are reports that it hangs if the space character is exported. The space character can be added manually, eg:
```
char id=32   x=0   y=0    width=0     height=0     xoffset=0    yoffset=0    xadvance=3     page=0  chnl=15
```
Change the xadvance as needed, this is the number of pixels for a space character.

### TWL Theme Editor

The [TWL](https://web.archive.org/web/20181029091157/http://twl.l33tlabs.org/) Theme Editor has a font tool that also uses FreeType. It doesn't support the supersampling. [Theme Editor JWS](https://web.archive.org/web/20180113081423/http://twl.l33tlabs.org/themer/themer.jnlp).

### gdx-fontpack

The [gdx-fontpack](https://github.com/mattdesl/gdx-fontpack) tool also uses FreeType. It doesn't yet support supersampling.

### FontPacker

The [FontPacker](https://web.archive.org/web/20190910225125/http://www.java-gaming.org/topics/fontpacker-pack-truetype-fonts-into-your-game/30219/view.html) tool is written in C# and uses .NET's TextRenderer, FontFamily, and Graphics classes to render.

### ShoeBox

[ShoeBox](http://renderhjs.net/shoebox/) has a tool for creating Angel Code fonts.

### JME

jMonkeyEngine has an Angel Code [font tool](https://web.archive.org/web/20120104011845/http://jmonkeyengine.org/groups/jmonkeyplatform/forum/topic/font-creator-for-jmp/), though it looks simplistic and most likely uses Java's font rendering.

### bmglyph

The [bmglyph](http://www.bmglyph.com/) tool is for OS X only and hasn't been evaluated.

### Littera

[https://kvazars.com/littera/littera.swf](https://kvazars.com/littera/littera.swf) (requires [Adobe Flash Player](https://www.adobe.com/support/flashplayer/debug_downloads.html))
