---
title: APK Expansions support
# Not listed in ToC
---
Whenever the assets of a game exceed a certain size, in order to release the game on Google Play, the assets have to be placed into a separate file, to keep the APK size under 100MB. For more information about this you can read [here](http://developer.android.com/google/play/expansion-files.html).

## How to use the feature
libGDX now has built-in support for detecting and reading assets from expansion files. The expansion file format accepted by libGDX is uncompressed (stored) zip file. Don't use the _jobb_ tool provided with the android SDK. Simply move some or all of your assets from android/assets into the zip file. Usually the file will be automatically downloaded from Google Play, however if you want to test it you will have to copy the file on the device manually.

The Android application then has to call from [AndroidFiles](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidFiles.java) the function `setAPKExpansion()` like this:  
`((AndroidFiles)Gdx.files).setAPKExpansion(1, 0)`  
where the return value of the function can be used to check whether the expansion file(s) was opened successfully. The parameters are the version numbers of the _main_ respectively _patch_ files which on Google Play have to match the APK version against which these files were uploaded.

Afterwards your assets can be accessed using:  
`Gdx.files.internal("assetname.ext")`  
just like you would normally.

Keep in mind that on lots of small files this can be inefficient because [AndroidFiles](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidFiles.java) first checks if a file exists in the assets and only afterwards it creates an [AndroidZipFileHandle](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backend-android/src/com/badlogic/gdx/backends/android/AndroidZipFileHandle.java). If you want to optimize loading time use a FileHandleResolver like the [ZipFileHandleResolver](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests-android/src/com/badlogic/gdx/tests/android/ZipFileHandleResolver.java).
