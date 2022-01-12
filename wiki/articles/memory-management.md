---
title: Memory management
---
Games are resource heavy applications. Images and sound effects can take up a considerable amount of RAM. Also, most of these resources are not managed by the Java garbage collector. Instead they are managed by native drivers. Having the garbage collector decide when to release a 5 megabyte texture from video ram wouldn't be a too bright idea either.

We want fine grained control over the life-time of our resources. There are multiple classes in libGDX which represent such resources. They all implement a common [Disposable](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Disposable.html) interface which indicates that instances of this class need to be disposed of manually at the end of the life-time. **Failure to dispose resources will lead to severe memory leaks!**.

The following classes need to be disposed of manually (might not be complete, [click here](https://libgdx.badlogicgames.com/ci/nightlies/docs/api/com/badlogic/gdx/utils/Disposable.html) instead for the full list):

  * AssetManager
  * Bitmap
  * BitmapFont
  * BitmapFontCache
  * CameraGroupStrategy
  * DecalBatch
  * ETC1Data
  * FrameBuffer
  * Mesh
  * Model
  * ModelBatch
  * ParticleEffect
  * Pixmap
  * PixmapPacker
  * Shader
  * ShaderProgram
  * Shape
  * Skin
  * SpriteBatch
  * SpriteCache
  * Stage
  * Texture
  * TextureAtlas
  * TileAtlas
  * TileMapRenderer
  * com.badlogic.gdx.physics.box2d.World
  * all bullet classes

Resources should be disposed of as soon as they are no longer needed, freeing up memory associated with them. Accessing a disposed resource will result in undefined errors, so make sure to clear out all references you have to a disposed resource.

When in doubt about whether a specific class needs to be disposed of, check if it has a `dispose()` method which implemented from `Disposable` interface of `com.badlogic.gdx.utils`. If it does, you are now working with a native resource.

> An idea to list all of such classes is to clone libGDX to your system, then use text editor such as Sublime Text or others to open its root directory, search for `implements Disposable`. It will show you result of all source files (thus class) you need to call `dispose()` when you're done with it. Note that all other classes that extend from such result classes are also applicable. List above is already complete. Note that a few classes from result come from test class of libGDX itself which are not relevant to your interest.

### Object pooling ###

Object pooling is the principle of reusing inactive or "dead" objects, instead of creating new objects every time. This is achieved by creating an object pool, and when you need a new object, you obtain it from that pool. If the pool has an available (free) object, it is returned. If the pool is empty, or does not contain free objects, a new instance of the object is created and returned. When you no longer need an object, you "free" it, which means it is returned to the pool.
This way, object allocation memory is reused, and garbage collector is happy.

This is vital for memory management in games that have frequent object spawning, like bullets, obstacles, monsters, etc.

libGDX offers a couple tools for easy pooling.

  * [Poolable](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Pool.Poolable.html) interface
  * [Pool](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Pool.html)
  * [Pools](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Pools.html)

Implementing the `Poolable` interface means you will have a `reset()` method in your object, which will be automatically called when you free the object.

Below is a minimal example of pooling a bullet object.

```java
public class Bullet implements Pool.Poolable {

    public Vector2 position;
    public boolean alive;

    /**
     * Bullet constructor. Just initialize variables.
     */
    public Bullet() {
        this.position = new Vector2();
        this.alive = false;
    }
    
    /**
     * Initialize the bullet. Call this method after getting a bullet from the pool.
     */
    public void init(float posX, float posY) {
    	position.set(posX,  posY);
    	alive = true;
    }

    /**
     * Callback method when the object is freed. It is automatically called by Pool.free()
     * Must reset every meaningful field of this bullet.
     */
    @Override
    public void reset() {
        position.set(0,0);
        alive = false;
    }

    /**
     * Method called each frame, which updates the bullet.
     */
    public void update (float delta) {
    	
    	// update bullet position
    	position.add(1*delta*60, 1*delta*60);
    	
    	// if bullet is out of screen, set it to dead
    	if (isOutOfScreen()) alive = false;
    }
}
```

In your game world class:
```java
public class World {

    // array containing the active bullets.
    private final Array<Bullet> activeBullets = new Array<Bullet>();

    // bullet pool.
    private final Pool<Bullet> bulletPool = new Pool<Bullet>() {
	@Override
	protected Bullet newObject() {
		return new Bullet();
	}
    };

    public void update(float delta) {
	
        // if you want to spawn a new bullet:
        Bullet item = bulletPool.obtain();
        item.init(2, 2);
        activeBullets.add(item);

        // if you want to free dead bullets, returning them to the pool:
    	Bullet item;
    	int len = activeBullets.size;
    	for (int i = len; --i >= 0;) {
    	    item = activeBullets.get(i);
    	    if (item.alive == false) {
    	        activeBullets.removeIndex(i);
    	        bulletPool.free(item);
    	    }
    	}
    }
}
```

The [Pools](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Pools.html) class provides static methods for dynamically creating pools of any objects (using [ReflectionPool](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ReflectionPool.html) and black magic). In the above example, it could be used like this.
```java
private final Pool<Bullet> bulletPool = Pools.get(Bullet.class);
```

### How to Use Pool

A `Pool<>` manages a single type of object, so it is parameterized by that type. Objects are taken from a specific `Pool` instance by invoking `obtain` and then should be returned to the Pool by invoking `free`.   The objects in the pool may optionally implement the [`Pool.Poolable`](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Pool.Poolable.html) interface (which just requires a `reset()` method be present), in which case the `Pool` will automatically reset the objects when they are returned to the pool.  By default, objects are initially allocated on demand (so if you never invoke `obtain`, the Pool will contain no objects). It is possible to force the `Pool` to allocate a number of objects by calling `fill()` after instantiation. Initial allocation is useful to have control over when these first time allocations occur.

You must implement your own subclass of `Pool<>` because the `newObject` method is abstract.

### Pool Caveats

Beware of leaking references to Pooled objects.  Just because you invoke "free" on the Pool does not invalidate any outstanding references.  This can lead to subtle bugs if you're not careful.  You can also create subtle bugs if the state of your objects is not fully reset when the object is put in the pool.

### Profiling Memory leaks

If you're encountering memory leaks, tools like [VisualVM](https://visualvm.github.io/) (free) and [JProfiler](https://www.ej-technologies.com/products/jprofiler/overview.html) (trial/paid) prove useful in tracking down the issue. These memory profilers will tell you what type of object is eating up the memory. From there on you can start tracking down the leak.
