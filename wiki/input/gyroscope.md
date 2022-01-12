---
title: Gyroscope
---
Some Android devices have a gyroscope sensor that provides information about the rate of rotation in rad/s around a device's x, y, and z axis.

NOTE: The gyroscope is currently not available on iOS devices since there is no implementation in the RoboVM - backend yet.

You must first enable the gyroscope in your android config. (Typically in your AndroidLauncher.java file)

```java 
config = new AndroidApplicationConfiguration();
config.useGyroscope = true;  //default is false

//you may want to switch off sensors that are on by default if they are no longer needed.
config.useAccelerometer = false;
config.useCompass = false;
```
Querying whether the gyroscope is available works as follows:

```java
boolean gyroscopeAvail = Gdx.input.isPeripheralAvailable(Peripheral.Gyroscope);
```

Once you determined that the gyroscope is indeed available, you can poll its state:

```java

if(gyroscopeAvail){
	float gyroX = Gdx.input.getGyroscopeX();
	float gyroY = Gdx.input.getGyroscopeY();
	float gyroZ = Gdx.input.getGyroscopeZ();
} 

```