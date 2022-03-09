---
title: Viewports
---
When dealing with different screens it is often necessary to decide for a certain strategy how those different screen sizes and aspect ratios should be handled. libGDX's [`Viewport`s](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/Viewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/Viewport.java)) are the solution to deal with this. Camera and Stage support different viewport strategies, for example when doing picking via `Camera.project(vec, viewportX, viewportY, viewportWidth, viewportHeight)`.

If you have never worked with viewports before, **be sure to check out this comprehensive introduction:**

{% include video id="8N2vw_3h9HU" provider="youtube" %}

There is also a transcript of this video available [here](https://github.com/raeleus/viewports-sample-project#libgdx-viewports). If you are having trouble picking the right viewport for your situation, the **interactive examples** [here](https://raeleus.github.io/viewports-sample-project/) and [here](https://crykn.github.io/viewports-showcase/) will most certainly prove useful.

### Usage ###
A viewport always manages a Camera's viewportWidth and viewportHeight. Thus a camera needs to be supplied to the constructors.
```java
    private Viewport viewport;
    private Camera camera;

    public void create() {
        camera = new PerspectiveCamera();
        viewport = new FitViewport(800, 480, camera);
    }
```
Whenever a resize event occurs, the viewport needs to be informed about it and updated. This will automatically recalculate the viewport parameters and update the camera:
```java
    public void resize(int width, int height) {
        viewport.update(width, height);
    }
```
Furthermore it will change the OpenGL Viewport via glViewport, which may add black bars if necessary, making it impossible to render in the area of the black bars. In case black bars appear with a certain viewport strategy, the OpenGL viewport may be reset to its standard size and the viewport can be queried for the size of the bars via `Viewport.getLeftGutterWidth()` etc. For an example of how to do so, see [this test](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ViewportTest2.java). This might look like the following (probably with a more appropriate border picture...)

![images/OVamVTh.png](/assets/wiki/images/OVamVTh.png)

In case picking needs to be done, Viewport offers convenient `project/unproject/getPickRay` methods, which uses the current viewport to do the correct picking. This is how you convert to and from screen and world coordinates.

When Stage is used, the Stage's viewport needs to be updated when a resize event happens.
```java
    private Stage stage;

    public void create() {
        stage = new Stage(new StretchViewport(width, height));
    }

    public void resize(int width, int height) {
        // use true here to center the camera
        // that's what you probably want in case of a UI
        stage.getViewport().update(width, height, true);
    }
```
### Multiple viewports

When using multiple viewports that have different screen sizes (or you use other code that sets `glViewport`), you will need to apply the viewport before drawing so the `glViewport` is set for that viewport.
```java
    viewport1.apply();
    // draw
    viewport2.apply();
    // draw
```
When using multiple Stages:
```java
    stage1.getViewport().apply();
    stage1.draw();
    stage2.getViewport().apply();
    stage2.draw();
```

### Examples

**To see the viewports in action, have a look at the interactive examples [here](https://raeleus.github.io/viewports-sample-project/) and [here](https://crykn.github.io/viewports-showcase/)**. There are also some tests concerning viewports: [ViewportTest1](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ViewportTest1.java), [ViewportTest2](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ViewportTest2.java) and [ViewportTest3](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ViewportTest3.java).

### StretchViewport ###
The [`StretchViewport`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/StretchViewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/StretchViewport.java))  supports working with a virtual screen size. That means one can assume that a screen is always of the size `virtualWidth x virtualHeight`. This virtual viewport will then always be stretched to fit the screen. There are no black bars, but the aspect ratio may not be the same after the scaling took place.

![images/oheUy0y.png](/assets/wiki/images/oheUy0y.png)

### FitViewport ###
A [`FitViewport`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/FitViewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/FitViewport.java)) also supports a virtual screen size. The difference to StretchViewport is that it will always maintain the aspect ratio of the virtual screen size (virtual viewport), while scaling it as much as possible to fit the screen. One disadvantage with this strategy is that there may appear black bars.

![images/Kv2wB94.png](/assets/wiki/images/Kv2wB94.png)

### FillViewport ###
A [`FillViewport`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/FillViewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/FillViewport.java)) also keeps the aspect ratio of the virtual screen size, but in contrast to FitViewport, it will always fill the whole screen which might result in parts of the viewport being cut off.

### ScreenViewport ###
The [`ScreenViewport`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/ScreenViewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/ScreenViewport.java)) does not have a constant virtual screen size; it will always match the window size which means that no scaling happens and no black bars appear. As a disadvantage this means that the gameplay might change, because a player with a bigger screen might see more of the game, than a player with a smaller screen size.

![images/qtOytdq.png](/assets/wiki/images/qtOytdq.png)

### ExtendViewport ###
The [`ExtendViewport`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/viewport/ExtendViewport.html) ([source](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/viewport/ExtendViewport.java)) keeps the world aspect ratio without black bars by extending the world in one direction. The world is first scaled to fit within the viewport, then the shorter dimension is lengthened to fill the viewport.

![images/HX6QS8r.png](/assets/wiki/images/HX6QS8r.png)

A maximum set of dimensions can be supplied to `ExtendViewport`, in which case, black bars will be added when the aspect ratio falls out of the supported range.

![images/vQeRKPY.png](/assets/wiki/images/vQeRKPY.png)

### CustomViewport ###
Different strategies may be implemented by doing `CustomViewport extends Viewport` and overriding `update(width, height, centerCamera)`. Another approach is use the generic `ScalingViewport` and supplying another Scaling which is not yet covered by any other Viewport. One example could be to supply `Scaling.none` to it, which will result in a completely "StaticViewport", which always keeps the same size. It might look like this:

![images/8F697TX.png](/assets/wiki/images/8F697TX.png)
