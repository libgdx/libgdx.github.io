---
title: Interpolation
---
# Interpolation #

Commonly known as _tweening_, [interpolation](http://en.wikipedia.org/wiki/Interpolation) is useful for generating values between two discrete end points using various curve functions. Often used with key-framed animation, interpolation allows an animator to specify a sparse collection of explicit frames for an animation and then generate a smooth transition between these frames computationally. The simplest form of interpolation is linear interpolation such as that available directly in the [Vector2](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Vector2.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Vector2.java) and [Vector3](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Vector3.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Vector3.java) classes. The [Interpolation](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Interpolation.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Interpolation.java) class provides more interesting results by using non-linear curve functions to interpolate values.

## Types of Interpolation ##

These are the basic built-in types of interpolation:

  * Bounce
  * Circle
  * Elastic
  * Exponential
  * Fade
  * Power
  * Sine
  * Swing

## Code Example ##

```kotlin
// Written in Kotlin

val easAlpha:Interpolation = Interpolation.fade
val lifeTime:Int = 2
var elapsed:Float = 0f
..
fun update(delta:Float)
{
    elapsed += delta

    val progress = Math.min(1f, elapsed/lifeTime)   // 0 -> 1 
    val alpha = easAlpha.apply(progress)
}

```


Most types offer three varieties which bias towards one or the other or both ends of the curve creating an easing in or out of the animation.

See [InterpolationTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/InterpolationTest.java) for a visual display of each interpolation.


## Visual display of interpolations ##

| bounce | bounceIn | bounceOut | circle |
| ------ | -------- | --------- | ------ |
| ![bounce](https://user-images.githubusercontent.com/12948924/75204377-8e3d2600-5725-11ea-8caa-a8cc94ea737e.png) | ![bouncein](https://user-images.githubusercontent.com/12948924/75204516-f5f37100-5725-11ea-8889-cff2abf0d6c9.png) | ![bounceout](https://user-images.githubusercontent.com/12948924/75204546-060b5080-5726-11ea-83a8-b02b9c740884.png) | ![circle](https://user-images.githubusercontent.com/12948924/75204564-115e7c00-5726-11ea-99e0-bbb26b9dbd20.png) |
| circleIn | circleOut | elastic | elasticIn |
| ![circlein](https://user-images.githubusercontent.com/12948924/75204649-4539a180-5726-11ea-86b8-dca6f9cb6651.png) | ![circleout](https://user-images.githubusercontent.com/12948924/75204659-4f5ba000-5726-11ea-8fe9-b99c768c8ba7.png) | ![elastic](https://user-images.githubusercontent.com/12948924/75204669-5aaecb80-5726-11ea-8023-28547317fba1.png) | ![elasticin](https://user-images.githubusercontent.com/12948924/75204689-669a8d80-5726-11ea-89e1-35a93c260cee.png) |
| elasticOut | exp5 | exp5In | exp5Out |
| ![elasticout](https://user-images.githubusercontent.com/12948924/75204735-8e89f100-5726-11ea-8b74-fa0e6d795ce0.png) | ![exp5](https://user-images.githubusercontent.com/12948924/75204749-99448600-5726-11ea-93ea-04cf230108a3.png) | ![exp5in](https://user-images.githubusercontent.com/12948924/75204765-a792a200-5726-11ea-9e74-dde07e0370a3.png) | ![exp5out](https://user-images.githubusercontent.com/12948924/75204776-b0837380-5726-11ea-8451-62f0c6b9e43f.png) |
| exp10 | exp10In | exp10Out | fade |
| ![exp10](https://user-images.githubusercontent.com/12948924/75204796-c002bc80-5726-11ea-918e-5fa0ed35f0c5.png) | ![exp10in](https://user-images.githubusercontent.com/12948924/75204812-c98c2480-5726-11ea-881d-8a20fee68b55.png) | ![exp10out](https://user-images.githubusercontent.com/12948924/75204846-e9234d00-5726-11ea-83d9-8fbc0be4b5e1.png) | ![fade](https://user-images.githubusercontent.com/12948924/75204914-1a038200-5727-11ea-85cb-f2f3ecee5d79.png) |
| fastSlow | linear | pow2 | pow2In |
![fastSlow](https://user-images.githubusercontent.com/12948924/75205068-a0b85f00-5727-11ea-8054-f873f2252ff2.png) | ![linear](https://user-images.githubusercontent.com/12948924/75205099-b75eb600-5727-11ea-9478-af1d96df9b25.png) | ![pow2](https://user-images.githubusercontent.com/12948924/75205109-c2194b00-5727-11ea-99e9-614c2f613331.png) | ![pow2in](https://user-images.githubusercontent.com/12948924/75205130-cd6c7680-5727-11ea-9a67-1a456f3e3bb9.png) |
| pow2InInverse | pow2Out | pow2OutInverse | pow3 |
| ![pow2InInverse](https://user-images.githubusercontent.com/12948924/75205146-dc532900-5727-11ea-992f-eeef9ecd1508.png) | ![pow2Out](https://user-images.githubusercontent.com/12948924/75205353-69967d80-5728-11ea-8011-e158a0e95582.png) | ![pow2OutInverse](https://user-images.githubusercontent.com/12948924/75205639-2b4d8e00-5729-11ea-98df-31e0e81e9e61.png) | ![pow3](https://user-images.githubusercontent.com/12948924/75205657-36082300-5729-11ea-8636-683fa98d1988.png) |
| pow3In | pow3InInverse | pow3Out | pow3OutInverse |
| ![pow3in](https://user-images.githubusercontent.com/12948924/75205686-47512f80-5729-11ea-91de-a044860fb78a.png) | ![pow3InInverse](https://user-images.githubusercontent.com/12948924/75205850-bb8bd300-5729-11ea-8710-8b5447268b34.png) | ![pow3Out](https://user-images.githubusercontent.com/12948924/75205867-cb0b1c00-5729-11ea-912b-563dab0e7d91.png) | ![pow3OutInverse](https://user-images.githubusercontent.com/12948924/75205878-d6f6de00-5729-11ea-8d24-95788c375db2.png) |
| pow4 | pow4In | pow4Out | pow5 |
| ![pow4](https://user-images.githubusercontent.com/12948924/75206040-52f12600-572a-11ea-8621-7763df2868e5.png) | ![pow4In](https://user-images.githubusercontent.com/12948924/75206050-58e70700-572a-11ea-890a-6afa6f25b554.png) | ![pow4Out](https://user-images.githubusercontent.com/12948924/75206058-5f757e80-572a-11ea-86b9-763d19272870.png) | ![pow5](https://user-images.githubusercontent.com/12948924/75206063-64d2c900-572a-11ea-8a38-db8ee3484682.png) |
| pow5In | pow5Out | sine | sineIn |
| ![pow5In](https://user-images.githubusercontent.com/12948924/75206202-b7ac8080-572a-11ea-9e45-394bc794f3b1.png) | ![pow5Out](https://user-images.githubusercontent.com/12948924/75206218-c1ce7f00-572a-11ea-9219-27ad23e83d34.png) | ![sine](https://user-images.githubusercontent.com/12948924/75206226-c85cf680-572a-11ea-8a9c-ce9dcde85a29.png) | ![sineIn](https://user-images.githubusercontent.com/12948924/75206237-cdba4100-572a-11ea-824e-e675c2b8a882.png) |
| sineOut | slowFast | smooth | smooth2 |
| ![sineOut](https://user-images.githubusercontent.com/12948924/75206272-e4609800-572a-11ea-926f-9ccbf6f154d2.png) | ![slowFast](https://user-images.githubusercontent.com/12948924/75206283-eaef0f80-572a-11ea-964f-09176844502f.png) | ![smooth](https://user-images.githubusercontent.com/12948924/75206295-f17d8700-572a-11ea-9154-d194a7c62d15.png) | ![smooth2](https://user-images.githubusercontent.com/12948924/75206325-04905700-572b-11ea-9121-2cb790d5f876.png) |
| smoother | swing | swingIn | swingOut |
| ![smoother](https://user-images.githubusercontent.com/12948924/75206469-5a64ff00-572b-11ea-81c5-c56a26b82cdb.png) | ![swing](https://user-images.githubusercontent.com/12948924/75206478-618c0d00-572b-11ea-93ff-f96a7e70665b.png) | ![swingIn](https://user-images.githubusercontent.com/12948924/75206491-68b31b00-572b-11ea-8335-88eb8fcc675b.png) | ![swingOut](https://user-images.githubusercontent.com/12948924/75206505-7072bf80-572b-11ea-97e7-3335d2ae3888.png) |
