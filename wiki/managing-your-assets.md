---
title: Managing your assets
---
### Why would I want to use the AssetManager

[AssetManager](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/AssetManager.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/AssetManager.java) helps you load and manage your assets. It is the recommended way to load your assets, due to the following nice behaviors:

  * Loading of most resources is done asynchronously, so you can display a reactive loading screen while things load
  * Assets are reference counted. If two assets A and B both depend on another asset C, C won't be disposed until A and B have been disposed. This also means that if you load an asset multiple times, it will actually be shared and only take up memory once!
  * A single place to store all your assets.
  * Allows to transparently implement things like caches (see FileHandleResolver below)

Still with me? Then read on.

### Creating an AssetManager

This part is rather simple:

```java
AssetManager manager = new AssetManager();
```

This sets up a standard AssetManager, with all the loaders libGDX has in store at the moment. Let's see how the loading mechanism works.

**Caution:** don't make your `AssetManager` or any other resources (like `Texture`, etc.) `static`, unless you properly manage them. E.g. the following code will cause issues:

```java
public static AssetManager assets = new AssetManager();
```

This will cause problems on Android because the life-cycle of the static variable is not necessarily the same as the life-cycle of your application. Therefore the `AssetManager` instance of a previous instance of your application might be used for the next instance, while the resources are no longer valid. This typically would cause black/missing textures or incorrect assets.

On Android, it is even possible for multiple instances of your Activity to be active at the same time, so do not think you're safe even if you handle life-cycle methods properly! (See [this StackOverflow question](https://stackoverflow.com/questions/4341600/how-to-prevent-multiple-instances-of-an-activity-when-it-is-launched-with-differ) for details.)

### Adding Assets to the queue

To load assets, the AssetManager needs to know how to load a specific type of asset. This functionality is implemented via AssetLoaders. There are two variants, SynchronousAssetLoader and AsynchronousAssetLoader. The former loads everything on the rendering thread, the latter loads parts of the asset on another thread, e.g., the Pixmap needed for a Texture, and then loads the OpenGL dependent part on the rendering thread. The following resources can be loaded out of the box with the AssetManager as constructed above.


  * Pixmaps via [PixmapLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/PixmapLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/PixmapLoader.java)
  * Textures via [TextureLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/TextureLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/TextureLoader.java)
  * BitmapFonts via [BitmapFontLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/BitmapFontLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/BitmapFontLoader.java)
  * FreeTypeFonts via [FreeTypeFontLoader](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/extensions/FreeTypeFontLoaderTest.java)
  * TextureAtlases via [TextureAtlasLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/TextureAtlasLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/TextureAtlasLoader.java)
  * Music instances via [MusicLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/MusicLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/MusicLoader.java)
  * Sound instances via [SoundLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/SoundLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/SoundLoader.java)
  * Skins via [SkinLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/SkinLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/SkinLoader.java)
  * Particle Effects via [ParticleEffectLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/ParticleEffectLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/ParticleEffectLoader.java)
  * I18NBundles via [I18NBundleLoader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/loaders/I18NBundleLoader.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/assets/loaders/I18NBundleLoader.java)
  * FreeTypeFontGenerator via FreeTypeFontGeneratorLoader [(code)](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/src/com/badlogic/gdx/graphics/g2d/freetype/FreeTypeFontGeneratorLoader.java)

Loading a specific asset is simple:

```java
manager.load("data/mytexture.png", Texture.class);
manager.load("data/myfont.fnt", BitmapFont.class);
manager.load("data/mymusic.ogg", Music.class);
```

