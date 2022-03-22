---
title: Internationalization and Localization
---
## Overview

Technically speaking, _internationalization_ is the process of designing a software so that it can potentially be adapted to various languages and regions without engineering changes.
 _Localization_ is the process of adapting internationalized software for a specific region or language by adding locale-specific components and translating text.
Due to the length of the terms, both internationalization and localization are frequently abbreviated to i18n and l10n respectively, where 18 and 10 stand for the number of letters between the initial and the final letters of the respective words.

In LibGDX, the [`I18NBundle` class](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/I18NBundle.html) is used to store and fetch strings that are locale sensitive. A bundle allows you to easily provide different translations for your application.


## Creating Properties Files

Each bundle is a set of properties files that share the same base name, `MyBundle` in the following example. The characters following the base name indicate the _language code_, _country code_, and _variant_ of a Locale, for example:

* `MyBundle.properties`
* `MyBundle_de.properties`
* `MyBundle_en_GB.properties`
* `MyBundle_fr_CA_VAR1.properties`

`MyBundle_en_GB`, for example, matches the Locale specified by the language code for English (`en`) and the country code for Great Britain (`GB`).

You should always create a _default properties file_, without any language code, country code or variant. In our example the contents of `MyBundle.properties` are as follows:
````
game=My Super Cool Game
newMission={0}, you have a new mission. Reach level {1}.
coveredPath=You covered {0,number}% of the path
highScoreTime=High score achieved on {0,date} at {0,time}
````

To support an additional Locale, your localizers will create an _additional properties file_ that contains the translated values. No changes to your source code are required, because your program references the keys, not the values.

For example, to add support for the Italian language, your localizers would translate the values in `MyBundle.properties` and place them in a file named `MyBundle_it.properties`. The contents of `MyBundle_it.properties` are as follows:

````
newMission={0}, hai una nuova missione. Raggiungi il livello {1}.
coveredPath=Hai coperto il {0,number}% del percorso
highScoreTime=High score ottenuto il {0,date} alle ore {0,time}
````
Notice that the key named `game` is missing from the Italian properties file since we want the game's name to remain unchanged regardless of the locale. If a key is not found, the key will be looked up in decreasingly specific properties files until found; for instance, if a key is not found in `MyBundle_en_GB.properties`, it will be looked up in `MyBundle_en.properties`, and if not found there either, in the default `MyBundle.properties`.



## Creating a Bundle

An instance of the `I18NBundle` class manages the named strings for a locale after loading into memory the appropriate properties files.
Invoke the factory method `createBundle` to get a new instance of the desired bundle:
````java
FileHandle baseFileHandle = Gdx.files.internal("i18n/MyBundle");
Locale locale = new Locale("fr", "CA", "VAR1");
I18NBundle myBundle = I18NBundle.createBundle(baseFileHandle, locale);
````

The path "i18n/MyBundle", in this case, refers to files whose names begin with _MyBundle_ that are located in the _i18n_ folder, more precisely in "assets/i18n". You do not need to create the _MyBundle_ subfolder as well.

Or, if you're using [`AssetManager`](/wiki/managing-your-assets):
```
assetManager.load("i18n/MyBundle", I18NBundle.class);
// ... after loading ...
I18NBundle myBundle = assetManager.get("i18n/MyBundle", I18NBundle.class);
```
If you don't specify any locale when you invoke `createBundle` then the default locale is used. This is usually what you want.

Note that you have to leave out the `.properties` file extension in both cases. If a property file for the specified Locale does not exist, `createBundle` tries to find the closest match. For example, if you requested the locale `fr_CA_VAR1` and the default Locale is `en_US`, `createBundle` will look for files in the following order:
  * `MyBundle_fr_CA_VAR1.properties`
  * `MyBundle_fr_CA.properties`
  * `MyBundle_fr.properties`
  * `MyBundle_en_US.properties`
  * `MyBundle_en.properties`
  * `MyBundle.properties`

Note that `createBundle` looks for files based on the default Locale before it selects the base file `MyBundle.properties`. If `createBundle` fails to find a match it throws a `MissingResourceException`. To avoid throwing this exception, you should always provide a base file with no suffixes.



## Fetching Localized Strings

To retrieve a translated value from the bundle, invoke the `get` method as follows:
````java
String value = myBundle.get(key);
````
The string returned by the `get` method corresponds to the specified key. The string is in the proper language, provided that a properties file exists for the specified locale. If no string for the given key can be found by the `get` method (or its parametric form `format`) a `MissingResourceException` is thrown.

Translated strings can contain formatting parameters. To substitute values for those, invoke the `format` method as follows:
````java
String value = myBundle.format(key, arg1, arg2, ...);
````

