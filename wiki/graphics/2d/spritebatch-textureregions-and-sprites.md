---
title: Spritebatch, Textureregions, and Sprites
---
This page gives a brief overview of how images are drawn using OpenGL and how libGDX simplifies and optimizes the task through the `SpriteBatch` class.

## Drawing images

An image that has been decoded from its original format (e.g., PNG) and uploaded to the GPU is called a texture. To draw a texture, geometry is described and the texture is applied by specifying where each vertex in the geometry corresponds on the texture. For example, the geometry could be a rectangle and the texture could be applied so that each corner of the rectangle corresponds to a corner of the texture. A rectangle that is a subset of a texture is called a texture region.

To do the actual drawing, first the texture is bound (i.e., made the current texture), then the geometry is given to OpenGL to draw. The size and position on the screen that the texture is drawn is determined by both the geometry and how the [OpenGL viewport](https://web.archive.org/web/20200427232345/https://www.badlogicgames.com/wordpress/?p=1550) is configured. Many 2D games configure the viewport to match the screen resolution. This means that the geometry is specified in pixels, which makes it easy to draw textures in the appropriate size and position on the screen.

It is very common to draw a texture mapped to rectangular geometry. It is also very common to draw the same texture or various regions of that texture many times. It would be inefficient to send each rectangle one at a time to the GPU to be drawn. Instead, many rectangles for the same texture can be described and sent to the GPU all at once. This is what the `SpriteBatch` class does.

`SpriteBatch` is given a texture and coordinates for each rectangle to be drawn. It collects the geometry without submitting it to the GPU. If it is given a texture different than the last texture, then it binds the last texture, submits the collected geometry to be drawn, and begins collecting geometry for the new texture.

Changing textures every few rectangles that are drawn prevents `SpriteBatch` from batching much geometry. Also, binding a texture is a somewhat expensive operation. For these reasons, it is common to store many smaller images in a larger image and then draw regions of the larger image to both maximize geometry batching and avoid texture changes. See [TexturePacker](/wiki/tools/texture-packer) for more information.

## SpriteBatch

Using [`SpriteBatch`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g2d/SpriteBatch.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g2d/SpriteBatch.java) in an application looks like this:

```java

public class Game implements ApplicationAdapter {
	private SpriteBatch batch;

	public void create () {
		batch = new SpriteBatch();
	}

	public void render () {
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT); // This cryptic line clears the screen.
		batch.begin();
		// Drawing goes here!
		batch.end();
	}
}
```

All `SpriteBatch` drawing calls must be made between the `begin` and `end` methods. Non-`SpriteBatch` drawing cannot occur between `begin` and `end`.

`SpriteBatch` assumes the active texture unit is 0. When using custom shaders and binding textures yourself, you can reset this with the following code:

```java
Gdx.gl.glActiveTexture(GL20.GL_TEXTURE0);
```

## Texture

The `Texture` class decodes an image file and loads it into GPU memory. The image file should be placed in the "assets" folder. The image's dimensions should be powers of two (16x16, 64x256, etc) for compatibility and performance reasons.

```java
private Texture texture;
...
texture = new Texture(Gdx.files.internal("image.png"));
...
batch.begin();
batch.draw(texture, 10, 10);
batch.end();
```

Here a texture is created and passed to a `SpriteBatch` to be drawn. The texture will be drawn in a rectangle positioned at 10,10 with a width and height equal to the size of the texture. `SpriteBatch` has many methods for drawing a texture:

| *Method signature* | *Description* |
| :------------------ | :-------------: |
| `draw(Texture texture, float x, float y)` | Draws the texture using the texture's width and height |
| `draw(Texture texture, float x, float y,`<br/>`int srcX, int srcY, int srcWidth, int srcHeight)` | Draws a portion of the texture. |
| `draw(Texture texture, float x, float y,`<br/>`float width, float height, int srcX, int srcY,`<br/>`int srcWidth, int srcHeight, boolean flipX, boolean flipY)` | Draws a portion of a texture, stretched to the `width` and `height`, and optionally flipped. |
| `draw(Texture texture, float x, float y,`<br/>`float originX, float originY, float width, float height,`<br/>`float scaleX, float scaleY, float rotation,`<br/>`int srcX, int srcY, int srcWidth, int srcHeight,`<br/>`boolean flipX, boolean flipY)` | This monster method draws a portion of a texture, stretched to the `width` and `height`, scaled and rotated around an origin, and optionally flipped. |
| `draw(Texture texture, float x, float y,`<br/>`float width, float height, float u,`<br/>`float v, float u2, float v2)` | This draws a portion of a texture, stretched to the `width` and `height`. This is a somewhat advanced method as it uses texture coordinates from 0-1 rather than pixel coordinates. |
| `draw(Texture texture, float[] spriteVertices, int offset, int length)` | This is an advanced method for passing in the raw geometry, texture coordinates, and color information. This can be used to draw any quadrilateral, not just rectangles. |

## TextureRegion

The [`TextureRegion` class](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g2d/TextureRegion.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g2d/TextureRegion.java) describes a rectangle inside a texture and is useful for drawing only a portion of the texture.

```java
private TextureRegion region;
...
texture = new Texture(Gdx.files.internal("image.png"));
region = new TextureRegion(texture, 20, 20, 50, 50);
...
batch.begin();
batch.draw(region, 10, 10);
batch.end();
```

Here the `20, 20, 50, 50` describes the portion of the texture, which is then drawn at 10,10. The same can be achieved by passing the `Texture` and other parameters to `SpriteBatch`, but `TextureRegion` makes it convenient to have a single object that describes both.

`SpriteBatch` has many methods for drawing a texture region:

| *Method signature* | *Description* |
| :------------------ | :-------------: |
| `draw(TextureRegion region, float x, float y)` | Draws the region using the width and height of the region. |
| `draw(TextureRegion region, float x, float y,`<br/>`float width, float height)` | Draws the region, stretched to the `width` and `height`. |
| `draw(TextureRegion region, float x, float y,`<br/>`float originX, float originY, float width, float height,`<br/>`float scaleX, float scaleY, float rotation)` | Draws the region, stretched to the `width` and `height`, and scaled and rotated around an origin. |

## Sprite

The [`Sprite` class](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g2d/Sprite.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g2d/Sprite.java) describes both a texture region, the geometry where it will be drawn, and the color it will be drawn.

```java
private Sprite sprite;
...
texture = new Texture(Gdx.files.internal("image.png"));
sprite = new Sprite(texture, 20, 20, 50, 50);
sprite.setPosition(10, 10);
sprite.setRotation(45);
...
batch.begin();
sprite.draw(batch);
batch.end();
```

Here the `20, 20, 50, 50` describes the portion of the texture, which is rotated 45 degrees and then drawn at 10,10. The same can be achieved by passing the `Texture` or a `TextureRegion` and other parameters to `SpriteBatch`, but `Sprite` makes it convenient to have a single object that describes everything. Also, because `Sprite` stores the geometry and only recomputes it when necessary, it is slightly more efficient if the scale, rotation, or other properties are unchanged between frames.

Note that `Sprite` mixes model information (position, rotation, etc) with view information (the texture being drawn). This makes `Sprite` inappropriate when applying a design pattern that wishes to strictly separate the model from the view. In that case, using `Texture` or `TextureRegion` may make more sense.

Also note that there is no Sprite constructor that is related to the position of the Sprite. calling `Sprite(Texture, int, int, int, int)` does ***not*** edit the position. It is necessary to call `Sprite#setPosition(float,float)` or else the sprite will be drawn at the default position of 0,0.

## Tinting

When a texture is drawn, it can be tinted a color:

```java
private Texture texture;
private TextureRegion region;
private Sprite sprite;
...
texture = new Texture(Gdx.files.internal("image.png"));
region = new TextureRegion(texture, 20, 20, 50, 50);
sprite = new Sprite(texture, 20, 20, 50, 50);
sprite.setPosition(100, 10);
sprite.setColor(0, 0, 1, 1);
...
batch.begin();
batch.setColor(1, 0, 0, 1);
batch.draw(texture, 10, 10);
batch.setColor(0, 1, 0, 1);
batch.draw(region, 50, 10);
sprite.draw(batch);
batch.end();
```

This shows how to draw a texture, region, and sprite with a tint color. The color values here are described using RGBA values between 1 and 0. Alpha is ignored if blending is disabled.

## Blending

Blending is enabled by default. This means that when a texture is drawn, translucent portions of the texture are merged with pixels already on the screen at that location.

When blending is disabled, anything already on the screen at that location is replaced by the texture. This is more efficient, so blending should always be disabled unless it is needed. E.g., when drawing a large background image over the whole screen, a performance boost can be gained by first disabling blending:

```java
Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT); // This cryptic line clears the screen.
batch.begin();
batch.disableBlending();
backgroundSprite.draw(batch);
batch.enableBlending();
// Other drawing here.
batch.end();
```

_Note: Be sure to clear the screen each frame. If this is not done, a texture with alpha can be drawn on top of itself hundreds of times, making it appear opaque. Also, some GPU architectures perform better when the screen is cleared each frame, even if opaque images are being drawn over the entire screen._

## Viewport

`SpriteBatch` manages its own projection and transformation matrixes. When a `SpriteBatch` is created, it uses the current application size to setup an orthographic projection using a y-up coordinate system. When `begin` is called, it sets up the [viewport](/wiki/graphics/viewports).


## Performance tuning

`SpriteBatch` has a constructor that sets the maximum number of sprites that can be buffered before sending to the GPU. If this is too low, it will cause extra calls to the GPU. If this is too high, the `SpriteBatch` will be using more memory than is necessary.

`SpriteBatch` has a public int field named `maxSpritesInBatch`. This indicates the highest number of sprites that were sent to the GPU at once over the lifetime of the `SpriteBatch`. Setting a very large `SpriteBatch` size and then checking this field can help determine the optimum `SpriteBatch` size. It should be sized equal to or slightly more than `maxSpritesInBatch`. This field may be set to zero to reset it at any time.

`SpriteBatch` has a public int field named `renderCalls`. After `end` is called, this field indicates how many times a batch of geometry was sent to the GPU between the last calls to `begin` and `end`. This occurs when a different texture must be bound, or when the `SpriteBatch` has cached enough sprites to be full. If the `SpriteBatch` is sized appropriately and `renderCalls` is large (more than maybe 15-20), it indicates that many texture binds are occurring.

`SpriteBatch` has an additional constructor that takes a size and a number of buffers. This is an advanced feature that causes vertex buffer objects (VBOs) to be used rather than the usual vertex arrays (VAs). A list of buffers is kept, and each render call uses the next buffer in the list (wrapping around). When `maxSpritesInBatch` is low and `renderCalls` is large, this may provide a small performance boost.