These calls will enqueue those assets for loading. The assets will be loaded in the order we called the [AssetManager.load()](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/assets/AssetManager.html#load-java.lang.String-java.lang.Class-) method. Some loaders allow you to also pass parameters to them via AssetManager.load(). Say we want to specify a non-default filter and mipmapping setting for loading a texture:

```java
TextureParameter param = new TextureParameter();
param.minFilter = TextureFilter.Linear;
param.genMipMaps = true;
manager.load("data/mytexture.png", Texture.class, param);
```

Look into the loaders mentioned above to find out about their parameters.

### Actually loading the assets
So far we only queued assets to be loaded. The AssetManager does not yet load anything. To kick this off we have to call AssetManager.update() continuously, say in our ApplicationListener.render() method:

```java
public MyAppListener implements ApplicationListener {

   public void render() {
      if(manager.update()) {
         // we are done loading, let's move to another screen!
      }

      // display loading information
      float progress = manager.getProgress()
      ... left to the reader ...
   }
}
```

As long as AssetManager.update() returns false you know it's still loading assets. To poll the concrete state of loading you can use AssetManager.getProgress(), which returns a number between 0 and 1 indicating the percentage of assets loaded so far. There are other methods in AssetManager that give you similar information, like AssetManager.getLoadedAssets() or AssetManager.getQueuedAssets(). <b>You have to call AssetManager.update() to keep loading!</b>

If you want to block and make sure all assets are loaded you can call:

```java
manager.finishLoading();
```

This will block until all the assets that have been queued are actually done loading. Kinda defeats the purpose of asynchronous loading, but sometimes one might need it (e.g., loading the assets needed to display the loading screen itself).

### Optimize loading
In order to perform loading as efficiently/fast as possible while trying to keep a certain FPS, AssetManager.update() should be called with parameters.<br>**E.g. AssetManager.update(17)** - In this case the AssetManager blocks for at least 17 milliseconds (only less if all assets are loaded) and loads as many assets as possible, before it returns control back to the render method. Blocking for 16 or 17 milliseconds leads to ~60FPS as 1/60*1000 = 16.66667. Note that it might block for longer, depending on the asset that is being loaded so **don't** take the desired FPS as guaranteed.

### Loading a TTF using the AssetHandler

Loading a TrueType file via the AssetHandler requires only a little bit extra tweaking. Before we can load a TTF, we need to set the type of loader we're going to use for FreeType fonts. This is done with the following:

```java
FileHandleResolver resolver = new InternalFileHandleResolver();
manager.setLoader(FreeTypeFontGenerator.class, new FreeTypeFontGeneratorLoader(resolver));
manager.setLoader(BitmapFont.class, ".ttf", new FreetypeFontLoader(resolver));
```

Next, we'll want to create a `FreeTypeFontLoaderParameter` that defines 1) our actual font file, and 2) our font size. There are other parameters we can define here, too, when you have time to dig more.

Let's say we want to create two different fonts: a smaller, sans-serif font that will be used for one type of writing text, and a larger, serif font for titles and other fun things. I've decided to use Arial and Georgia for these two fonts, respectively. Here's how I can load them using the AssetManager:

```java
// First, let's define the params and then load our smaller font
FreeTypeFontLoaderParameter mySmallFont = new FreeTypeFontLoaderParameter();
mySmallFont.fontFileName = "arial.ttf";
mySmallFont.fontParameters.size = 10;
manager.load("arial.ttf", BitmapFont.class, mySmallFont);

// Next, let's define the params and then load our bigger font
FreeTypeFontLoaderParameter myBigFont = new FreeTypeFontLoaderParameter();
myBigFont.fontFileName = "georgia.ttf";
myBigFont.fontParameters.size = 20;
manager.load("georgia.ttf", BitmapFont.class, myBigFont);
```

Neat! Now we've got two different fonts, `mySmallFont` and `myBigFont`, that we can use to display different text.

We're not quite done yet. Now that the fonts have been `.load`ed, we still need to set them. We can do this like so:

```java
BitmapFont mySmallFont = manager.get("arial.ttf", BitmapFont.class);
BitmapFont myBigFont = manager.get("georgia.ttf", BitmapFont.class);
```

The name you give the manager doesn't have to match the name of the font, like in the above example. If you want to use the same font for different sizes, just make sure the name you give the asset manager when loading the font is unique. For example, here's how you could load the Arial font in both 10pt and 20pt:

```java
FreeTypeFontLoaderParameter arial10 = new FreeTypeFontLoaderParameter();

// This is the file that needs to exist in the assets directory.
arial10.fontFileName = "arial.ttf";
arial10.fontParameters.size = 10;

// There is no file named arial10.ttf. This is just an identifier for the asset manager.
// The .ttf extension is important, because it tells the asset manager which loader to use.
manager.load("arial10.ttf", BitmapFont.class, arial10);

// Now just change the font size, but use the same font.
FreeTypeFontLoaderParameter arial20 = new FreeTypeFontLoaderParameter();
arial20.fontFileName = "arial.ttf";
arial20.fontParameters.size = 20;

// And create a new BitmapFont in 20pt.
manager.load("arial20.ttf", BitmapFont.class, arial20);
```

### Getting Assets
That's again easy:

```java
Texture tex = manager.get("data/mytexture.png", Texture.class);
BitmapFont font = manager.get("data/myfont.fnt", BitmapFont.class);
```

This of course assumes that those assets have been successfully loaded. If we want to poll whether a specific asset has been loaded we can do the following:

```java
if(manager.isLoaded("data/mytexture.png")) {
   // texture is available, let's fetch it and do something interesting
   Texture tex = manager.get("data/mytexture.png", Texture.class);
}
```

### Disposing Assets
Easy again, and here you can see the real power of the AssetManager:

```java
manager.unload("data/myfont.fnt");
```

If that font references a Texture that you loaded manually before, the texture won't get destroyed! It will be reference counted, getting one reference from the bitmap font and another from itself. As long as this count is not zero, the texture won't be disposed.

* Assets managed via the AssetManager shouldn't be disposed manually, instead, call AssetManager.unload()!

If you want to get rid of all assets at once you can call:

```java
manager.clear();
```

or

```java
manager.dispose();
```

Both will dispose all currently loaded assets and remove any queued and not yet loaded assets. The AssetManager.dispose() method will also kill the AssetManager itself. After a call to this method you should not use the manager anymore.

And that's pretty much everything there is. Now for the nitty-gritty parts.

### I only supply Strings, where does the AssetManager load the assets from?
Every loader has a reference to a FileHandleResolver. That's a simple interface looking like this:

```java
public interface FileHandleResolver {
   public FileHandle resolve(String file);
}
```

By default, every loader uses an InternalFileHandleResolver. That will return a FileHandle pointing at an internal file (just like Gdx.files.internal("data/mytexture.png"). You can write your own resolvers! Look into the assets/loaders/resolvers package for more FileHandleResolver implementation. One use case for this would be a caching system, where you check if you have a newer version downloaded to the external storage first, and fall back to the internal storage if it's not available. The possibilities are endless.

You can set the FileHandleResolver to be used via the second constructor of AssetManager:

```java
AssetManager manager = new AssetManager(new ExternalFileHandleResolver());
```

This will make sure all default loaders listed above will use that loader.

### Writing your own Loaders
I can't anticipate which other types of resources you want to load, so at some point you might want to write your own loaders. There are two interfaces called SynchronousAssetLoader and AsynchronousAssetLoader you can implement. Use the former if your asset type is fast to load, use the latter if you want your loading screen to be responsive. I suggest basing your loader on the code of one of the loaders listed above. Look into MusicLoader for a simple SynchronousAssetLoader, look into PixmapLoader for a simple AsynchronousAssetLoader. BitmapFontLoader is a good example of an asynchronous loader that also has dependencies that need to be loaded before the actual asset can be loaded (in that case it's the texture storing the glyphs). Again, you can do pretty much anything with this.

Additionally, the `loadAsync` function _can_ be used to load parts of the assets where the loading can be delegated to another thread (this is a requirement for responsive loading screen). The `loadSync` function _must_ be used if some parts of the asset needs to be loaded on the main rendering thread. For example, OpenGL API function calls must be invoked on the main rendering thread, therefore any parts of the asset and its loading involving calls to OpenGL must be called in `loadSync`.

`loadAsync` will be called first and `loadSync` afterwards. You can pass information from `loadASync` to `loadSync` with the aid of your custom asset loader class' attributes. **Care must be taken to initialize these temporary variables to null between the loading of each separate asset or you might end up loading the same asset multiple times!** Easiest way to achieve this is by setting your temporary variables to null at the beginning of `loadASync` implementation. `PixmapLoader` class demonstrates a simple way of using the temporary variables correctly, whereas `TextureLoader` shows a more complex way to pass information between `loadAsync` and `loadSync`.

Once you are done writing your loader, tell the AssetManager about it:

```java
manager.setLoader(MyAssetClass.class, new MyAssetLoader(new InternalFileHandleResolver()));
manager.load("data/myasset.mas", MyAssetClass.class);
```

### Resuming with a Loading Screen
On Android, your app can be paused and resumed. Managed OpenGL resources like Textures need to be reloaded in that case, which can take a bit of time. If you want to display a loading screen on resume, you can do the following after you created your AssetManager.

```java
Texture.setAssetManager(manager);
```

In your ApplicationListener.resume() method you can then switch to your loading screen and call AssetManager.update() again until everything is back to normal.

If you don't set the AssetManager as shown in the last snippet, the usual managed texture mechanism will kick in, so you don't have to worry about anything.

And this concludes the long awaited article on the AssetManager. 