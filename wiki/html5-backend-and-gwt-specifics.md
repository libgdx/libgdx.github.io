---
title: HTML5 Backend and GWT Specifics
---
Welcome to a place of magic and wonder, the World Wide Web! Even though some folks say this Internet thing is "just a fad," and we should keep using usenet and gopher, there's at least one thing the WWW has that those technologies don't:

## libGDX Games

That's right! You can make your very own libGDX games that run in an HTML5-capable web browser, which I assume is some advanced form of Netscape Navigator. This is possible by GWT, or Google Web Toolkit! I know what you're thinking, Google? The guys who are trying to let people search the Internet with a form? What are they doing with libGDX? I have no idea either. If you want to make your own libGDX game deploy to the web using GWT, well, just make a project in the latest setup jar and make sure to check the `Html` checkbox. The rest should be straightforward!

**BUT IT SOMETIMES ISN'T, AT FIRST**

So there are a few things that are fundamentally different about developing using GWT as opposed to running a desktop project. You'll want to get familiar with two Gradle tasks in particular; you can launch these tasks from your IDE if you aren't comfortable on the command line, but command-line Gradle tends to avoid problems when the IDE isn't working as well as we would like. `gradlew html:superDev` will be your main tool during development; it allows for a much-improved debugging experience and allows quickly reloading changes to the Java code. `gradlew html:dist` produces a fully-functioning web page that can be uploaded to a static web host (such as [itch.io](https://itch.io/developers) or [GitHub Pages](https://pages.github.com/), both free); it also optimizes the web page so the game in it will perform better, which makes `dist` take a little longer than `superDev`.

## superDev

superDev allows you to debug your HTML5 application. This is not necessary in most cases: if there are problems in your core game, you can debug the desktop application. But sometimes, there are bugs only appearing when running on HTML5. You can debug the application with the following steps:

* Run the `html:superdev` Gradle task. It compiles the game and sets up a local HTTP server. When it is done, it will idle to keep the server running.
* Your game is available here: http://localhost:8080/index.html (current config) or http://localhost:8080/html/ (older Gradle configuration with Jetty plugin) - open the page with *Chrome* to debug
* Hit the big reload button and hit compile. The game will recompile and source maps will be set up.
* After the game restarted, open Chrome's dev console with F12 and navigate to the sources tab. Hit Ctrl-P and enter the name of the Java file you want to debug. The Java file will open within Chrome's dev console and you can set a break point. You are able to step through the Java code lines. However, debug variables will be generated JS names but you'll be able to make sense of it.
* When you are done, you can stop the Gradle task with Ctrl-C.

If your bug does not show up on Chrome, but only on Firefox or Safari, you are in bad luck. No debugging is available. But you can work with debug logging and, to avoid unreadable stack traces, you can turn off the obfuscation by adding this line to HTML project's `build.gradle`:

```
gwt {
  // right below compiler.strict = true
  compiler.style = org.wisepersist.gradle.plugins.gwt.Style.DETAILED
}
```

## dist Information

Should be pretty straightforward; the dist is generated in `html/build/dist/`. You can delete the sourcemap files if you feel you won't be debugging the dist; they're usually a few MB in size and are in `html/build/dist/WEB-INF/deploy/html/symbolMaps`.

## Fullscreen Functionality

Surprisingly, fullscreen functionality actually works on the HTML backend. To enable fullscreen, call the following method from within your core project:

```java
Gdx.graphics.setFullscreenMode(Gdx.graphics.getDisplayMode());
```

The user will be prompted to press "ESC" to exit fullscreen. And it even works on mobile. Great! It does have some caveats though. Turns out you can't activate full screen on iOS. Also, if you choose to use the "Resizable Application" option in the HTML Launcher, you'll need to rewrite the ResizeListener to the following:

```java
class ResizeListener implements ResizeHandler {
    @Override
    public void onResize(ResizeEvent event) {
        if (Gdx.graphics.isFullscreen()) {
            Gdx.graphics.setFullscreenMode(Gdx.graphics.getDisplayMode());
        } else {
            int width = event.getWidth() - PADDING;
            int height = event.getHeight() - PADDING;
            getRootPanel().setWidth("" + width + "px");
            getRootPanel().setHeight("" + height + "px");
            getApplicationListener().resize(width, height);
            Gdx.graphics.setWindowedMode(width, height);
        }
    }
}
```

