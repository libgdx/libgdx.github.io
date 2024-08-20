---
title: "A Simple Game"
redirect_from:
  - /dev/simple-game/
  - /dev/simple_game/
---

Let's make a game! Game design is hard, but if you break up the process into small, achievable goals, you'll be able to produce wonders. In this simple game tutorial, you will learn how to make a basic game from scratch. These are the essential skills that you will build on in future projects.

Click Here to Play! (libGDX logo with bucket graphic bottom right tilted with water spilling out very catchy)

As you can see with the live demo, we're going to make a basic game where you control a bucket to collect water droplets falling from the sky. There is no score or end goal. Just enjoy the experience! Here are the steps that we will use to split up the game design process:

  * Prerequisites
  * Loading Assets
  * The Game Life Cycle
  * Rendering
  * Input Controls
  * Game Logic
  * Sound
  * Additional Steps
  * Further Learning

## Prerequisites
There are a few things that you need to do before you begin this tutorial.

  * Make sure to follow the setup instructions on libgdx.com to configure Java and your IDE. You need to know how to create a project and run it with the appropriate Gradle commands.
  * Create a project in GDX-Liftoff with the following settings:
  * Project Name: Drop
  * Package: com.badlogic.drop
  * Main Class: Main
  * Include the Core and Desktop platforms. You may include others, however they will not be discussed in this tutorial.
  * Use the ApplicationListener template

If you have a knowledge of Java code, your experience in libGDX will be a lot easier. However, you should still be able to follow along in this tutorial even if you only have a minimal understanding of how code works.

Comments will be used throughout the code examples to explain the facets of this tutorial. You do not have to copy these comments when writing your code:

```java
```

However, it is good practice to make your own comments to explain confusing code or to label parts of your design.

```java
```

Import statements are an important part of Java programming. Thankfully, they are automatically added by modern IDE's as you type your code. They are omitted in the examples, but assume they are necessary in your code. There are times where something named in libGDX is named the same as something found in another package:

Always opt for the libGDX named class.

## Loading Assets
2D games made in libGDX need assets: images, audio, and other resources that comprise the project. In this case, we'll need a bucket, a raindrop, a background, a water drop sound effect, and music. If you're pretty resourceful, you can make these on your own. For simplicity's sake, you can download these examples which are optimized for this tutorial.

bucket.png
drop.png
background.png
drop.mp3
music.mp3

Just having these saved on your computer is not enough. These files need to be placed in the assets folder of your project. Look inside the folder path of the liftoff project you made:

There are many folders in here for the different backends that libGDX supports. Assets is a folder shared by all the backends. Whatever you save in here gets distributed with your game. For example, your desktop game will include these files inside your JAR distributable. This is what you give your users so they can play your game.

libGDX has an emphasis on code. Every asset you use must be loaded through code before you can use it in the rest of your game. This needs to happen when the game starts. Open the project in your chosen IDE, then open the Core project > Main.java. This file is the main file we're going to work in.

Declare your variables at the top of the file. You'll need a variable for every asset you plan to use:

```java
```

Enter the following code in the create method:

```java
```

This loads the assets into memory. See that the background image is loaded as a texture. Textures are the way that games keep images in video ram. It's actually not efficient to have different textures for each element in the game. It should be one big Texture for them all. Learn about TextureAtlas and TextureRegion in the wiki. For now, we'll keep these as separate textures because it's easier to explain this way.

Similarly, we have Sound to handle the raindrop audio file in our project. Sounds are loaded completely into memory so they can be played quickly and repeatedly. Music, on the other hand, is too large to keep entirely in memory. It's streamed from the file in chunks. There is no precise rule about what should or should not be a sound versus a music, but consider any audio shorter than 10 seconds to be a sound.

```java
```

We have many assets to manage now. We should use an AssetManager to handle them. That can be found in the wiki too. Again, that's outside the scope of this tutorial. Let's keep it simple.

## The Game Life Cycle
The work we've done so far is in the create method. Create executes immediately when the game is run, so of course it makes sense to load our assets there. What are these other methods for?

Resize is called whenever the game screen is resized. The width and height of the screen is important to have so you can make sure to not let your game look stretched or out of proportion.

```java
```

Render is the main loop of your game. This is code that is executed again and again while your game is running. Each time Render is called, a frame of your game is drawn to the screen. This is where the main logic of your game should go followed by your rendering code which will draw your images.

```java
```

Pause isn't like the pause menu you have in games you've played before. Pause is called when the game is minimized on Desktop or when the user presses home on Android, for example. It's basically when the game loop is paused by some action of the operating system.

```java
```

Consequently, Resume is called when the game loop is activated again. With Pause and Resume, you can implement a sort of autosave feature, or rebuild assets if necessary. These are not things you'll need to deal with in this tutorial.

```java
```

Dispose is code that is executed when your game is exited. This can be helpful for cleaning up resources, however you should note that the operating system will clean up these resources for you. This is more relevant for games with multiple screens.

```java
```

You will use these methods to create your game and all future games you make in libGDX. You'll find that a lot of advanced systems you can use abstract the direct use of these methods, however these remain at the foundation of your code.

## Rendering
Now let's talk about rendering. For the most part, all modern games just manipulate textures, drawing them to the screen to give you the final image you see: the frame.

