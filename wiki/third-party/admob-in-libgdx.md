---
title: Admob in libgdx
---
 * [Introduction](#introduction)
 * [Background](#background)
 * [Setup](#setup)
 * [Initialization](#initialization)
 * [Control](#control)
 * [Code](#code)
 * [iOS Setup (RoboVM)](#ios-setup-robovm)


# Introduction

This article shows you how to set up AdMob with a libGDX app. This is current roughly with AdMob 4.0.4 and libGDX 0.9.1. The same instructions will work with Mobclix as well (and probably others), the only changes being the differences between the AdMob and Mobclix APIs. In the code snippets, I'm going to leave out the package and import lines for brevity. If you're working in Eclipse, Ctrl-1 on any line showing an error will auto-fill-in the required imports.

I should note that this isn't the only way to make this work. But it's one approach that worked for me, so I decided to share it in the hopes that others might find it useful as well.

Please note that Google have deprecated 6.4.1 and earlier SDKs. For notes on how to use the new Google Mobile Ads approach, please see [Google Mobile Ads](/wiki/third-party/google-mobile-ads-in-libgdx). Thankfully the changes are very minimal from a developer/implementation point of view.


# Background

Let's look at the libGDX HelloWorld example and understand what it's doing. There's a HelloWorld class (in HelloWorld.java) that does all the libGDX stuff. There's a HelloWorldDesktop class that creates and runs a HelloWorld on the desktop. And finally, there's a HelloWorldAndroid class that creates and runs a HelloWorld on Android. Here's what they look like:

HelloWorldDesktop:

```java
public class HelloWorldDesktop {
    public static void main (String[] argv) {
        new LwjglApplication(new HelloWorld(), "Hello World", 480, 320, false);
    }
}
```

HelloWorldAndroid:

```java
public class HelloWorldAndroid extends AndroidApplication {
    @Override public void onCreate (Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initialize(new HelloWorld(), false);		
    }
}
```

HelloWorldIOS:

```java
public class HelloWorldIOS extends Delegate {
	@Override
	protected IOSApplication createApplication() {
		final IOSApplicationConfiguration config = new IOSApplicationConfiguration();
		config.orientationLandscape = false;
		config.orientationPortrait = true;

		return new IOSApplication(new HelloWorld(), config);
	}
}
```

They're pretty similar. They all create a `new HelloWorld()`, and pass that into something that sets up the application. On the desktop that's a LwjglApplication, on Android that's the `initialize()` method and on IOS it's `IOSApplication()`. Then the HelloWorld class does all the work of the application.

Let's take a closer look at the `initialize()` method. There are two forms, and one of them calls the other. If you follow that code through, here's the stuff that sets up an Android application:

```java
    public void initialize(ApplicationListener listener, AndroidApplicationConfiguration config) {
   	 graphics = new AndroidGraphics(this, ...

...

       requestWindowFeature(Window.FEATURE_NO_TITLE);
       getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
       getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
       setContentView(graphics.getView(), createLayoutParams());

...
```

Let's see what it's doing:

 * Create an AndroidGraphics object with some parameters
 * Specify that the window has no title
 * Specify that the window is fullscreen
 * Call `setContentView()` with a View from the AndroidGraphics object, and some layout parameters

The last step hooks everything together, and sets up the Activity to use the libGDX view as its main (and only) View. I'm not going to explain what an Android Activity and View is, you can find that information easily enough with a Google search.

With that background, let's look at what needs to be changed to add AdMob to the application.

# Setup

To start out, follow the AdMob setup instructions as normal. Sign up, get your application key, configure your ad colors and refresh rate on the website, add the stuff needed to the AndroidManifest.xml file for permissions, activities, etc.

# Initialization

The main thing to understand is that AdMob uses its own View. And we know that libGDX creates a View. If we call `setContentView()` with the libGDX View, then that's what gets hooked up to the application, and there's no place to add the AdMob view. So here's what we need to do:

 * Create a Layout that can contain multiple views
 * Create the libGDX View, add that to the Layout
 * Create the AdMob view, add that to the Layout as well
 * Call `setContentView()` with the Layout

Let's dive into some code. This example uses the RelativeLayout class, because I found it easy to get multiple overlapping Views on the screen using that. This assumes that you want your libGDX View to be full-screen, and the AdMob view to be overlaid on top. If you want some other layout, like the AdMob view sitting next to a partial-screen libGDX View, then you'll probably have to use a different Layout and set it up accordingly.

First, create a RelativeLayout:

```java
        RelativeLayout layout = new RelativeLayout(this);
```

Easy enough. Then, we need to create the libGDX View. There's a different initialization function, `initializeForView()`, that does this. It is similar to `initialize()`, but instead of calling `setContentView()` with the libGDX View, it returns the View to you so you can use it. The way you call it is identical to calling `initialize()`:

```java
        View gameView = initializeForView(new HelloWorld(), false);
```

Let's take a closer look inside `initializeForView()`. Again, there are two versions, and the bulk of the work is here:

```java
    public View initializeForView(ApplicationListener listener, AndroidApplicationConfiguration config) {
   	 graphics = new AndroidGraphics(this, ...

...

       return graphics.getView();
    }
```

You'll note that this time, the function didn't do anything about setting the Activity to be full-screen, removing the title, and so on. Most likely, you will want all those things. So make sure you call them in your AndroidActivity:

```java
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
        		WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

        View gameView = initializeForView(new HelloWorld(), false);
```

That completes the setup for the libGDX View. Next, we create the AdMob view and kick it off by calling `loadAd()`. This assumes that you want it to start fetching ads immediately. If you want more customized behavior, then you'll have to configure the AdView accordingly. I'm not going to cover that here.

```java
        AdView adView = new AdView(this);
        adView.setAdSize(AdSize.BANNER);
        adView.setAdUnitId("xxxxxxxx"); // Put in your secret key here

        AdRequest adRequest = new AdRequest.Builder().build();
        adView.loadAd(adRequest);
```

Now we have a Layout, and two Views. All that's left is to add both the Views to the Layout, and then tell Android to use the Layout as the thing to display for the Activity.

Views get stacked in the sequence in which you add them, so make sure you add the libGDX View first, since you want that under the AdMob View. If you do the reverse, the full-screen libGDX View will hide the AdMob View, and you'll be left wondering why your ads aren't showing up.

Add the libGDX View. You can use the simpler form of `addView()`, because the libGDX View is full-screen, so there's no positioning information needed.

```java
        layout.addView(gameView);
```

Now we need to add the AdMob View. Here, you probably want some more control, because you want to position the ads in some specific area of the screen. There's another `addView()` that takes some layout parameters, so let's use that. In this example, I'm telling Android that I want the AdMob View to be as large as necessary to show the full ad, and I want to align it with the top right of the screen (technically, it's aligning to the top right of the parent, but the parent is the Layout which fills the screen, so it's effectively aligning with the screen):

```java
        RelativeLayout.LayoutParams adParams = 
        	new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, 
        			RelativeLayout.LayoutParams.WRAP_CONTENT);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
```

Then we add the AdMob View using these layout parameters:

```java
        layout.addView(adView, adParams);
```

And finally, all that's needed is to tell Android to use this Layout:

```java
        setContentView(layout);
```

Putting all of that together, here's what it looks like:

```java
public class HelloWorldAndroid extends AndroidApplication {
    @Override public void onCreate (Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Create the layout
        RelativeLayout layout = new RelativeLayout(this);

        // Do the stuff that initialize() would do for you
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
        		WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

        // Create the libGDX View
        View gameView = initializeForView(new HelloWorld(), false);

        // Create and setup the AdMob view
        AdView adView = new AdView(this);
        adView.setAdSize(AdSize.BANNER);
        adView.setAdUnitId("xxxxxxxx"); // Put in your secret key here

        AdRequest adRequest = new AdRequest.Builder().build();
        adView.loadAd(adRequest);

        // Add the libGDX view
        layout.addView(gameView);

        // Add the AdMob view
        RelativeLayout.LayoutParams adParams = 
        	new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, 
        			RelativeLayout.LayoutParams.WRAP_CONTENT);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);

        layout.addView(adView, adParams);

        // Hook it all up
        setContentView(layout);
    }
```

And that's it. Now you should have ads showing on top of your libGDX app. If you want the ads to be visible all the time, this should be all you need to do. If you want to control when the ads are visible from within your libGDX app, then there's a little more work left.

# Control

This example will show you how to turn the AdMob View's visibility on and off from within your libGDX app. Note that this is probably not the best way to control AdMob. If your ad View is invisible, but still fetching ads in the background, then you're wasting ad impressions, and that will negatively impact your ad revenue. I'm not going to talk about the best way to control the AdMob view - that varies from application to application. Also, there are things you can do on the website, and things you can do in your app. So look through the AdMob documentation for more information on that.

The first thing you need to do is to make the AdView a member of your AndroidApplication, because you'll need to refer to it later.

```java
public class HelloWorldAndroid extends AndroidApplication {
    protected AdView adView;

    @Override public void onCreate (Bundle savedInstanceState) {

...

      adView = new AdView(this, AdSize.BANNER, "xxxxxxxx"); // Put in your secret key here
```

The next thing you need to understand is a Handler. This is an Android mechanism that lets you send messages between threads. The HelloWorld app runs in its own thread (let's call it the 'game thread'), which is different from the thread where you created the AdView (the 'UI thread'). AdMob (and many other libraries, for that matter) gets cranky if you try to manipulate the AdView from any thread other than the UI thread. So what can you do? From the other thread, you send a message back to your UI thread. The next time the UI thread is scheduled to run, it picks up the message, and takes the action. All of this is handled by something called a Handler. Let's see how you set that up:

```java
public class HelloWorldAndroid extends AndroidApplication {

    private final int SHOW_ADS = 1;
    private final int HIDE_ADS = 0;

    protected Handler handler = new Handler()
    {
        @Override
        public void handleMessage(Message msg) {
            switch(msg.what) {
                case SHOW_ADS:
                {
                    adView.setVisibility(View.VISIBLE);
                    break;
                }
                case HIDE_ADS:
                {
                    adView.setVisibility(View.GONE);
                    break;
                }
            }
        }
    };
```

That's the part that will process the message. You've defined two constants - `SHOW_ADS` and `HIDE_ADS`. If the message contains either one of those constants, this code makes the AdView visible or invisible, as instructed.

That leaves two things:

 * Some code to send a message containing the `SHOW_ADS` or `HIDE_ADS` command
 * Some way to call that code from within the libGDX app's game thread

There are multiple ways to solve that problem. One solution is to use an interface that defines functionality that the AndroidApplication can provide, like the ability to show and hide ads. Here's the definition of such an interface. Note that this should go in its own Java file:

IActivityRequestHandler.java:

```
public interface IActivityRequestHandler {
   public void showAds(boolean show);
}
```

This interface defines just one function, `showAds()`. If you later want to add other functionality that you need to call from the game thread and have it run in the UI thread, you can add more methods in here.

Now that we have an interface, our AndroidApplication must implement that interface:

```java
public class HelloWorldAndroid extends AndroidApplication implements IActivityRequestHandler  {

...

    // This is the callback that posts a message for the handler
    @Override
    public void showAds(boolean show) {
       handler.sendEmptyMessage(show ? SHOW_ADS : HIDE_ADS);
    }
```

And there's our implementation of the `showAds()` function. It's pretty simple - it sends a message to our Handler. `sendEmptyMessage` is handy when the message only needs to contain a single code, as in this case. If you need to convey more information in the message, you'll have to send a more complex message, and the Handler code for processing that message must change accordingly.

Now we have a mechanism to send a message to the UI thread, so that the UI thread can process it. Next, we need a way to get the game thread to call this functionality. To do this, the HelloWorld object needs to know about the HelloWorldAndroid object, so it can call the `showAds()` function. One way to do this is to define a constructor for HelloWorld that takes a parameter:

```java
public class HelloWorld implements ApplicationListener {
    private IActivityRequestHandler myRequestHandler;

    public HelloWorld(IActivityRequestHandler handler) {
        myRequestHandler = handler;
    }
```

That lets you save the reference to the IActivityRequestHandler that was passed in by the caller. Now, you can access myRequestHandler from anywhere in this object, so when you want to turn ads on, all you do is:

```java
    myRequestHandler.showAds(true);
```

Back in the HelloWorldAndroid class, we need to create the HelloWorld with this new constructor:

```java
        View gameView = initializeForView(new HelloWorld(this), false);
```

Note the `this` parameter in the HelloWorld constructor - that's how you pass in a reference to the HelloWorldAndroid object to the HelloWorld object.

There's just one thing left. Remember the desktop version - that needs to be updated to call the new constructor as well. To do this, HelloWorldDesktop must implement the IActivityRequestHandler interface as well, so HelloWorld has something on which it can call `showAds()`. But the implementation can be empty here, since we don't have any ads to show on the desktop. We need to cheat a little here, because `main()` is a static function, so there's no `this` when you're in that function. The following solution works, but there are probably better ways of handling this:

```java
public class HelloWorldDesktop implements IActivityRequestHandler {
    private static HelloWorldDesktop application;
    public static void main (String[] argv) {
        if (application == null) {
            application = new HelloWorldDesktop();
        }
		
        new LwjglApplication(new HelloWorld(application), "Hello World", 480, 320, false);
    }

    @Override
    public void showAds(boolean show) {
        // TODO Auto-generated method stub
	
    }
}
```

That's it. Now you can show and hide AdMob ads from within your libGDX app.

# Code

Here's the full code for the various classes, for completeness:

HelloWorldAndroid.java:

```java
/*******************************************************************************
 * Copyright 2011 See AUTHORS file.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
/*
 * Copyright 2010 Mario Zechner (contact@badlogicgames.com), Nathan Sweet (admin@esotericsoftware.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.badlogic.gdx;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RelativeLayout;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.helloworld.HelloWorld;
import com.badlogic.gdx.helloworld.IActivityRequestHandler;
import com.mobclix.android.sdk.MobclixMMABannerXLAdView;

public class HelloWorldAndroid extends AndroidApplication implements IActivityRequestHandler  {

    protected AdView adView;

    private final int SHOW_ADS = 1;
    private final int HIDE_ADS = 0;

    protected Handler handler = new Handler()
    {
        @Override
        public void handleMessage(Message msg) {
            switch(msg.what) {
                case SHOW_ADS:
                {
                    adView.setVisibility(View.VISIBLE);
                    break;
                }
                case HIDE_ADS:
                {
                    adView.setVisibility(View.GONE);
                    break;
                }
            }
        }
    };

    @Override public void onCreate (Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Create the layout
        RelativeLayout layout = new RelativeLayout(this);

        // Do the stuff that initialize() would do for you
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
        		WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

        // Create the libGDX View
        View gameView = initializeForView(new HelloWorld(this), false);

        // Create and setup the AdMob view
        AdView adView = new AdView(this);
        adView.setAdSize(AdSize.BANNER);
        adView.setAdUnitId("xxxxxxxx"); // Put in your secret key here

        AdRequest adRequest = new AdRequest.Builder().build();
        adView.loadAd(adRequest);

        // Add the libGDX view
        layout.addView(gameView);

        // Add the AdMob view
        RelativeLayout.LayoutParams adParams = 
        	new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, 
        			RelativeLayout.LayoutParams.WRAP_CONTENT);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        adParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);

        layout.addView(adView, adParams);

        // Hook it all up
        setContentView(layout);
    }

    // This is the callback that posts a message for the handler
    @Override
    public void showAds(boolean show) {
       handler.sendEmptyMessage(show ? SHOW_ADS : HIDE_ADS);
    }
}
```

HelloWorldDesktop.java:

```java
/*******************************************************************************
 * Copyright 2011 See AUTHORS file.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
package com.badlogic.gdx.helloworld;

import com.badlogic.gdx.backends.lwjgl.LwjglApplication;

public class HelloWorldDesktop implements IActivityRequestHandler {
    private static HelloWorldDesktop application;
    public static void main (String[] argv) {
        if (application == null) {
            application = new HelloWorldDesktop();
        }
		
        new LwjglApplication(new HelloWorld(application), "Hello World", 480, 320, false);
    }

    @Override
    public void showAds(boolean show) {
        // TODO Auto-generated method stub
	
    }
}
```

HelloWorld.java:

```java
/*******************************************************************************
 * Copyright 2011 See AUTHORS file.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
package com.badlogic.gdx.helloworld;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Files.FileType;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL10;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.Texture.TextureWrap;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Vector2;

public class HelloWorld implements ApplicationListener {
	SpriteBatch spriteBatch;
	Texture texture;
	BitmapFont font;
	Vector2 textPosition = new Vector2(100, 100);
	Vector2 textDirection = new Vector2(1, 1);

    private IActivityRequestHandler myRequestHandler;

    public HelloWorld(IActivityRequestHandler handler) {
        myRequestHandler = handler;
    }
    
    @Override public void create () {
		font = new BitmapFont();
		font.setColor(Color.RED);
		texture = new Texture(Gdx.files.internal("data/badlogic.jpg"));
		spriteBatch = new SpriteBatch();
	}

	@Override public void render () {
		int centerX = Gdx.graphics.getWidth() / 2;
		int centerY = Gdx.graphics.getHeight() / 2;

		Gdx.graphics.getGL10().glClear(GL10.GL_COLOR_BUFFER_BIT);
		
		// more fun but confusing :)
		//textPosition.add(textDirection.tmp().mul(Gdx.graphics.getDeltaTime()).mul(60));
		textPosition.x += textDirection.x * Gdx.graphics.getDeltaTime() * 60;
		textPosition.y += textDirection.y * Gdx.graphics.getDeltaTime() * 60;

		if (textPosition.x < 0 ) {
			textDirection.x = -textDirection.x;
			textPosition.x = 0;
		}
		if(textPosition.x > Gdx.graphics.getWidth()) {
			textDirection.x = -textDirection.x;
			textPosition.x = Gdx.graphics.getWidth();
		}
		if (textPosition.y < 0) {
			textDirection.y = -textDirection.y;
			textPosition.y = 0;			
		}
		if (textPosition.y > Gdx.graphics.getHeight()) {
			textDirection.y = -textDirection.y;
			textPosition.y = Gdx.graphics.getHeight();			
		}

		spriteBatch.begin();
		spriteBatch.setColor(Color.WHITE);
		spriteBatch.draw(texture, 
							  centerX - texture.getWidth() / 2, 
							  centerY - texture.getHeight() / 2, 
							  0, 0, texture.getWidth(), texture.getHeight());		
		font.draw(spriteBatch, "Hello World!", (int)textPosition.x, (int)textPosition.y);
		spriteBatch.end();
	}

	@Override public void resize (int width, int height) {
		spriteBatch.getProjectionMatrix().setToOrtho2D(0, 0, width, height);
		textPosition.set(0, 0);
	}

	@Override public void pause () {

	}

	@Override public void resume () {

	}
	
	@Override public void dispose () {

	}
	
}
```

# iOS Setup (RoboVM)

For admob to work on IOS it's best to make sure you are doing the following things:

* Make sure you project is using the latest libGDX version

* Make sure you are on the latest RoboVM

* Make sure you are using the latest admob bindings found here [robovm-ios-bindings - admob](https://github.com/MobiVM/robovm-robopods/tree/master/google-mobile-ads)

* Admob needs a separate ad unit for iOS, so make sure you create a new app the key will be different than the one used for Android.


***

1. Follow the [AdMob RoboPod installation instructions](https://github.com/MobiVM/robovm-robopods/tree/master/google-mobile-ads/ios).

2. Now with the configuration complete you can make calls to the AdMob API from Java and configure ads as desired. The following is an example on how to integrate a Banners ad at the top of the screen:


_WARNING the following code may be a bit outdated for latest RoboPod version, use it as a reference_


```java
package com.badlogic.gdx;

import org.robovm.apple.coregraphics.CGRect;
import org.robovm.apple.coregraphics.CGSize;
import org.robovm.apple.foundation.NSArray;
import org.robovm.apple.foundation.NSAutoreleasePool;
import org.robovm.apple.foundation.NSObject;
import org.robovm.apple.foundation.NSString;
import org.robovm.apple.uikit.UIApplication;
import org.robovm.apple.uikit.UIScreen;
import org.robovm.bindings.admob.GADAdSizeManager;
import org.robovm.bindings.admob.GADBannerView;
import org.robovm.bindings.admob.GADBannerViewDelegateAdapter;
import org.robovm.bindings.admob.GADRequest;
import org.robovm.bindings.admob.GADRequestError;

import com.badlogic.gdx.Application;
import com.badlogic.gdx.backends.iosrobovm.IOSApplication;
import com.badlogic.gdx.backends.iosrobovm.IOSApplication.Delegate;
import com.badlogic.gdx.backends.iosrobovm.IOSApplicationConfiguration;
import com.badlogic.gdx.utils.Logger;

public class HelloWorldIOS extends Delegate implements IActivityRequestHandler {
	private static final Logger log = new Logger(HelloWorldIOS.class.getName(), Application.LOG_DEBUG);
	private static final boolean USE_TEST_DEVICES = true;
	private GADBannerView adview;
	private boolean adsInitialized = false;
	private IOSApplication iosApplication;

	@Override
	protected IOSApplication createApplication() {
		final IOSApplicationConfiguration config = new IOSApplicationConfiguration();
		config.orientationLandscape = false;
		config.orientationPortrait = true;

		iosApplication = new IOSApplication(new HelloWorld(this), config);
		return iosApplication;
	}

	public static void main(String[] argv) {
		NSAutoreleasePool pool = new NSAutoreleasePool();
		UIApplication.main(argv, null, HelloWorldIOS.class);
		pool.close();
	}

	@Override
	public void hide() {
		initializeAds();

		final CGSize screenSize = UIScreen.getMainScreen().getBounds().size();
		double screenWidth = screenSize.width();

		final CGSize adSize = adview.getBounds().size();
		double adWidth = adSize.width();
		double adHeight = adSize.height();

		log.debug(String.format("Hidding ad. size[%s, %s]", adWidth, adHeight));

		float bannerWidth = (float) screenWidth;
		float bannerHeight = (float) (bannerWidth / adWidth * adHeight);

		adview.setFrame(new CGRect(0, -bannerHeight, bannerWidth, bannerHeight));
	}

	@Override
	public void show() {
		initializeAds();

		final CGSize screenSize = UIScreen.getMainScreen().getBounds().size();
		double screenWidth = screenSize.width();

		final CGSize adSize = adview.getBounds().size();
		double adWidth = adSize.width();
		double adHeight = adSize.height();

		log.debug(String.format("Showing ad. size[%s, %s]", adWidth, adHeight));

		float bannerWidth = (float) screenWidth;
		float bannerHeight = (float) (bannerWidth / adWidth * adHeight);

		adview.setFrame(new CGRect((screenWidth / 2) - adWidth / 2, 0, bannerWidth, bannerHeight));
	}

	public void initializeAds() {
		if (!adsInitialized) {
			log.debug("Initalizing ads...");

			adsInitialized = true;

			adview = new GADBannerView(GADAdSizeManager.smartBannerPortrait());
			adview.setAdUnitID("xxxxxxxx"); //put your secret key here
			adview.setRootViewController(iosApplication.getUIViewController());
			iosApplication.getUIViewController().getView().addSubview(adview);

			final GADRequest request = GADRequest.request();
			if (USE_TEST_DEVICES) {
				final NSArray<?> testDevices = new NSArray<NSObject>(
						new NSString(GADRequest.GAD_SIMULATOR_ID));
				request.setTestDevices(testDevices);
				log.debug("Test devices: " + request.getTestDevices());
			}

			adview.setDelegate(new GADBannerViewDelegateAdapter() {
				@Override
				public void didReceiveAd(GADBannerView view) {
					super.didReceiveAd(view);
					log.debug("didReceiveAd");
				}

				@Override
				public void didFailToReceiveAd(GADBannerView view,
						GADRequestError error) {
					super.didFailToReceiveAd(view, error);
					log.debug("didFailToReceiveAd:" + error);
				}
			});

			adview.loadRequest(request);

			log.debug("Initalizing ads complete.");
		}
	}

    @Override
    public void showAds(boolean show) {
    	initializeAds();

       	final CGSize screenSize = UIScreen.getMainScreen().getBounds().size();
		double screenWidth = screenSize.width();

		final CGSize adSize = adview.getBounds().size();
		double adWidth = adSize.width();
		double adHeight = adSize.height();

		log.debug(String.format("Hidding ad. size[%s, %s]", adWidth, adHeight));

		float bannerWidth = (float) screenWidth;
		float bannerHeight = (float) (bannerWidth / adWidth * adHeight);

		if(show) {
			adview.setFrame(new CGRect((screenWidth / 2) - adWidth / 2, 0, bannerWidth, bannerHeight));
		} else {
			adview.setFrame(new CGRect(0, -bannerHeight, bannerWidth, bannerHeight));
		}
    }
}
```