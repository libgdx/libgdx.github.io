---
title: Compass
---
Some Android devices and iOS devices have an integrated magnetic field sensor that provides information on how the device is oriented with respect to the magnetic north pole.

NOTE: The compass is currently not available on iOS devices since there is no implementation in the RoboVM - backend yet. The compass appears to be present with the Intel MOE backend on iOS.

Querying whether the compass is available works as follows:

```java
boolean compassAvail = Gdx.input.isPeripheralAvailable(Peripheral.Compass);
```

Once you determined that the compass is indeed available, you can poll its state:

```java
float azimuth = Gdx.input.getAzimuth();
float pitch = Gdx.input.getPitch();
float roll = Gdx.input.getRoll();
```

The angles are given in degrees. Here's the interpretation of these values:

  * The **azimuth** is the angle of the device's orientation around the z-axis. The positive z-axis points towards the earths center.
  * The **pitch** is the angle of the device's orientation around the x-axis. The positive x-axis roughly points to the west and is orthogonal to the z- and y-axis.
  * The **roll** is the angle of the device's orientation around the y-axis. The positive y-axis points toward the magnetic north pole of the earth while remaining orthogonal to the other two axes.

Here's an illustration of the axis relative to the earth.

![images/compass.png](/assets/wiki/images/compass.png)

[Prev](/wiki/input/accelerometer) | [Next](/wiki/input/vibrator)