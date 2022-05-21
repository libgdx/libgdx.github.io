---
title: Preferences
---
Preferences are a simple way to store small data for your application, e.g. user settings, small game state saves and so on. Preferences work like a hash map, using strings as keys, and various primitive types as values. *Preferences are also the only way to date to write persistent data when your application is run in the browser*.


## Obtaining a Preferences instance
Preferences are obtained via the following snippet:

```java
Preferences prefs = Gdx.app.getPreferences("My Preferences");
```

Note that your application can have multiple preferences, just give them different names.

## Writing And Reading Values
Modifying preferences is as simple as modifying a Java Map:

```java
prefs.putString("name", "Donald Duck");
String name = prefs.getString("name", "No name stored");

prefs.putBoolean("soundOn", true);
prefs.putInteger("highscore", 10);
```

Note that getter methods come in two flavors: with and without a default value. The default value will be returned if there is no value for the specified key in the preferences.

## Flushing
Your changes to a preferences instance will only get persisted if you explicitly call the `flush()` method.

```java
// bulk update your preferences
prefs.flush();
```

## Storage

On Windows, Linux, and OS X, preferences are stored in an xml file within the user's home directory.

| OS    |      Preferences storage location    |
|:-----:|:------------------------------------:|
| Windows | `%UserProfile%/.prefs/My Preferences`|
| Linux and OS X | `~/.prefs/My Preferences`|

The file is named whatever you passed to `Gdx.app.getPreferences()`.

This is useful to know if you want to change or delete them manually for testing.

On Android, the system's [SharedPreferences](https://developer.android.com/reference/android/content/SharedPreferences) class is used. This means preferences will survive app updates, but are deleted when the app is uninstalled.

On iOS, an NSMutableDictionary will be written to the given file. [per [javadocs](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/Preferences.html)]