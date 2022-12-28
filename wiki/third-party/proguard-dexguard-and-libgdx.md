---
title: ProGuard DexGuard and libGDX
---
[ProGuard](https://www.guardsquare.com/proguard) and the newer [R8](https://developer.android.com/studio/build/shrink-code) are optimizers and obfuscators for Java and Android applications. You can use these tools with your libGDX application to make it harder for 3rd parties to decompile your app, reduce your apps size and even increase the runtime speed by ahead-of-time optimizations like inlining.

The following configuration file will make your libGDX app work with ProGuard/R8:

```
# To enable ProGuard in your project, edit project.properties
# to define the proguard.config property as described in that file.
#
# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in ${sdk.dir}/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the ProGuard
# include property in project.properties.
#
# For more details, see
#   https://developer.android.com/studio/build/shrink-code

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

-verbose

-dontwarn com.badlogic.gdx.backends.android.AndroidFragmentApplication

# Required if using Gdx-Controllers extension
-keep class com.badlogic.gdx.controllers.android.AndroidControllers

# Required if using Box2D extension
-keepclassmembers class com.badlogic.gdx.physics.box2d.World {
   boolean contactFilter(long, long);
   void    beginContact(long);
   void    endContact(long);
   void    preSolve(long, long);
   void    postSolve(long, long);
   boolean reportFixture(long);
   float   reportRayFixture(long, float, float, float, float, float);
}
```

Note that you will also have to keep any classes that you access via reflection yourself! Please refer to the [ProGuard/R8 documentation](https://developer.android.com/studio/build/shrink-code) for more details.

To apply ProGuard/R8 to your Android project on Release builds, you need to add the following config to `build.gradle` file (the one in the `android/` folder of your project, not the root `build.gradle`)


```groovy
buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
```
