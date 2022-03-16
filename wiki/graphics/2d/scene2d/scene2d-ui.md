---
title: Scene2d.ui
---
## Overview ##

scene2d is libGDX's 2D scene graph. At its core, it provides basic 2D scene graph functionality: actors, groups, drawing, events, and actions. This is a lot of utility that applications can leverage, but it is reasonably low level. For games this is fine because most actors are application specific. For building UIs, the scene2d.ui package provides common UI widgets and other classes built on top of scene2d.

It is highly recommended to read or least skim the [scene2d documentation](/wiki/graphics/2d/scene2d/scene2d) before continuing.

Check out [libGDX.info](https://libgdxinfo.wordpress.com/) for examples showcasing Scene2d actors, scenes, Stages Images etc..

 * [Widget and WidgetGroup](#widget-and-widgetgroup)
 * [Layout](#layout)
 * [Stage setup](#stage-setup)
 * [Skin](#skin)
 * [Drawable](#drawable)
 * [ChangeEvents](#changeevents)
 * [Clipping](#clipping)
 * [Rotation and scale](#rotation-and-scale)
 * [Layout widgets](#layout-widgets)
   * [Table](#table)
   * [Container](#container)
   * [Stack](#stack)
   * [ScrollPane](#scrollpane)
   * [SplitPane](#splitpane)
   * [Tree](#tree)
   * [VerticalGroup](#verticalgroup)
   * [HorizontalGroup](#horizontalgroup)
 * [Widgets](#widgets)
   * [Label](#label)
   * [Image](#image)
   * [Button](#button)
   * [TextButton](#textbutton)
   * [ImageButton](#imagebutton)
   * [CheckBox](#checkbox)
   * [ButtonGroup](#buttongroup)
   * [TextField](#textfield)
   * [TextArea](#textarea)
   * [List](#list)
   * [SelectBox](#selectbox)
   * [ProgressBar](#progressbar)
   * [Slider](#slider)
   * [Window](#window)
   * [Touchpad](#touchpad)
   * [Dialog](#dialog)
 * [Widgets without scene2d.ui](#widgets-without-scene2dui)
 * [Drag and Drop](#drag-and-drop-draganddrop-class)
 * [Usage without touch or mouse](#Keycontrol)
 * [Examples](#examples)

# <a id="Widget_and_WidgetGroup"></a>Widget and WidgetGroup #

UIs often have many UI widgets to be sized and positioned on the screen. Doing this manually is time consuming, makes code difficult to read and maintain, and doesn't easily adapt to different screen sizes. The Layout interface defines methods that allow for more intelligent layout for actors.

The Widget and WidgetGroup classes extend Actor and Group respectively, and they both implement Layout. These two classes are the basis for actors that will participate in layout. UI widgets should extend WidgetGroup if they have child actors, otherwise they should extend Widget.

## <a id="Layout"></a>Layout ##

UI widgets do not set their own size and position. Instead, the parent widget sets the size and position of each child. Widgets provide a minimum, preferred, and maximum size that the parent can use as hints. Some parent widgets, such as Table and Container, can be given constraints on how to size and position the children. To give a widget a specific size in a layout, the widget's minimum, preferred, and maximum size are left alone and size constraints are set in the parent.

Before each widget is drawn, it first calls `validate`. If the widget's layout is invalid, its `layout` method will be called so that the widget (and any child widgets) can cache information needed for drawing at their current size. The `invalidate` and `invalidateHierarchy` methods both invalidate the layout for a widget.

`invalidate` should be called when the widget's state has changed and the cached layout information needs to be recalculated, but the widget's minimum, preferred, and maximum size are unaffected. This means that the widget needs to be laid out again, but the widget's desired size hasn't changed so the parent is unaffected.

`invalidateHierarchy` should be called when the widget's state has changed that affects the widget's minimum, preferred, or maximum size. This means that the parent's layout may be affected by the widget's new desired size. `invalidateHierarchy` calls `invalidate` on the widget and every parent up to the root.

## <a id="Stage_setup"></a>Stage setup ##

Most scene2d.ui layouts will use a [table](/wiki/graphics/2d/scene2d/table) that is the size of the stage. All other widgets and nested tables are placed in this table.

Here is an example of the most basic scene2d.ui application with a root table:

```java
private Stage stage;
private Table table;

public void create () {
	stage = new Stage();
	Gdx.input.setInputProcessor(stage);

	table = new Table();
	table.setFillParent(true);
	stage.addActor(table);

	table.setDebug(true); // This is optional, but enables debug lines for tables.

	// Add widgets to the table here.
}

public void resize (int width, int height) {
	stage.getViewport().update(width, height, true);
}

public void render () {
	Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
	stage.act(Gdx.graphics.getDeltaTime());
	stage.draw();
}

public void dispose() {
	stage.dispose();
}
```

Note that `setFillParent` is used on the root table, causing it to be sized to its parent (in this case, the stage) when validated. Normally a widget's size is set by its parent and `setFillParent` must not be used. `setFillParent` is for convenience only when the widget's parent does not set the size of its children (such as the stage).

Tables automatically adapt to various screen resolutions, so this sets up a stage that uses pixel coordinates. See [stage viewport setup](/wiki/graphics/2d/scene2d/scene2d#viewport) for setting up a stage that scales.

## <a id="Skin"></a>Skin ##

Most UI widgets are made up of a few configurable resources: images, fonts, colors, etc. All the resources needed to render a widget is called a "style". Each widget defines its own style class (usually a static member class) and has constructors for setting the initial style and a `setStyle` method for changing the style later.

Skin files from the [libGDX tests](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests-android/assets/data) can be used as a starting point. You will need: uiskin.png, uiskin.atlas, uiskin.json, and default.fnt. This enables you to quickly get started using scene2d.ui and replace the skin assets later.

Styles can be configured using JSON or with code:

```java
TextureRegion upRegion = ...
TextureRegion downRegion = ...
BitmapFont buttonFont = ...

TextButtonStyle style = new TextButtonStyle();
style.up = new TextureRegionDrawable(upRegion);
style.down = new TextureRegionDrawable(downRegion);
style.font = buttonFont;

TextButton button1 = new TextButton("Button 1", style);
table.add(button1);

TextButton button2 = new TextButton("Button 2", style);
table.add(button2);
```

Note the same style can be used for multiple widgets. Also note that all images needed by UI widgets are actually implementations of the Drawable interface.

The Skin class can be used to more conveniently define the styles and other resources for UI widgets. See the [Skin documentation](/wiki/graphics/2d/scene2d/skin) for more information. It is very strongly recommended to use Skin for convenience, even if not defining styles via JSON.

## <a id="Drawable"></a>Drawable ##

The Drawable interface provides a draw method that takes a SpriteBatch, position, and size. The implementation can draw anything it wants: texture regions, sprites, animations, etc. Drawables are used extensively for all images that make up widgets. Implementations are provided to draw texture regions, sprites, nine patches, and to tile a texture region. Custom implementations can draw anything they like.

Drawable provides a minimum size, which can be used as a hint for the smallest it should be drawn. It also provides top, right, bottom, and left sizes, which can be used as a hint for how much padding should be around content drawn on top of the drawable.

By default, NinePatchDrawable uses the top, right, bottom, and left sizes of the corresponding nine patch texture regions. However, the drawable sizes are separate from the nine patch sizes. The drawable sizes can be changed to draw content on the nine patch with more or less padding than the actual nine patch regions.

Creating drawables is very common and somewhat tedious. It is recommended to use the [skin methods](/wiki/graphics/2d/scene2d/skin#wiki-Conversions) to automatically obtain a drawable of the appropriate type.

### <a id="ChangeEvents"></a>ChangeEvents ###

Most widgets fire a ChangeEvent when something changes. This is a generic event, what actually changed depends on each widget. Eg, for a button the change is that the button was pressed, for a slider the change is the slider position, etc.

ChangeListener should be used to detect these events:

```java
actor.addListener(new ChangeListener() {
	public void changed (ChangeEvent event, Actor actor) {
		System.out.println("Changed!");
	}
});
```

ChangeListener should be used when possible instead of ClickListener, eg on buttons. ClickListener reacts to input events on the widget and only knows if the widget has been clicked. The click will still be detected if the widget is disabled and doesn't handle the widget being changed by a key press or programmatically. Also, for most widgets the ChangeEvent can be cancelled, allowing the widget to revert the change.

### <a id="Clipping"></a>Clipping ###

Clipping is most easily done using `setClip(true)` on a Table. Actors in the table will be clipped to the table's bounds. Culling is done so actors completely outside of the table's bounds are not drawn at all.

Actors added to a table using the `add` Table methods get a table cell and will be sized and positioned by the table. Like any group, actors can still be added to a table using the `addActor` method. The table will not size and position actors added this way. This can be useful when using a table solely for clipping.

## <a id="Rotation_and_scale"></a>Rotation and scale ##

As [described previously](/wiki/graphics/2d/scene2d/scene2d#wiki-group-transform), a scene2d group that has transform enabled causes a SpriteBatch flush before drawing its children. A UI often has dozens, if not hundreds, of groups. Flushing for each group would severely limit performance, so most scene2d.ui groups have transform set to false by default. Rotation and scale is ignored when the group's transform is disabled.

Transforms can be enabled as needed, with some caveats. Not all widgets support all features when rotation or scaling is applied. Eg, transform can be enabled for a Table and then it can be rotated and scaled. Children will be drawn rotated and scaled, input is routed correctly, etc. However, other widgets may perform drawing without taking rotation and/or scale into account. A workaround for this problem is to wrap a widget in a table or container with transform enabled and set the rotation and scale on the table or container, not on the widget:

```java
TextButton button = new TextButton("Text Button", skin);
Container wrapper = new Container(button);
wrapper.setTransform(true);
wrapper.setOrigin(wrapper.getPrefWidth() / 2, wrapper.getPrefHeight() / 2);
wrapper.setRotation(45);
wrapper.setScaleX(1.5f);
```

Note that scene2d.ui groups that perform layout, such as Table, will use the unscaled and unrotated bounds of a transformed widget when computing the layout.

Widgets that perform clipping, such as ScrollPane, use `glScissor` which uses a screen aligned rectangle. These widgets cannot be rotated.

If excessive batch flushes are occurring due to transform being enabled on many groups, `CpuSpriteBatch` can be used for the stage. This does transformations using the CPU to avoid flushing the batch.

## <a id="Layout_Widgets"></a>Layout widgets ##

### <a id="Table"></a>Table ###

[The Table class](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Table.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Table.java)) sizes and positions its children using a logical table, similar to HTML tables. Tables are intended to be used extensively in scene2d.ui to layout widgets, as they are easy to use and much more powerful than manually sizing and positioning widgets. Table-based layouts don't rely on absolute positioning and therefore automatically adjust to different widget sizes and screen resolutions.

It is highly recommended to read the [Table documentation](/wiki/graphics/2d/scene2d/table) before building a UI using scene2d.ui.

### <a id="Container"></a>Container ###

[The Container class](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Container.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Container.java)) is equivalent to a Table with only a single child, but is more lightweight. Container has all of the constraints of a table cell and is useful for setting the size and alignment of a single widget.  If you implement with Scene2D, Container presents to you a much better personal development experience if you encounter trouble adjusting values for alignments and sizes for whatever an object holds and supports.  While the advantages of this class generally work best within a Table object, you may still find a benefit in certain scenarios even outside of such code.

### <a id="Stack"></a>Stack ###

[Stack](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Stack.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Stack.java)) is a WidgetGroup that lays out each child to be the size of the stack. This is useful when it is necessary to have widgets stacked on top of each other. The first widget added to the stack is drawn on the bottom, and the last widget added is drawn on the top.

### <a id="ScrollPane"></a>ScrollPane ###

[ScrollPane](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/ScrollPane.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/ScrollPane.java)) scrolls a child widget using scrollbars and/or mouse or touch dragging. Scrolling is automatically enabled when the widget is larger than the scroll pane. If the widget is smaller than the scroll pane in one direction, it is sized to the scroll pane in that direction. ScrollPane has many settings for if and how touches control scrolling, fading scrollbars, etc. ScrollPane has drawables for the background, horizontal scrollbar and knob, and vertical scrollbar and knob. If touches are enabled (the default), all the drawables are optional.

Note: ScrollPane doesn't support well children that dynamically change their size or move while dragging them. Having a children in your scrollpane that move while being dragged will make the ScrollPane flicker.

### <a id="SplitPane"></a>SplitPane ###

[SplitPane](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/SplitPane.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/SplitPane.java)) contains two widgets and is divided in two either horizontally or vertically. The user may resize the widgets with a draggable splitter. The child widgets are always sized to fill their half of the splitpane. SplitPane has a drawable for the draggable splitter.

### <a id="Tree"></a>Tree ###

[Tree](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Tree.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Tree.java)) displays a hierarchy of nodes. Each node may have child nodes and can be expanded or collapsed. Each node has an actor, allowing complete flexibility over how each item is displayed. Tree has drawables for the plus and minus icons next to each node's actor.

### <a id="VerticalGroup"></a>VerticalGroup ###

A [VerticalGroup](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/VerticalGroup.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/VerticalGroup.java)) is equivalent to a Table with only a single column, but is more lightweight. VerticalGroup allows widgets to be inserted in the middle and removed, while Table does not.

### <a id="HorizontalGroup"></a>HorizontalGroup ###

A [HorizontalGroup](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/HorizontalGroup.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/HorizontalGroup.java)) is equivalent to a Table with only a single row, but is more lightweight. HorizontalGroup allows widgets to be inserted in the middle and removed, while Table does not.

## <a id="Widgets"></a>Widgets ##

### <a id="Label"></a>Label ###

[Label](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Label.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Label.java)) displays text using a bitmap font and a color. The text may contain newlines. Word wrap may be enabled, in which case the width of the label should be set by the parent. The lines of text can be aligned relative to each other, and also all of the text aligned within the label widget.

The labels that use the same font will be the same size, though they may have different colors. Bitmap fonts don't typical scale well, especially at small sizes. It is suggested to use a separate bitmap font for each font size. The bitmap font image should be packed into the skin's atlas to reduce texture binds.

To create a label which contain text with different colors, the [BitmapFont](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g2d/BitmapFont.html) used to create the label should have markup enabled by setting it in the [BitmapFont.BitmapFontData](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g2d/BitmapFont.BitmapFontData.html) object passed via the constructor. If you're using the [AssetManager](/wiki/managing-your-assets), you can pass this data by passing an appropriate [BitmapFontParameter](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/assets/loaders/BitmapFontLoader.BitmapFontParameter.html) object when you call [load](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/assets/AssetManager.html#load-java.lang.String-java.lang.Class-com.badlogic.gdx.assets.AssetLoaderParameters-).

### <a id="Image"></a>Image ###

[Image](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Image.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Image.java)) simply displays a drawable. The drawable can be a texture, texture region, ninepatch, sprite, etc. The drawable may be scaled and aligned within the image widget bounds in various ways.

For a tutorial on using Image (Create, rotate, resize and creating images with repeating texture [see this Image tutorial](https://libgdxinfo.wordpress.com/basic_image/))

### <a id="Button"></a>Button ###

[Button](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Button.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Button.java)) by itself it is just an empty button, but it extends table so other widgets can be added to it. It has an `up` background that is normally displayed, and a `down` background that is displayed when pressed. It has a checked state which is toggled each time it is clicked, and when checked it will use the `checked` background instead of `up`, if defined. It also has pressed/unpressed offsets, which offset the entire button contents when pressed/unpressed.

### <a id="TextButton"></a>TextButton ###

[TextButton](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/TextButton.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/TextButton.java)) extends Button and contains a label. TextButton adds to Button a bitmap font and a colors for the text in the up, down, and checked states.

TextButton extends Button which extends Table, so widgets can be added to the TextButton using the Table methods.

### <a id="ImageButton"></a>ImageButton ###

[ImageButton](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/ImageButton.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/ImageButton.java)) extends Button and contains an image widget. ImageButton adds to Button a drawables for the image widget in the up, down, and checked states.

Note that ImageButton extends Button, which already has a background drawable for the up, down, and checked states. ImageButton is only needed when it is desired to have a drawable (such as an icon) on top of the button background.

ImageButton extends Button which extends Table, so widgets can be added to the ImageButton using the Table methods.

### <a id="CheckBox"></a>CheckBox ###

[CheckBox](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/CheckBox.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/CheckBox.java)) extends TextButton and adds an image widget to the left of the label. It has a drawable for the image widget for the checked and unchecked states.

### <a id="ButtonGroup"></a>ButtonGroup ###

[ButtonGroup](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/ButtonGroup.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/ButtonGroup.java)) is not an actor and has no visuals. Buttons are added to it and it enforces a minimum and maximum number of checked buttons. This allows for buttons (button, text button, checkbox, etc) to be used as "radio" buttons.

### <a id="TextField"></a>TextField ###

[TextField](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/TextField.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/TextField.java)) is a single line text entry field. It has drawables for the background, text cursor, and text selection, a font and font color for the entered text, and a font and font color for the message displayed when the text field is empty. Password mode can be enabled, where it will display asterisks instead of the entered text.

### <a id="TextArea"></a>TextArea ###

[TextArea](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/TextArea.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/TextArea.java)) is similiar to a TextField, but allows multiple line text entry.

### <a id="List"></a>List ###

[List](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/List.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/List.java)) is a list box that displays textual items and highlights the selected item. List has a font, selected item background drawable, and a font color for selected and unselected items. A list does not scroll on its own, but is often put in a scrollpane.

### <a id="SelectBox"></a>SelectBox ###

[SelectBox](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/SelectBox.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/SelectBox.java)) is a drop-down list, it allows one of a number of values to be chosen from a list. When inactive, the selected value is displayed. When activated, it shows the list of values that may be selected. SelectBox has drawables for the background, list background, and selected item background, a font and font color, and a setting for how much spacing is used between items.

### <a id="ProgressBar"></a>ProgressBar ###

[ProgressBar](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/ProgressBar.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/ProgressBar.java)) is a widget that visually displays the progress of some activity or a variable value within a given range. The progress bar has a range (min, max) and a stepping between each value it represents. The percentage of completeness typically starts out as an empty progress bar and gradually becomes filled in as the task or value increases towards upper limit.

A progress bar can be setup to be of horizontal or vertical orientation, although the increment direction is always the same. For horizontal progress bar, is grows to the right, for vertical, upwards. Animation for changes to the progress bar value can be enabled to make the bar fill more smoothly over time.

### <a id="Slider"></a>Slider ###

[Slider](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Slider.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Slider.java)) is a horizontal indicator that allows a user to set a value. The slider has a range (min, max) and a stepping between each value the slider represents. Slider has drawables for the background, the slider knob, and for the portion of the slider before and after the knob.

A slider with touches disabled, a drawable before the knob, and without the knob can be used as a substitute for progress bar, as both widgets share the same codebase and use same visual style. Animation for changes to the slider value can be enabled to make the progress bar fill more smoothly.


### <a id="Window"></a>Window ###

[Window](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Window.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Window.java)) is a table with a title bar area above the contents that displays a title. It can optionally act as a modal dialog, preventing touch events to widgets below. Window has a background drawable and a font and font color for the title.

### <a id="Touchpad"></a>Touchpad ###

[Touchpad](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Touchpad.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Touchpad.java)) is an onscreen joystick that moves in a circular area. It has a background drawable and a drawable for the knob that the user drags around. If you want to implement a "follow mode" for your joystick element, check out the example [here](https://github.com/libgdx/libgdx/issues/6688#issuecomment-962640273).

### <a id="Dialog"></a>Dialog ###

[Dialog](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/ui/Dialog.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/scenes/scene2d/ui/Dialog.java)) is a window with a content table and a button table underneath. Anything can be added to the dialog, but convenience methods are provided to add a label to the content table and buttons to the button table.

## <a id="Widgets_without_scene2d.ui"></a>Widgets without scene2d.ui ##

Widgets can be used as simple actors in scene2d, without using tables or the rest of scene2d.ui. Widgets have a default size and can be positioned absolutely, the same as any actor. If a widget's size is changed, the `invalidate` Widget method must be called so the widget will relayout at the new size.

Some widgets, such as Table, don't have a default size after construction because their preferred size is based on the widgets they will contain. After the widgets have been added, the `pack` method can be used to set the width and height of the widget to its preferred width and height. This method also calls `invalidate` if the widget's size was changed, and then calls `validate` so that the widget adjusts itself to the new size.

## <a id="DragAndDrop"></a>Drag and Drop (DragAndDrop class) ##
It should be noted that to make a drag start/source actor, a table and to have that table and all of its contents trigger a drag, one must enable Table.setTouchable(Enabled). It is set to ChildrenOnly by default.

## <a id="Keycontrol"></a>Usage without touch or mouse ##

Scene2d.ui is mainly designed with touch or mouse control in mind. Stage has a `setKeyboardFocus` and a `setScrollFocus` methods to set the Actor receiving scroll and key events. However, it does not support a full type focus and is therefore not operable with keys only.
A focusing system is needed for games designed with controller-only or keyboard-only interface. [gdx-controllerutils project](https://github.com/MrStahlfelge/gdx-controllerutils)'s scene2d module includes a `ControllerMenuStage` adding this to scene2d.ui. [View the documentation](https://github.com/MrStahlfelge/gdx-controllerutils/wiki/Button-operable-Scene2d).

## <a id="Examples"></a>Examples ##

For now, please see these test programs:

 * [UISimpleTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/UISimpleTest.java#L37)
 * [TableLayoutTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/TableLayoutTest.java#L35)
 * [UITest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/UITest.java#L50)
 * [ImageTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ImageTest.java#L30)
 * [LabelTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/LabelTest.java#L34)
 * [ScrollPaneTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ScrollPaneTest.java#L36)
