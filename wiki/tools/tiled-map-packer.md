---
title: "Tiled Map Packer"
---

# TiledMapPacker

> **Note:** The most recent TiledMapPacker runnable is now available and requires libGDX version 1.13.5 or higher to load maps created with it.
You can download the runnable JAR release of **TiledMapPacker**, [here](https://libgdx-nightlies.s3.eu-central-1.amazonaws.com/libgdx-runnables/runnable-tiledmappacker.jar).

*Offline tool for preparing Tiled maps (`.tmx` or `.tmj`) to use a single optimized `TextureAtlas` for rendering
in libGDX, by combining tilesets, image layers, and individual images. Designed for use with `AtlasTmxMapLoader` or `AtlasTmjMapLoader`.*

## Why use TiledMapPacker?

TiledMapPacker is designed to optimize your Tiled maps for better runtime performance:

- **Fewer draw calls** – By combining multiple tilesets, images, and layers into a single optimized `TextureAtlas`,
  your game can render entire maps faster with fewer texture switches. This is especially helpful for parallax backgrounds made using imagelayers, and maps that use a variety of tilesets.
- **Optional tile stripping** – Unused tiles can be omitted to reduce file size and memory use.


## Running TiledMapPacker

### Standalone JAR

```
# Creates an output directory named "output" next to INPUTDIR
java -jar runnable-tiledmappacker.jar ./maps

# Explicit output directory
java -jar runnable-tiledmappacker.jar ./maps ./maps-packed

# Explicit output directory, as well as loading maps that require .tiled-project files
java -jar runnable-tiledmappacker.jar ./maps ./maps-packed ./customClass.tiled-project

# Various options are available as well such as verbose logging and stripping unused tiles
java -jar runnable-tiledmappacker.jar ./maps ./maps-packed -v --strip-unused
```

> **Note:** TiledMapPacker internally uses `TmxMapLoader` and `TmjMapLoader`, which require a valid OpenGL context. The runnable JAR automatically creates a minimal LwjglApplication that opens a small window.

## Positional arguments

| Argument           | Description |
|------------------- |-------------|
| **INPUTDIR**       | Folder that contains the maps. Searches recursively for `.tmx` and `.tmj` files.|
| **OUTPUTDIR**      | *(optional)* Directory where the processed maps and atlases are written. Defaults to a sibling directory named **output**.|
| **PROJECTFILEPATH** | *(optional)* Path to a Tiled `.tiled-project` file when your maps rely on *custom classes*.|

## Flags

| Flag                 | Effect                                                                        |
| -------------------- |-------------------------------------------------------------------------------|
| `--strip-unused`     | Omit tiles that never appear in any layer.                                    |
| `--combine-tilesets` | Combine all tilesets from all maps into a single mega‑atlas (not recommended). |
| `--ignore-coi`       | Skip "*collection‑of‑images*" tilesets.                                       |
| `-v`                 | Verbose output (lists every tile or image that is packed/stripped).           |


## Default Per‑Map Atlases vs Combined

- **Per‑map** (default) – Each individual map gets its own atlas.

  *Command*: `java -jar tiledmappacker.jar ./maps`.

- **Combined** – All tilesets across every map are packed into a single giant
  atlas, so you only need one atlas for all maps. This option has been around since the inception of the TiledMapPacker but still *not recommended* for use as nested folders and absolute tileset paths may break it.

  *Option*: `--combine-tilesets`.


## Typical Workflow

1. Design your map(s) in Tiled as usual.
2. Run **TiledMapPacker** whenever your art or map files change.
3. The packer creates updated map files (`.tmx` or `.tmj`) and a `tileset/` directory containing the generated `.atlas` and images.
4. Make sure you keep your original tileset definitions (`.tsx` or `.tsj`) and place them alongside the newly generated map and atlas files.
5. Then load the map exactly as you would a regular map:
   ```java
   TiledMap map = new AtlasTmxMapLoader().load("maps/testLevel.tmx");
   ```
   Or through the AssetManager class as well, like any other map.
   ```java
   assetManager.setLoader(TiledMap.class, new AtlasTmxMapLoader(new InternalFileHandleResolver()));
   assetManager.load("maps/testLevel.tmx", TiledMap.class);
   ```

## Handling ImageLayers

Image‑layers are detected automatically. Each image is renamed to a safe region
ID (prefixed with `atlas_imagelayer_`), packed into the atlas, and the map file
is rewritten. The modified atlas map loaders resolve these names automatically.


## Limitations

- **XML tile‑layer encoding** is not supported – stick to CSV or Base64 layers.
- Having a `.tmx` *and* `.tmj` with the **same basename** in the same folder
  (e.g. `level1.tmx` and `level1.tmj`) will cause region‑name collisions and the
  packer will abort.
- **Collection‑of‑images** tilesets are packed automatically, but if they are
  not used in tile layers and not meant to be rendered you can exclude them with `--ignore-coi`.
- `--combine-tilesets` is experimental. Complex folder hierarchies or absolute
  tileset paths may fail to resolve correctly.

## Results

In a worst-case scenario, we have a map that uses three different tilesets,
including a "collection-of-images" tileset, along with eight image layers for parallax background effects.

![TiledMap UI Layers](/assets/wiki/images/tiledmappacker1.png)

You can see the amount of draw calls being wasted if this map were loaded through the `TmxMapLoader`.
In the below example we range 12 to 14 depending on where we are on the screen.

![Unoptimized TMX Map](/assets/wiki/images/tiledmappacker2.gif)

But by using the TiledMapPacker and an AtlasTmxMapLoader, we can significantly reduce our draw calls.
In this case, down to 1.

![Optimized Atlas TMX Map](/assets/wiki/images/tiledmappacker3.gif)

## Example Tests
* [Running TiledMapPacker](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-tools/src/com/badlogic/gdx/tiledmappacker/TiledMapPackerTest.java)
* [Rendering Packed Atlas Tiled Maps](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-tools/src/com/badlogic/gdx/tiledmappacker/TiledMapPackerTestRender.java)

## Asset Credits
* Example .gifs use free assets from the [**SunnyLand Tileset**](https://ansimuz.itch.io/sunny-land-pixel-game-art).
