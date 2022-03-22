---
title: Adding new Keycodes
# Not listed in ToC
---
## Short info on how to add new keycodes:

- Add the keycodes to `Input.Keys` (don't forget to define `Input.Keys.toString()` for the new codes).

- **Android:**  If they exist for Android, use same codes as in Android's `KeyEvent` class. If not existent for Android, define a keycode non-clashing with Android's codes and document it as a comment. Due to Android's key code being same than libgdx, no change is needed in Android's backend.
- **GWT:** Changes needed in `DefaultGwtInput.keyForCode()`. GWT's KeyCode.java is incomplete. Check with all browsers and OS at hand (might be slightly different) at [keycode.info](https://keycode.info/)
- **RoboVM:** Changes needed in `DefaultIOSInput.getGdxKeyCode()`. Check `UIKeyboardHIDUsage` enum (yes, you can do that on any OS).
- **Lwjgl:** Use Keyboard constants in `DefaultLwjglInput.getGdxKeyCode()` and `getLwjglKeyCode()`, Lwjgl3 is similar. Don't forget `LwjglAwtInput`
- **CHANGES:** Document newly added keycodes and if they are completely new (unmapped before) or changing a mapping existing before

If you follow these steps, merge is highly likely.

For any controller issues, take a look at the [gdx-controllers repo](https://github.com/libgdx/gdx-controllers).

From [MrStahlfelge](https://github.com/MrStahlfelge)'s [comment](https://github.com/libgdx/libgdx/issues/5389#issuecomment-730477319) at: [#5389](https://github.com/libgdx/libgdx/issues/5389)
