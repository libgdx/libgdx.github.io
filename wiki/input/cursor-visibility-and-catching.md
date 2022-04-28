---
title: Cursor Visibility and Catching
---
## Cursor catching

For some games like first-person shooters, it is often necessary to catch the cursor so it stays in the center of the screen, and only use position deltas to rotate the camera. Other times we might want to position the cursor manually. Both things can be done as follows:

```java
Gdx.input.setCursorCatched(true);
Gdx.input.setCursorPosition(x, y);
```

Cursor catching is only available on the desktop and GWT backends, and positioning is only available on the desktop backend.

## Custom cursor

Changing the cursor to a custom image can be done like so. The following example turns this 32×32 image into a cursor: <a href="/assets/wiki/images/cursor-visibility-and-catching1.png?nomagnify" download="badcursor">![Example custom cursor image](/assets/wiki/images/cursor-visibility-and-catching1.png)</a>

```java
Pixmap pixmap = new Pixmap(Gdx.files.internal("badcursor.png"));
// Set hotspot to the middle of it (0,0 would be the top-left corner)
int xHotspot = 15, yHotspot = 15;
Cursor cursor = Gdx.graphics.newCursor(pixmap, xHotspot, yHotspot);
pixmap.dispose(); // We don't need the pixmap anymore
Gdx.graphics.setCursor(cursor);
```

**Note:** You should call `dispose()` on your cursor if you don't need it anymore.

Only cursors of power-of-two resolutions are supported. For example, if your cursor is 24×24, you must pad it to 32×32. Remember that your cursor may appear small on HDPI monitors if you don't account for them. Custom cursors are supported only on the desktop and GWT backends.

## System cursors

You can also change the cursor to one of the other system cursors. This only works on the LWJGL3, GWT and Android backends.
It can be done as follows:
```java
Gdx.graphics.setSystemCursor(SystemCursor.Crosshair);
```

### Supported system cursors

Cursor appearance varies depending on operating system and user preferences. The images below are from Ubuntu. Windows and macOS cursors are not displayed out of respect for copyright, but they look similar.

You can hover over each row in the table with your mouse to see what the cursors look like on your own system.

<table>
	<tr>
		<th><code>SystemCursor</code></th>
		<th>Appearance</th>
		<th>Notes</th>
	</tr>
	<tr style="cursor: default">
		<td><code>Arrow</code></td>
		<td><img alt="default cursor" src="/assets/wiki/images/cursor-visibility-and-catching2.png" width="24" height="24"></td>
		<td>The default cursor</td>
	</tr>
	<tr style="cursor: text">
		<td><code>Ibeam</code></td>
		<td><img alt="text cursor" src="/assets/wiki/images/cursor-visibility-and-catching3.png" width="24" height="24"></td>
		<td>Indicates text can be selected</td>
	</tr>
	<tr style="cursor: crosshair">
		<td><code>Crosshair</code></td>
		<td><img alt="crosshair cursor" src="/assets/wiki/images/cursor-visibility-and-catching4.png" width="24" height="24"></td>
		<td>Used for finer precision than the default arrow cursor</td>
	</tr>
	<tr style="cursor: pointer">
		<td><code>Hand</code></td>
		<td><img alt="pointer cursor" src="/assets/wiki/images/cursor-visibility-and-catching5.png" width="24" height="24"></td>
		<td>Indicates hyperlink can be followed</td>
	</tr>
	<tr style="cursor: col-resize">
		<td><code>HorizontalResize</code></td>
		<td><img alt="ew-resize cursor" src="/assets/wiki/images/cursor-visibility-and-catching6.png" width="24" height="24"></td>
		<td>Indicates item can be resized horizontally</td>
	</tr>
	<tr style="cursor: row-resize">
		<td><code>VerticalResize</code></td>
		<td><img alt="ns-resize cursor" src="/assets/wiki/images/cursor-visibility-and-catching7.png" width="24" height="24"></td>
		<td>Indicates item can be resized vertically</td>
	</tr>
	<tr style="cursor: nwse-resize">
		<td><code>NWSEResize</code></td>
		<td><img alt="nwse-resize cursor" src="/assets/wiki/images/cursor-visibility-and-catching8.png" width="24" height="24"></td>
		<td>Indicates item corner can be resized inwards or outwards<br>
		<strong>macOS:</strong> Uses private system API and may fail in future<br>
		<strong>Linux:</strong> Uses newer standard that not all cursor themes support</td>
	</tr>
	<tr style="cursor: nesw-resize">
		<td><code>NESWResize</code></td>
		<td><img alt="nesw-resize cursor" src="/assets/wiki/images/cursor-visibility-and-catching9.png" width="24" height="24"></td>
		<td>Indicates item corner can be resized inwards or outwards<br>
		<strong>macOS:</strong> Uses private system API and may fail in future<br>
		<strong>Linux:</strong> Uses newer standard that not all cursor themes support</td>
	</tr>
	<tr style="cursor: move">
		<td><code>AllResize</code></td>
		<td><img alt="move cursor" src="/assets/wiki/images/cursor-visibility-and-catching10.png" width="24" height="24"></td>
		<td>Indicates the ability to scroll/pan in all directions</td>
	</tr>
	<tr style="cursor: not-allowed">
		<td><code>NotAllowed</code></td>
		<td><img alt="not-allowed cursor" src="/assets/wiki/images/cursor-visibility-and-catching11.png" width="24" height="24"></td>
		<td>Indicates an action is prohibited<br>
		<strong>Linux:</strong> Uses newer standard that not all cursor themes support</td>
	</tr>
	<tr style="cursor: none">
		<td><code>None</code></td>
		<td><div style="width: 24px; height: 24px"></div></td>
		<td>Hides the cursor for when it may be unwanted, such as during video playback</td>
	</tr>
</table>

Note that `NWSEResize` onwards are new in libGDX 1.11.0. They aren't present in earlier versions.

## Additional resources

If you wish to let your HTML5 game use system cursors libGDX doesn't support, this is a good starting point:

* [CSS `cursor` values](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor#values)
* [Interfacing with platform specific code](https://libgdx.com/wiki/app/interfacing-with-platform-specific-code)
* [JSNI](http://www.gwtproject.org/doc/latest/DevGuideCodingBasicsJSNI.html)

[Prev](/wiki/input/vibrator) | [Next](/wiki/input/back-and-menu-key-catching)
