---
title: On screen keyboard
---
Most Android devices and all iOS devices do not possess a hardware keyboard. Instead, a soft- or on-screen keyboard can be presented to the user. To bring up the on-screen keyboard we can call this method:

```java
Gdx.input.setOnscreenKeyboardVisible(true);
```

Once visible, any key presses will be reported as [events](/wiki/input/event-handling) to the application. Additionally, [polling](/wiki/input/polling) can be used to check for a specific key's state.

Note that there is currently a bug in the on-screen keyboard implementation when landscape mode is used on Android. The default Android on-screen keyboard can be switched for a custom keyboard, and many handset manufacturers like HTC make use of this. Sadly, their keyboard implementations tend to be buggy which leads to problems described in this [issue](https://code.google.com/p/libgdx/issues/detail?id=431). If you're using a buggy custom keyboard or your manufacturer supplied a buggy custom keyboard, [Google's keyboard](https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin&hl=en) works correctly with libGDX.

On-screen keyboard functionality is only available the Android and iOS platforms.
