---
title: Configuration and Querying
---
Sometimes it is necessary to know which input devices are supported. It is also often the case that your game does not need the full range of input devices supported, e.g. you might not need the accelerometer or compass. It is good practice to disable those input devices in that case to preserve battery on Android. The following sections will show you how to perform these actions.


## Disabling Accelerometer & Compass (Android, iOS and Html) ##
The [AndroidApplicationConfiguration](https://github.com/libgdx/libgdx/tree/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidApplicationConfiguration.java) class has a couple of public fields you can set before you hand it of to the `AndroidApplication.initialize()` method.

Assuming our game doesn't need the accelerometer and compass, we can disable this input devices as follows:

```java
public class MyGameActivity extends AndroidApplication {
   @Override
   public void onCreate (Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
      config.useAccelerometer = false;
      config.useCompass = false;
      initialize(new MyGame(), config);
   }
}
```

Both the accelerometer and the compass are enabled by default. The above code disables them and will thus preserve some precious battery.

## Enabling Gyroscope (Android and Html) ##
The gyroscope is disabled by default to preserve battery, you can enable it as follows:

```java
public class MyGameActivity extends AndroidApplication {
   @Override
   public void onCreate (Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
      config.useGyroscope = true;
      initialize(new MyGame(), config);
   }
}
```

## Querying Available Input Devices ##
To check whether a specific input device is available on the platform the application currently runs, you can use the `Input.isPeripheralAvailable()` method.

```java
   boolean hardwareKeyboard = Gdx.input.isPeripheralAvailable(Peripheral.HardwareKeyboard);
   boolean multiTouch = Gdx.input.isPeripheralAvailable(Peripheral.MultitouchScreen);
```

Please refer to the [Peripheral](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Input.java#L560) enumeration to see the rest of the available constants.

Note that only a few Android devices have a hardware keyboard. Even if the keyboard is physically present, the user might not have slid it out. The method shown above will return false in this case.

[Next](/wiki/input/mouse-touch-and-keyboard)