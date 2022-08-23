---
title: Google Mobile Ads in libGDX (replaces deprecated AdMob)
---
The number one ad service being used by Android and libGDX developers at the moment is Google AdMob.

If you've not updated your app recently you should consider doing so soon. Google says:

> Android (6.4.1 and earlier SDKs)
> Deprecated. On August 1, 2014, Google Play will stop accepting new or updated apps that use the old standalone Google Mobile Ads SDK v6.4.1 or lower. You must upgrade to the Google Play version of the Mobile Ads SDK by then.

Ok, so we want to migrate to the new Google Play Services way of doing things - this wiki post walks you through the process :)

***

**Barebones Sample App**

I created a new libGDX project using gdx-setup-ui.jar, added a .gitignore file, and made my initial commit.


**Eclipse Setup**

In eclipse, import the barebones sample app (file > import > existing projects into workspace) - you should now have at least three projects in package explorer (core, android, and desktop).

Open the Android SDK Manager, download the latest SDK Platform and Google APIs (at time of writing: 4.4.2/API19), the 2.3.1/API9 SDK Platform, and from Extras - Google Play Services.

Locate the <android-sdk>/extras/google/google_play_services/libproject/google-play-services_lib/ directory on your machine (on my windows machine - C:\Program Files (x86)\Android\android-sdk\extras\google\google_play_services\libproject\google-play-services_lib) and copy into your working directory alongside the existing libGDX projects.

File > Import > Android > Existing Android Code, Next, Browse, navigate to the local copy of google-play-services_lib in your working directory, Ok, Finish.

Right-click your android project, select Properties, Android, scroll down and click Add, select the google-play-services_lib project, Ok.

A refresh and clean in eclipse probably wouldn't hurt at this point, so go ahead and do that.


**AndroidManifest.xml**

Ensure that the target in android project's project.properties file is at least 13, and the android:minSdkVersion in your AndroidManifest.xml is at least 9. Sadly this does mean users running ancient versions of Android will be excluded, but there's nothing we can do about this. There are very very VERY few devices still running versions below 2.3/API9, so at least you won't be excluding many users...

Add these two lines as children of the 'application' element:

`<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version"/>`   
`<activity android:name="com.google.android.gms.ads.AdActivity" android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize"/>`

Add these two permissions as children of the 'manifest' element:

`<uses-permission android:name="android.permission.INTERNET"/>`   
`<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>`

Save changes, then refresh and clean in eclipse for good luck...


**Banner Ad**

[See this version of the android project's MainActivity class](https://github.com/TheInvader360/tutorial-libgdx-google-ads/blob/9a4c9342d98c02e3c44e0b62fcfaa153d257130a/tutorial-libgdx-google-ads-android/src/com/theinvader360/tutorial/libgdx/google/ads/MainActivity.java) for a reasonably straightforward banner ad implementation.


**Interstitial Ad**

[This diff shows an interstitial ad implementation](https://github.com/TheInvader360/tutorial-libgdx-google-ads/commit/0a5ea376d4eb92b8e87c13a03245adb40b53e811) (ActionResolver interface lets us trigger interstitial actions from the core project while retaining the invaluable libGDX cross-platform functionality).

***

That's all there is to it!

One final note if cloning from [https://github.com/TheInvader360/tutorial-libgdx-google-ads](https://github.com/TheInvader360/tutorial-libgdx-google-ads), pay attention to the problems view in eclipse! You will need to create an empty 'gen' directory in both the google-play-services_lib and tutorial-libgdx-google-ads-android projects, and ensure you have the required android sdks installed. As is often the case with eclipse, a liberal amount of refreshing and cleaning will do no harm...
