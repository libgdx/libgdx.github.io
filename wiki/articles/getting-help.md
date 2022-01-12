---
title: Getting Help
---
The [libGDX community](https://libgdx.com/community/) is glad to help you when you get stuck or encounter a bug, but we need your help to make it as easy to help you as possible.

## Contents

* [Helping Yourself](#helping-yourself)
* [Help Us Help You](#help-us-help-you)
* [Title](#title)
* [Context](#context)
* [Relevance](#relevance)
* [Problem Statement](#problem-statement)
* [Exceptions](#exceptions)
* [Code Snippets](#code-snippets)
* [Executable Example Code](#executable-example-code)
  * [Example Resources](#example-resources)
  * [Barebones Application](#barebones-application)
  * [Barebones SpriteBatch](#barebones-spritebatch)
  * [Barebones Stage](#barebones-stage)
* [Actually Executable](#actually-executable)
* [Attitude](#attitude)
* [Formatting](#formatting)

## Helping Yourself ##

Please go through this short checklist to be sure you haven't missed an easy to find solution.

  * Are you using the latest [nightly build](http://libgdx.badlogicgames.com/download.html)? Please try that first, as issues are being fixed every single day.
  * Have you read the documentation on the [Table of Contents](/wiki/index)? It can also be very helpful to look at the [Javadocs](http://libgdx.badlogicgames.com/nightlies/docs/api/) and [source code](https://github.com/libgdx/libgdx) (don't be shy!). Search the [tests](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests/src/com/badlogic/gdx/tests) for a specific class to find example code.
  * Have you [searched on our Discord server](https://libgdx.com/community/discord/) for your problem?
  * Have you [searched the issue tracker](https://github.com/libgdx/libgdx/issues?q=is%3Aissue) for your problem? Be sure to search "All issues", not just "Open issues".

**If you still have a problem, the way to get help is the [libGDX Discord](https://libgdx.com/community/discord/). There are a lot of active users, any one of which could answer your question right now.**

Otherwise, if you wish to [post a new issue](https://github.com/libgdx/libgdx/blob/master/CONTRIBUTING.md) on the [tracker](https://github.com/libgdx/libgdx/issues), keep reading.

## Help Us Help You ##
If you believe your issue, error, or suspected bug is related to a specific backend, please present the following information with your issue. If you are on the Discord/IRC have the following information on hand.

**For Android backend issues**
 - **Note:** Android issues can sometimes be more difficult due to device manufactures breaking things or buggy drivers.

- **Note 2:** libGDX only works completely on the Android Runtime (ART) on devices running the Android L developer preview and higher. Some functions will not work on the ART builds in 4.4.x due to an issue in ART that was fixed and included in the L developer preview.

- Please have the device name and Android version in the bug report. Providing things won't be broken, we will make an attempt to fix the issue or implement a workaround for the device.

**For Desktop backend issues (LWJGL 2 & 3)**
 - Please list the operating system and version, architecture, and if necessary OpenGL version.
 - Also mark specifically which of those backends have this issue.

**For iOS (RoboVM) backend issues**
 - Please list the iOS version, and device the issue occurs on

**For GWT (WebGL) backend issues**
 - Please list the operating system and version, and architecture.
 - Please list the browser and browser version
Listing this information can greatly reduce the workload on us and can greatly increase the chances your issue will be resolved or an available fix or workaround implemented.

## Title ##

Write a clear and short title. Titles that do not describe the issue (such as "please help") or contain all caps, exclamation marks, etc. make it much less likely that your issue will be read.

## Context ##

Describe what you are trying to achieve. If it might help your question get answered, also explain the reasons why. If specific solutions are unacceptable, list them and why.

Try to keep the information relevant. If you aren't sure, include the extra information but if your text gets very long, provide an executive summary separate from the rest.

## Problem Statement ##

Concisely describe the problem. Describe each approach you have tried and, for each of those, explain what you expected and what actually happened.

If you fail to do this, likely you will be ignored. No one wants to guess what your problem is and often they don't have the time or patience to ask for the information you should have included from the start.

## Exceptions ##

If an exception occurred, include the _full_ exception message and stack-trace.

Often the first line number just after the deepest (nearest to the bottom) exception message is most relevant. If this line is in your code, along with the full exception message and stack-trace you should include your code for this line and 1-2 surrounding lines.

```
Exception in thread "LWJGL Application" com.badlogic.gdx.utils.GdxRuntimeException: java.lang.NullPointerException
	at com.badlogic.gdx.backends.lwjgl.LwjglApplication$1.run(LwjglApplication.java:111)
Caused by: java.lang.NullPointerException
	at com.badlogic.gdx.scenes.scene2d.ui.Button.setStyle(Button.java:155) <- **MOST IMPORTANT LINE**
	at com.badlogic.gdx.scenes.scene2d.ui.TextButton.setStyle(TextButton.java:55)
	at com.badlogic.gdx.scenes.scene2d.ui.Button.<init>(Button.java:74)
	at com.badlogic.gdx.scenes.scene2d.ui.TextButton.<init>(TextButton.java:34)
	at com.badlogic.gdx.backends.lwjgl.LwjglApplication.mainLoop(LwjglApplication.java:125)
	at com.badlogic.gdx.backends.lwjgl.LwjglApplication$1.run(LwjglApplication.java:108)
```

## Code Snippets ##

Code snippets are most often not very useful. Unless you are blatantly misusing the API, most problems cannot be solved just by looking at a code snippet. Code snippets mostly lead to vague guesses at what might be wrong instead of a real answer to your question. Instead, include **executable example code**.

## Executable Example Code ##

Example code that can be copied, pasted, and run is the best way to get help. It saves those helping you time because they can see the problem right away. They can quickly fix your code or fix the bug, verify the fix, and show you the result. No matter what, an executable example has to be written to properly test, fix, and verify the fix. If you can't debug and fix the problem yourself, you can still help by providing the executable example.

Creating executable example code does take some time. You need to take apart your application and reconstruct the relevant parts in a new, barebones application that shows the problem. Quite often just by doing this you will figure out the problem. If not, you will get help very quickly and the people helping you will have more time to help more people.

Example code should be contained entirely in a single class (use static member classes if needed) and executable, meaning it has a main method and can simply be copied, pasted, and run. Do not use a GdxTest, as that cannot be copy, pasted, and run.

For more about how to make executable example code, please see [SSCCE](http://sscce.org/) and [MCVE](http://stackoverflow.com/help/mcve).

### Example Resources ###

Often executable examples need some resources, such as an image or sound file. It is extra work for those trying to help if they must download your specific resources. Instead, it is ideal to use resources from the [libgdx tests](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests-android/assets). This enables your example code to be simply pasted into the `gdx-tests-lwjgl` project and run.

The easiest way to write an executable example is to paste one of the barebones applications below into the `gdx-tests-lwjgl` project and then modify it to show your problem, using only the [test resources](https://github.com/libgdx/libgdx/tree/master/tests/gdx-tests-android/assets). Note the test resources are pulled in by `gdx-tests-lwjgl` from the `gdx-tests-android` project.

### Barebones Application ###

Below is a simple, barebones, executable application. This can be used as a base for creating your own executable example code.

```java
import com.badlogic.gdx.*;
import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.graphics.GL20;

public class Barebones extends ApplicationAdapter {
	public void create () {
		// your code here
	}

	public void render () {
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		// your code here
	}

	public static void main (String[] args) throws Exception {
		new LwjglApplication(new Barebones());
	}
}
```

### Barebones SpriteBatch ###

This barebones application uses SpriteBatch to draw an image from the `gdx-tests-lwjgl` project.

```java
import com.badlogic.gdx.*;
import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.graphics.*;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

public class BarebonesBatch extends ApplicationAdapter {
	SpriteBatch batch;
	Texture texture;

	public void create () {
		batch = new SpriteBatch();
		texture = new Texture(Gdx.files.internal("data/badlogic.jpg"));
	}

	public void render () {
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		batch.begin();
		batch.draw(texture, 100, 100);
		batch.end();
	}

	public static void main (String[] args) throws Exception {
		new LwjglApplication(new BarebonesBatch());
	}
}
```

### Barebones Stage ###

This barebones application has a [scene2d](/wiki/graphics/2d/scene2d/scene2d) Stage and uses [scene2d.ui](/wiki/graphics/2d/scene2d/scene2d-ui) to draw a label and a button. It uses the [Skin](/wiki/graphics/2d/scene2d/skin) from the gdx-tests-lwjgl project.

```java
import com.badlogic.gdx.*;
import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.*;
import com.badlogic.gdx.utils.viewport.*;

public class BarebonesStage extends ApplicationAdapter {
	Stage stage;

	public void create () {
		stage = new Stage(new ScreenViewport());
		Gdx.input.setInputProcessor(stage);

		Skin skin = new Skin(Gdx.files.internal("skin.json"));
		Label label = new Label("Some Label", skin);
		TextButton button = new TextButton("Some Button", skin);

		Table table = new Table();
		stage.addActor(table);
		table.setFillParent(true);

		table.debug();
		table.defaults().space(6);
		table.add(label);
		table.add(button);
	}

	public void render () {
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		stage.draw();
	}

	public void resize (int width, int height) {
		// Pass false to not modify the camera position.
		stage.getViewport().update(width, height, true);
	}

	public static void main (String[] args) throws Exception {
		new LwjglApplication(new BarebonesStage());
	}
}
```

## Actually Executable ##

If your executable example cannot be pasted into the `gdx-tests-lwjgl` project and run, then it is not actually an executable example. Others should not have to fix up your code to run it, not even to add a main method.

## Attitude ##

Begging for help or a quick answer tends to turn people off and makes it less likely you will receive help at all. Just be polite and your question will get answered politely as time allows. If you are rude, you will be ignored or met with rudeness in return. The people helping you are busy and providing you help for free simply because they are nice. They don't owe you anything and they don't have to care about you or your problems.

## Formatting ##

If you spend a little bit of your time to format your post nicely, it is more likely others will spend their time responding to your post. This means capital letters where appropriate, paragraphs to separate ideas, use actual words (rather than "u", "bcoz", etc), put code in code blocks, etc. If English is not your first language, we understand. No need to apologize, just do your best to make an effort.
