---
title: Scene2d
---
## Overview ##

scene2d is a 2D scene graph for building applications and UIs using a hierarchy of actors. If you're looking for the UI component of scene2d, see [Scene2d.ui](/wiki/graphics/2d/scene2d/scene2d-ui)

Check out [LibGDX.info](https://libgdx.info/basic_action/) for Scene2d examples (Image, Label etc...)

It provides the following features:

 * Rotation and scale of a group is applied to all child actors. Child actors always work in their own coordinate system, parent transformations are applied transparently.

 * Simplified 2D drawing via [SpriteBatch](/wiki/graphics/2d/spritebatch-textureregions-and-sprites). Each actor draws in its own un-rotated and unscaled coordinate system where 0,0 is the bottom left corner of the actor.

 * Hit detection of rotated and scaled actors. Each actor determines if it is hit using its own un-rotated and unscaled coordinate system.

 * Routing of input and other events to the appropriate actor. The event system is flexible, enabling parent actors to handle events before or after children.

 * Action system for easy manipulation of actors over time. Actions can be chained and combined for complex effects.

scene2d is well equipped for laying out, drawing, and handling input for game menus, HUD overlays, tools, and other UIs. The [scene2d.ui](/wiki/graphics/2d/scene2d/scene2d-ui) package provides many actors and other utilities specifically for building UIs.

Scene graphs have the drawback that they couple model and view. Actors store data that is often considered model data in games, such as their size and position. Actors are also the view, as they know how to draw themselves. This coupling makes MVC separation difficult. When used solely for UIs or for apps that don't care about MVC, the coupling is not an issue.

scene2d has three classes at its core:

1. The Actor class is a node in the graph which has a position, rectangular size, origin, scale, rotation, and color.

1. The Group class is an actor that may have child actors.

1. The Stage class has a camera, SpriteBatch, and a root group and handles drawing the actors and distributing input events.

### Stage ###

Stage is an InputProcessor. When it receives input events, it fires them on the appropriate actors. If the stage is being used as a UI on top of other content (eg, a HUD), an InputMultiplexer can be used to first give the stage a chance to handle an event. If an actor in the stage handles an event, stage's InputProcessor methods will return true, indicating the event has been handled and should not continue on to the next InputProcessor.

Stage has an `act` method that takes a delta time since last frame. This causes the `act` method on every actor in the scene to be called, allowing the actors to take some action based on time. By default, the Actor `act` method updates all actions on the actor. Calling `act` on the stage is optional, but actor actions and enter/exit events will not occur if it is omitted.

### Viewport ###

The stage's viewport is determined by a [Viewport](/wiki/graphics/viewports) instance. The viewport manages a `Camera` and controls how the stage is displayed on the screen, the stage's aspect ratio (whether it is stretched) and whether black bars appear (letterboxing). The viewport also converts screen coordinates to and from stage coordinates.

The viewport is specified in the stage constructor or by using `setViewport`. If running where the application window can be resized (eg, on the desktop), the stage's viewport should be set when the application window is resized.

Here is an example of the most basic scene2d application with no actors, using a `ScreenViewport`. With this viewport, each unit in the stage corresponds to 1 pixel. This means the stage is never stretched, but more or less of the stage is visible depending on the size of the screen or window. This is often useful for UI applications.

```java
private Stage stage;

public void create () {
	stage = new Stage(new ScreenViewport());
	Gdx.input.setInputProcessor(stage);
}

public void resize (int width, int height) {
	// See below for what true means.
	stage.getViewport().update(width, height, true);
}

public void render () {
	float delta = Gdx.graphics.getDeltaTime();
	Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
	stage.act(delta);
	stage.draw();
}

public void dispose () {
	stage.dispose();
}
```

Passing `true` when updating the viewport changes the camera position so it is centered on the stage, making 0,0 the bottom left corner. This is useful for UIs, where the camera position is not usually changed. When managing the camera position yourself, pass false or omit the boolean. If the stage position is not set, by default 0,0 will be in the center of the screen.

Here is an example of using `StretchViewport`. The stage's size of 640x480 will be stretched to the screen size, potentially changing the stage's aspect ratio.

```java
	stage = new Stage(new StretchViewport(640, 480));
```

Here is an example of using `FitViewport`. The stage's size of 640x480 is scaled to fit the screen without changing the aspect ratio, then black bars are added on either side to take up the remaining space (letterboxing).

```java
	stage = new Stage(new FitViewport(640, 480));
```

Here is an example of using `ExtendViewport`. The stage's size of 640x480 is first scaled to fit without changing the aspect ratio, then the stage's shorter dimension is increased to fill the screen. The aspect ratio is not changed and there are no black bars, but the stage may be longer in one direction.

```java
	stage = new Stage(new ExtendViewport(640, 480));
```

Here is an example of using `ExtendViewport` with a maximum size. As before, the stage's size of 640x480 is first scaled to fit without changing the aspect ratio, then the stage's shorter dimension is increased to fill the screen. However, the stage's size won't be increased beyond the maximum size of 800x480. This approach allows you to show more of the world to support many different aspect ratios without showing black bars.

```java
	stage = new Stage(new ExtendViewport(640, 480, 800, 480));
```

Most viewports that show black bars use `glViewport`, so the stage cannot draw within the black bars. The `glViewport` can be set to the full screen to draw in the black bars outside of the stage.

```java
// Set the viewport to the whole screen.
Gdx.gl.glViewport(0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());

// Draw anywhere on the screen.

// Restore the stage's viewport.
stage.getViewport().update(Gdx.graphics.getWidth(), Gdx.graphics.getHeight(), true);
```

See [Viewport](/wiki/graphics/viewports) for more information.

## Drawing ##

When `draw` is called on the stage, it calls draw on every actor in the stage. Actors' `draw` method can be overridden to perform drawing:

```java
public class MyActor extends Actor {
	TextureRegion region;

	public MyActor () {
		region = new TextureRegion(...);
                setBounds(region.getRegionX(), region.getRegionY(),
			region.getRegionWidth(), region.getRegionHeight());
	}

	@Override
	public void draw (Batch batch, float parentAlpha) {
		Color color = getColor();
		batch.setColor(color.r, color.g, color.b, color.a * parentAlpha);
		batch.draw(region, getX(), getY(), getOriginX(), getOriginY(),
			getWidth(), getHeight(), getScaleX(), getScaleY(), getRotation());
	}
}
```

This `draw` method draws a region using the position, origin, size, scale, and rotation of the actor. The Batch passed to draw is configured to draw in the parent's coordinates, so 0,0 is the bottom left corner of the parent. This makes drawing simple, even if the parent is rotated and scaled. Batch begin has already been called. If the `parentAlpha` is combined with this actor's alpha as shown, child actors will be influenced by the parent's translucency. Note the color of the Batch may be changed by other actors and should be set by each actor before it draws.

If `setVisible(false)` is called on an actor, its draw method will not be called. It will also not receive input events.

If an actor needs to perform drawing differently, such as with a 
`ShapeRenderer`, the Batch should be ended and then begun again at the end of the method. Of course, this causes the batch to be flushed, so should be used judiciously. The transformation and projection matrices from the Batch can be used:

```java
private ShapeRenderer renderer = new ShapeRenderer();

public void draw (Batch batch, float parentAlpha) {
	batch.end();

	renderer.setProjectionMatrix(batch.getProjectionMatrix());
	renderer.setTransformMatrix(batch.getTransformMatrix());
	renderer.translate(getX(), getY(), 0);

	renderer.begin(ShapeType.Filled);
	renderer.setColor(Color.BLUE);
	renderer.rect(0, 0, getWidth(), getHeight());
	renderer.end();

	batch.begin();
}
```

### Group transform ###

When a group is rotated or scaled, the children draw as normal and the Batch's transform draws them correctly rotated or scaled. Before a group draws, the Batch is flushed so the transform can be set. This flush may become a performance bottleneck if there are many dozens of groups. If the actors in a group are not rotated or scaled, then `setTransform(false)` can be used for the group. When this is done, each child's position will be offset by the group's position for drawing, causing the children to appear in the correct location even though the Batch has not been transformed. This cannot be used for a group that has rotation or scale.

## Hit detection ##

The Actor `hit` method receives a point and returns the deepest actor at that point, or null if no actor was hit. Here is the default `hit` method:

```java
public Actor hit (float x, float y, boolean touchable) {
	if (touchable && getTouchable() != Touchable.enabled) return null;
	return x >= 0 && x < width && y >= 0 && y < height ? this : null;
}
```

The coordinates are given in the actor's coordinate system. This simply returns the actor if the point is inside the actor's bounds. More sophisticated checks could be used, eg if the actor was round. The `touchable` boolean parameter indicates if the actor's touchability should be respected. This enables hit detection for purposes other than touch on actors that are not touchable.

When `hit` is called on the stage, `hit` is called on the stage's root group, which in turn calls `hit` on each child. The first non-null actor found is returned as the actor deepest in the hierarchy that contains the given point.

## Event system ##

scene2d uses a generic event system. Each actor has a list of listeners that are notified for events on that actor. Events are propagated in two phases. First, during the "capture" phase an event is given to each actor from the root down to the target actor. Only capture listeners are notified during this phase. This gives parents a chance to intercept and potentially cancel events before children see them. Next, during the "normal" phase the event is given to each actor from the target up to the root. Only normal listeners are notified during this phase. This allows actors to handle an event themselves or let the parent have a try at it.

The event provided to each actor when it is notified contains state about the event. The target is the actor that the event originated on. The listener actor is the actor that the listener is attached to. The event also has a few important methods. If `stop` is called on the event, any remaining listeners for the current actor are still notified, but after those no other actors will receive the event. This can be used to prevent children (during the capture phase) or parents (during the normal phase) from seeing the event. If `cancel` is called on the event, it stops propagation the same as stop and also prevents any default action that would have been taken by the code that fired the event. E.g., if the event is for a check-box being checked, cancelling the event could prevent the check-box from being checked.

For example, imagine a group (a button) which has a child (a label). When the label is clicked, capture listeners are fired. Usually there are none. Next, the label's normal listeners are notified. The label is both the target and the listener actor. If the event was not stopped, the button gets the event and its normal listeners are notified. The label is the target and the button is the listener actor. This continues up to the root. This system allows a single listener on a parent to handle events on its children.

### InputListener ###

EventListeners are added to actors to be notified about events. EventListener is an interface with a `handle(Event)` method. Classes that implement the EventListener interface use `instanceof` to determine whether they should handle the event. For most types of events, specific listener classes are provided for convenience. For example, [InputListener](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/InputListener.html) is provided for receiving and handling InputEvents. An actor just needs to add an InputListener to start receiving input events. InputListener has several methods that may be overridden, and two are shown below:

```java
actor.setBounds(0, 0, texture.getWidth(), texture.getHeight());

actor.addListener(new InputListener() {
	public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) {
		System.out.println("down");
		return true;
	}
	
	public void touchUp (InputEvent event, float x, float y, int pointer, int button) {
		System.out.println("up");
	}
});
```

Note that the actor must specify its bounds in order to receive input events within those bounds.

To handle touch and mouse events, override `touchDown`, `touchDragged`, and `touchUp`. The touchDragged and touchUp events will only be received if touchDown returns true. Also, the touchDragged and touchUp events will be received even if they do not occur over the actor. This simplifies the most common touch event use cases.

To handle enter and exit events when a touch and or the mouse enters or exits an actor, override `enter` or `exit`. 

To handle mouse movement when no mouse button is down (which only occurs on the desktop), override the `mouseMoved` method.

To handle mouse scrolling (which only occurs on the desktop), override the `scrolled` method. This will only be called on the actor with scroll focus, which is set and cleared by calling setScrollFocus on the stage.

To handle key input, override the `keyDown`, `keyUp`, and `keyTyped` methods. These will only be called on the actor with keyboard focus, which is set and cleared by calling `setKeyboardFocus` on the stage.

If `setTouchable(false)` or `setVisible(false)` is called on an actor, it will not receive input events.

### Other listeners ###

Other listeners are provided for common handling of input events. ClickListener has a boolean that is true when a touch or mouse button is pressed over the actor and a `clicked` method that is called when the actor is clicked. ActorGestureListener detects tap, longPress, fling, pan, zoom, and pinch gestures on an actor.

```java
actor.addListener(new ActorGestureListener() {
	public boolean longPress (Actor actor, float x, float y) {
		System.out.println("long press " + x + ", " + y);
		return true;
	}

	public void fling (InputEvent event, float velocityX, float velocityY, int button) {
		System.out.println("fling " + velocityX + ", " + velocityY);
	}

	public void zoom (InputEvent event, float initialDistance, float distance) {
		System.out.println("zoom " + initialDistance + ", " + distance);
	}
});
```

## Actions ##

Each actor has a list of actions. These are updated each frame by the Actor `act` method. Many types of actions are included with libgdx. These can be instantiated, configured, and added to an actor. When the action is complete, it will automatically be removed from the actor.

```java
MoveToAction action = new MoveToAction();
action.setPosition(x, y);
action.setDuration(duration);
actor.addAction(action);
```

Check out [LibGDX.info](https://libgdx.info/basic_action/) for a tutorial on Actions

### Action pooling ###

To avoid allocating a new action each time it is needed, a pool can be used:

```java
Pool<MoveToAction> pool = new Pool<MoveToAction>() {
	protected MoveToAction newObject () {
		return new MoveToAction();
	}
};
MoveToAction action = pool.obtain();
action.setPool(pool);
action.setPosition(x, y);
action.setDuration(duration);
actor.addAction(action);
```

When the action is complete, it is removed from the actor and put back in the pool for reuse. The above code is quite verbose though. The Actions class (note the plural) provides convenience methods. It can provide pooled actions:

```java
MoveToAction action = Actions.action(MoveToAction.class);
action.setPosition(x, y);
action.setDuration(duration);
actor.addAction(action);
```

Even better, the Actions class has methods that return a pooled and configured action.

```java
actor.addAction(Actions.moveTo(x, y, duration));
```

The Actions class has many of these convenience methods for completely configuring any of the built in actions using a single method call. This can be made even simpler by using a static import, which allows the static methods to be referenced on Actions without specifying "Actions." each time. Note that Eclipse will not add a static import for you, you must add it yourself.

```java
import static com.badlogic.gdx.scenes.scene2d.actions.Actions.*;
...
actor.addAction(moveTo(x, y, duration));
```

### Complex actions ###

More complex actions can be built by running actions at the same time or in sequence. ParallelAction has a list of actions and runs them at the same time. SequenceAction has a list of actions and runs them one after another. Use of the static import for the Actions class makes defining complex actions very easy:

```java
actor.addAction(sequence(moveTo(200, 100, 2), color(Color.RED, 6), delay(0.5f), rotateTo(180, 5)));
```

### Action completion ###

To run code when an action is complete, a sequence with a RunnableAction can be used:

```java
actor.addAction(sequence(fadeIn(2), run(new Runnable() {
	public void run () {
		System.out.println("Action complete!");
	}
})));
```

### Interpolation ###

The tweening curve can be set for actions that manipulate an actor over time. This is done by giving the action an instance of Interpolation. The Interpolation class has many static fields for convenience, or you can write your own. See [InterpolationTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/InterpolationTest.java) for an interactive demo of each interpolation.

```java
MoveToAction action = Actions.action(MoveToAction.class);
action.setPosition(x, y);
action.setDuration(duration);
action.setInterpolation(Interpolation.bounceOut);
actor.addAction(action);
```

The Actions class has methods that can take an interpolation and a static import can be used to more easily access the Interpolation static fields. Here the `bounceOut` and `swing` interpolations are used:

```java
import static com.badlogic.gdx.scenes.scene2d.actions.Actions.*;
import static com.badlogic.gdx.math.Interpolation.*;
...
actor.addAction(parallel(moveTo(250, 250, 2, bounceOut), color(Color.RED, 6), delay(0.5f), rotateTo(180, 5, swing)));
actor.addAction(forever(sequence(scaleTo(2, 2, 0.5f), scaleTo(1, 1, 0.5f), delay(0.5f))));
```

### External Links ##

 * [netthreads](http://www.netthreads.co.uk/2012/01/31/libgdx-example-of-using-scene2d-actions-and-event-handling/) A fully documented scene2d example game.
 * [gdx-ui-app](https://github.com/broken-e/gdx-ui-app) A library on top of scene2d for easier development.
 * [Should I use scene2d for my game?](https://jvm-gaming.org/t/libgdx-actor-to-use-or-not-to-use-or-when-to-use/41938/7)
 * [Street Race game tutorial](http://theinvader360.blogspot.co.uk/2013/05/street-race-swipe-libgdx-scene2d.html)
