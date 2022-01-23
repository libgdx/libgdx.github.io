---
title: Smaato in libGDX
---
# Summary #

 * [Introduction](#introduction)
 * [Configuration](#configuration)
 * [Recap](#recap)
 * [Banner](#banner)
 * [Interstitial](#interstitial)
 * [Rewarded](#rewarded)
 * [Test Ads](#test-ads)

# Introduction #

This article will show you how to add Smaato ads to your libGDX Android projects. You will be able to monetize your games with Banner, Interstitial and Rewarded Ads. This tutorial implies that you are already familiar with libGDX basics and how Android Views are handled. But there will be a short recap.

Just for a reference, the latest documentation is available on Smaato official [website](https://developers.smaato.com/publishers/nextgen-sdk-android-integration).

You will need:
1. A libGDX Android Game Project
2. Your [Smaato](https://spx.smaato.com) account

# Configuration #
Add the following repository setup to your project’s main `build.gradle` file:
```java

buildscript {
    repositories {
        mavenCentral()
        google()
        jcenter()
        maven { url "https://s3.amazonaws.com/smaato-sdk-releases/" }
    }
}
...
allprojects {
    repositories {
        google()
        jcenter()
        maven {
            url "https://s3.amazonaws.com/smaato-sdk-releases/"
        }
    }
}
```
Set the compile options to Java 8 and minSdkVersion to at least version 16, in android module `build.gradle` file:
```java
android {
    defaultConfig {
        minSdkVersion 16
        ...
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

Add required dependencies to your application module `build.gradle` file under project(":android") --> dependencies.

`implementation 'com.smaato.android.sdk:smaato-sdk:21.5.3`

If you’re using Proguard in your project, please add the following lines to your Proguard config file:
```java
-keep public class com.smaato.sdk.** { *; }
-keep public interface com.smaato.sdk.** { *; }
```

Add the following permissions to application AndroidManifest.xml file:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

If your application targets Android 5.0 (API level 21) or higher, then you need to add the following line to your application AndroidManifest.xml file:
```xml
<uses-feature android:name="android.hardware.location.network" />
```

The latest version of Smaato NextGenSDK has been validated against `com.android.tools.build:gradle:3.5.4` and gradle-wrapper `gradle-5.6.3-bin`

Main build.gradle:
```java
buildscript {
    ...
    dependencies {
        classpath 'com.android.tools.build:gradle:3.5.4'
    }
}
```

The gradle-wrapper.properties:
```xml
distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.3-bin.zip
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStorePath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
```

# Recap #
LibGDX Android game is created as a [View](https://developer.android.com/reference/android/view/View). In order to add ads that are constantly displayed (like Banners) another view holding that should be used. In other words, a Relative Layout having both views should be created.
You can see that in the following code snippet:

```java
public class AndroidLauncher extends AndroidApplication {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        RelativeLayout layout = new RelativeLayout(this);
        layout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        layout.addView(createGameView());
        createAdView(layout);
        setContentView(layout);
    }

    private View createGameView() {
        View gameView = initializeForView(new MyGame(this), new AndroidApplicationConfiguration());
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        params.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.TRUE);
        params.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
        gameView.setLayoutParams(params);
        return gameView;
    }
}
```
The only missing piece here is the `createAdView` method that will be created in the next section.

# Banner #
In order to add Banner ads we will use `com.smaato.sdk.banner.widget.BannerView`. As mentioned previously, the Banner view will reside in the same Relative Layout as the Game view. 
```java
public class AndroidLauncher extends AndroidApplication {
    private static final String PUBLISHER_ID = "1100042525";
    private static final String BANNER_AD_SPACE_ID = "130635694";

    private BannerView smaatoBanner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        RelativeLayout layout = new RelativeLayout(this);
        layout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        layout.addView(createGameView());
        createAdView(layout);
        setContentView(layout);
    }

    private void createAdView(RelativeLayout layout) {
        SmaatoSdk.init(getApplication(), PUBLISHER_ID);
        createSmaatoBanner();
        layout.addView(smaatoBanner);
    }

    private void createSmaatoBanner() {
        smaatoBanner = new BannerView(this);

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM, RelativeLayout.TRUE);
        params.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
        smaatoBanner.setLayoutParams(params);
        smaatoBanner.setBackgroundColor(Color.TRANSPARENT);
        smaatoBanner.setVisibility(View.INVISIBLE);
    }

    @Override
    public void onDestroy() {
        if (smaatoBanner != null) smaatoBanner.destroy();
        super.onDestroy();
    }

    public void showBannerAds() {
        runOnUiThread(() -> {
            smaatoBanner.setVisibility(View.VISIBLE);
            smaatoBanner.setEnabled(true);
            smaatoBanner.loadAd(BANNER_AD_SPACE_ID, BannerAdSize.XX_LARGE_320x50);
        });
    }

    public void hideBannerAds() {
        runOnUiThread(() -> {
            smaatoBanner.setVisibility(View.GONE);
            smaatoBanner.setEnabled(false);
        });
    }
}
```
Let me walk you through this code snippet:
* `BannerView smaatoBanner` is kept as an instance variable, so an ad can be shown and hidden depending on the game lifecycle
* `BannerView` should be always destroyed in order to release resources properly
*  The banner will be placed according to `RelativeLayout.LayoutParams` rules
* `showBannerAds`/`hideBannerAds` are supposed to be called as per the game lifecycle
* `PUBLISHER_ID` and `BANNER_AD_SPACE_ID` can be used during testing. Please, refer to [Test Ads](#test-ads) section for all available test ads configurations.

# Interstitial #
Unlike Banners, Interstitial ads are not constantly displayed on the screen. Such ads should be only shown at natural transition points in the flow of an app, like finishing/failing of a level or switching between the screens. Hence there is no need to have an additional view for Interstitial ads as they will typically occupy the whole screen and will be destroyed upon closing.

```java
public class AndroidLauncher extends AndroidApplication {
    private static final String PUBLISHER_ID = "1100042525";
    private static final String INTERSTITIAL_AD_SPACE_ID = "130626426";

    private InterstitialAd smaatoInterstitial;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        RelativeLayout layout = new RelativeLayout(this);
        layout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        layout.addView(createGameView());
        createAd();
        setContentView(layout);
    }

    private void createAd() {
        SmaatoSdk.init(getApplication(), PUBLISHER_ID);
        requestSmaatoInterstitialAd();
    }

    public void showInterstitial() {
        runOnUiThread(() -> {
            if (smaatoInterstitial == null) {
                requestSmaatoInterstitialAd();
                return;
            }
            smaatoInterstitial.showAd(AndroidLauncher.this);
            requestSmaatoInterstitialAd();
        });
    }

    private void requestSmaatoInterstitialAd() {
        Interstitial.loadAd(INTERSTITIAL_AD_SPACE_ID, new EventListener() {
            @Override
            public void onAdLoaded(@NonNull InterstitialAd interstitialAd) {
                smaatoInterstitial = interstitialAd;
            }

            @Override
            public void onAdFailedToLoad(@NonNull InterstitialRequestError interstitialRequestError) {
                log(AndroidLauncher.class.getName(), "Smaato Interstitial failed to load; error: " + interstitialRequestError.getInterstitialError());
            }

            @Override
            public void onAdError(@NonNull InterstitialAd interstitialAd, @NonNull InterstitialError interstitialError) {
            }

            @Override
            public void onAdOpened(@NonNull InterstitialAd interstitialAd) {
            }

            @Override
            public void onAdClosed(@NonNull InterstitialAd interstitialAd) {
            }

            @Override
            public void onAdClicked(@NonNull InterstitialAd interstitialAd) {
            }

            @Override
            public void onAdImpression(@NonNull InterstitialAd interstitialAd) {
            }

            @Override
            public void onAdTTLExpired(@NonNull InterstitialAd interstitialAd) {
            }
        });
    }
}
```
Let me walk you through this code snippet:
* `InterstitialAd smaatoInterstitial` is kept as an instance variable, so an ad can be shown depending on the game lifecycle
* It is recommended to call `requestSmaatoInterstitialAd` on a game load, in order to have an ad preloaded from the start
* There are multiple useful callbacks of `Interstitial.loadAd` that can be used depending on your use case
* `showInterstitial` is supposed to be called as per the game lifecycle

# Rewarded #
Rewarded ads are visually similar to Interstitial ads as they typically occupy the whole screen. 
But workflow-wise they are completely different - such ads encourage users to interact with the ad content in exchange for in-app rewards, like extra lives, free coins or energy.

```java
public class AndroidLauncher extends AndroidApplication {
    private static final String PUBLISHER_ID = "1100042525";
    private static final String REWARDED_INTERSTITIAL_AD_SPACE_ID = "130626428";

    private RewardedInterstitialAd smaatoRewardedInterstitial;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        RelativeLayout layout = new RelativeLayout(this);
        layout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        layout.addView(createGameView());
        createAd();
        setContentView(layout);
    }

    private void createAd() {
        SmaatoSdk.init(getApplication(), PUBLISHER_ID);
        requestSmaatoRewardedInterstitialAd();
    }

    public void showRewarded() {
        runOnUiThread(() -> {
            if (smaatoRewardedInterstitial == null) {
                requestSmaatoRewardedInterstitialAd();
                return;
            }
            smaatoRewardedInterstitial.showAd();
            requestSmaatoRewardedInterstitialAd();
        });
    }

    private void requestSmaatoRewardedInterstitialAd() {
        RewardedInterstitial.loadAd(REWARDED_INTERSTITIAL_AD_SPACE_ID, new EventListener() {
            @Override
            public void onAdLoaded(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
                smaatoRewardedInterstitial = rewardedInterstitialAd;
            }

            @Override
            public void onAdFailedToLoad(@NonNull RewardedRequestError rewardedRequestError) {
            }

            @Override
            public void onAdError(@NonNull RewardedInterstitialAd rewardedInterstitialAd, @NonNull RewardedError rewardedError) {
            }

            @Override
            public void onAdClosed(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
            }

            @Override
            public void onAdClicked(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
            }

            @Override
            public void onAdStarted(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
            }

            @Override
            public void onAdReward(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
            }

            @Override
            public void onAdTTLExpired(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
            }
        });
    }
}
```
One more time, let me walk you through this code snippet:
* `RewardedInterstitialAd smaatoRewardedInterstitial` is kept as an instance variable, so an ad can be shown whenever a user initiates a rewarded ad flow in your game
* It is recommended to call `requestSmaatoRewardedInterstitialAd` on a game load, in order to have an ad preloaded from the start
* There are multiple useful callbacks of `RewardedInterstitial.loadAd` that you can be used depending on your use case
* `showRewarded` is supposed to be called whenever a user initiates a rewarded ad flow in your game

# Test Ads #

| Adspace ID    | Type               |
| ------------- | -------------------- |
| 130626424     | Rich Media         |
| 130635694     | Static Image       |
| 130635706     | MRAID              |
| 130626426     | Rich Media / Video |
| 130626427     | Video              |
| 130626428     | Rewarded           |

Please, use Publisher Id 1100042525 with each of those adspaces.

Don't forget to change the values to the production ones before the release!