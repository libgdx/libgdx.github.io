---
title: "The Ultimate Migration Guide (1.9.10 to 1.10.0)"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.45"
  overlay_image: /assets/images/posts/2021-04-18/header.jpeg
  caption: "Photo credit: [**Jan-Niclas Aberle**](https://unsplash.com/photos/h5ZqVoCDgys)"
  teaser: /assets/images/posts/2021-04-18/header.jpeg

excerpt: This guide summarises what you need to do to update your game from libGDX 1.9.10 to 1.10.0.

show_author: true
author_username: "crykn"
author_displayname: "damios"

categories: news
---

We know that a lot of you are still stuck on older versions of libGDX. The following post is intended to make porting your games easier by summarising all the breaking changes that happened in the last two years. If you are looking for the past changelogs themselves, check out [this](/news/changelog/) page.

First things first: be sure to bring the versions of gradle, any plugins and your dependencies [up to date](https://libgdx.com/dev/versions/)!
{: .notice--warning}

## Android
- **[1.9.12]** `Gdx.files.external` **on Android now uses an app's external storage directory. See this [wiki article](https://github.com/libgdx/libgdx/wiki/File-handling#android) for more information.**
- **[1.10.0] Android ARMv5 (armeabi) support has been dropped. Remove any dependency with the** `natives-armeabi` **qualifier (but not** `natives-armeabi-v7a`**!) from your gradle build files. This applies to gdx-platform, gdx-bullet-platform, gdx-freetype-platform and gdx-box2d-platform.**

## Controllers
- **Since version 1.9.13, [gdx-controllers](https://github.com/libgdx/gdx-controllers) now uses its own versioning scheme, the latest version being** `2.2.0`**. Find out more in the corresponding [migration guide](https://github.com/libgdx/gdx-controllers/wiki/Migrate-from-v1).**

## Graphics
- [1.9.11] DefaultTextureBinder `WEIGHTED` strategy was replaced by `LRU` strategy ([#5942](https://github.com/libgdx/libgdx/pull/5942)).
- [1.9.11] ShaderProgram begin and end methods are deprecated in favour to bind method ([#5944](https://github.com/libgdx/libgdx/pull/5944)).
- [1.9.14] `AnimationDesc#update` now returns `-1` (instead of `0`) if an animation is not finished ([#6303](https://github.com/libgdx/libgdx/pull/6303))

## Headless
- [1.9.14] `HeadlessApplicationConfiguration#renderInterval` was changed to `#updatesPerSecond`; so, for example, `16.6F` should become `60` ([#6306](https://github.com/libgdx/libgdx/pull/6306))

## Input
- [1.9.11] Removed `TextField#ENTER_ANDROID` and `ENTER_DESKTOP` in favour of `NEWLINE` and `CARRIAGE_RETURN`. Changed the visibility of `BULLET`, `DELETE`, `TAB` and `BACKSPACE` to protected.
- **[1.9.12]** `InputProcessor#scrolled` **now receives two (!) float (!) values:** `scrollX` **and** `scrollY` **([#6154](https://github.com/libgdx/libgdx/pull/6154)).** `InputEvent` **was changed accordingly. To match the old behaviour use the** `amountY` **argument.**
- **[1.9.13] The keycodes for** `ESCAPE`**,** `END`**,** `INSERT` **and** `F1` **to** `F12` **were changed. If you saved those values, for example in config files, you need to migrate ([#6299](https://github.com/libgdx/libgdx/pull/6299#issuecomment-739154036)).**
- [1.9.13] Input Keycodes added: CAPS_LOCK, PAUSE (aka Break), PRINT_SCREEN, SCROLL_LOCK, F13 to F24, NUMPAD_DIVIDE, NUMPAD_MULTIPLY, NUMPAD_SUBTRACT, NUMPAD_ADD, NUMPAD_DOT, NUMPAD_COMMA, NUMPAD_ENTER, NUMPAD_EQUALS, NUMPAD_LEFT_PAREN, NUMPAD_RIGHT_PAREN, NUM_LOCK. This means that there is now a difference between: Keys.STAR and Keys.NUMPAD_MULTIPLY, Keys.SLASH and Keys.NUMPAD_DIVIDE, Keys.NUM and Keys.NUM_LOCK, Keys.COMMA and Keys.NUMPAD_COMMA, Keys.PERIOD and Keys.NUMPAD_DOT, Keys.ENTER and Keys.NUMPAD_ENTER, Keys.PLUS and Keys.NUMPAD_ADD, Keys.MINUS and Keys.NUMPAD_SUBTRACT.
- [1.9.14] `InputEventQueue` no longer implements `InputProcessor`. To preserve old behaviour pass an `InputProcessor` to `#drain`. ([#6357](https://github.com/libgdx/libgdx/pull/6357))

## iOS
- **[1.9.12+] The handling of HDPI (or Retina, as Apple likes to call it) was adapted to match the implementations on the other platforms ([#3709](https://github.com/libgdx/libgdx/pull/3709)). This means that the iOS backend now reports logical (e.g., 414x 896) and hardware/physical resolutions (e.g., 1242x2688) in the same way the four other backends already do: the former via** `getWidth()`**/**`getHeight()` **and the latter via** `getBackBufferWidth()`**/**`getBackBufferHeight()`**. If you want to keep the old behaviour, just set** `IOSApplicationConfiguration#hdpiMode` **to** `HdpiMode.Pixels`**. Otherwise, use a viewport or replace any calls to** `getWidth()`**, etc. with** `getBackBufferWidth()`**.**
- **[1.9.12] The iOS MOE backend was removed in favour of the RoboVM one.**
- [1.9.14] `IOSUIViewController` has been moved to its own separate class ([#6336](https://github.com/libgdx/libgdx/pull/6336))

## LWJGL 3
- [1.10.0] `Lwjgl3WindowConfiguration#autoIconify` is enabled by default ([#6422](https://github.com/libgdx/libgdx/pull/6422)).

## Math
- [1.9.11] `Matrix3#setToRotation(Vector3, float float)` now rotates counter-clockwise about the axis provided. This also changes `Matrix3#setToRotation(Vector3, float)` and the 3D particles will rotate counter-clockwise as well.
- **[1.9.12]** `Vector2#angleRad(Vector2)` **now correctly returns counter-clockwise angles ([#5428](https://github.com/libgdx/libgdx/pull/5428)).**

## Miscellaneous
- [1.9.11] `Base64Coder#encodeString()` uses `UTF-8` instead of the platform default encoding ([#6061](https://github.com/libgdx/libgdx/pull/6061)).
- [1.9.11] Changed `TiledMapTileLayer#tileWidth` & `#tileHeight` from float to int.
- [1.9.13] `TextureAtlas.AtlasRegion` and `Region` `splits` and `pads` fields have been removed and moved to name/value pairs. Use `#findValue("split")` and `#findValue("pad")` instead ([#6316](https://github.com/libgdx/libgdx/pull/6316)).
- **[1.10.0] The JCenter repository is shutting down. To update your libGDX Gradle projects, open the main** `build.gradle` **file in your project and in both of the two** `repositories {}` **sections replace** `jcenter()` **with** `gradlePluginPortal()`**.**
- [1.10.0] `Scaling` is now an object instead of an enum. This may change behaviour when used with serialisation.
- [1.10.0]`Group#clear()` and `#clearChildren()` now unfocus the children. Added `clear(boolean)` and `clearChildren(boolean)` for when this isn't wanted. Code that overrides `clear()`/`clearChildren()` probably should change to override its counterpart taking a boolean parameter ([#6423](https://github.com/libgdx/libgdx/pull/6423)).

<br/>

# Common issues
The following are some of the more common issues when upgrading from previous versions of libGDX:

### 1. AbstractMethodError regarding glGetActiveAttrib
```
Exception in thread "main" com.badlogic.gdx.utils.GdxRuntimeException: java.lang.AbstractMethodError:
com.badlogic.gdx.backends.lwjgl3.Lwjgl3GL20.glGetActiveAttrib(IILjava/nio/IntBuffer;Ljava/nio/IntBuffer;)Ljava/lang/String;
```

The method signatures for `GL20#glGetActiveUniform` and `#glGetActiveAttrib` were changed in 1.9.11. This leads to issues if some of your libraries are pulling in older or later versions of libGDX as transitive dependencies. To fix this, you need to find the third-party dependency that is responsible for this. Use `./gradlew desktop:dependencies` on the command line to debug that.

### 2. iOS app uses only a quarter of the screen
If you are wondering why your iOS app is displayed in the lower left corner and is using only half of the screen’s width and height, you should take a look at the [iOS section above](#ios).

### 3. Could not resolve Gretty dependency
```
> Task :html:beforeRun FAILED

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':html:beforeRun'.
> Could not resolve all files for configuration ':html:grettyRunnerJetty94'.
   > Could not find org.gretty:gretty-runner-jetty94:3.0.2.
```
The Gretty dependency could not be resolved, because the corresponding repository is missing. Open the main `build.gradle` file in your project and in both of the two `repositories {}` sections add `gradlePluginPortal()`.
