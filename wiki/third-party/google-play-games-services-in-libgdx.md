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

A [Super Jumper](https://github.com/libgdx/libgdx-demo-superjumper) based example that makes use of Leaderboards and Achievements.

The project is freely available on [GitHub](https://github.com/TheInvader360/libgdx-gameservices-tutorial), and a companion tutorial is available [here](https://theinvader360.blogspot.co.uk/2013/10/google-play-game-services-tutorial-example.html).

Another in-depth LibGDX-based tutorial for adding Google Play Game Services can be found [here](https://fortheloss.org/tutorial-set-up-google-services-with-libgdx/).

Latest tutorial using Android Studio can be found [here](https://chandruscm.wordpress.com/2015/12/30/how-to-setup-google-play-game-services-in-libgdx-using-android-studio/)

### IntelliJ IDEA and Android Studio Setup

1. Install Google Play Service and Google Play Repository using and Android SDK
   To do that on Android Studio, Open up SDK Manager, ( Click the button next to the AVD manager in the top toolbar ) click Launch Standalone SDK Manager
   Scroll down to the Extras section and make sure these 2 packages are installed and updated to the latest :
   * Google Play services
   * Google Repository
2. Download the BaseGameUtils sample project [here](https://github.com/playgameservices/android-basic-samples), copy folder `BaseGameUtils`, located in folder `BasicSamples` into your project root folder.
3. Edit `settings.gradle`
   ```gradle
   include 'desktop', 'android', 'ios', 'html', 'core', "BaseGameUtils"
   ```
4. Edit root `build.gradle` and add the below as android dependency:
   ```gradle
   compile project(":BaseGameUtils")
   ```
5. in your `AndroidManifest.xml` file
   * add two permissions:
      ```xml
      <uses-permission android:name="android.permission.INTERNET" />
      <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
      ```
   * add to your application tag
      ```xml
      <meta-data android:name="com.google.android.gms.games.APP_ID" android:value="@string/app_id" />
      ```
6. In your Android project, under 'res'->'values', in file `strings.xml` add app_id as follows, where 123456789 is your app ID as declared in the Google Play Developer Console:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
     <resources>
     <string name="app_name">sample_ios_google_signin</string>
     <string name="app_id">123456789</string>
   </resources>
   ```

7. `build.gradle` in Android project

   Synchronize with Gradle. you will get the following message:
   ```
   Error:Execution failed for task ':android:processDebugManifest'.
   > Manifest merger failed : uses-sdk:minSdkVersion 9 cannot be smaller than version 15 declared in library [libgdx-GPGS:BaseGameUtils:1.0]
   ```

   edit and set `minSdkVersion` to the version number in the message above (in this case '15')

## iOS integration

Google Play Game Services is no longer supported on iOS. You should use something like [gdx-gamesvcs](https://github.com/MrStahlfelge/gdx-gamesvcs) or [Firebase](/wiki/third-party/firebase-in-libgdx) instead.
{: .notice--warning}
