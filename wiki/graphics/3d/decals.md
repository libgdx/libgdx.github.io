---
title: Decals
---
A `Decal` is basically a `Sprite` that can be manipulated and rendered in 3D space. They allow you to draw a 2D texture within your 3D world very efficiently using a `DecalBatch`, with an API similar to that of the `Sprite` and `SpriteBatch`.

## [Decal](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/decals/Decal.html)

A `Decal` represents a sprite in 3d space. Typical 3d transformations such as translation, rotation and scaling are supported.

### Creation
A `Decal` requires a `DecalMaterial` to do anything meaningful. While it's possible to instantiate a DecalMaterial directly, it's far simpler to use one of the helpful `newDecal` methods of the `Decal` class. For example, if we have a `TextureRegion`:

	Decal decal = Decal.newDecal(textureRegion);

If you have a texture that uses transparency, then you can use an alternative method:

	Decal decal = Decal.newDecal(textureRegion, true);

Additional [methods](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/decals/Decal.html) are available for further specifying the size and blending properties of the region.

### Manipulation
There are many methods for transforming a `Decal` in 3D space. Some examples:

- Translation: `translate(x, y, z)`, `translateX(x)`, etc
- Rotation: `rotate(x, y, z)`, `rotateX()`, etc
- Scale: `setScale(x, y)`, `setScale(x)`, etc
- Position: `setPosition(x, y, z)`, `setPosition(Vector3)`, etc

For a more complete list of available methods, see [here](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/decals/Decal.html).

### Billboard
If we wanted a decal to always face a PerspectiveCamera, we can easily do this using the `lookAt` method.
	
	// For perspective camera
	decal.lookAt(camera.position, camera.up);

## [DecalBatch](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/decals/DecalBatch.html)
Similar to `SpriteBatch`, we can use a `DecalBatch` to batch together many `Decals` for efficient rendering. The `DecalBatch` will allow us to queue as many Decals as we need before pushing big chunks of geometry to the graphics pipeline.
We should create a DecalBatch only once, rather than every game loop.

    // e.g. called at start of scene
    DecalBatch decalBatch = new DecalBatch(groupStrategy);

### Group Strategy
The way a batch handles things depends on the GroupStrategy. Different strategies can be used to customize shaders, states, culling etc. Essentially, a GroupStrategy evaluates the group a sprite falls into, and adjusts settings before and after rendering a group.

For ease of use, the following GroupStrategy implementations exist:

- [SimpleOrthoGroupStrategy](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/decals/SimpleOrthoGroupStrategy.java)
- [CameraGroupStrategy](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/decals/CameraGroupStrategy.java)

CameraGroupStrategy is likely the most appropriate. You can pass it a Camera instance and it will handle the rest.

	decalBatch = new DecalBatch(new CameraGroupStrategy(camera));

### Adding Decals
Unlike a SpriteBatch, we do not need to call a begin method. Instead, we just add decals to the batch.

	decalBatch.add(decal);

It typically does not matter what order we add the decals to the batch, as the GroupStrategy and depth buffer will handle overlapping decals.

### Rendering
Once we have added all our decals, we should tell the DecalBatch to flush them to the graphics pipeline.

	decalBatch.flush();

The DecalBatch will then process all queued decals and render them.

### Performance Tweaking
The default decal pool size is 1000. Adding more than this many decals in one go will trigger the DecalBatch to submit a chunk. If it is known before hand that not as many decals be needed on average the batch can be downsized to save memory.

We can set the pool size in the constructor:

    DecalBatch decalBatch = new DecalBatch(500, groupStrategy);

## Complete Example

You can see a working example that shows off the correct usage of Decals here:

[https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/SimpleDecalTest.java](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/SimpleDecalTest.java)
