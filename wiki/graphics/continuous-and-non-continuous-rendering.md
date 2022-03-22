---
title: Continuous and Non Continuous Rendering
---
By default in libGDX, the rendering thread calls the `render()` method of your ApplicationListener class continuously, with a frequency that depends on your hardware (30-50-80 times per second).

If you have many still frames in your game (think about a card game) you can save precious battery power by disabling the continuous rendering, and calling it only when you really need it.

All you need is put the following lines in your ApplicationListener's create() method

```java
Gdx.graphics.setContinuousRendering(false);
Gdx.graphics.requestRendering();
```

The first line tells the game to stop calling the render() method automatically. The second line triggers the render() method once. You have to use the second line wherever you want the render() method to be called.

If continuous rendering is set to false, the render() method will be called only when the following things happen.

  * An input event is triggered
  * Gdx.graphics.requestRendering() is called
  * Gdx.app.postRunnable() is called

**UI Actions**: Many Actions, such as the default fade-in and fade-out of dialogs, have a duration in which they need rendering to occur, so they will call `Gdx.graphics.requestRendering()` on your behalf. This is enabled by default. To disable it, you can call:

```java
Stage.setActionsRequestRendering(false);
```
----

Good article about this topic: [https://bitiotic.com/blog/2012/10/01/enabling-non-continuous-rendering-in-libgdx/](https://bitiotic.com/blog/2012/10/01/enabling-non-continuous-rendering-in-libgdx/)

Official libGDX blog post: [https://web.archive.org/web/20201028180041/https://www.badlogicgames.com/wordpress/?p=2289](https://web.archive.org/web/20201028180041/https://www.badlogicgames.com/wordpress/?p=2289)