This process is repeated many times per second to give the illusion of motion. That's what we're going to do here. Let's start with some boilerplate code. What is meant by boilerplate code is that you'll use similar code again and again without much change. And you'll see this pattern all over:

```java
```

This code clears the screen. It's a good practice to clear the screen every frame. Otherwise, you'll get weird graphical errors. You can use any color you want, but we'll just settle on Black this time.

```java
```

A viewport controls how we see the game. It's like a window from our world into another: the game world. The viewport controls how big this "window" is and how it's placed on our screen. There are many kinds of viewports you can use. A simple one to understand is the FitViewport which will ensure that no matter what size our window is, the full game view will always be visible. It will "fit" into the window. Each viewport also has a camera which controls what part of the game world is visible and at what zoom. Learn more about viewports and cameras in the wiki.

```java
```

Ever wonder why your favorite games sometimes have poor FPS or Frames Per Second? Stuttering gameplay is often related to the number of textures being rendered and the capabilities of your player's graphics card. There are tricks to alleviate this. For one, it is more efficient to send all your draw calls at once to the graphics processing unit (GPU). The process of drawing an individual texture is called a draw call. The SpriteBatch is how libGDX combines these draw calls together. The projection matrix configures the SpriteBatch to use the coordinates of our Viewport.

```java
```

It is important to order these lines appropriately. You should never draw from a SpriteBatch outside of a begin and an end. If you do, you will get an error message.

Before we launch our game, we should set the size of the desktop window. Any configuration that needs to happen for the desktop version of your game needs to be set in the LWJGL3 project launcher class.

```java
```

This code should now draw our bucket. You can run this game by calling the appropriate Gradle command in Idea or implement whatever steps are needed for your chosen development environment as listed in the setup guide. If all things have gone well, you should see our brave, lone bucket sitting in the darkness of the void.

The coordinates we provide determine where the bucket will be drawn on the screen. The coordinates begin in the bottom left and grow to the right and up. Our game world is described in imaginary units best defined as meters. For reference our bucket at 100 pixels wide and 100 pixels tall will equal 1 meter, making our bucket 1x1 meters. This ratio or pixels per meter can be anything you want, but make sure whatever you choose is a simple value that makes sense in your game world. Your game logic should really know nothing about pixels.

The constructor of the viewport determines how much of the game world we see in meters.

```java
```

Let's cheer up this scene with the background. Drawing the background is similar to drawing the bucket.

```java
```

But what happened to our bucket? We need to talk about draw order. Drawing happens consecutively in the order you list it in code. This is what really happens. The screen is cleared. The bucket is drawn on the screen. And then the background is drawn over everything. This final image is then shown on the screen. The process is repeated every frame.

Simply reordering the code will resolve this issue.

```java
```

We'll skip rendering the droplets for now and return to it when we have the logic to randomly create them.

## Input Controls
It's not fun to have a game without some sort of movement or action on screen. Let's enable the player's ability to control the bucket. As you know, there are all sorts of ways to get input from a user. We'll focus on a few: the keyboard, mouse, and touch.

We need some way of keeping track of where the player bucket is in the game world. Texture does not store any position state. Sure, you can tell SpriteBatch where to draw it every frame by using the provided overloaded methods. What if you want to rotate it? Resize it? These methods get incredibly complicated the more you want to do.

```java
```

Let's use a Sprite instead.

```java
```

Erase the SpriteBatch.draw line. The Sprite draw code is written in a different way:

```java
```

### Keyboard
Now to capturing player input. This is how you detect if a player is pressing keys on the keyboard.

```java
```

This is known as keyboard polling. Every time a frame is drawn, we're going to check if a key is pressed. There is a list of pretty much every conceivable key in Gdx.input.Keys. We want to react to the user pressing the left arrow key.

```java
```

That's great, but what is supposed to happen when the key is pressed? We need to move the coordinates of the bucket sprite.

```java
```

The number dictates how fast the bucket moves. Adding to the x makes the bucket move to the right. This basically means "set the bucket x to what it currently is right now plus a little bit more". Subtracting from the x makes the bucket move to the left.

```java
```

An unfortunate side effect of having our logic inside the render method is that our code behaves differently on different hardware. This is because of differences in framerate. More frames per second means more movement per second.

To counteract this, we need to use delta time. Delta time is the measured time between frames. If we multiply our movement by delta time, the movement will be consistent no matter what hardware we run this game on.

```java
```

This effectively means that the number we select here is how far the bucket moves in one second. Remember to use delta time whenever you are calculating something that happens over time. Now let's copy the code for movement to the right. Flip the minus to a plus to move to the right.

```java
```

### Mouse and Touch Controls
Mouse and Touch controls are related. To react to the user clicking or tapping the screen, call the following method:

```java
```

Now the player has clicked the screen, but where did they click? We can use the methods Gdx.input.getX() and Gdx.input.getY() for this. Unfortunately, these values are in window coordinates which don't correlate to our selected pixels per meter. The coordinates are also upside down because Window coordinates start from the top left. We need to create a Vector3 object to do some math. Notice that we have created a single instance variable for the Vector3 instead of creating it locally. By reusing this Vector3, we prevent the game from triggering the garbage collector frequently which causes lag spikes in the game.

