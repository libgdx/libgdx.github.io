---
title: Cursor Visibility and Catching
---
For some games like first person shooters, it is often necessary to catch the cursor so it stays in the center of the screen, and only use position deltas to rotate the camera. Other times we might want to position the cursor manually. Both things can be done as follows:

```java
Gdx.input.setCursorCatched(true);
Gdx.input.setCursorPosition(x, y);
```

Note that catching the cursor only works reliably in the LWJGL/LWJGL3 back-ends.

Cursor catching and positioning is only available on the desktop.

Similarly, changing the cursor image is available on the desktop and on gwt if the browser supports the "cursor:url()" syntax and also supports the png format as cursor.
It can be done as follows:

Note: **You Should dispose the cursor if you don't need it anymore**
```java
Cursor customCursor = Gdx.graphics.newCursor(new Pixmap(Gdx.files.internal("cursor.png")), hotspotX, hotspotY);
Gdx.graphics.setCursor(customCursor);
```

You can also change the cursor to a system cursor, this only works in the LWJGL3 backend and in the GWT backend.
It can be done as follows:
```java
Gdx.graphics.setSystemCursor(SystemCursor.Crosshair);
```

Supported system cursors are the 
* `Arrow` ![Image of an arrow cursor](https://developer.mozilla.org/@api/deki/files/3438/=default.gif)
* `Ibeam` ![Image of an i-beam cursor](https://developer.mozilla.org/files/3809/text.gif)
* `Crosshair` ![Image of a crosshair cursor](https://developer.mozilla.org/@api/deki/files/3437/=crosshair.gif)
* `Hand` ![Image of a pointer cursor](https://developer.mozilla.org/@api/deki/files/3449/=pointer.gif)
* `HorizontalResize` ![Image of a horizontal-resize cursor](https://developer.mozilla.org/files/3806/3-resize.gif)
* `VerticalResize` ![Image of a vertical-resize cursor](https://developer.mozilla.org/files/3808/6-resize.gif)

cursors.

[Prev](/wiki/input/vibrator) | [Next](/wiki/input/back-and-menu-key-catching)