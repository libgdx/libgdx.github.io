---
title: Color Markup Language
---
The `BitmapFontCache` class supports in-string colored text through a simple markup language.

Markup is disabled by default. Use the public member [font.getData().markupEnabled](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g2d/BitmapFont.BitmapFontData.html#markupEnabled) to turn it on/off.

The markup syntax is really simple but still versatile:
- **[name]** Sets the color by name. There are a few predefined colors, see the [Colors.reset()](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/Colors.java) method for an exhaustive list. Users can define their own colors through the methods of the [Colors](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Colors.html) class.
- **[#xxxxxxxx]** Sets the color specified by the hex value `xxxxxxxx` in the form `RRGGBBAA` where AA is optional and defaults to 0xFF.
- **[]** Sets the color to the previous color (kind of optional end tag)
- **[[** Escapes the left bracket.

Notice that color names are case-sensitive, cannot be empty, cannot start with neither `#` nor `[`, and cannot contain `]`. Also, any occurrence of `[` in the color name must not be escaped.

Unknown colors, illegal hex codes and unclosed tags are silently ignored and treated as normal text.

For a sample code see the test class [BitmapFontTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/BitmapFontTest.java).

**Note:** When using with Scene2D you have to remove the **fontColor** property from **LabelStyle** definition in the **skin.json** file to have markup coloring work with a Label. 