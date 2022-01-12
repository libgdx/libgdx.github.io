---
title: Airpush in Libgdx
---
# Summary #

 * [Introduction](#introduction)
 * [Step 1. Choose SDK.](#step-1-choose-sdk-)
 * [Step 2. Create App in Airpush Dashboard.](#step-2-create-app-in-airpush-dashboard-)
 * [Step 3. Add Google Play Services Library.](#step-3-add-google-play-services-library-)
 * [Step 4. Adding the Airpush SDK.](#step-4-adding-the-airpush-sdk-)
 * [Step 5. Editing the Android Manifest.](#step-5-editing-the-android-manifest-)
 * [Step 6. Adding dem Codes.](#step-6-adding-dem-codes-)

# Introduction #

This tutorial will guide you for all the steps to add Airpush adds in your libGDX Powered Android Games. You will be able to add both Banner Ads, and Smartwall Ads. The basic structure is very like the [Admob Tutorial](/wiki/third-party/admob-in-libgdx). But there are several changes and it will be more straight forward with not much text. (If you want a very detailed explanation of why every step, feel free to read that tutorial first).

You need:

1. A libGDX Powered Android Game Project.
2. And [Airpush](http://www.airpush.com/) Account.

# Step 1. Choose SDK.- #

Airpush has 2 SDKs that you will be able to use in Google Play. Standard and Bundle. Both have advantages and flaws.

**Bundle.-**

Supports less devices than Standard (around 15% less), but pays you for each install of your app in which the user accepts the EULA additional to Ad clicks.

**Standard.-**

Support the most devices, but won't pay you for users accepting the EULA. Only Ad clicks.

This tutorial will cover the 2 SDKs, any differences in their implementation will be noted.

What SDK do I recommend?. Well I use both, I make an app that implements the standard SDK with certain Version Number, lets say 1. And then I implement the Bundle and make that with a higher Version Number, lets say 2. Then I upload the 2 APKs in the same app in Google Play Console (they have same package name, don't be confused). Then Google Play automatically will install the Bundle version if supported or the Standard if not supported. The reason Bundle support less devices is because required permissions.

# Step 2. Create App in Airpush Dashboard.- #

Log in to your Airpush Account, you will be taken to the Dashboard. Click the Add Application button left of the screen.

![images/aptuto1.png](/assets/wiki/images/aptuto1.png)

Fill all the fields in the first tab and Click Continue. Don't worry if you haven't uploaded your app to Google Play yet, just put your package name there and it will be automatically checked when its up. But try not to take more than 48 hours to publish it.

![images/aptuto4.png](/assets/wiki/images/aptuto4.png)

In the next tab, uncheck Push Notification ads, and Icon Ads, you don't need those and also they don't complain with Google Play policies. You will be using Standard or Bundle SDK or both, and they don't use them. Check SmartWall Ads, and Banner Ads. Also you can check "Exclude dating campaigns" if you don't want your users to see sexually suggestive ads (I always check it).

![images/aptuto2.png](/assets/wiki/images/aptuto2.png)

Back in the Dashboard save your API Key and Your App ID. You will need these later.

![images/aptuto3.png](/assets/wiki/images/aptuto3.png)

# Step 3. Add Google Play Services Library.- #

You must import Google Play Services Library and link it to your Android libGDX Project.

First of all, install/update it. Open Android SDK Manager and install Google Play Services under Extras.

![images/aptuto5.png](/assets/wiki/images/aptuto5.png)

Now go to your Android SDK Installation 'Folder -> extras -> google -> google_play_services -> libproject' and copy "google-play-services_lib" folder to your workspace.

Now, import the project like this in eclipse: 'File -> import... -> Android -> Existing Android Code Into Workspace'. You will end up with something like this:

![images/aptuto6.png](/assets/wiki/images/aptuto6.png)

Right click the Android Project, go to 'Properties -> Android' and scroll down. Click the "Add..." button and choose the services project. Will end up like this:

![images/aptuto7.png](/assets/wiki/images/aptuto7.png)

# Step 4. Adding the Airpush SDK.- #

Go to the Airpush Dashboard and download your SDK. Standard or Bundle. Now this is where gets tricky, every developer has a different SDK name and also SDK packages. So you must be aware you have to change these values when you are implementing them.

Unzip the rar. And copy "mraid_attrs.xml" to your Android Project 'res- > values' folder. And copy the .jar file to your Android Project 'libs' folder.

Right click your Android Project and choose 'Properties -> Java Build Path', go to 'Libraries' tab. And click 'Add JARs'. Choose the 'android project -> libs -> airpushsdk.jar' (remember it has a different name for each developer). Now also add the Goggle Play Services jar, because even if its added as a library, android won't export the jar. click 'Add JARs' again, go to 'services project -> libs -> google-play-services.jar'.

Switch to the 'Order and Export' tab and be sure to check both new jars. Will end up like this:

![images/aptuto8.png](/assets/wiki/images/aptuto8.png)

Click Ok to finish.

# Step 5. Editing the Android Manifest.- #

Ad the following to your Android Manifest. Be aware this is different for Standard and Bundle SDKs.-

**Standard.-**

Permissions.-

```java
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

Activity declarations.-

```java
<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
<meta-data android:name="com.<sdkpackage>.APPID" android:value="<Your appId>" />
<meta-data android:name="com.<sdkpackage>.APIKEY" android:value="android*<Your ApiKey>"/>
<activity android:exported="false" android:name="com.<sdkpackage>.MainActivity"
     android:configChanges="orientation|screenSize"
android:theme="@android:style/Theme.Translucent" />
<activity android:name="com.<sdkpackage>.BrowserActivity"
android:configChanges="orientation|screenSize" />
<activity android:name="com.<sdkpackage>.VDActivity"
            android:configChanges="orientation|screenSize" android:screenOrientation="landscape"
            android:theme="@android:style/Theme.NoTitleBar.Fullscreen" >
</activity>
```

**Bundle.-**

Permissions.-

```java
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="com.android.browser.permission.READ_HISTORY_BOOKMARKS" />
<uses-permission android:name="android.permission.GET_ACCOUNTS" />    
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```
(see why it supports less devices).

Activity declarations.-

```java
<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
<meta-data android:name="com.<sdkpackage>.APPID" android:value="<Your appId>" />
<meta-data android:name="com.<sdkpackage>.APIKEY" android:value="android*<Your ApiKey>"/>
<activity android:exported="false" android:name="com.<sdkpackage>.AdActivity"
     android:configChanges="orientation|screenSize"
android:theme="@android:style/Theme.Translucent" />
<activity android:name="com.<sdkpackage>.BrowserActivity"
android:configChanges="orientation|screenSize" />
<activity android:name="com.<sdkpackage>.VActivity"
            android:configChanges="orientation|screenSize" android:screenOrientation="landscape"
            android:theme="@android:style/Theme.NoTitleBar.Fullscreen" >
</activity>
 <service android:name="com.<sdkpackage>.LService" android:exported="false"></service>
 <receiver android:name="com.<sdkpackage>.BootReceiver" android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
                </intent-filter>
        </receiver>
```

Don't forget to change your `<sdkpackage>`, `<Your ApiKey>` and `<Your appId>` for your unique values. Also, your min sdk version must be set to 9 or higer.

```java
<uses-sdk android:minSdkVersion="9" android:targetSdkVersion="19"/>
```

# Step 6. Adding dem Codes.- #

First make an Interface in your core project called "ActionResolver". And add the following 2 methods.
```java
public interface ActionResolver {
	   public void showAds(boolean show);
	   public void startSmartWallAd();
}
```

Make your ApplicationListener receive an ActionResolver when created as a parameter. Like this:
```java
public class TheMonsterFree extends Game{

    public ActionResolver ar;

    public TheMonsterFree(ActionResolver ar){
        this.ar = ar;
    }
```

You will notice errors in your platform projects, because they aren't sending an Action Resolver already. Make the Desktop and the HTML project send it. Like this:

**Desktop.-**
```java
public class Main {
	public static void main(String[] args) {
		LwjglApplicationConfiguration cfg = new LwjglApplicationConfiguration();
		cfg.title = "TheMonsterFree";
		cfg.width = 480;
		cfg.height = 320;

		new LwjglApplication(new TheMonsterFree(new ActionResolver(){
			@Override public void startSmartWallAd(){}
			@Override public void showAds(boolean show){}
		}), cfg);
	}
}
```

**HTML.-**
```java
public class GwtLauncher extends GwtApplication implements ActionResolver{
	@Override
	public GwtApplicationConfiguration getConfig(){
		GwtApplicationConfiguration cfg = new GwtApplicationConfiguration(480, 320);
		return cfg;
	}

	@Override
	public ApplicationListener getApplicationListener(){
		return new TheMonsterFree(this);
	}

	@Override public void showAds(boolean show){}
	@Override public void startSmartWallAd(){}
}
```

They have an empty implementation as Airpush only supports ads in Android. Add this to your Android MainActivity.java:

**Android.-**
```java
public class MainActivity extends AndroidApplication implements ActionResolver{

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();
        cfg.useWakelock = true;
        cfg.useAccelerometer = false;
        cfg.useCompass = false;

      	if(ma==null) ma=new Prm(this, adCallbackListener, false);

		RelativeLayout layout = new RelativeLayout(this);

		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

		View gameView = initializeForView(new TheMonsterFree(this), cfg);

		RelativeLayout.LayoutParams adParams = new
		RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		adParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
		adParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);

		adView = new AdView(this, AdView.BANNER_TYPE_IN_APP_AD, AdView.PLACEMENT_TYPE_INTERSTITIAL, false, false,
				AdView.ANIMATION_TYPE_LEFT_TO_RIGHT);
		adView.setAdListener(adlistener);

		layout.addView(gameView);
		layout.addView(adView);
		setContentView(layout);
    }

    AdListener adCallbackListener=new AdListener(){
        @Override
        public void onSDKIntegrationError(String message){
        	//Here you will receive message from SDK if it detects any integration issue.
			Log.w("Airpush", "onSDKIntegrationError() "+message);
        }
        public void onSmartWallAdShowing(){
        	// This will be called by SDK when it's showing any of the SmartWall ad.
        	Log.w("Airpush", "onSmartWallAdShowing()");
        }
        @Override
        public void onSmartWallAdClosed(){
        	// This will be called by SDK when the SmartWall ad is closed.
        	Log.w("Airpush", "onSmartWallAdClosed()");
        }
        @Override
        public void onAdError(String message){
        	//This will get called if any error occurred during ad serving.
        	Log.w("Airpush", "onAdError() "+message);
        }
        @Override
		public void onAdCached(AdType arg0){
        	//This will get called when an ad is cached.
        	Log.w("Airpush", "onAdCached() "+arg0.toString());
		}
		@Override
		public void noAdAvailableListener(){
			//this will get called when ad is not available
			Log.w("Airpush", "noAdAvailableListener()");
		}
     };

     AdListener.BannerAdListener adlistener = new AdListener.BannerAdListener(){
        @Override
        public void onAdClickListener(){
        	//This will get called when ad is clicked.
        	Log.w("Airpush", "onAdClickListener()");
        }
        @Override
        public void onAdLoadedListener(){
        	//This will get called when an ad has loaded.
        	Log.w("Airpush", "onAdLoadedListener()");
        }
        @Override
        public void onAdLoadingListener(){
        	//This will get called when a rich media ad is loading.
        	Log.w("Airpush", "onAdLoadingListener()");
        }
        @Override
        public void onAdExpandedListner(){
        	//This will get called when an ad is showing on a user's screen. This may cover the whole UI.
        	Log.w("Airpush", "onAdExpandedListner()");
        }
        @Override
        public void onCloseListener(){
        	//This will get called when an ad is closing/resizing from an expanded state.
        	Log.w("Airpush", "onCloseListener()");
        }
        @Override
        public void onErrorListener(String message){
        	//This will get called when any error has occurred. This will also get called if the SDK notices any integration mistakes.
        	Log.w("Airpush", message);
        }
        @Override
        public void noAdAvailableListener(){
        	//this will get called when ad is not available
        	Log.w("Airpush", "noAdAvailableListener()");
	   	}
    };

	private final int SHOW_ADS = 1;
	private final int HIDE_ADS = 0;

	Prm ma = null;
	AdView adView = null;

	protected Handler handler = new Handler(Looper.getMainLooper()){
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case SHOW_ADS: {
				if (adView != null) adView.setVisibility(View.VISIBLE);
				break;
			}
			case HIDE_ADS: {
				if (adView != null) adView.setVisibility(View.GONE);
				break;
			}
			}
		}
	};

	@Override
	public void showAds(boolean show){
		handler.sendEmptyMessage(show ? SHOW_ADS : HIDE_ADS);
	}

	@Override
	public void startSmartWallAd(){
	    if (ma!=null) ma.runAppWall();
	}
}
```

For the SmartWall ads you have several options:

* Overlay Dialog Ad: `ma.runOverlayAd();`
* AppWall Ad: `ma.runAppWall();`
* Rich Media Interstitial Ad: `ma.displayRichMediaInterstitialAd();`
* Video Ad: `ma.runVideoAd();`
* And Landing Page Ad: `ma.callLandingPageAd();` only for Bundle.

And you can even do `ma.callSmartWallAd();` and let the server decide for you. I recommend using AppWall as thats the one with better results.

Btw that above is for **Standard SDK**. If you are using **Bundle** you have to make these changes:

1. Replace `ma.runAppWall();`
for `ma.callAppWall();`
2. Replace `AdListener.BannerAdListener adlistener = new AdListener.BannerAdListener(){`
for `AdListener.MraidAdListener adlistener = new AdListener.MraidAdListener(){`
3. Replace all `Prm` for `MA`

Do `Ctrl+ Shift + O` for the correct imports to update.

Thats it, now inside your core project you can show Banner ads like this:
```java
ar.showAds(true);
```
Hide Banner ads like this:
```java
ar.showAds(false);
```
And Call SmartWall ads like this:
```java
ar.startSmartWallAd();
```
