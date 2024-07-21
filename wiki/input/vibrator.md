---
title: Vibrator
---
While not strictly an input device, it nevertheless is a kind of a peripheral. We felt it belonged in the input model.

The vibrator allows you to vibrate the phone of a user. This can be used similar to more sophisticated force feedback functionality found commonly in game console controllers.

The vibrator is only available on Android and needs a special permission in the manifest file

```java
android.permission.VIBRATE
```

See the [application configuration](/wiki/app/starter-classes-and-configuration) section if you are unsure how to specify permissions in your Android manifest.

Vibrating the phone works as follows:

```java
Gdx.input.vibrate(2000);
```

As the parameter is given in milliseconds the example above will vibrate the phone for 2 seconds.

More sophisticated patterns can be specified via the second `vibrate()` method:

```java
Gdx.input.vibrate(new long[] { 0, 200, 200, 200}, -1); 
```

This will turn the vibrator on for 200 milliseconds, then turn it off for 200 milliseconds then on again for another 200 milliseconds. The second parameter specifies that the pattern should not be repeated. Refer to the [Javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/Input.html#vibrate(int)) for more information.

[Prev](/wiki/input/compass) | [Next](/wiki/input/cursor-visibility-and-catching)
