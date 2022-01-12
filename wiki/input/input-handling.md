---
title: Input handling
---
Different platforms have different input facilities. On the desktop users can talk to your application via the keyboard and a mouse. The same is true for browser based games. On Android, the mouse is replaced with a (capacitive) touch screen, and a hardware keyboard is often missing. All (compatible) Android devices also feature an accelerometer and sometimes even a compass (magnetic field sensor).

libGDX abstract all these different input devices. Mouse and touch screens are treated as being the same, with mice lacking multi-touch support (they will only report a single "finger") and touch-screens lacking button support (they will only report "left button" presses).

Depending on the input device, one can either [poll](http://en.wikipedia.org/wiki/Polling_\(computer_science\)) the state of a device periodically, or [register a listener](/wiki/input/event-handling) that will receive input events in chronological order. The former is sufficient for many arcade games, e.g. analogue stick controls, the latter is necessary if UI elements such as buttons are involved, as these rely on event sequences such as touch down/touch up.

All of the input facilities are accessed via the [Input](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Input.java) module.

```java
   // Check if the A key is pressed
   boolean isPressed = Gdx.input.isKeyPressed(Keys.A);
```


[Next](/wiki/input/configuration-and-querying)