This converts the window coordinates to coordinates in our world space. You actually do not have to modify this code if you want to support input in mobile devices, however you should read about some other features that libGDX provides you.

## Game Logic
The player can move left and right now, but they can go completely off the screen. We need to prevent the player from doing that. Remember that the left side of the screen starts at 0.
This code detects if the bucket goes too far left. If it does, it snaps its position at the farthest it's allowed to go. Let's do the other side.

This kind of works, but it lets the bucket go just a little too far right. In fact, it's one whole unit too far to the right. This is because the bucket sprite has an origin on the bottom left of the image.

To resolve this, we need to subtract the width of the bucket from the right edge.
Now to spawn the rain drops. We'll create our first rain drop in the create method
The size is the same as the player. Setting the y position at the top of the screen will make it appear as if it's falling from the sky. The following line adds the drop to a list of drops that we can manage in our render loop. Now you can call this method whenever you want to create a droplet. Let's create our first droplet in the create method.

If you run the program now, you'll see nothing happen. That's because the droplet doesn't have any movement or render code. Begin coding the logic for the droplets in the render method.

It might seem inefficient to have two separate loops for logic and rendering, but there is a good reason for this as you will soon see. It's also good practice to keep logic and rendering code independent from each other.

We have a problem here. The rain drop only spawns on the left side every time. You could change the position, of course, but there is no variability. No randomness. We need it to be a random position between 0 and the width of the world.

Again, we're subtracting the width of the sprite so none of the raindrops appear outside of the view. Success!

That's only one droplet though. When it rains, we have multiple droplets over the course of time. Whenever we need something to be done in the future, we can use the Timer class. You'll need to wrap your existing code within this inner class.

The parameters define how soon it should start this code in seconds (right away), how long is the interval before calling the code again (every second), and how many times it should do this (a negative number means it will do it forever).

These droplets will fall off the screen never to be seen again. Java doesn't forget though. These droplets remain in memory forever. If you profile your game you'll see that we have a memory leak.

So, we should remove the drop sprite from the list when it falls off screen. We need to make some modifications to the for loop.

Removing items in a list while you are iterating through it can cause some unforeseen bugs. That's why you should iterate through the list backwards so you don't skip any indexes. Make sure to learn about other collections available like the SnapshotArray and the DelayedRemovalArray for more complex projects.

This is great, however the drops don't interact with the bucket. This is where we incorporate some rudimentary collision detection. This can be achieved with the Rectangle class. We need two rectangles to make comparisons. One for the bucket and one to be reused with every drop.
The code now sets the dropRectangle to the position and dimensions of the Sprite.

This line checks if it overlaps with the bucketRectangle. If it does, remove the Sprite from the list of drop Sprites. That means it will no longer be drawn or acted upon. It simply doesn't exist anymore.

## Sound
It's very easy to add a line to play a sound effect now that we are at the end of our workflow. We want the drop sound to play when the bucket collides with the drop. It should not play when the drop falls out of the level.

## Additional Steps
So, you're at the final steps of making a game. You should test the game out. Tweak values to make the game easier or harder.

If you want to let your friends and colleagues try your game out, you'll need to make a distributable that they can play. No one is going to want set up an IDE and copy your entire project just to play it. See the page on Importing & Running a project.

## Further learning
Now that you've completed the simple game, it's time to extend the simple game. This project managed to put all of its code in a single class. This was in the service of making it simple, but it is a terrible way to organize code. The next tutorial will teach you about the Game class and how to implement Screen to arrange your project. It will also cover other important improvements to your game. For example, these instructions skipped the use of the dispose() method because it's not relevant for single page project. When working with multiple screens, you may want to dispose of resources from the last screen to release the memory for new resources in your game.

Game design is a constant journey of learning. The wiki goes furth in depth regarding all the subjects you have learned here. Look into collections, TexturePacker, AssetManager, audio, and user input.

This tutorial focused entirely on desktop development. There are many more considerations you must make before you explore Android, iOS, and HTML5 development. Java is not truly "write once, run anywhere" but libGDX takes you pretty close to that goal.















Before diving into the APIs provided by libGDX, let's create **a very simple "game"**, that touches each module provided by the framework, to get a feeling for things. We'll introduce a few different concepts without going into unnecessary detail.

{% include setup_flowchart.html current='3' %}

In the following, we'll look at:

  * Basic file access
  * Clearing the screen
  * Drawing images
  * Using a camera
  * Basic input processing
  * Playing sound effects

## Project Setup
Follow the steps in the [Generating a Project](/wiki/start/project-generation) guide. In the following, we will use these settings:

  * Application name: `drop`
  * Package name: `com.badlogic.drop`
  * Game class: `Drop`

Now fill in the destination. If you are interested in Android development, be sure to check that option and provide the Android SDK folder. For the purpose of this tutorial, we will uncheck the iOS sub project (as you would need OS X to run it) and all extensions (extensions are a more advanced topic).

Once imported into your IDE, you should have 5 projects or modules: the main one `drop`, and the sub projects `android` (or `drop-android` under Eclipse), `core` / `drop-core`, `lwjgl3` / `drop-lwjgl3`, and `html` / `drop-html`.