For example, to retrieve the strings from the properties files above your code might look like this:
````java
String game = myBundle.format("game");
String mission = myBundle.format("newMission", player.getName(), nextLevel.getName());
String coveredPath = myBundle.format("coveredPath", path.getPerc());
String highScoreTime = myBundle.format("highScoreTime", highScore.getDate());
````

When a string has no arguments, you might think that the methods `get` and `format` are equivalent. This is not entirely true. The `get` method returns the string exactly as it was specified in the properties file, while the `format` method might make replacements for escaping even if no arguments are present. As a result, `get` is slightly faster, but unless you are certain that none of your translations contain any escaping it's best to always use `format`.



## Message Format

As we have seen, the strings in a properties file can contain parameters. These strings are commonly called patterns and follow the syntax specified by the `java.text.MessageFormat` API. In short, a pattern can contain zero or more formats of the form `{index, type, style}` where the type and the style are optional. Refer to the [official JavaDoc of the `MessageFormat` class](https://docs.oracle.com/javase/7/docs/api/java/text/MessageFormat.html) to learn all its features.

**Important**: There is one change that libGDX makes to `MessageFormat`'s syntax, because the default escaping rules have proved to be somewhat confusing to localizers. If you want to use a literal `{` in your string, normally you would need to escape it using single quotes (`'`). In libGDX however, you just double it; for example, {% raw %}`{{0}`{% endraw %} is interpreted as the literal string `{0}`, without any format elements. As a result, single quotes never need to be escaped!

Note that formats are localizable. This means that typed data like numbers, dates and times will be automatically expressed in the typical form of the specific locale. For example, the float number `3.14` becomes `3,14` for the Italian locale; notice the comma in place of the decimal point. (If you're using GWT, there are [some limitations](#gwt-limitations-and-compatibility) to this.)

Unlike `java.util.Properties`, the default encoding is `UTF-8`. If, for whatever reason, you don't want to use UTF-8 encoding, invoke one of the overloaded forms of the `createBundle` method that allows you to specify the desired encoding.



## Plural Forms

Plural forms are supported through the standard `choice` format provided by `MessageFormat`.
See the [official documentation of the class `java.text.ChoiceFormat`](https://docs.oracle.com/javase/7/docs/api/java/text/ChoiceFormat.html).
I'm going to show you just an example. Let's consider the following property:
````
collectedCoins=You collected {0,choice,0#no coins|1#one coin|1<{0,number,integer} coins|100<hundreds of coins} along the path.
````
You can retrieve the localized string as usual:
````java
System.out.println(myBundle.format("collectedCoins", 0));
System.out.println(myBundle.format("collectedCoins", 1));
System.out.println(myBundle.format("collectedCoins", 32));
System.out.println(myBundle.format("collectedCoins", 117));
````
And the output result would be like the following:
````
You collected no coins along the path.
You collected one coin along the path.
You collected 32 coins along the path.
You collected hundreds of coins along the path.
````

It's worth noting that the choice format can properly handle nested formats as we did with `{0,number,integer}` inside `{0,choice,...}`.


## GWT Limitations and Compatibility

As said before, the I18N system provided by libGDX is cross-platform. However there are some limitations when it comes to the GWT back-end.
In particular:
- **Simple format:** The format syntax of `java.text.MessageFormat` is not fully supported. You'll have to stick to a simplified syntax where formats are made only by their index, i.e. `{index}`.
Format's type and style are not supported and cannot be used; otherwise an `IllegalArgumentException` is thrown.
- **Non localizable arguments:** Formats are never localized, meaning that the arguments passed to the `format` method are converted to a string with the `toString` method, so without taking into account the bundle's locale.

If your application can run on both GWT and non-GWT back-ends, you should call [I18NBundle.setSimpleFormat(true)](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/I18NBundle.html#setSimpleFormatter%28boolean%29) when the application starts. This way all subsequent invocations of the factory method `createBundle` will create bundles having the same behavior on all back-ends.
If you don't do this, you'll get the localized string `3,14` for the Italian locale on a non-GWT back-end (notice the comma and the rounding) and the non-localized string `3.1415927` for the same locale on the GWT back-end.
On the contrary, if `simpleFormat` is set to `true` you'll get the non-localized string `3.1415927` for any locale on any back-end.


## Multiple Bundles

Of course you can use multiple bundles in your application. For example, you might want to use a different bundle for each level of your game. Using multiple bundles offers some advantages:
   * Your code is easier to read and to maintain.
   * You'll avoid huge bundles, which may take somewhat long to load into memory.
   * You can reduce memory usage by loading each bundle only when needed.


## iOS
For iOS, you need to specify the supported language in the `Info.plist.xml` file. Add the following for supporting English, Spanish and German:

    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>es</string>
        <string>de</string>
    </array>
