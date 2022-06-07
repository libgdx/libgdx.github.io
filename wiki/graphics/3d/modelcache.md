---
title: ModelCache
---
When rendering many [Models](/wiki/graphics/3d/models) using [ModelBatch](/wiki/graphics/3d/modelbatch) you might notice that it will have an impact on performance. This is often because every [[part](/wiki/graphics/3d/models#nodepart) of the model will cause a [render call](/wiki/graphics/3d/modelbatch#what-are-render-calls). Every render call requires the GPU and the CPU to synchronize, which is a relatively costly operation. Therefor you typically want to keep the number of render calls to a minimum.

There are multiple ways to reduce the number of render calls. For example by *frustum culling* (not rendering what wont be visible anyway), by *optimizing your models* to contain less parts or by *merging models* to reduce the number of models. [ModelCache](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/ModelCache.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/ModelCache.java)) allows to do the latter two of those at runtime.

> **BE AWARE** merging and optimizing models *at runtime* is typically still a relatively costly operation and when done incorrectly it can even make performance worse. Always make sure to implement other options of reducing the render calls, like frustum culling or optimizing assets, as well.

ModelCache is somewhat comparable to [SpriteCache](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g2d/SpriteCache.html) and [SpriteBatch](/wiki/graphics/2d/spritebatch-textureregions-and-sprites) which are used for 2D rendering. However, models typically are more complex compared to sprites in for example the number of vertices, vertex attributes and the material.

ModelCache will not merge skinned meshes. When you add a skinned mesh it will not be merged, but instead kept as is. So it is safe to add a skinned mesh to the cache, but it won't reduce the number of render calls (because skinning is applied inside the render call).

## Using ModelCache

Using ModelCache is similar to using [ModelBatch](/wiki/graphics/3d/modelbatch). To start merging and optimizing models you'll have to call the `begin()` method. Then you can `add()` one or more [ModelInstance](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/ModelInstance.html)s or other [RenderableProvider](/wiki/graphics/3d/modelbatch#renderableprovider)s. After that call the `end()` method to actually perform the merging.

When the cache is created (after the call to `end()`) you can use it in the call to `ModelBatch.render`.

ModelCache owns several native resources. Therefor you should `dispose()` the cache when no longer needed.

```java
ModelBatch batch;
ModelCache cache;
public void create() {
    //...
    Array<ModelInstance> instances = createTheInstanceYouWantToMerge();
    cache = new ModelCache();
    cache.begin();
    cache.add(instances);
    cache.end();
    //... create the batch and such
}
public void render() {
    //... call glClear and such
    batch.begin();
    batch.render(cache, environment);
    batch.end();
}
public void dispose() {
    // dispose models and such
    cache.dispose();
    batch.dispose();
}
```

It is possible to use ModelCache for dynamic models, for example objects that move every frame. In that case you can recreate the cache on every render call.

```java
ModelBatch batch;
ModelCache cache;
Array<ModelInstance> instances;
public void create() {
    //...
    instances = createTheInstanceYouWantToMerge();
    cache = new ModelCache();
    //... create the batch and such
}
public void render() {
    //... call glClear and such
    cache.begin();
    cache.add(instances);
    cache.end();

    batch.begin();
    batch.render(cache, environment);
    batch.end();
}
public void dispose() {
    // dispose models and such
    cache.dispose();
    batch.dispose();
}
```
