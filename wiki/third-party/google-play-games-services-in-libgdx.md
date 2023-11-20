---
title: Google Play Games Services in libGDX
---
[Google Play Games Services](https://developers.google.com/games/services/) offers social leaderboards, achievements, and much more (realtime multiplayer, cloud saves, anti-piracy...)

Cross-platform features are deprecated, for new projects it is recommended to use on Android only.

## Using open-source libGDX Extension
Google Play Games support for libGDX games on Android and Desktop is provided by [gdx-gamesvcs libGDX extension](https://github.com/MrStahlfelge/gdx-gamesvcs). The extension also provides implementations for other game services (Apple Game Center, GameJolt and others).

Follow the readme and the project's wiki to integrate GPGS and other game services in your project.

## Manual integration in your project

The following article describes the manual integration in your project without using the library.

A [Super Jumper](https://github.com/libgdx/libgdx-demo-superjumper) based example that makes use of Leaderboards and Achievements is available to download from [Google Play](https://play.google.com/store/apps/details?id=com.theinvader360.tutorial.libgdx.gameservices).

The project is freely available on [GitHub](https://github.com/TheInvader360/libgdx-gameservices-tutorial), and a companion tutorial is available [here](https://theinvader360.blogspot.co.uk/2013/10/google-play-game-services-tutorial-example.html).

Another in-depth LibGDX-based tutorial for adding Google Play Game Services can be found [here](https://fortheloss.org/tutorial-set-up-google-services-with-libgdx/).

Latest tutorial using Android Studio can be found [here](https://chandruscm.wordpress.com/2015/12/30/how-to-setup-google-play-game-services-in-libgdx-using-android-studio/)

### Intellij IDEA and Android Studio Setup

1. Install Google Play Service and Google Play Repository using and Android SDK

To do that on Android Studio, Open up SDK Manager, ( Click the button next to the AVD manager in the top toolbar ) click Launch Standalone SDK Manager
Scroll down to the Extras section and make sure these 2 packages are installed and updated to the latest :
* Google Play services
* Google Repository

2. Download BaseGameUtils sample project [here](https://github.com/playgameservices/android-basic-samples), copy folder `BaseGameUtils`, located in folder `BasicSamples` into your project root folder.

3. Edit settings.gradle 
```
include 'desktop', 'android', 'ios', 'html', 'core', "BaseGameUtils"
```
4. Edit root build.gradle and add the below as android dependency: 
```
compile project(":BaseGameUtils")
```

5. in your AndroidManifest.xml file

* add two permissions:
```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

* add to your application tag
```
<meta-data android:name="com.google.android.gms.games.APP_ID" android:value="@string/app_id" />
```

6. string.xml

in your android project, under 'res'->'values', in file `strings.xml` add app_id as follow, where 123456789 is your app ID in as declared in the Google Play Developer Console.

```
<?xml version="1.0" encoding="utf-8"?>
  <resources>
  <string name="app_name">sample_ios_google_signin</string>
  <string name="app_id">123456789</string>
</resources>
```

6. build.gradle in Android project

Synchronize with Gradle. you will get the following message: 
```
Error:Execution failed for task ':android:processDebugManifest'.
> Manifest merger failed : uses-sdk:minSdkVersion 9 cannot be smaller than version 15 declared in library [libgdx-GPGS:BaseGameUtils:1.0]
```

edit and set `minSdkVersion` to the version number in the message above (in this case '15')

## iOS integration

**Google Play Games' iOS support is deprecated and shouldn't be implemented in new games.**

There are two ways (called `Backend`) to integrate Google Play Games Services with iOS depending whether your are using the open source, community supported [Mobidevelop's RoboVM and its Robopods](https://github.com/MobiDevelop/robovm) or [Intel's Multi-OS Engine](https://software.intel.com/en-us/node/633261) 

### Mobidevelop's RoboVM and its Robopods

Please read the specific page for more information on [Mobidevelop's RoboVM and its Robopods](https://github.com/MobiDevelop/robovm)

*Warning:You can no longer create new Google Play Game Services accounts with iOS. There is a [Simple LIBDX Google Play Games Services integration for iOS](https://github.com/julienvillegas/libgdx-GPGS) but it explains why the new version of Google SDK does not allow iOS users to create a GPGS account from iOS (not a libGDX issue).*

note: Until early 2016, libGDX iOS integration was achieved using RoboVM.com. This has been deprecated. Be careful when you check examples on the Internet as older examples may be based on this version.
The easy way to find out which version is being referred to:
* Supported version will have `com.mobidevelop.robovm` in the buid.gradle file
* Deprecated examples will have `org.robovm:robovm` in the buid.gradle file   

### Intel's Multi-OS Engine

Checkout the specific page for more information on [Intel's Multi-OS Engine](https://software.intel.com/en-us/node/633261).

In the meantime, you can check out the following sample to get you started:

[Splinter Sweets](https://github.com/reime005/splintersweets) is a Kotlin based example that makes use of Leaderboards. It is available on Android and iOS (Gamecenter and Google Play Services integration).


