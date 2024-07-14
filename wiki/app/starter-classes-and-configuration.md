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

Since libGDX version 1.10.1, LWJGL3 has been the default desktop backend. You can find more information [here](/news/2021/07/devlog-7-lwjgl3).
{: .notice--info}

Opening the `Lwjgl3Launcher.java` class in `my-gdx-game` shows the following:

```java
package com.me.mygdxgame;

import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration;
import com.me.mygdxgame.MyGdxGame;

public class Lwjgl3Launcher {
    public static void main(String[] args) {
        if (StartupHelper.startNewJvmIfRequired()) return;
        createApplication();
    }

    private static Lwjgl3Application createApplication() {
        return new Lwjgl3Application(new MyGdxGame(), getDefaultConfiguration());
    }

    private static Lwjgl3ApplicationConfiguration getDefaultConfiguration() {
        Lwjgl3ApplicationConfiguration configuration = new Lwjgl3ApplicationConfiguration();
        configuration.setTitle("my-gdx-game");
        configuration.useVsync(true);
        configuration.setForegroundFPS(Lwjgl3ApplicationConfiguration.getDisplayMode().refreshRate);
        configuration.setWindowedMode(640, 480);
        configuration.setWindowIcon("libgdx128.png", "libgdx64.png", "libgdx32.png", "libgdx16.png");
        return configuration;
    }
}
```

First an [Lwjgl3ApplicationConfiguration](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-lwjgl3/src/com/badlogic/gdx/backends/lwjgl3/Lwjgl3ApplicationConfiguration.java) is instantiated. This class lets one specify various configuration settings, such as the initial screen resolution, whether to use OpenGL ES 2.0 or 3.0 and so on. Refer to the Javadocs of this class for more information.

Once the configuration object is set, an `Lwjgl3Application` is instantiated. The `MyGdxGame()` class is the ApplicationListener implementing the game logic.

From there on a window is created and the ApplicationListener is invoked as described in [The Life-Cycle](/wiki/app/the-life-cycle)

# Android

## Game Activity

Android applications do not use a `main()` method as the entry-point, but instead require an Activity. Open the `AndroidLauncher.java` class in the `my-gdx-game-android` project:

```java
package com.me.mygdxgame;

import android.os.Bundle;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;
import com.me.mygdxgame.MyGdxGame;

public class AndroidLauncher extends AndroidApplication {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AndroidApplicationConfiguration configuration = new AndroidApplicationConfiguration();
        configuration.useImmersiveMode = true;
        initialize(new MyGdxGame(), configuration);
    }
}
```

The main entry-point method is the Activity's `onCreate()` method. Note that `AndroidLauncher` derives from `AndroidApplication`, which itself derives from `Activity`. As in the desktop starter class, a configuration instance is created ([AndroidApplicationConfiguration](https://github.com/libgdx/libgdx/tree/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidApplicationConfiguration.java)). Once configured, the `AndroidApplication.initialize()` method is called, passing in the `ApplicationListener` (`MyGdxGame`) as well as the configuration. Refer to the [AndroidApplicationConfiguration Javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/backends/android/AndroidApplicationConfiguration.html) for more information on what configuration settings are available.

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
    xmlns:tools="http://schemas.android.com/tools">
  <uses-feature android:glEsVersion="0x00020000" android:required="true"/>
  <application
      android:allowBackup="true"
      android:fullBackupContent="true"
      android:icon="@drawable/ic_launcher"
      android:isGame="true"
      android:appCategory="game"
      android:label="@string/app_name"
      tools:ignore="UnusedAttribute"
      android:theme="@style/GdxTheme">
    <activity
        android:name="com.me.mygdxgame.android.AndroidLauncher"
        android:label="@string/app_name"
        android:screenOrientation="landscape"
        android:configChanges="keyboard|keyboardHidden|navigation|orientation|screenSize|screenLayout"
        android:exported="true">
        <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
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

Opening the `IOSLauncher.java` class in `my-gdx-game` shows the following:

```java
package com.me.mygdxgame.ios;

import org.robovm.apple.foundation.NSAutoreleasePool;
import org.robovm.apple.uikit.UIApplication;

import com.badlogic.gdx.backends.iosrobovm.IOSApplication;
import com.badlogic.gdx.backends.iosrobovm.IOSApplicationConfiguration;
import com.me.mygdxgame.MyGdxGame;

public class IOSLauncher extends IOSApplication.Delegate {
    @Override
    protected IOSApplication createApplication() {
        IOSApplicationConfiguration configuration = new IOSApplicationConfiguration();
        return new IOSApplication(new MyGdxGame(), configuration);
    }

    public static void main(String[] argv) {
        NSAutoreleasePool pool = new NSAutoreleasePool();
        UIApplication.main(argv, null, IOSLauncher.class);
        pool.close();
    }
}
```

See [this medium article](https://medium.com/@bschulte19e/deploying-your-libgdx-game-to-ios-in-2020-4ddce8fff26c) for more details on deploying to iOS devices.

# HTML5/GWT
The main entry-point for an HTML5/GWT application is a `GwtApplication`. Open `GwtLauncher.java` in the my-gdx-game-html5 project:

```java
package com.me.mygdxgame.gwt;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.backends.gwt.GwtApplication;
import com.badlogic.gdx.backends.gwt.GwtApplicationConfiguration;
import com.me.mygdxgame.MyGdxGame;

public class GwtLauncher extends GwtApplication {
    @Override
    public GwtApplicationConfiguration getConfig () {
        GwtApplicationConfiguration cfg = new GwtApplicationConfiguration(true);
        cfg.padVertical = 0;
        cfg.padHorizontal = 0;
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
<!DOCTYPE module PUBLIC "-//Google Inc.//DTD Google Web Toolkit 2.11.0//EN" "https://www.gwtproject.org/doctype/2.11.0/gwt-module.dtd">
<module rename-to="html">
  <source path="" />

  <inherits name="com.badlogic.gdx.backends.gdx_backends_gwt" />
  <inherits name="com.me.mygdxgame.MyGdxGame" />

  <entry-point class="com.me.mygdxgame.gwt.GwtLauncher" />

  <set-configuration-property name="gdx.assetpath" value="../assets" />
  <set-configuration-property name="xsiframe.failIfScriptTag" value="FALSE"/>
  <set-property name="user.agent" value="gecko1_8, safari"/>
  <collapse-property name="user.agent" values="*" />
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
