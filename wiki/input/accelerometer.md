---
title: Accelerometer
---
An accelerometer measures the acceleration of a device on three axes (at least on Android). From this acceleration one can derive the tilt or orientation of the device.

Acceleration is measured in meters per second per second (m/s²). If an axis is pointing straight towards the center of the earth, its acceleration will be roughly -10 m/s². If it is pointing in the opposite direction, the acceleration will be 10 m/s².

The axes in an Android device are setup as follows:

![images/accelerometer.png](/assets/wiki/images/accelerometer.png)

Unfortunately, this configuration is different for tablets. Android devices have a notion called default orientation. For phones, portrait mode (as in the image above) is the default orientation. For tablets, landscape mode is the default orientation. A default landscape orientation device has its axes rotated, so that the y-axis points up the smaller side of the device and the x-axis points to the right of the wider side.

libGDX takes care of this and presents the accelerometer readings as shown in the image above, no matter the default orientation of the device (positive z-axis comes out of the screen, positive x-axis points to the right along the wider side of the device, positive y-axis points upwards along the smaller side of the device).

## Checking Availability
Different Android devices have different hardware configurations. Checking whether the device has an accelerometer can be done as follows:

```java
boolean available = Gdx.input.isPeripheralAvailable(Peripheral.Accelerometer);
```

## Querying Current/Native Orientation
If your game needs to know the current orientation of the device, the following method can be used:

```java
int orientation = Gdx.input.getRotation();
```

This will return a value of 0, 90, 180 or 270, giving you the angular difference between the current orientation and the native orientation.

The native orientation is either portrait mode (as in the image above) or landscape mode (mostly for tablets). It can be queried as follows:

```java
Orientation nativeOrientation = Gdx.input.getNativeOrientation();
```

This returns either Orientation.Landscape or Orientation.Portrait.

## Acceleration Readings

Accelerometer readings can only be accessed via polling in libgdx:

```java
    float accelX = Gdx.input.getAccelerometerX();
    float accelY = Gdx.input.getAccelerometerY();
    float accelZ = Gdx.input.getAccelerometerZ();
```

Platforms or devices that don't have accelerometer support will return zero.

See the [Super Jumper](https://github.com/libgdx/libgdx-demo-superjumper) demo game for a demonstration on the usage of the accelerometer.

## Rotation Matrix
If you want to use the orientation of your device for rendering, it might be beneficial to work with the rotation matrix. See <a href="https://developer.android.com/reference/android/hardware/SensorManager.html#getRotationMatrix(float[], float[], float[], float[])">this link</a> for an explanation. You can plug the resulting matrix directly into your OpenGL rendering:

```java
Matrix4 matrix = new Matrix4();
Gdx.input.getRotationMatrix(matrix.val);
// use the matrix, Luke
```

[Prev](/wiki/input/simple-text-input) | [Next](/wiki/input/compass)