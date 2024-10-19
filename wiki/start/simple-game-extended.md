---
title: "Extending the Simple Game"
redirect_from:
  - /dev/simple-game-extended/
  - /dev/simple_game_extended/
---

In this tutorial we will be **extending the simple game** "Drop", made in [the previous tutorial](/wiki/start/a-simple-game). We will be adding a menu screen and a couple of features to make this game a little more fully featured.

Let's get started with an introduction to a few more advanced classes in libGDX.

## The Screen interface
Screens are _fundamental_ to any game with multiple components. Screens contain many of the methods you are used to from ApplicationListener objects, and include a couple of new methods: `show` and `hide`, which are called when the Screen gains or loses focus, respectively. Screens are responsible for handling (i.e., processing and rendering) one aspect of your game: a menu screen, a settings screen, a game screen, etc.

## The Game Class
The Game class is responsible for handling multiple screens and provides some helper methods for this purpose, alongside an implementation of ApplicationListener for you to use. Together, Screen and Game objects are used to create a simple and powerful structure for games.

We will start by creating a `Drop` class, which extends Game and whose `create()` method will be the entry point to our game. Let's take a look at some code:

```java
package com.badlogic.drop;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.utils.viewport.FitViewport;


public class Drop extends Game {

	public SpriteBatch batch;
	public BitmapFont font;
	public FitViewport viewport;


	public void create() {
		batch = new SpriteBatch();
		// use libGDX's default Arial font
		font = new BitmapFont();
		viewport = new FitViewport(8, 5);
		
		//font has 15pt, but we need to scale it to our viewport by ratio of viewport height to screen height 
		font.setUseIntegerPositions(false);
		font.getData().setScale(viewport.getWorldHeight() / Gdx.graphics.getHeight());
		
		this.setScreen(new MainMenuScreen(this));
	}

	public void render() {
		super.render(); // important!
	}

	public void dispose() {
		batch.dispose();
		font.dispose();
	}

}
```

We start the application with instantiating a SpriteBatch, BitmapFont and a Viewport. It is a bad practice to create multiple objects that can be shared instead (see [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself)). The SpriteBatch object is used to render objects onto the screen, such as textures; and the BitmapFont object is used, along with a SpriteBatch, to render text onto the screen. We will touch more on this in the Screen classes.

Next, we set the Screen of the Game to a `MainMenuScreen` object, with a Drop instance as its first and only parameter.

A common mistake is to forget to call `super.render()` with a Game implementation. Without this call, the Screen that you set in the `create()` method will not be rendered if you override the render method in your Game class!
{: .notice--primary}

Finally, another reminder to dispose of your (heavy) objects! Some further reading on this can be found [here](/wiki/managing-your-assets).


## The Main Menu
Now, let's get into the nitty-gritty of the `MainMenuScreen` class.

```java
package com.badlogic.drop;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;

public class MainMenuScreen implements Screen {

	final Drop game;

	public MainMenuScreen(final Drop game) {
		this.game = game;
	}


        //...Rest of class omitted for succinctness.

}
```

In this code snippet, we make the constructor for the `MainMenuScreen` class, which implements the Screen interface. The Screen interface does not provide any sort of `create()` method, so we instead use a constructor. The only parameter for the constructor necessary for this game is an instance of `Drop`, so that we can call upon its methods and fields if necessary.

Next, the final "meaty" method in the `MainMenuScreen` class: `render(float)`

```java
public class MainMenuScreen implements Screen {

        //public MainMenuScreen(final Drop game)....

	@Override
	public void render(float delta) {
		ScreenUtils.clear(Color.BLACK);

		game.viewport.apply();
		game.batch.setProjectionMatrix(game.viewport.getCamera().combined);

		game.batch.begin();
		//draw text. Remember that x and y are in meters
		game.font.draw(game.batch, "Welcome to Drop!!! ", 1, 1.5f);
		game.font.draw(game.batch, "Tap anywhere to begin!", 1, 1);
		game.batch.end();

		if (Gdx.input.isTouched()) {
			game.setScreen(new GameScreen(game));
			dispose();
		}
	}

        // Rest of class still omitted...

}

```

