---
title: Starter classes and configuration
---
* [Desktop (LWJGL3)](#desktop-lwjgl3)
* [Desktop (LWJGL)](#desktop-lwjgl)
* [Android](#android)
  - [Game Activity](#game-activity)
  - [Game Fragment](#game-fragment)
  - [Manifest configuration](#manifest-configuration)
  - [Live Wallpapers](#live-wallpapers)
  - [Screen Savers (aka Daydreams)](#screen-savers-aka-daydreams)
* [iOS/Robovm](#iosrobovm)
* [HTML5/GWT](#html5gwt)


For each target platform, a starter class has to be written. This class instantiates a back-end specific `Application` implementation and the `ApplicationListener` that implements the application logic. The starter classes are platform-dependent, so let's have a look at how to instantiate and configure these for each backend.

This article assumes you have followed the instructions in [Project Setup](/wiki/start/project-generation) as well as [Importing & Running a Project](/wiki/start/import-and-running) and you therefore have already set up the project in your IDE.
{: .notice--info}

# Desktop (LWJGL3)

Since libGDX version 1.10.1, this has been the default desktop backend. You can find more information [here](/news/2021/07/devlog-7-lwjgl3).
{: .notice--info}

Opening the `DesktopLauncher.java` class in `my-gdx-game` shows the following:

```java
package com.me.mygdxgame;

import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration;

public class DesktopLauncher {
   public static void main(String[] args) {
      Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
      config.setTitle("my-gdx-game");
      config.setWindowedMode(480, 320);

      new Lwjgl3Application(new MyGdxGame(), config);
   }
}
```

First an [Lwjgl3ApplicationConfiguration](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-lwjgl3/src/com/badlogic/gdx/backends/lwjgl3/Lwjgl3ApplicationConfiguration.java) is instantiated. This class lets one specify various configuration settings, such as the initial screen resolution, whether to use OpenGL ES 2.0 or 3.0 and so on. Refer to the Javadocs of this class for more information.

Once the configuration object is set, an `Lwjgl3Application` is instantiated. The `MyGdxGame()` class is the ApplicationListener implementing the game logic.

From there on a window is created and the ApplicationListener is invoked as described in [The Life-Cycle](/wiki/app/the-life-cycle)

#### Common issues:

1. On **macOS**, there is another step required to get LWJGL 3 apps running. Either add the `com.badlogicgames.gdx:gdx-lwjgl3-glfw-awt-macos` dependency to your desktop project set the VM Options to `-XstartOnFirstThread`. The latter can typically be done in the Launch/Run Configurations of your IDE, as is described [here](/wiki/start/import-and-running). Alternatively, if you're starting your project via Gradle, add this line to `run` task of the desktop Gradle file:
   ```
    jvmArgs = ['-XstartOnFirstThread']
   ```
   A fourth approach is to just programatically restart the JVM if the argument is not present (see [here](https://github.com/crykn/guacamole/blob/master/gdx-desktop/src/main/java/de/damios/guacamole/gdx/StartOnFirstThreadHelper.java#L69) for a simple example). Lastly, if you want to deploy your game by packaging a JRE with it (which is the recommended way to distribute your later game), jpackage or packr allow you to set the JVM arguments.

2. If you are using **gdx-tools** and the lwjgl3 backend in the same project, you need to modify your gdx-tools dependency like this:
   ```
   compile ("com.badlogicgames.gdx:gdx-tools:$gdxVersion") {
      exclude group: 'com.badlogicgames.gdx', module: 'gdx-backend-lwjgl'
   }
   ```

# Desktop (LWJGL)

In version 1.10.1, libGDX switched its default desktop backend to LWJGL 3. If you want to upgrade, please take a look [here](/news/2021/07/devlog-7-lwjgl3#how-can-i-migrate).
{: .notice--warning}

Opening the `DesktopLauncher.java` class in `my-gdx-game` shows the following:

```java
package com.me.mygdxgame;

import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration;

public class DesktopLauncher {
   public static void main(String[] args) {
      LwjglApplicationConfiguration cfg = new LwjglApplicationConfiguration();
      cfg.title = "my-gdx-game";
      cfg.useGL30 = false;
      cfg.width = 480;
      cfg.height = 320;

      new LwjglApplication(new MyGdxGame(), cfg);
   }
}
```

First an [LwjglApplicationConfiguration](https://github.com/libgdx/libgdx/tree/master/backends/gdx-backend-lwjgl/src/com/badlogic/gdx/backends/lwjgl/LwjglApplicationConfiguration.java) is instantiated. This class lets one specify various configuration settings, such as the initial screen resolution, whether to use OpenGL ES 2.0 or 3.0 and so on. Refer to the [Javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/backends/lwjgl/LwjglApplicationConfiguration.html) of this class for more information.

Once the configuration object is set, an `LwjglApplication` is instantiated. The `MyGdxGame()` class is the ApplicationListener implementing the game logic.

From there on a window is created and the ApplicationListener is invoked as described in [The Life-Cycle](/wiki/app/the-life-cycle)

### Common issues:

- When using a JDK of version 8 or later, an **"illegal reflective access"** warning is shown. This is nothing to be worried about. If it bothers you, downgrade the used JDK or switch to the LWJGL 3 backend.

- If an error like **`Process 'command 'C:/.../java.exe'' finished with non-zero exit value -1`** is shown, this can safely be ignored. A workaround is disabling forceExit: `config.forceExit = false;`.

# Android

## Game Activity

Android applications do not use a `main()` method as the entry-point, but instead require an Activity. Open the `MainActivity.java` class in the `my-gdx-game-android` project:

```java
package com.me.mygdxgame;

import android.os.Bundle;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;

public class MainActivity extends AndroidApplication {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();

        initialize(new MyGdxGame(), cfg);
    }
}
```

The main entry-point method is the Activity's `onCreate()` method. Note that `MainActivity` derives from `AndroidApplication`, which itself derives from `Activity`. As in the desktop starter class, a configuration instance is created ([AndroidApplicationConfiguration](https://github.com/libgdx/libgdx/tree/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidApplicationConfiguration.java)). Once configured, the `AndroidApplication.initialize()` method is called, passing in the `ApplicationListener` (`MyGdxGame`) as well as the configuration. Refer to the [AndroidApplicationConfiguration Javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/backends/android/AndroidApplicationConfiguration.html) for more information on what configuration settings are available.

Android applications can have multiple activities. libGDX games should usually only consist of a single activity. Different screens of the game are implemented within libGDX, not as separate activities. The reason for this is that creating a new `Activity` also implies creating a new OpenGL context, which is time consuming and also means that all graphical resources have to be reloaded.

## Game Fragment

A libGDX game can be hosted in an Android [Fragment](https://developer.android.com/guide/fragments) instead of using a complete Activity. This allows it to take up a portion of the screen in an Activity or be moved between layouts. To create a libGDX fragment, subclass `AndroidFragmentApplication` and implement the `onCreateView()` with the following initialization:
```java
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return initializeForView(new MyGdxGame());
    }
```

That code depends on some other changes to the -android project:
1. [Add AndroidX Fragment Library to the -android project and its build path](https://developer.android.com/jetpack/androidx/releases/fragment) if you haven't already added it. This is needed in order to extend FragmentActivity later.
2. Change the AndroidLauncher Activity to extend FragmentActivity, not AndroidApplication.
3. Implement AndroidFragmentApplication.Callbacks on the AndroidLauncher Activity.
4. Create a class that extends AndroidFragmentApplication which is the Fragment implementation for libGDX.
5. Add the `initializeForView()` code in the Fragment's `onCreateView` method.
6. Finally, replace the AndroidLauncher activity content with the libGDX Fragment.

For example:
```java
// 2. Change AndroidLauncher activity to extend FragmentActivity, not AndroidApplication
// 3. Implement AndroidFragmentApplication.Callbacks on the AndroidLauncher activity
public class AndroidLauncher extends FragmentActivity implements AndroidFragmentApplication.Callbacks
{
   @Override
   protected void onCreate (Bundle savedInstanceState)
   {
      super.onCreate(savedInstanceState);

      // 6. Finally, replace the AndroidLauncher activity content with the libGDX Fragment.
      GameFragment fragment = new GameFragment();
      FragmentTransaction trans = getSupportFragmentManager().beginTransaction();
      trans.replace(android.R.id.content, fragment);
      trans.commit();
   }

   // 4. Create a Class that extends AndroidFragmentApplication which is the Fragment implementation for libGDX.
   public static class GameFragment extends AndroidFragmentApplication
   {
      // 5. Add the initializeForView() code in the Fragment's onCreateView method.
      @Override
      public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
      {  return initializeForView(new MyGdxGame());   }
   }

   @Override
   public void exit() {}
}
```

## Manifest configuration
Besides the `AndroidApplicationConfiguration`, an Android application is also configured via the `AndroidManifest.xml` file, found in the root directory of the Android project. This might look something like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.me.mygdxgame">

    <application
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name" >
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name"
            android:screenOrientation="landscape"
            android:configChanges="keyboard|keyboardHidden|orientation">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```

#### Screen Orientation & Configuration Changes
In addition to the targetSdkVersion, the `screenOrientation` and `configChanges` attributes of the activity element should always be set.

The `screenOrientation` attribute specifies a fixed orientation for the application. One may omit this if the application can work with both landscape and portrait mode.

The `configChanges` attribute is *crucial* and should always have the values shown above. Omitting this attribute means that the application will be restarted every time a physical keyboard is slid out/in or if the orientation of the device changes. If the `screenOrientation` attribute is omitted, a libGDX application will receive calls to `ApplicationListener.resize()` to indicate the orientation change. API clients can then re-layout the application accordingly.

#### Permissions
If an application needs to be able to write to the external storage of a device (e.g. SD-card), needs internet access, uses the vibrator or wants to record audio, the following permissions need to be added to the `AndroidManifest.xml` file:

```xml
	<uses-permission android:name="android.permission.RECORD_AUDIO"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.VIBRATE"/>
```

Users are generally suspicious of applications with many permissions, so choose these wisely.

For wake locking to work, `AndroidApplicationConfiguration.useWakeLock` needs to be set to true.

If a game doesn't need accelerometer or compass access, it is advised to disable these by setting the
`useAccelerometer` and `useCompass` fields of `AndroidApplicationConfiguration` to false.

If your game needs the gyroscope sensor, you have to set `useGyroscope` to true in `AndroidApplicationConfiguration` (It's disabled by default, to save energy).

Please refer to the [Android Developer's Guide](https://developer.android.com/guide) for more information on how to set other attributes like icons for your application.

## Live Wallpapers
A libGDX core application can also be used as an Android [Live Wallpaper](https://android-developers.googleblog.com/2010/02/live-wallpapers.html).
The project setup is very similar to an Android game, but `AndroidLiveWallpaperService` is used in
place of `AndroidApplication`. Live Wallpapers are Android [Services](https://developer.android.com/guide/components/services),
not Activities.

**Note: Due to synchronization issues, you cannot combine games and live wallpapers in the same app. However, Live
Wallpapers and Screen Savers can safely coexist in the same app.**

First, extend `AndroidLiveWallpaperService` and override `onCreateApplication()` (instead of `onCreate()`
like you would do with a game `Activity`):

```java
public class MyLiveWallpaper extends AndroidLiveWallpaperService {
    @Override
    public void onCreateApplication() {
        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();

        initialize(new MyGdxGame(), cfg);
    }
}
```

You can optionally subscribe to Live Wallpaper-specific events by implementing `AndroidWallpaperListener` with your
`ApplicationListener` class. `AndroidWallpaperListener` is not available from the `core` module, so you can either
follow the strategy outlined in [Interfacing With Platform-Specific Code](/wiki/app/interfacing-with-platform-specific-code), or you can manage it just from the `android`
module by subclassing your `ApplicationListener` like this:

```java
public class MyLiveWallpaper extends AndroidLiveWallpaperService {

    static class MyLiveWallpaperListener extends MyGdxGame implements AndroidWallpaperListener {
        @Override
        public void offsetChange (float xOffset, float yOffset, float xOffsetStep,
                                  float yOffsetStep, int xPixelOffset, int yPixelOffset) {
            // Called when the home screen is scrolled. Not all launchers support this.
        }

        @Override
        public void previewStateChange (boolean isPreview) {
            // Called when switched between being previewed and running as the wallpaper.
        }

        @Override
        public void iconDropped (int x, int y) {
            // Called when an icon is dropped on the home screen.
        }
    }

    @Override
    public void onCreateApplication() {
        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();

        initialize(new MyLiveWallpaperListener(), cfg);
    }
}
```

Since libGDX 1.9.12, you can also report the dominant colors of the wallpaper to
the OS. Starting with Android 8.1, this is used by some Android launchers and lock screens for styling, such as changing
the text color of the clock. You can create a method like this to report the colors, and access it from the core module
using the strategy from [Interfacing With Platform-Specific Code](/wiki/app/interfacing-with-platform-specific-code):

```java
public void notifyColorsChanged (Color primaryColor, Color secondaryColor, Color tertiaryColor) {
    Application app = Gdx.app;
    if (Build.VERSION.SDK_INT >= 27 && app instanceof AndroidLiveWallpaper) {
        ((AndroidLiveWallpaper) app).notifyColorsChanged(primaryColor, secondaryColor, tertiaryColor);
    }
}
```

In additional to the service class, you must also create an `xml` file in the Android `res/xml` directory to define
some Live Wallpaper properties: its thumbnail and description shown in the wallpaper picker, and an optional settings
Activity. Let's call this file `livewallpaper.xml`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<wallpaper
    xmlns:android="http://schemas.android.com/apk/res/android"  
    android:thumbnail="@drawable/ic_launcher"
    android:description="@string/description"
    android:settingsActivity="com.mypackage.MyLiveWallpaperSettingsActivity"/>
```

Finally, you'll need to add things to your `AndroidManifest.xml` files. Here's an example for a Live Wallpaper with a simple
settings Activity. The key elements here are the `uses-feature` and `service` blocks. The label and icon set on the
service appear in the Android application settings. The settings Activity and the Live Wallpaper service must both be set
with `exported` true so they can be accessed by the Live Wallpaper picker.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.mypackage">
    <uses-feature android:name="android.software.live_wallpaper" />
    <application android:icon="@drawable/icon" android:label="@string/app_name">
        <activity android:name=".MyLiveWallpaperSettingsActivity"
            android:label="@string/app_name"
            android:exported="true" />
        <service android:name=".LiveWallpaper"
            android:label="@string/app_name"
            android:icon="@drawable/icon"
            android:exported="true"
            android:permission="android.permission.BIND_WALLPAPER">
            <intent-filter>
                <action android:name="android.service.wallpaper.WallpaperService" />
            </intent-filter>
            <meta-data android:name="android.service.wallpaper"
                android:resource="@xml/livewallpaper" />
        </service>				  	
    </application>
</manifest>
```

Live Wallpapers have some limitations concerning touch input. In general only one pointer will be reported. If you want
full multi-touch events you can set the `AndroidApplicationConfiguration.getTouchEventsForLiveWallpaper` field to true.

## Screen Savers (aka Daydreams)
A libGDX core application can also be used as an Android [Screen Saver](https://developer.android.com/about/versions/android-4.2#Daydream).
Screen Savers were once known as Daydreams, so many of the related classes have the term "Daydream" in their names. Screen
Savers have no relation to Google's Daydream VR platform.

The project setup is very similar to an Android game, but `AndroidDaydream` is used in  place of `AndroidApplication`.
Screen Savers are Android [Services](https://developer.android.com/guide/components/services), not Activities.

First, extend `AndroidDaydream` and override `onAttachedToWindow()` (instead of `onCreate()` like you
would do with a game `Activity`). It must call through to `super`. You can also call `setInteractive()` from this method
to enable/disable touch. A non-interactive Screen Saver immediately closes when the screen is touched.

```java
public class MyScreenSaver extends AndroidDaydream {
    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        setInteractive(true);

        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();
        initialize(new MyGdxGame(), cfg);
    }
}
```

In additional to the service class, you must also create an `xml` file in the Android `res/xml` directory to define
the only Screensaver setting: an optional settings Activity. Let's call this file `screensaver.xml`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<dream xmlns:android="http://schemas.android.com/apk/res/android"
    android:settingsActivity="com.badlogic.gdx.tests.android/.MyScreenSaverSettingsActivity" />
```

Finally, you'll need to add things to your `AndroidManifest.xml` files. Here's an example for a Screen Saver with a simple
settings Activity. Note that a settings Activity is optional. The key element is the `service` block. The settings Activity
and the Screen Saver service must both be set with `exported` true so they can be accessed by the Screen Saver picker.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.mypackage">
    <application android:icon="@drawable/icon" android:label="@string/app_name">
        <activity android:name=".MyScreenSaverSettingsActivity"
            android:label="@string/app_name"
            android:exported="true" />
        <service android:name=".MyScreenSaver"
            android:label="@string/app_name"
            android:icon="@drawable/icon"
            android:exported="true" >
            <intent-filter>
                <action android:name="android.service.dreams.DreamService" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
            <meta-data android:name="android.service.dream"
                android:resource="@xml/screensaver" />
        </service>			  	
    </application>
</manifest>
```

# iOS/Robovm

[ToDo]

# HTML5/GWT
The main entry-point for an HTML5/GWT application is a `GwtApplication`. Open `GwtLauncher.java` in the my-gdx-game-html5 project:

```java
package com.me.mygdxgame.client;

import com.me.mygdxgame.MyGdxGame;
import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.backends.gwt.GwtApplication;
import com.badlogic.gdx.backends.gwt.GwtApplicationConfiguration;

public class GwtLauncher extends GwtApplication {
   @Override
   public GwtApplicationConfiguration getConfig () {
      GwtApplicationConfiguration cfg = new GwtApplicationConfiguration(480, 320);
      return cfg;
   }

   @Override
   public ApplicationListener createApplicationListener () {
      return new MyGdxGame();
   }
}
```

The main entry-point is composed of two methods, `GwtApplication.getConfig()` and `GwtApplication.createApplicationListener()`. The former has to return a [GwtApplicationConfiguration](https://github.com/libgdx/libgdx/tree/master/backends/gdx-backends-gwt/src/com/badlogic/gdx/backends/gwt/GwtApplicationConfiguration.java) instance, which specifies various configuration settings for the HTML5 application. The `GwtApplication.createApplicatonListener()` method returns the `ApplicationListener` to run.

### Module Files
GWT needs the actual Java code for each jar/project that is referenced. Additionally, each of these jars/projects needs to have one module definition file, having the suffix gwt.xml.

In the example project setup, the module file of the html5 project looks like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE module PUBLIC "-//Google Inc.//DTD Google Web Toolkit trunk//EN" "http://google-web-toolkit.googlecode.com/svn/trunk/distro-source/core/src/gwt-module.dtd">
<module>
   <inherits name='com.badlogic.gdx.backends.gdx_backends_gwt' />
   <inherits name='MyGdxGame' />
   <entry-point class='com.me.mygdxgame.client.GwtLauncher' />
   <set-configuration-property name="gdx.assetpath" value="../my-gdx-game-android/assets" />
</module>
```

This specifies two other modules to inherit from (gdx-backends-gwt and the core project) as well as the entry-point class (`GwtLauncher` above) and a path relative to the html5 project's root directory, pointing to the assets directory.

Both the gdx-backend-gwt jar and the core project have a similar module file, specifying other dependencies. *You cannot use jars/projects which do not contain a module file and source!*

For more information on modules and dependencies refer to the [GWT Developer Guide](https://developers.google.com/web-toolkit/doc/1.6/DevGuide).

### GWT Specifics

The HTML backend has a number of caveats. Be sure to check out the  comprehensive [HTML Backend Guide](/wiki/html5-backend-and-gwt-specifics#differences-between-gwt-and-desktop-java)!
{: .notice--warning}

GWT does not support Java **reflection** for various reasons. libGDX has an internal emulation layer that will generate reflection information for a select few internal classes. This means that if you use the [Json serialization](/wiki/utils/reading-and-writing-json) capabilities of libGDX, you'll run into issues. You can fix this by specifying for which packages and classes reflection information should be generated for. To do so, take a look at the [Reflection Guide](/wiki/utils/reflection#gwt).

A libGDX HTML5 application preloads all assets found in the `gdx.assetpath`. During this loading process, a **loading screen** is displayed which is implemented via GWT widget. If you want to customize this loading screen, you can simply overwrite the `GwtApplication.getPreloaderCallback()` method (in `GwtLauncher` in the above example). An example can be found [here](/wiki/html5-backend-and-gwt-specifics#changing-the-load-screen-progress-bar).