To launch or debug the game, see the page [Importing & Running a Project](/wiki/start/import-and-running).

If we just run the project, we will get an error: `Couldn't load file: badlogic.jpg`. Your Run Configuration has to be properly configured first: Select as working directory `PATH_TO_YOUR_PROJECT/​drop/assets`. When we run the game now, we will get the default 'game' generated by the setup app: a Badlogic Games image on a red background. Not too exciting, but that's about to change.

## The Game
The game idea is very simple:

  * Catch raindrops with a bucket.
  * The bucket is located in the lower part of the screen.
  * Raindrops spawn randomly at the top of the screen every second and accelerate downwards.
  * Player can drag the bucket horizontally via the mouse/touch or move it via the left and right cursor keys.
  * The game has no end - think of it as a zen-like experience :)

## The Assets
We need a few images and sound effects to make the game look somewhat pretty. For the graphics we need to define a target resolution of 800x480 pixels (landscape mode on Android). If the device the game is run on does not have that resolution, we simply scale everything to fit on the screen.

**Note:** for high profile games you might want to consider using different assets for different screen densities. This is a big topic on its own and won't be covered here.
{: .notice--primary}

The raindrop and the bucket should take up a small(ish) portion of the screen vertically, so we'll let them have a size of 64x64 pixels.

