---
title: Querying and Configuring Graphics (monitors, display modes, vsync, display cutouts)
---
# Configuration & querying
libGDX has an elaborate API that lets you query monitors and display modes, and toggle vertical synchronization (vsync). This can be done either when configuring your application, or at runtime. **Note: Display mode changes are not supported by Android, iOS or HTML5.**

## Querying and setting monitors & display modes at configuration time
Querying monitors and display modes at configuration time is platform specific. The following subsections illustrate what you can do on each platform with regards to monitors and display modes.

### Desktop LWJGL 3 backend
Unlike the legacy LWJGL 2 backend, LWJGL 3 supports multi-monitor setups.

Querying all available monitors at configuration time works like this:
```java
Monitor[] monitors = Lwjgl3ApplicationConfiguration.getMonitors();
```

To get the primary monitor, call:
```java
Monitor primary = Lwjgl3ApplicationConfiguration.getPrimaryMonitor();
```

To get all supported display modes of a monitor, call:
```java
DisplayMode[] displayModes = Lwjgl3ApplicationConfiguration.getDisplayModes(monitor);
```

To get the current display mode of a monitor, call:
```java
DisplayMode desktopMode = Lwjgl3ApplicationConfiguration.getDisplayMode(monitor);
```

There are shorthands for getting the display modes of the primary monitor as well:
```java
DisplayMode[] primaryDisplayModes = Lwjgl3ApplicationConfiguration.getDisplayModes();
DisplayMode primaryDesktopMode = Lwjgl3ApplicationConfiguration.getDisplayMode();
```

With a display mode in hand, you can set it on the `Lwjgl3ApplicationConfiguration`:
```java
DisplayMode primaryMode = Lwjgl3ApplicationConfiguration.getDisplayMode();
Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
config.setFullscreenMode(primaryMode);
new Lwjgl3Application(new MyAppListener(), config);
```
This will start your app in full-screen mode on the primary monitor, using that monitor's current resolution. If you pass a display mode from a different monitor, the app will be started in full-screen mode on that montior. **Note: it is recommended to always use the current display mode of a monitor. Other display modes may fail.**

To start your app in windowed mode, call this method on the configuration:
```java
Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
config.setWindowedMode(800, 600);
```

This will start your app in windowed mode on the primary monitor. To set the position of your window call:
```java
config.setWindowPosition(100, 100);
```

This will position the window's top-left corner at the coordinates `100,100` relative to the virtual surface all your monitors span. To check the position of a monitor, simply access it's `virtualX` and `virtualY` members. These coordinates are also relative to the virtual surface your monitors span. By positioning your window relative to these coordinates, you can move a window to that specific monitor.

You can also specify if your window should be resizable and whether it has decoration (window title bar, borders):
```java
config.setResizable(false);
config.setDecorated(false);
```

The LWJGL 3 backend also allows you to specify how to deal with HDPI monitors. The operating system may report logical sizes and coordinates instead of pixel-based coordinates to you for drawing surface sizes or mouse events. E.g. on a Macbook Pro with a retina display running Mac OS X, the OS reports only half the width/height of the underlying pixel surface. The LWJGL 3 backend can report drawing surface sizes as returned by `Gdx.graphics.getWidth()/getHeight()` and mouse coordinates either in those logical coordinates, or in pixel coordinates. To configure this behaviour, set a HDPI mode:

```java
config.setHdpiMode(HdpiMode.Logical);
```

This will report mouse coordinates and drawing surface sizes in logical coordinates. It is also the default for this backend. If you want to work in raw pixels, use `HdpiMode.Pixels`. Note that when using logical coordinates, you will have to convert these to pixel coordinates for OpenGL functions like `glScissor`, `glViewport` or `glReadPixels`. All libGDX classes calling these functions will take into account the `HdpiMode` you set. If you call these functions yourself, use `HdpiUtils`.

## Querying and setting monitors & display modes at runtime
libGDX provides an API via the `Graphics` interface that lets you query monitors, display modes and other related aspects at runtime. Once you know about possible configurations, you can set them, e.g. switch to full-screen mode, or toggle vsync.

### Checking if display mode changes are supported
Only a subset of platforms supports display mode changes. Notably, Android and iOS do not support switching to arbitrary full-screen display modes. It is therefor good practice to check if the platform your application currently runs on supports display mode changes:
```java
if(Gdx.graphics.supportsDisplayModeChange()) {
   // change display mode if necessary
}
```
Note that all display mode related functions in `Graphics` will simply not do anything on platforms that don't support display mode changes.

### Querying monitors
To query all connected monitors, use this method:
```java
Monitor[] monitors = Gdx.graphics.getMonitors();
```

On Android, iOS, GWT and the LWJGL 2 backend, only the primary monitor will be reported. The LWJGL 3 backend reports all connected monitors.

To query the primary monitor, use:
```java
Monitor primary = Gdx.graphics.getPrimaryMonitor();
```

To query the monitor the window is currently on, use:
```java
Monitor currMonitor = Gdx.graphics.getMonitor();
```

It is good practice to toggle full-screen on the monitor the window is on, instead of say the primary monitor. This allows users to move the application window to another monitor, and then enable full-screen mode there.

