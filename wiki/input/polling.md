---
title: Polling
---
Polling refers to checking the current state of an input device, e.g. is a specific key pressed, where is the first finger on the screen and so on. It's a quick and easy way to process user input and will suffice for most arcade games.

*Caution:* If you rely on polling, you might miss events, e.g. a fast paced key down/key up. If you need to make sure a specific sequence of input action was completed, use [event handling](/wiki/input/event-handling) instead.

## Polling the Keyboard

Polling for input from a Keyboard is done with just one simple line of code, like below.

```java
boolean isAPressed = Gdx.input.isKeyPressed(Keys.A);
```

The parameter passed to that method is a Key Code. Rather than having to memorize these codes there is a static class within the `Input` interface that contains the codes which you can use. They can be seen  [here](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Input.Keys.html).

## Polling the Touch Screen / Mouse

There are a number of methods concerning polling the touch screen/mouse. To check whether one or more fingers are currently on the screen (which is equivalent to a mouse button being pressed) you can do the following:

```java
boolean isTouched = Gdx.input.isTouched();
```

For multi-touch input you might be interested whether a specific finger (pointer) is currently on the screen:

```java
// Will Return whether the screen is currently touched
boolean firstFingerTouching = Gdx.input.isTouched(0);
boolean secondFingerTouching = Gdx.input.isTouched(1);
boolean thirdFingerTouching = Gdx.input.isTouched(2);
```

Each finger that goes down on the screen gets a so called pointer index. The first finger to go down gets the index 0, the next one gets the index 1 and so on. If a finger is lifted off the screen and touched down again, while other fingers are still on the screen, the finger will get the first free index. An example:


1. first finger goes down -> 0
2. second finger goes down -> 1
3. third finger goes down -> 2
4. second finger goes up -> 1 becomes free
5. first finger goes up -> 0 becomes free, at this point only 2 is used
6. another finger goes down -> 0, as it is the first free index


On the desktop or the browser you will only ever have a single "finger" so to speak.


If you want to check if the user touched down and released any finger again you can use the following method:

```java
// Will return whether the screen has just been touched
boolean justTouched = Gdx.input.justTouched();
```

This can be used in situations where you want to check a touch down/up sequence really quickly, e.g. on a screen that says "touch screen to continue". Note that it is not a reliable method as it is based on polling.

To get the coordinates of a specific finger you can use the following methods:

```java
int firstX = Gdx.input.getX();
int firstY = Gdx.input.getY();
int secondX = Gdx.input.getX(1);
int secondY = Gdx.input.getY(1);
```

Here we get the touch coordinates at pointer index 0 (0 is default) and pointer index 1. Coordinates are reported in a coordinate system relative to the screen. The origin (0, 0) is in the upper left corner of the screen, the x-axis points to the right, the y-axis points *downwards*.


### Pressure

You can get the Pressure applied on a pointer using

`Gdx.input.getPressure()`

This returns a value between 0 and 1

## Mouse Buttons
On the desktop you can also check which mouse buttons are currently pressed:

```java
boolean leftPressed = Gdx.input.isButtonPressed(Input.Buttons.LEFT);
boolean rightPressed = Gdx.input.isButtonPressed(Input.Buttons.RIGHT);
```

See the [Buttons](https://libgdx.badlogicgames.com/ci/nightlies/docs/api/com/badlogic/gdx/Input.Buttons.html) class for more constants.

Note that on Android we only emulate the left mouse button. Any touch event will be interpreted as if it was issued with a left mouse button press. Touch screens obviously don't have a notion of left, right and middle button.

[Prev](/wiki/input/mouse-touch-and-keyboard) | [Next](/wiki/input/event-handling)