The following sources provide some sample assets:

  * water drop sound by _junggle_, see [here](https://freesound.org/people/junggle/sounds/30341/)
  * rain sounds by _acclivity_, see [here](https://freesound.org/people/acclivity/sounds/28283/)
  * droplet sprite by _mvdv_, see [here](https://github.com/Quillraven/SimpleKtxGame/blob/01-app/android/assets/images/drop.png?raw=true)
  * bucket sprite by _mvdv_, see [here](https://github.com/Quillraven/SimpleKtxGame/blob/01-app/android/assets/images/bucket.png?raw=true)

To make the assets available to the game, we have to place them in the `assets` folder, which is located in the root directory of your game. I named the 4 files: _drop.wav_, _rain.mp3_, _droplet.png_ and _bucket.png_ and put them in `assets/`. We only need to store the assets once, as both the desktop and HTML5 projects are configured to 'see' this folder through different means. After that, depending on your IDE you may have to refresh the project tree to make the new files known (in Eclipse, right click -> Refresh), otherwise you may get a 'file not found' runtime exception.

## Configuring the Starter Classes
Given our requirements we can now configure our different starter classes. We'll start with the **desktop project**. Open the `Lwjgl3Launcher.java` class in `lwjgl3/src/…` (or `drop-lwjgl3` under Eclipse). We want a 800x480 window and set the title to "Drop". The code should look like this:

```java
package com.badlogic.drop;

import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration;
import com.badlogic.drop.Drop;

public class Lwjgl3Launcher {
   public static void main (String[] arg) {
      Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
      config.setTitle("Drop");
      config.setWindowedMode(800, 480);
      config.useVsync(true);
      config.setForegroundFPS(60);
      new Lwjgl3Application(new Drop(), config);
   }
}
```

If you are only interested in desktop development, you can skip the rest of this section.
{: .notice--info}

Moving on to the **Android project**, we want the application to be run in landscape mode. For this we need to modify `AndroidManifest.xml` in the `android` (or `drop-android`) root directory, which looks like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.badlogic.drop.android"
    android:versionCode="1"
    android:versionName="1.0" >

    <uses-feature android:glEsVersion="0x00020000" android:required="true" />

    <application
        android:allowBackup="true"
        android:fullBackupContent="true"
        android:icon="@drawable/ic_launcher"
        android:isGame="true"
        android:appCategory="game"
        android:label="@string/app_name"
        android:theme="@style/AppTheme"
        tools:ignore="UnusedAttribute">
        <activity
            android:name="com.badlogic.drop.AndroidLauncher"
            android:label="@string/app_name"
            android:screenOrientation="landscape"
            android:configChanges="keyboard|keyboardHidden|navigation|orientation|screenSize|screenLayout"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```

The setup tool already filled in the correct values for us, `android:screenOrientation` is set to "landscape". If we wanted to run the game in portrait mode we would have set that attribute to "portrait".

We also want to conserve battery and disable the accelerometer and compass. We do this in the `AndroidLauncher.java` file in `android/src/…` (or `drop-android`), which should look something like this:

```java
package com.badlogic.drop;

import android.os.Bundle;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;
import com.badlogic.drop.Drop;

public class AndroidLauncher extends AndroidApplication {
   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
      config.useAccelerometer = false;
      config.useCompass = false;
      initialize(new Drop(), config);
   }
}
```

We cannot define the resolution of the `Activity`, as it is set by the Android operating system. As we defined earlier, we'll simply scale the 800x480 target resolution to whatever the resolution of the device is.

Finally we want to make sure the **HTML5 project** also uses a 800x480 drawing area. For this we modify the `HtmlLauncher.java` file in `html/src/…` (or `drop-html`):

```java
package com.badlogic.drop.client;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.backends.gwt.GwtApplication;
import com.badlogic.gdx.backends.gwt.GwtApplicationConfiguration;
import com.badlogic.drop.Drop;

public class HtmlLauncher extends GwtApplication {
   @Override
   public GwtApplicationConfiguration getConfig () {
      return new GwtApplicationConfiguration(800, 480);
   }

   @Override
   public ApplicationListener createApplicationListener () {
      return new Drop();
   }
}
```

All our starter classes are now correctly configured, let's move on to implementing our fabulous game.

## The Code
We want to split up our code into a few sections. For the sake of simplicity we keep everything in the `Drop.java` file of the Core project, located in `core/src/…` (or `drop-core` in Eclipse).

## Loading the Assets
Our first task is to load the assets and store references to them. Assets are usually loaded in the `ApplicationAdapter.create()` method, so let's do that:

```java
package com.badlogic.drop;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.audio.Music;
import com.badlogic.gdx.audio.Sound;
import com.badlogic.gdx.graphics.Texture;

public class Drop extends ApplicationAdapter {
   private Texture dropImage;
   private Texture bucketImage;
   private Sound dropSound;
   private Music rainMusic;

   @Override
   public void create() {
      // load the images for the droplet and the bucket, 64x64 pixels each
      dropImage = new Texture(Gdx.files.internal("droplet.png"));
      bucketImage = new Texture(Gdx.files.internal("bucket.png"));

      // load the drop sound effect and the rain background "music"
      dropSound = Gdx.audio.newSound(Gdx.files.internal("drop.wav"));
      rainMusic = Gdx.audio.newMusic(Gdx.files.internal("rain.mp3"));

      // start the playback of the background music immediately
      rainMusic.setLooping(true);
      rainMusic.play();

      // ... more to come ...
   }

   // rest of class omitted for clarity
```

For each of our assets we have a field in the `Drop` class so we can later refer to it. The first two lines in the `create()` method load the images for the raindrop and the bucket. A `Texture` represents a loaded image that is stored in video ram. One can usually not draw to a Texture. A `Texture` is loaded by passing a `FileHandle` to an asset file to its constructor. Such `FileHandle` instances are obtained through one of the methods provided by `Gdx.files`. There are different types of files, we use the "internal" file type here to refer to our assets. Internal files are located in the `assets` directory of the Android project. As seen before, the desktop and HTML5 projects reference the same directory.

Next we load the sound effect and the background music. libGDX differentiates between sound effects, which are stored in memory, and music, which is streamed from wherever it is stored. Music is usually too big to be kept in memory completely, hence the differentiation. As a rule of thumb, you should use a `Sound` instance if your sample is shorter than 10 seconds, and a `Music` instance for longer audio pieces.

**Note:** libGDX supports MP3, OGG and WAV files. Which format you should use, depends on your specific needs, as each format has its own advantages and disadvantages. For example, WAV files are quite large compared to other formats, OGG files don't work on RoboVM (iOS) nor with Safari (GWT), and MP3 files have issues with seemless looping.
{: .notice--primary}

Loading of a `Sound` or `Music` instance is done via `Gdx.audio.newSound()` and `Gdx.audio.newMusic()`. Both of these methods take a `FileHandle`, just like the `Texture` constructor.

At the end of the `create()` method we also tell the `Music` instance to loop and start playback immediately. If you run the application you'll see a nice red background and hear the rain fall.

## A Camera and a SpriteBatch
Next up, we want to create a camera and a `SpriteBatch`. We'll use the former to ensure we can render using our target resolution of 800x480 pixels no matter what the actual screen resolution is. The `SpriteBatch` is a special class that is used to draw 2D images, like the textures we loaded.

We add two new fields to the class, let's call them camera and batch:

```java
   private OrthographicCamera camera;
   private SpriteBatch batch;
```

In the `create()` method we first create the camera like this:

```java
   camera = new OrthographicCamera();
   camera.setToOrtho(false, 800, 480);
```

This will make sure the camera always shows us an area of our game world that is 800x480 units wide. Think of it as a virtual window into our world. We currently interpret the units as pixels to make our life a little easier. There's nothing preventing us from using other units though, e.g. meters or whatever you have. Cameras are very powerful and allow you to do a lot of things we won't cover in this basic tutorial. Check out the rest of the developer guide for more information.

Next we create the `SpriteBatch` (we are still in the `create()` method):

```java
   batch = new SpriteBatch();
```

We are almost done with creating all the things we need to run this simple game.

## Adding the Bucket
The last bits that are missing are representations of our bucket and the raindrop. Let's think about what we need to represent those in code:

  * A bucket/raindrop has an x/y position in our 800x480 units world.
  * A bucket/raindrop has a width and height, expressed in the units of our world.
  * A bucket/raindrop has a graphical representation, we already have those in form of the `Texture` instances we loaded.

So, to describe both the bucket and raindrops we need to store their position and size. libGDX provides a `Rectangle` class which we can use for this purpose. Let's start by creating a `Rectangle` that represents our bucket. We add a new field:

```java
   // add this import and NOT the one in the standard library
   import com.badlogic.gdx.math.Rectangle;

   private Rectangle bucket;
```

In the `create()` method we instantiate the Rectangle and specify its initial values. We want the bucket to be 20 pixels above the bottom edge of the screen, and centered horizontally.

```java
   bucket = new Rectangle();
   bucket.x = 800 / 2 - 64 / 2;
   bucket.y = 20;
   bucket.width = 64;
   bucket.height = 64;
```

We center the bucket horizontally and place it 20 pixels above the bottom edge of the screen. Wait, why is `bucket.y` set to 20, shouldn't it be 480 - 20? By default, all rendering in libGDX (and OpenGL) is performed with the y-axis pointing upwards. The x/y coordinates of the bucket define the bottom left corner of the bucket, the origin for drawing is located in the bottom left corner of the screen. The width and height of the rectangle are set to 64x64, our small-ish portion of our target resolutions height.

**Note:** it is possible to [change this setup](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/YDownTest.java) so the y-axis points down and the origin is in the upper left corner of the screen. OpenGL and the camera class are so flexible that you use have pretty much any kind of viewing angle you want, in 2D and 3D. However, this is not recommended.
{: .notice--primary}

### Rendering the Bucket
Time to render our bucket. The first thing we want to do is to clear the screen with a dark blue color. Simply change the `render()` method to look like this:

```java
   @Override
   public void render() {
      ScreenUtils.clear(0, 0, 0.2f, 1);

      ... more to come here ...
   }
```

The arguments for `ScreenUtils.clear(r, g, b, a)` are the red, green, blue and alpha component of that color, each within the range [0, 1].

Next we need to tell our camera to make sure it is updated. Cameras use a mathematical entity called a matrix that is responsible for setting up the coordinate system for rendering. These matrices need to be recomputed every time we change a property of the camera, like its position. We don't do this in our simple example, but it is generally a good practice to update the camera once per frame:

```java
   camera.update();
```

Now we can render our bucket:

```java
   batch.setProjectionMatrix(camera.combined);
   batch.begin();
   batch.draw(bucketImage, bucket.x, bucket.y);
   batch.end();
```

The first line tells the `SpriteBatch` to use the coordinate system specified by the camera. As stated earlier, this is done with something called a matrix, to be more specific, a projection matrix. The `camera.combined` field is such a matrix. From there on the `SpriteBatch` will render everything in the coordinate system described earlier.

Next we tell the `SpriteBatch` to start a new batch. Why do we need this and what is a batch? OpenGL hates nothing more than telling it about individual images. It wants to be told about as many images to render as possible at once.

The `SpriteBatch` class helps make OpenGL happy. It will record all drawing commands in between `SpriteBatch.begin()` and `SpriteBatch.end()`. Once we call `SpriteBatch.end()` it will submit all drawing requests we made at once, speeding up rendering quite a bit. This all might look cumbersome in the beginning, but it is what makes the difference between rendering 500 sprites at 60 frames per second and rendering 100 sprites at 20 frames per second.

### Making the Bucket Move (Touch/Mouse)
Time to let the user control the bucket. Earlier we said we'd allow the user to drag the bucket. Let's make things a little bit easier. If the user touches the screen (or presses a mouse button), we want the bucket to center around that position horizontally. Adding the following code to the bottom of the `render()` method will do this:

```java
   if(Gdx.input.isTouched()) {
      Vector3 touchPos = new Vector3();
      touchPos.set(Gdx.input.getX(), Gdx.input.getY(), 0);
      camera.unproject(touchPos);
      bucket.x = touchPos.x - 64 / 2;
   }
```

First we ask the input module whether the screen is currently touched (or a mouse button is pressed) by calling `Gdx.input.isTouched()`. Next we want to transform the touch/mouse coordinates to our camera's coordinate system. This is necessary because the coordinate system in which touch/mouse coordinates are reported might be different than the coordinate system we use to represent objects in our world.

`Gdx.input.getX()` and `Gdx.input.getY()` return the current touch/mouse position (libGDX also supports multi-touch, but that's a topic for a different article). To transform these coordinates to our camera's coordinate system, we need to call the `camera.unproject()` method, which requests a `Vector3`, a three dimensional vector. We create such a vector, set the current touch/mouse coordinates and call the method. The vector will now contain the touch/mouse coordinates in the coordinate system our bucket lives in. Finally we change the position of the bucket to be centered around the touch/mouse coordinates.

**Note:** it is very, very bad to instantiate a lot of new objects, such as the Vector3 instance. The reason for this is the garbage collector has to kick in frequently to collect these short-lived objects. While on the desktop this not such a big deal (due to the resources available), on Android the GC can cause pauses of up to a few hundred milliseconds, which results in stuttering. In this particular case, if you want to solve this issue, simply make `touchPos` a private final field of the `Drop` class instead of instantiating it all the time.
{: .notice--primary}

**Note:** `touchPos` is a three dimensional vector. You might wonder why that is if we only operate in 2D. `OrthographicCamera` is actually a 3D camera which takes into account z-coordinates as well. Think of CAD applications, they use 3D orthographic cameras as well. We simply abuse it to draw 2D graphics.
{: .notice--primary}

### Making the Bucket Move (Keyboard)
On the desktop and in the browser we can also receive keyboard input. Let's make the bucket move when the left or right cursor key is pressed.

We want the bucket to move without acceleration, at two hundred pixels/units per second, either to the left or the right. To implement such time-based movement we need to know the time that passed in between the last and the current rendering frame. Here's how we can do all this:

```java
   if(Gdx.input.isKeyPressed(Input.Keys.LEFT)) bucket.x -= 200 * Gdx.graphics.getDeltaTime();
   if(Gdx.input.isKeyPressed(Input.Keys.RIGHT)) bucket.x += 200 * Gdx.graphics.getDeltaTime();
```

The method `Gdx.input.isKeyPressed()` tells us whether a specific key is pressed. The `Keys` enumeration contains all the keycodes that libGDX supports. The method `Gdx.graphics.getDeltaTime()` returns the time passed between the last and the current frame in seconds. All we need to do is modify the bucket's x-coordinate by adding/subtracting 200 units times the delta time in seconds.

We also need to make sure our bucket stays within the screen limits:

```java
   if(bucket.x < 0) bucket.x = 0;
   if(bucket.x > 800 - 64) bucket.x = 800 - 64;
```

## Adding the Raindrops
For the raindrops we keep a list of `Rectangle` instances, each keeping track of the position and size of a raindrop. Let's add that list as a field:

```java
   private Array<Rectangle> raindrops;
```

The `Array` class is a libGDX utility class to be used instead of standard Java collections like `ArrayList`. The problem with the latter is that they produce garbage in various ways. The `Array` class tries to minimize garbage as much as possible. libGDX offers other garbage collector aware collections such as hash-maps or sets as well.

We also need to keep track of the last time we spawned a raindrop, so we add another field:

```java
   private long lastDropTime;
```

We'll store the time in nanoseconds, that's why we use a long.

To facilitate the creation of raindrops we'll write a method called `spawnRaindrop()` which instantiates a new `Rectangle`, sets it to a random position at the top edge of the screen and adds it to the `raindrops` array.

```java
   private void spawnRaindrop() {
      Rectangle raindrop = new Rectangle();
      raindrop.x = MathUtils.random(0, 800-64);
      raindrop.y = 480;
      raindrop.width = 64;
      raindrop.height = 64;
      raindrops.add(raindrop);
      lastDropTime = TimeUtils.nanoTime();
   }
```

The method should be pretty self-explanatory. The `MathUtils` class is a libGDX class offering various math related static methods. In this case it will return a random value between zero and 800 - 64. The `TimeUtils` is another libGDX class that provides some very basic time related static methods. In this case we record the current time in nano seconds based on which we'll later decide whether to spawn a new drop or not.

In the `create()` method we now instantiate the raindrops array and spawn our first raindrop:

We need to instantiate that array in the `create()` method:

```java
   raindrops = new Array<Rectangle>();
   spawnRaindrop();
```

Next we add a few lines to the `render()` method that will check how much time has passed since we spawned a new raindrop, and creates a new one if necessary:

```java
   if(TimeUtils.nanoTime() - lastDropTime > 1000000000) spawnRaindrop();
```

We also need to make our raindrops move, let's take the easy route and have them move at a constant speed of 200 pixels/units per second. If the raindrop is beneath the bottom edge of the screen, we remove it from the array.

```java
   for (Iterator<Rectangle> iter = raindrops.iterator(); iter.hasNext(); ) {
      Rectangle raindrop = iter.next();
      raindrop.y -= 200 * Gdx.graphics.getDeltaTime();
      if(raindrop.y + 64 < 0) iter.remove();
   }
```

The raindrops need to be rendered. We'll add that to the `SpriteBatch` rendering code which looks like this now:

```java
   batch.begin();
   batch.draw(bucketImage, bucket.x, bucket.y);
   for(Rectangle raindrop: raindrops) {
      batch.draw(dropImage, raindrop.x, raindrop.y);
   }
   batch.end();
```

One final adjustment: if a raindrop hits the bucket, we want to playback our drop sound and remove the raindrop from the array. We simply add the following lines to the raindrop update loop:

```java
      if(raindrop.overlaps(bucket)) {
         dropSound.play();
         iter.remove();
      }
```

The `Rectangle.overlaps()` method checks if this rectangle overlaps with another rectangle. In our case, we tell the drop sound effect to play itself and remove the raindrop from the array.

## Cleaning Up
A user can close the application at any time. For this simple example there's nothing that needs to be done. However, it is in general a good idea to help out the operating system a little and clean up the mess we created.

Any libGDX class that implements the `Disposable` interface and thus has a `dispose()` method needs to be cleaned up manually once it is no longer used. In our example that's true for the textures, the sound and music and the `SpriteBatch`. Being good citizens, we override the `ApplicationAdapter.dispose()` method as follows:

```java
   @Override
   public void dispose() {
      dropImage.dispose();
      bucketImage.dispose();
      dropSound.dispose();
      rainMusic.dispose();
      batch.dispose();
   }
```

Once you dispose of a resource, you should not access it in any way.

Disposables are usually native resources which are not handled by the Java garbage collector. This is the reason why we need to manually dispose of them. libGDX provides various ways to help with asset management. Read the rest of the development guide to discover them.

## Handling Pausing/Resuming
Android has the notation of pausing and resuming your application every time the user gets a phone call or presses the home button. libGDX will do many things automatically for you in that case, e.g. reload images that might have gotten lost (OpenGL context loss, a terrible topic on its own), pause and resume music streams and so on.

In our game there's no real need to handle pausing/resuming. As soon as the user comes back to the application, the game continues where it left. Usually one would implement a pause screen and ask the user to touch the screen to continue. This is left as an exercise for the reader - check out the `ApplicationAdapter.pause()` and `ApplicationAdapter.resume()` methods.

## The Full Source
Here's the tiny source for our simple game:

```java
package com.badlogic.drop;

import java.util.Iterator;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input;
import com.badlogic.gdx.audio.Music;
import com.badlogic.gdx.audio.Sound;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.MathUtils;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.math.Vector3;
import com.badlogic.gdx.utils.Array;
import com.badlogic.gdx.utils.ScreenUtils;
import com.badlogic.gdx.utils.TimeUtils;

public class Drop extends ApplicationAdapter {
   private Texture dropImage;
   private Texture bucketImage;
   private Sound dropSound;
   private Music rainMusic;
   private SpriteBatch batch;
   private OrthographicCamera camera;
   private Rectangle bucket;
   private Array<Rectangle> raindrops;
   private long lastDropTime;

   @Override
   public void create() {
      // load the images for the droplet and the bucket, 64x64 pixels each
      dropImage = new Texture(Gdx.files.internal("droplet.png"));
      bucketImage = new Texture(Gdx.files.internal("bucket.png"));

      // load the drop sound effect and the rain background "music"
      dropSound = Gdx.audio.newSound(Gdx.files.internal("drop.wav"));
      rainMusic = Gdx.audio.newMusic(Gdx.files.internal("rain.mp3"));

      // start the playback of the background music immediately
      rainMusic.setLooping(true);
      rainMusic.play();

      // create the camera and the SpriteBatch
      camera = new OrthographicCamera();
      camera.setToOrtho(false, 800, 480);
      batch = new SpriteBatch();

      // create a Rectangle to logically represent the bucket
      bucket = new Rectangle();
      bucket.x = 800 / 2 - 64 / 2; // center the bucket horizontally
      bucket.y = 20; // bottom left corner of the bucket is 20 pixels above the bottom screen edge
      bucket.width = 64;
      bucket.height = 64;

      // create the raindrops array and spawn the first raindrop
      raindrops = new Array<Rectangle>();
      spawnRaindrop();
   }

   private void spawnRaindrop() {
      Rectangle raindrop = new Rectangle();
      raindrop.x = MathUtils.random(0, 800-64);
      raindrop.y = 480;
      raindrop.width = 64;
      raindrop.height = 64;
      raindrops.add(raindrop);
      lastDropTime = TimeUtils.nanoTime();
   }

   @Override
   public void render() {
      // clear the screen with a dark blue color. The
      // arguments to clear are the red, green
      // blue and alpha component in the range [0,1]
      // of the color to be used to clear the screen.
      ScreenUtils.clear(0, 0, 0.2f, 1);

      // tell the camera to update its matrices.
      camera.update();

      // tell the SpriteBatch to render in the
      // coordinate system specified by the camera.
      batch.setProjectionMatrix(camera.combined);

      // begin a new batch and draw the bucket and
      // all drops
      batch.begin();
      batch.draw(bucketImage, bucket.x, bucket.y);
      for(Rectangle raindrop: raindrops) {
         batch.draw(dropImage, raindrop.x, raindrop.y);
      }
      batch.end();

      // process user input
      if(Gdx.input.isTouched()) {
         Vector3 touchPos = new Vector3();
         touchPos.set(Gdx.input.getX(), Gdx.input.getY(), 0);
         camera.unproject(touchPos);
         bucket.x = touchPos.x - 64 / 2;
      }
      if(Gdx.input.isKeyPressed(Input.Keys.LEFT)) bucket.x -= 200 * Gdx.graphics.getDeltaTime();
      if(Gdx.input.isKeyPressed(Input.Keys.RIGHT)) bucket.x += 200 * Gdx.graphics.getDeltaTime();

      // make sure the bucket stays within the screen bounds
      if(bucket.x < 0) bucket.x = 0;
      if(bucket.x > 800 - 64) bucket.x = 800 - 64;

      // check if we need to create a new raindrop
      if(TimeUtils.nanoTime() - lastDropTime > 1000000000) spawnRaindrop();

      // move the raindrops, remove any that are beneath the bottom edge of
      // the screen or that hit the bucket. In the latter case we play back
      // a sound effect as well.
      for (Iterator<Rectangle> iter = raindrops.iterator(); iter.hasNext(); ) {
         Rectangle raindrop = iter.next();
         raindrop.y -= 200 * Gdx.graphics.getDeltaTime();
         if(raindrop.y + 64 < 0) iter.remove();
         if(raindrop.overlaps(bucket)) {
            dropSound.play();
            iter.remove();
         }
      }
   }

   @Override
   public void dispose() {
      // dispose of all the native resources
      dropImage.dispose();
      bucketImage.dispose();
      dropSound.dispose();
      rainMusic.dispose();
      batch.dispose();
   }
}
```

## Where to go from here
This was a very basic example of how to use libGDX to create a minimalistic game. There are quite a few things that can be improved from here on. Your next steps should most certainly entail looking at `Screen`s and `Game`s. To learn about these, there is a **[second tutorial](/wiki/start/simple-game-extended)** following on from this one.
