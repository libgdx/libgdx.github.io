---
title: Gesture detection
---
# Gesture Detection
Touch screens lend themselves well to gesture based input. A gesture could be a pinch with two fingers to indicate the desire to zoom, a tap or double tap, a long press and so on.

libGDX provides a [GestureDetector](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/input/GestureDetector.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/input/GestureDetector.java) that lets you detect the following gestures:

  * **touchDown**: A user touches the screen.
  * **longPress**: A user touches the screen for some time.
  * **tap**: A user touches the screen and lifts the finger again. The finger must not move outside a specified square area around the initial touch position for a tap to be registered. Multiple consecutive taps will be detected if the user performs taps within a specified time interval.
  * **pan**: A user drags a finger across the screen. The detector will report the current touch coordinates as well as the delta between the current and previous touch positions. Useful to implement camera panning in 2D.
  * **panStop**: Called when no longer panning.
  * **fling**: A user dragged the finger across the screen, then lifted it. Useful to implement swipe gestures.
  * **zoom**: A user places two fingers on the screen and moves them together/apart. The detector will report both the initial and current distance between fingers in pixels. Useful to implement camera zooming.
  * **pinch**: Similar to zoom. The detector will report the initial and current finger positions instead of the distance. Useful to implement camera zooming and more sophisticated gestures such as rotation.

A `GestureDetector` is an [event handler](/wiki/input/event-handling) in disguise. To listen for gestures, one has to implement the [GestureListener](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/input/GestureDetector.GestureListener.html) interface and pass it to the constructor of the `GestureDetector`. The detector is then set as an InputProcessor, either on an InputMultiplexer or as the main InputProcessor:

```java
public class MyGestureListener implements GestureListener{

   	@Override
   	public boolean touchDown(float x, float y, int pointer, int button) {
		   	
	   	return false;
   	}
	   	
	@Override
	public boolean tap(float x, float y, int count, int button) {
			
		return false;
	}
		
	@Override
	public boolean longPress(float x, float y) {
			
		return false;
	}
		
	@Override
	public boolean fling(float velocityX, float velocityY, int button) {
			
		return false;
	}
		
	@Override
	public boolean pan(float x, float y, float deltaX, float deltaY) {
			
		return false;
	}
		
	@Override
	public boolean panStop(float x, float y, int pointer, int button) {
			
		return false;
	}
		
   	@Override
   	public boolean zoom (float originalDistance, float currentDistance){
	   		
	   return false;
   	}

   	@Override
   	public boolean pinch (Vector2 initialFirstPointer, Vector2 initialSecondPointer, Vector2 firstPointer, Vector2 secondPointer){
	   		
	   return false;
   	}
   	@Override
	public void pinchStop () {
	}
}
```

```java
Gdx.input.setInputProcessor(new GestureDetector(new MyGestureListener()));
```

The `GestureListener` can signal whether it consumed the event or wants it to be passed on to the next InputProcessor by returning either true or false respectively from its methods.

As with the events reported to a normal `InputProcessor`, the respective methods will be called right before the call to `ApplicationListener.render()` on the rendering thread.

The `GestureDetector` also has a second constructor that allows it to specify various parameters for gesture detection. Please refer to the [Javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/input/GestureDetector.html#GestureDetector(float,%20float,%20float,%20float,%20com.badlogic.gdx.input.GestureDetector.GestureListener)) for more information.

[Prev](/wiki/input/controllers) | [Next](/wiki/input/simple-text-input)