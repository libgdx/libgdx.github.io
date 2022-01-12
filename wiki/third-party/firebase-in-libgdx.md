---
title: Firebase in libGDX
---
If you are interested in using [Firebase](https://firebase.google.com) with libGDX, take a look at mk-5's [gdx-fireapp](https://github.com/mk-5/gdx-fireapp).


## Setup
Add the following dependencies to the corresponding places in your `build.gradle` files. For further information check out the project's extensive wiki: [Android guide](https://github.com/mk-5/gdx-fireapp/wiki/Android-guide), [iOS guide](https://github.com/mk-5/gdx-fireapp/wiki/iOS-Guide), [GWT guide](https://github.com/mk-5/gdx-fireapp/wiki/GWT-guide). 

**Core:**
```
implementation "pl.mk5.gdx-fireapp:gdx-fireapp-core:$gdxFireappVersion"
```

**Android:**
```
implementation "pl.mk5.gdx-fireapp:gdx-fireapp-android:$gdxFireappVersion"
```

**iOS:**
```
implementation "pl.mk5.gdx-fireapp:gdx-fireapp-ios:$gdxFireappVersion"
```

**GWT:**
```
implementation "pl.mk5.gdx-fireapp:gdx-fireapp-html:$gdxFireappVersion"
```

## Basics
Gdx-firebase is a bridge between a libGDX app and the Firebase SDK. It covers Firebase functionality, so if you have some knowledge of the Firebase SDK, using gdx-firebase's API should be intuitive.

To initialize the library, just put this line somewhere in your app's initialization code:

```java
GdxFIRApp.inst().configure();
```

Firebase Analytics should start working just after this step.


## Examples
The project's wiki provides various examples. Check them out [here](https://github.com/mk-5/gdx-fireapp/wiki/Examples).