### Querying display modes
Once you have a `Monitor` instance, you can query its supported display modes:
```java
DisplayMode[] modes = Gdx.graphics.getDisplayModes(monitor);
```

To get the current display mode, use this method:
```java
DisplayMode currMode = Gdx.graphics.getDisplayMode(monitor);
```

### Switching to full-screen mode
With a `DisplayMode` from a specific `Monitor`, you can switch to full-screen as follows:
```java
Monitor currMonitor = Gdx.graphics.getMonitor();
DisplayMode displayMode = Gdx.graphics.getDisplayMode(currMonitor);
if(!Gdx.graphics.setFullscreenMode(displayMode)) {
   // switching to full-screen mode failed
}
```
If the switch to full-screen mode failed, the backend will restore the last windowed-mode configuration.

### Switching to windowed mode
To change the size of a window, or to switch from full-screen mode to windowed mode, use this method:
```java
Gdx.graphics.setWindowedMode(800, 600);
```

This will set the window to windowed mode, centering it on the monitor it was on before the call to this method.

## Querying display cutouts on mobile
On Android and iOS, displays don't have to be a perfect rectangle but might have cutouts, round edges or overlaying status bars. You can query the areas that are not safe to use for your important game content with the `Gdx.graphics.getSafeInsetLeft()`, `Gdx.graphics.getSafeInsetRight()`, `Gdx.graphics.getSafeInsetTop()` and `Gdx.graphics.getSafeInsetBottom()` methods.

## Desktop & multi-window API of the LWJGL 3 backend
Some applications like editors or other desktop-only tools can benefit from multi-window setups. The LWJGL 3 backend provides an additional, non-cross-platform API to create multiple windows.

Every application starts with one window that is set up during configuration time:
```java
Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
config.setWindowedMode(800, 600);
new Lwjgl3Application(new MyMainWindowListener(), config);
```

In this example, the window is driven by `MyMainWindowListener`, a standard `ApplicationListener`. libGDX does not report events like iconification or focus loss directly. For this, the LWJGL 3 backend introduces a desktop specific interface called `Lwjgl3WindowListener`. You can provide an implementation of this interface to receive and react to such events:
```java
config.setWindowListener(new Lwjgl3WindowListener() {
   @Override
   public void iconified() {
      // the window is not visible anymore, potentially stop background
      // work, mute audio, etc.
   }

   @Override
   public void deiconified() {
      // the window is visible again, start-up background work, unmute
      // audio, etc.
   }

   @Override
   public void focusLost() {
      // the window lost focus, pause the game
   }

   @Override
   public void focusGained() {
      // the window received input focus, unpause the game
   }

   @Override
   public boolean windowIsClosing() {
      // if there's unsaved stuff, we may not want to close
      // the window, but ask the user to save her work
      if(isStuffUnsaved) {
         // tell our app listener to show a save dialog
         return false;
      } else {
         // OK, the window may close
         return true;
      }
});
```

The LWJGL 3 backend does not report pause and resume events if the window loses focus. It will only report pause and resume events in case the app is iconfified/deiconified, or if the app is being closed.

To spawn additional windows, your code needs to cast `Gdx.app` to `Lwjgl3Application`. This is only possible if your project directly depends on the LWJGL 3 backend. You will not be able to share such code with other platforms. Once you have an `Lwjgl3Application`, you can create a new window like this:
```java
Lwjgl3Application lwjgl3App = (Lwjgl3Application)Gdx.app;
Lwjgl3WindowConfiguration windowConfig = new Lwjgl3WindowConfiguration();
windowConfig.setWindowListener(new MyWindowListener());
windowConfig.setTitle("My other window");
Lwjgl3Window window = Lwjgl3App.newWindow(new MyOtherWindowAppListener(), windowConfig);
```

It is recommended to let every window have its own `ApplicationListener`. All windows of an application are updated on the same thread, one after the other. The LWJGL 3 backend will ensure that the statics `Gdx.graphics` and `Gdx.input` are setup for the window that's currently being updated. This means that your `ApplicationListener` can essentially ignore the other windows, and pretend it's the only listener in town.

There is one exception to this. When using `Gdx.app.postRunnable()`, the LWJGL 3 backend can not decide for which window the `Runnable` has been posted. E.g. the method may have been called from a worker thread, and by the time the `Runnable` is posted, a different window may currently be updated. To fix this, it is recommended to post window-specific `Runnable` instances directly to the window:

```java
// e.g. in a worker thread
window.postRunnable(new MyRunnable());
```

This ensures that the statics `Gdx.graphics` and `Gdx.input` will be setup for the specific window when the `Runnable` is executed.

The `Lwjgl3Window` class has additional methods that let you modify the window's properties. You can fetch the current window in your `ApplicationListener`, then proceed to modify it:
```java
// in ApplicationListener#render()
Lwjgl3Window window = ((Lwjgl3Graphics)Gdx.graphics).getWindow();
window.setVisible(false); // hide the window
window.iconifyWindow(); // iconify the window
window.deiconifyWindow(); // deiconify window
window.closeWindow(); // close the window, also disposes the ApplicationListener
```