Don't forget to also set the fullscreen orientation for mobile in the getConfig():

```java
cfg.fullscreenOrientation = GwtGraphics.OrientationLockType.LANDSCAPE;
```

## Resolution on mobiles

On mobile, if your game is run in an iframe, or if you switch to full screen, you will notice that your game looks pixelated. That is because the reported screen size of mobiles is not the real screen size. You can enable using the real screen size with `config.usePhysicalPixels = true;`. This will also affect HDPI and Retina screens on desktop, so maybe you want to use `usePhysicalPixels = GwtApplication.isMobileDevice()`. [Check out this PR](https://github.com/libgdx/libgdx/pull/5691) for detailed information.

## Changing the Load Screen Progress Bar

As much as we love libGDX, the default loading progress bar when preparing the HTML game screams "newbie". Impress your friends and bring honor to your family name by making a custom progress bar! Add the following to your HtmlLauncher class in your HTML project:

```java
@Override
public Preloader.PreloaderCallback getPreloaderCallback() {
    return createPreloaderPanel(GWT.getHostPageBaseURL() + "preloadlogo.png");
}

@Override
protected void adjustMeterPanel(Panel meterPanel, Style meterStyle) {
    meterPanel.setStyleName("gdx-meter");
    meterPanel.addStyleName("nostripes");
    meterStyle.setProperty("backgroundColor", "#ffffff");
    meterStyle.setProperty("backgroundImage", "none");
}
```

"preloadlogo.png" is an image you place in the "webapp" folder in the HTML project for DIST builds. Place the image in your "war" folder as well for your SUPERDEV builds. Adjust your color to fit the theme of your game. Enjoy yourself.

Please note that you can only use pure GWT facilities to display the loading screen. libGDX APIs will only be available after the preloading is complete.
{: .notice--primary}

## Speeding up preload process

Speaking of the preloader: The HTML5 preloader is necessary, because usual gdx games rely on all assets being ready to access when needed. It prefetches every file in your asset directory. This may take some time and is not necessary if your game is a game that does not need all assets for presenting the startup screen. Think of all the people out there not having high speed internet connections.

From 1.9.12 on, you can decrease your preload time a lot if you use asset manager to load your assets later. You can override a predefined `AssetFilter` with your own AssetFilter on GWT and return `false` for all asset files that are not needed before game start. Make sure these files are only loaded via AssetManager, otherwise your game will freeze when using such assets.

```
public class AssetFilter extends DefaultAssetFilter {
    @Override
    public boolean preload(String file) {
        return !file.endsWith(".png") || file.startsWith("data/hud/");
    }
}
```

For compile process to pick up this asset filter instead of your own, add the following configuration to your `GdxDefinition.gwt.xml` file:

      <set-configuration-property name="gdx.assetfilterclass" value="your.package.AssetFilter"/>

([See game source commit using the feature](https://github.com/MrStahlfelge/SMC-libgdx/commit/b8d595376fe98a0ac55c1cf63f5f18c83c9afdfe))

Prior 1.9.12, you can use [an alternative backend](https://github.com/MrStahlfelge/gdx-backends).

## Preventing Keys From Triggering Scrolling and Other Browser Functions

On a normal web page, if you press the down arrow on your keyboard, it will scroll the page up. That's nice and all, but maybe you don't want that to happen when players are trying to move the character in your game. To prevent this, you have to set libGDX to prevent the default actions of special keys by catching them:

```java
Gdx.input.setCatchKey(Input.Keys.SPACE, true);
```

## Preventing Right Click Context Menu

Similarly to keyboard keys, the right click context menu can be prevented from interrupting your game. You'll notice that there are already functions to prevent left click from doing anything unexpected. You just need to add an additional line to apply the fix to right click as well. The following must be added to the script block of your index.html in the "html/webapp" folder (dist) and "html/war" folder (superDev):

```javascript
// prevent right click
document.getElementById('embed-html').addEventListener('contextmenu', handleMouseDown, false);
```

## Sound and Music

You will probably face some problems with sounds and music, especially on mobile platforms. It is not recommended to play sounds immediately on startup of the game as browsers probably will block this.

The implementation the official HTML5 backend uses has some other restrictions, too. Pitch will not work and you will experience a lag on playing the sounds the first time. If you want to improve the situation, [check out this PR](https://github.com/libgdx/libgdx/pull/5659)

## Differences Between GWT and Desktop Java

### Numbers

* When some number is very important and you want to make sure it is treated identically on desktop/Android and GWT, use a `long`.
* When you know a number will never be especially large (specifically, that it won't encounter numeric overflow by exceeding roughly 2 billion or negative 2 billion), feel free to use an `int`.
  * Math with `int`s is much faster than math with `long`s on GWT, because any `int` is represented by a JavaScript Number and web browsers are used to working with Numbers all the time. On the other hand, any `long` is represented by a specific type of JavaScript Object that stores three Numbers to help ensure precision.
  * A JavaScript Number, so an `int`, is almost the same as a `double` in Java, but it also allows bitwise operations to be used on it.
    * Because Numbers act like `double`s, they don't overflow, and can go higher than `Integer.MAX_VALUE` (2147483647) and lower than `Integer.MIN_VALUE` (-2147483648). Using any bitwise operation on them will bring any numbers that got too big back into the normal `int` range. If you encounter fishy numeric results that seem way too large for an int, try using this simple trick: `int fishy = Integer.MAX_VALUE * 5; int fixed = (Integer.MAX_VALUE * 5) | 0;` On desktop, adding `| 0` won't change anything, but it can correct numbers that got weird on GWT. Or, you can use a `long`.
* The problem with `long` values on GWT is that they aren't visible to reflection, so libGDX's Json class won't automatically write them or read them. You can work around this with Json's handy custom serializer behavior, so it isn't a huge issue.
* Floats can have more equality check problems than usual. Make sure you make all equality checks for floats by using `MathUtils.isEqual()`.

### Other Known Limitations

* Some java classes/features that are not supported:
  * System.nanoTime
  * Java reflection. You must only use libGDX reflection utils, see [this wiki page](/wiki/utils/reflection#gwt) for more details.
  * Multithreading is not supported.
* Audio:
  * Sound pitch is not implemented prior 1.9.12. You can use [an alternative backend](https://github.com/MrStahlfelge/gdx-backends) which is based on WebAudioAPI and supports it.
  * Your game needs a user interaction (eg. click on a button) before playing any music or sounds. This is a limitation for any games played in a browser.
* TiledMaps should be saved with Base64 encoding.
* Pixmap
  * Some Pixmap methods are not supported (eg. loading from binary data).
  * Some drawings (eg. lines) are antialiased which is not always wanted. If you need non-antialiased lines, you can [draw it pixel by pixel](https://github.com/libgdx/libgdx/issues/6019#issuecomment-702916344) or use FrameBuffer with a ShapeRenderer to achieve it.
* WebGL 1.0 is used and has its own limitations compared with OpenGL or GLES, among them:
  * NPOT (non power of two) textures are not supported with MipMap filters and/or Repeat wrapping.
  * Gdx.graphics.supportsExtension(...) should be called for each extension prior to enabling it in shaders.
* Some libGDX extensions are not supported or require additional libraries:
  * Bullet
  * Freetype requires https://github.com/intrigus/gdx-freetype-gwt

## Further Reading

[The original Super Dev Instructions from Mario](https://web.archive.org/web/20201028180932/https://www.badlogicgames.com/wordpress/?p=3073)

[How to speed up GWT compilation](https://www.gamefromscratch.com/post/2013/10/07/Speeding-up-GWT-compilation-speeds-in-a-LibGDX-project.aspx)

[Building libGDX from source and adding new files to gdx.gwt.xml](/wiki/misc/local-libgdx-package-use-with-gwt)

[HTML5 - GWT Explained on YouTube](https://youtu.be/I_85usDvJvQ)
