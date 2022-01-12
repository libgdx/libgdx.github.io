---
title: Skin
---
 * [Overview](#overview)
 * [Resources](#resources)
 * [Convenience methods](#convenience-methods)
 * [Conversions](#conversions)
 * [Modifying resources](#modifying-resources)
 * [Widget styles](#widget-styles)
 * [Skin JSON](#skin-json)
   * [Color](#color)
   * [BitmapFont](#bitmapfont)
   * [TintedDrawable](#tinteddrawable)

## <a id="Overview"></a>Overview ##

The Skin class stores resources for UI widgets to use. It is a convenient container for texture regions, ninepatches, fonts, colors, etc. Skin also provides convenient conversions, such as retrieving a texture region as a ninepatch, sprite, or drawable.

Skin files from the [libGDX tests](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests-android/assets/data) can be used as a starting point. You will need: `uiskin.png`, `uiskin.atlas`, `uiskin.json`, and `default.fnt`. This enables you to quickly get started using `scene2d.ui` and replace the skin assets later.

Resources in a skin typically come from a [texture atlas](/wiki/tools/texture-packer#textureatlas), widget styles and other objects defined using JSON, and objects added to the skin via code. Even when JSON is not used, it is still recommended to use Skin with a texture atlas and objects added via code. This is much more convenient to obtain instances of drawables and serves as a central place to obtain UI resources.

Useful resources:
* [Ready to use skins.](https://github.com/czyzby/gdx-skins)
* [Skin Composer](https://ray3k.wordpress.com/software/skin-composer-for-libgdx/) is a UI tool for creating and editing skins.
* [Basic skin Label tutorial ](https://libgdx.info/basic-label/)

## <a id="Resources"></a>Resources ##

Each resource in the skin has a name and type. The regions from a [texture atlas](/wiki/tools/texture-packer#textureatlas) can be made available as resources in the skin. Texture regions can be retrieved as a ninepatch, sprite, tiled drawable, or drawable.

```java
TextureAtlas atlas = ...
Skin skin = new Skin();
skin.addRegions(atlas);
...
TextureRegion hero = skin.get("hero", TextureRegion.class);
```

Resources can also be defined for a skin using JSON ([see below](#skin-json)) or added using code:

```java
Skin skin = new Skin();
skin.add("logo", new Texture("logo.png"));
...
Texture logo = skin.get("logo", Texture.class);
```

## <a id="Convenience_Methods"></a>Convenience Methods ##

There are convenience methods to retrieve resources for commons types.

```java
Skin skin = ...
Color red = skin.getColor("red");
BitmapFont font = skin.getFont("large");
TextureRegion region = skin.getRegion("hero");
NinePatch patch = skin.getPatch("header");
Sprite sprite = skin.getSprite("footer");
TiledDrawable tiled = skin.getTiledDrawable("pattern");
Drawable drawable = skin.getDrawable("enemy");
```

These methods are identical to passing in the appropriate class, but allow for slightly more concise code.

## <a id="Conversions"></a>Conversions ##

All styles for UI widgets use a [Drawable](https://github.com/sinistersnare/libgdx/wiki/Scene2d.ui#drawable) when they need an image. This allows a texture region, ninepatch, sprite, etc to be used anywhere in the UI. Skin makes it easy to convert textures and texture regions to drawables and other types:

```java
Skin skin = new Skin();
skin.add("logo", new Texture("logo.png"));
...
Texture texture = skin.get("logo", Texture.class);
TextureRegion region = skin.getRegion("logo");
NinePatch patch = skin.getPatch("logo");
Sprite sprite = skin.getSprite("logo");
TiledDrawable tiled = skin.getTiledDrawable("logo");
Drawable drawable = skin.getDrawable("logo");
```

A texture region can be retrieved as a ninepatch, sprite, tiled drawable, or drawable. The first time a conversion is made, a new object is allocated and stored in the skin. Subsequent retrievals will return the stored object.

When converting a texture region to a drawable, the skin will choose the most appropriate drawable for that region. If the region is an AtlasRegion with ninepatch split information, then a NinePatchDrawable is returned. If the region is an AtlasRegion that has been rotated or whitespace stripped, then a SpriteDrawable is returned so the region will be drawn correctly. Otherwise, a TextureRegionDrawable is returned.

## <a id="Modifying_resources"></a>Modifying resources ##

Resources obtained from the skin are not new instances, the same object is returned each time. If the object is modified, the changes will be reflected throughout the application. If this is not desired, a copy of the object should be made.

The `newDrawable` method copies a drawable. The new drawable's size information can be changed without affecting the original. The method can also tint a drawable.

```java
Skin skin = ...
...
Drawable redDrawable = skin.newDrawable("whiteRegion", Color.RED);
```

Note the new drawable is not stored in the skin. To store it in the skin it must be explicitly added with a name like any other resource.

## <a id="Widget_styles"></a>Widget styles ##

Skin is a useful container for providing texture regions and other resources that UI widgets need. It can also store the UI widget styles that define how widgets look.

```java
TextButtonStyle buttonStyle = skin.get("bigButton", TextButtonStyle.class);
TextButton button = new TextButton("Click me!", buttonStyle);
```

All widgets have convenience methods for passing the skin and the style name:

```java
TextButton button = new TextButton("Click me!", skin, "bigButton");
```

If the style name is omitted, the name "default" is used:

```java
TextButton button = new TextButton("Click me!", skin);
```

## <a id="Skin_JSON"></a>Skin JSON ##

A skin can be [populated programmatically](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/UISimpleTest.java#L37). Alternatively, JSON can be used to describe named objects in the skin. This makes it convenient to define the UI widget styles. Note the JSON does not describe texture regions, ninepatche splits, or other information which comes from the [texture atlas](/wiki/tools/texture-packer). However, the JSON may reference the regions, ninepatches, and other resources in the skin by name. The JSON looks like this:

```
{
	className: {
		name: resource,
		...
	},
	className: {
		name: resource,
		...
	},
	...
}
```

`className` is the fully qualified Java class name for the objects. `name` is the name of each resource. `resource` is the JSON for the actual resource object. The JSON corresponds exactly to the names of the fields in the resource's class. Here is a real example:

```
{
	com.badlogic.gdx.graphics.Color: {
		white: { r: 1, g: 1, b: 1, a: 1 },
		red: { r: 1, g: 0, b: 0, a: 1 },
		yellow: { r: 0.5, g: 0.5, b: 0, a: 1 }
	},
	com.badlogic.gdx.graphics.g2d.BitmapFont: {
		medium: { file: medium.fnt }
	},
	com.badlogic.gdx.scenes.scene2d.ui.TextButton$TextButtonStyle: {
		default: {
			down: round-down, up: round,
			font: medium, fontColor: white
		},
		toggle: {
			down: round-down, up: round, checked: round-down,
			font: medium, fontColor: white, checkedFontColor: red
		},
		green: {
			down: round-down, up: round,
			font: medium, fontColor: { r: 0, g: 1, b: 0, a: 1 }
		}
	}
}
```

First, some colors and a font are defined. Next, some text button styles are defined. The fields `down`, `up`, and `checked` are of type Drawable. An object is expected but a string is found in the JSON, so the string is used as a name to look up the drawable in the skin. The same thing happens for the font and colors, except for the "green" text button style, which defines a new color inline.

Note that order is important. A resource must be declared in the JSON above where it is referenced. Also note that the JSON that libGDX uses differentiates from the standard, where quotes are not used to define keys or values.

Skin files from the [libGDX tests](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests-android/assets/data) can be used as a starting point: uiskin.png, uiskin.atlas, uiskin.json, and default.fnt.

Loading and configuring a freetype font via the skin json file requires some additional steps. Either use [Scene Composer](https://github.com/raeleus/skin-composer/wiki/Creating-FreeType-Fonts#using-a-custom-serializer) or a library like [freetype-skin](https://github.com/acanthite/freetype-skin).

### <a id="Color"></a>Color ###

Colors are defined in JSON as shown above. If the `r`, `g`, or `b` properties are omitted, 0 is used. If `a` is omitted, 1 is used.

Alternatively, you can specify the color by hex value:
```
com.badlogic.gdx.graphics.Color: {
	skyblue: { hex: 489affff }
}
```

### <a id="BitmapFont"></a>BitmapFont ###

A bitmap font is declared in the JSON like this:

```
{
	com.badlogic.gdx.graphics.g2d.BitmapFont: {
		medium: { file: medium.fnt,
                  scaledSize: -1, //integer height of capital letters, default -1 for unscaled
                  markupEnabled: false,
                  flip : false}
	}
}
```

To find the font's BMFont file, first the skin looks in the directory containing the skin file. If not found, it uses the specified path as an internal path.

To find the font's image file, first the skin looks for a texture region with the same name as the font file, without the file extension. If not found, it will look in the directory containing the font file for an image with the same name as the font file, but with a "png" file extension.

### <a id="TintedDrawable"></a>TintedDrawable ###

It is very useful to tint regions various colors. For example, the regions for a white button can be tinted to have a button of any color. Drawables can be tinted in code using the `newDrawable` method. The Skin.TintedDrawable class provides a way to tint drawables in JSON:

```
{
	com.badlogic.gdx.graphics.Color: {
		green: { r: 0, g: 1, b: 0, a: 1 }
	},
	com.badlogic.gdx.scenes.scene2d.ui.Skin$TintedDrawable: {
		round-green: { name: round, color: green }
	}
}
```

This makes a copy of the drawable named "round", tints it green, and adds it to the skin as a drawable under the name "round-green".