The code here is fairly straightforward, except for the fact that we need to call game's SpriteBatch and BitmapFont instances instead of creating our own. `game.font.draw(SpriteBatch, String, float, float)`, is how text is rendered to the screen. libGDX comes with a pre-made font, Arial, so that you can use the default constructor and still get a font.

We then check to see if the screen has been touched, if it has, then we check to set the games screen to a GameScreen instance, and then dispose of the current instance of MainMenuScreen. The rest of the methods that are needed to implement in the MainMenuScreen are left empty, so I'll continue to omit them (there is nothing to dispose of in this class).

Also remember to update viewport on resize.

```java
@Override
public void resize(int width, int height) {
	game.viewport.update(width, height, true);
}
```

## The Game Screen
Now that we have our main menu finished, it's time to finally get to making our game. We will be lifting most of the code from the [original game](/wiki/start/a-simple-game) as to avoid redundancy, and avoid having to think of a different game idea to implement as simply as Drop is.


```java
package com.badlogic.drop;


import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.audio.Music;
import com.badlogic.gdx.audio.Sound;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.Sprite;
import com.badlogic.gdx.math.MathUtils;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.utils.Array;
import com.badlogic.gdx.utils.ScreenUtils;

public class GameScreen implements Screen {
	final Drop game;

	Texture backgroundTexture;
	Texture bucketTexture;
	Texture dropTexture;
	Sound dropSound;
	Music music;
	Sprite bucketSprite;
	Vector2 touchPos;
	Array<Sprite> dropSprites;
	float dropTimer;
	Rectangle bucketRectangle;
	Rectangle dropRectangle;
	int dropsGathered;

	public GameScreen(final Drop game) {
		this.game = game;

		// load the images for the background, bucket and droplet
		backgroundTexture = new Texture("background.png");
		bucketTexture = new Texture("bucket.png");
		dropTexture = new Texture("drop.png");

		// load the drop sound effect and background music
		dropSound = Gdx.audio.newSound(Gdx.files.internal("drop.mp3"));
		music = Gdx.audio.newMusic(Gdx.files.internal("music.mp3"));
		music.setLooping(true);
		music.setVolume(0.5F);

		bucketSprite = new Sprite(bucketTexture);
		bucketSprite.setSize(1, 1);
		
		touchPos = new Vector2();
		
		bucketRectangle = new Rectangle();
		dropRectangle = new Rectangle();
		
		dropSprites = new Array<>();
	}

	@Override
	public void show() {
		// start the playback of the background music
		// when the screen is shown
		music.play();
	}

	@Override
	public void render(float delta) {
		input();
		logic();
		draw();
	}

	private void input() {
		float speed = 4f;
		float delta = Gdx.graphics.getDeltaTime();
        
		if (Gdx.input.isKeyPressed(Input.Keys.RIGHT)) {
			bucketSprite.translateX(speed * delta);
		}
		else if (Gdx.input.isKeyPressed(Input.Keys.LEFT)) {
			bucketSprite.translateX(-speed * delta);
		}
	
		if (Gdx.input.isTouched()) {
			touchPos.set(Gdx.input.getX(), Gdx.input.getY());
			game.viewport.unproject(touchPos);
			bucketSprite.setCenterX(touchPos.x);
		}
	}

	private void logic() {
		float worldWidth = game.viewport.getWorldWidth();
		float worldHeight = game.viewport.getWorldHeight();
		float bucketWidth = bucketSprite.getWidth();
		float bucketHeight = bucketSprite.getHeight();
		float delta = Gdx.graphics.getDeltaTime();
	
		bucketSprite.setX(MathUtils.clamp(bucketSprite.getX(), 0, worldWidth - bucketWidth));
		bucketRectangle.set(bucketSprite.getX(), bucketSprite.getY(), bucketWidth, bucketHeight);
	
		for (int i = dropSprites.size - 1; i >= 0; i--) {
			Sprite dropSprite = dropSprites.get(i);
			float dropWidth = dropSprite.getWidth();
			float dropHeight = dropSprite.getHeight();

            dropSprite.translateY(-2f * delta);
			dropRectangle.set(dropSprite.getX(), dropSprite.getY(), dropWidth, dropHeight);
	
			if (dropSprite.getY() < -dropHeight) dropSprites.removeIndex(i);
			else if (bucketRectangle.overlaps(dropRectangle)) {
				dropsGathered++;
				dropSprites.removeIndex(i);
				dropSound.play();
			}
		}
	
		dropTimer += delta;
		if (dropTimer > 1f) {
			dropTimer = 0;
			createDroplet();
		}
	}

	private void draw() {
		ScreenUtils.clear(Color.BLACK);
		game.viewport.apply();
		game.batch.setProjectionMatrix(game.viewport.getCamera().combined);
		game.batch.begin();
		
		float worldWidth = game.viewport.getWorldWidth();
		float worldHeight = game.viewport.getWorldHeight();
        
		game.batch.draw(backgroundTexture, 0, 0, worldWidth, worldHeight);
		bucketSprite.draw(game.batch);
	
		game.font.draw(game.batch, "Drops collected: " + dropsGathered, 0, worldHeight);
	
		for (Sprite dropSprite : dropSprites) {
			dropSprite.draw(game.batch);
		}
	
		game.batch.end();
	}

	private void createDroplet() {
		float dropWidth = 1;
		float dropHeight = 1;
		float worldWidth = game.viewport.getWorldWidth();
		float worldHeight = game.viewport.getWorldHeight();
	
		Sprite dropSprite = new Sprite(dropTexture);
		dropSprite.setSize(dropWidth, dropHeight);
		dropSprite.setX(MathUtils.random(0F, worldWidth - dropWidth));
		dropSprite.setY(worldHeight);
		dropSprites.add(dropSprite);
	}

	@Override
	public void resize(int width, int height) {
		game.viewport.update(width, height, true);
	}

	@Override
	public void hide() {
	}

	@Override
	public void pause() {
	}

	@Override
	public void resume() {
	}

	@Override
	public void dispose() {
		backgroundTexture.dispose();
		dropSound.dispose();
		music.dispose();
		dropTexture.dispose();
		bucketTexture.dispose();
	}
}
```

