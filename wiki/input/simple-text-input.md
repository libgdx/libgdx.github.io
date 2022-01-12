---
title: Simple text input
---
If an application needs to ask the user for a string, e.g a user name or a password, it can do so by using a simple dialog box that is customizable to some extent.

On the desktop a Swing dialog will be opened, prompting the user to enter a string. ⚠ In the LWJGL3 backend is this method not implemented. (See [here](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-lwjgl3/src/com/badlogic/gdx/backends/lwjgl3/Lwjgl3Input.java#L335-L338))

On Android a standard Android dialog will be opened, again prompting the user for input.

To receive the input or a notification that the user canceled the input, one has to implement the `TextInputListener` interface:

```java
public class MyTextInputListener implements TextInputListener {
   @Override
   public void input (String text) {
   }

   @Override
   public void canceled () {
   }
}
```

The `input()` method will be called when the user enters a text string. The `canceled()` method will be called if the user closed the dialog on the desktop or pressed the back button on Android.

To bring up the dialog, simple invoke the following method with your listener:

```java
MyTextInputListener listener = new MyTextInputListener();
Gdx.input.getTextInput(listener, "Dialog Title", "Initial Textfield Value", "Hint Value");
```

The methods of the listener will be called on the rendering thread, right before the `ApplicationListener.render()` method is called.

[Prev](/wiki/input/gesture-detection) | [Next](/wiki/input/accelerometer)