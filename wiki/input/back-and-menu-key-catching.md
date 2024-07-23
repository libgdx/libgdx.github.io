---
title: Back and menu key catching
---
When a user presses the back button on an Android device, this usually kills the currently running activity. Games might chose to display a confirmation dialog before letting the user exit. For that to work one needs to catch the back key so it is not passed on to the operating system:

```java
Gdx.input.setCatchKey(Input.Keys.BACK, true);
```

You will still receive key events if you have registered an [InputProcessor](/wiki/input/event-handling), but the operating system will not close your application.

```   
@Override
public boolean keyDown(int keycode) {
    if(keycode == Keys.BACK){
       // Respond to the back button click here
       return true;
    }
    return false;
}
```

Note that the general paradigm in Android is to have the back key close the current activity. Deviating from this is usually viewed as bad practice.

Another key that might need to be caught is the menu key. If uncaught, it will bring up the on-screen keyboard after a long press. Catching this key can be done as follows:

```java
Gdx.input.setCatchKey(Input.Keys.MENU, true);
```

There might be other keys to catch as well. You should catch all keys used to control your game to tell the operating system to prevent triggering behaviour outside your apps. This could affect media control keys on Android TV, and some general keys if you target HTML5 as well (see [HTML 5 specifics article](/wiki/html5-backend-and-gwt-specifics#preventing-keys-from-triggering-scrolling-and-other-browser-functions) for more information)