This code is almost 95% the same as the original implementation, except now we use a constructor instead of the `create()` method of the `ApplicationListener`, and pass in a `Drop` object, like in the `MainMenuScreen` class. We also start playing the music as soon as the Screen is set to `GameScreen`. Moreover, we added a string to the top left corner of the game, which tracks the number of raindrops collected.

Note that the `dispose()` method of the `GameScreen` class is not called automatically, see the [Screen API](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/Screen.html). It is your responsibility to take care of that. You can call this method from the `dispose()` method of the `Game` class, if the `GameScreen` class passes a reference to itself to the `Game` class or by calling `screen.dispose()` in `Drop` class `dispose()` method. It is important to do this, else `GameScreen` assets might persist and occupy memory even after exiting the application.

And that's it, you have the complete game finished. That is all there is to know about the Screen interface and abstract Game Class, and all there is to creating multifaceted games with multiple states. The **full Java code** can be found [here](https://github.com/libgdx/libgdx.github.io/tree/master/assets/downloads/tutorials/extended-game-java). If you are developing in **Kotlin**, take a look [here](https://github.com/libgdx/libgdx.github.io/tree/master/assets/downloads/tutorials/extended-game-kotlin) for the full code.

## The Future
After this tutorial you should have a basic understanding how libGDX works and what to expect going forward. Some things can still be improved, like using the [Memory Management](/wiki/articles/memory-management#object-pooling) classes to recycle all the Rectangles we have the garbage collector clean up each time we delete a raindrop. OpenGL is also not too fond if we hand it too many different images in a batch (in our case it's OK as we only had two images). Usually one would put all those images into a single `Texture`, also known as a `TextureAtlas`. In addition, taking a look at [Viewports](/wiki/graphics/viewports) will most certainly prove useful. Viewports help dealing with different screen sizes/resolutions and decide, whether the screen's content needs to be stretched/should keep its aspect ratio, etc.

To continue learning about libGDX we highly **recommend reading our [wiki](/wiki/)** and checking out the demos and tests in our main GitHub repository. If you have any questions, **join our official [Discord server](/community/)**, we are always glad to help!

The best practice is to get out there and do it, so farewell and happy coding!
