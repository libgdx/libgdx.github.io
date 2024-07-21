---
title: Vibrator
---
While not strictly an input device, it nevertheless is a kind of peripheral. We felt it belonged in the input model.

The vibrator allows you to vibrate the user's mobile device. This can be used to provide feedback to the user in addition to or instead of sound effects.

## Enabling support

### Android

On Android, vibration requires the following permission in `AndroidManifest.xml`, otherwise attempting to vibrate will crash the app:

```xml
<uses-permission android:name="android.permission.VIBRATE" />
```

This is a "normal" install-time permission, meaning it is automatically granted without the user agreeing to it. If publishing on the Google Play Store, this permission will be listed on your app's store page as "control vibration".

### iOS

On iOS, haptics need to be enabled in `IOSLauncher`:

```java
config.useHaptics = true;
```

### GWT

The GWT backend does not support vibration. However, it is quite simple to implement basic vibration with [platform-specific code](/wiki/app/interfacing-with-platform-specific-code).

```java
native void vibrateJsni(int milliseconds) /*-{
    navigator.vibrate(milliseconds);
}-*/;
```

This only works in Chromium-based browsers on Android devices that are not in silent mode. Despite caniuse.com claiming Firefox for Android supports this, support has been disabled since Firefox 79 due to abuse.

## Vibration

### Simple

The simplest form of vibration runs the motor for a period of time given in milliseconds.

In this example, the device will vibrate for 1 second on supported Android and iOS devices:

```java
Gdx.input.vibrate(1000);
```

On iPhones that lack Haptic Feedback or are running an iOS version earlier than 13, this will vibrate for 400ms no matter what argument is inserted. If you would rather it not do this, you can disable the fallback:

```java
Gdx.input.vibrate(1000, false);
```

### Amplitude

Some devices support setting the vibration amplitude, i.e. how intense the vibration is. This is on a scale of 0 to 255.

```java
// Vibrate for 1 second at half amplitude, no fallback
Gdx.input.vibrate(1000, 127, false);

// Vibrate for 1 second at full amplitude, with fallback
Gdx.input.vibrate(1000, 255, true);
```

If the `fallback` boolean is `true`, Android devices without amplitude control will ignore the amplitude argument, and iPhones without iOS 13 or newer will ignore all arguments.

### Preset

libGDX provides three preset vibration intensities:

```java
Gdx.input.vibrate(Input.VibrationType.LIGHT);
Gdx.input.vibrate(Input.VibrationType.MEDIUM);
Gdx.input.vibrate(Input.VibrationType.HEAVY);
```

These are delegated to the system, and as such should provide a consistent experience with other apps the user may have. This also means they will not work on all devices.

This method requires at least Android 10 and a device with amplitude control, or iOS 13 with Haptic Feedback. On budget or older devices, it will do nothing.

### Pattern

As of libGDX 1.12.0, vibration patterns, also known as waveforms, are no longer supported. For existing games that use this functionality, you can reimplement this into your `android` module or, for cross-platform support, parse the pattern on a separate thread.

```java
public void vibrate (long[] pattern, int repeat) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        vibrator.vibrate(VibrationEffect.createWaveform(pattern, repeat));
    else vibrator.vibrate(pattern, repeat);
}
```

## Detecting vibrator support

You may wish to detect whether a device supports vibration or amplitude control.

```java
boolean vibration = Gdx.input.isPeripheralAvailable(Input.Peripheral.Vibrator);
boolean amplitude = Gdx.input.isPeripheralAvailable(Input.Peripheral.HapticFeedback);
```

In the above example, each variable will be `true` under the following circumstances:

|OS|`vibration`|`amplitude`|
|--|-----------|-----------|
|**Android**|The device supports vibration. This does not mean the app has permission to vibrate!|The device supports amplitude control vibration.|
|**iOS**|`useHaptics` is `true` and the device has a phone form factor. This includes the iPod touch, which lacks a vibration motor.|`useHaptics` is `true` and the device supports vibration beyond the 400ms fallback.|

Especially on Android, this can be useful for scenarios such as only displaying vibration settings to devices that support vibration, and providing your own fallbacks to less advanced vibration:

```java
if (Gdx.input.isPeripheralAvailable(Input.Peripheral.HapticFeedback)) {
    Gdx.input.vibrate(Input.VibrationType.MEDIUM);
} else {
    Gdx.input.vibrate(50);
}
```

These values only reflect whether the device itself can vibrate. Devices without a built-in vibrator can still vibrate external peripherals. For that, see `Controller#canVibrate` in [gdx-controllers](/wiki/input/controllers).

## Additional considerations

When designing your game, you may wish to consider which devices are likely to support vibration.

* Smartphones and smartwatches are practically guaranteed to have a vibration motor, though only the flagships tend to support amplitude control.
* Tablets may or may not have vibration, depending on the model. Samsung and Lenovo tablets generally do, whereas iPads and the Pixel Tablet do not.
* Larger devices such as Chromebooks and televisions almost never support vibration.

Vibration can cause some users discomfort, so you should always allow them to disable it. This would typically be done from your game's settings or main menu.

Some apps have been known to vibrate depending on whether the user's device is in silent mode (on Android, using `AudioManager#getRingerMode`) but this is not an ideal approach.


[Prev](/wiki/input/compass) | [Next](/wiki/input/cursor-visibility-and-catching)
