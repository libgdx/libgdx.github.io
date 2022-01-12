---
title: Math utilities
---
# Introduction #

The [math](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math) package contains various useful classes for dealing with problems in geometry, linear algebra, collision detection, interpolation, and common unit conversions.


## Math Utils ##

The [MathUtils](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/MathUtils.html)  [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/MathUtils.java) class covers a number of useful odds and ends. There is a handy static `Random` member to avoid instantiating one in your own code. Using the same random instance throughout your code can also ensure consistently deterministic behavior as long as you store the seed value used. There are constants for conversion between radians and degrees as well as look-up tables for the sine and cosine functions. There are also `float` versions of common `java.lang.Math` functions to avoid having to cast down from `double`.

## Catmull-Rom Spline ##

A [Catmull-Rom spline](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/CatmullRomSpline.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/CatmullRomSpline.java) allows a continuous curve to be generated from a discrete list of control points. Splines can be useful for describing a smooth path of motion of a body or camera through space. Catmull-Rom splines are particularly useful in this regard as they are simple to compute and can guarantee the resulting path will pass through each control point (except the first and last points which control spline shape but do not become part of the path). Unlike Bezier splines, control tangents are implicit and control over spline shape is traded for ease of path definition. All that is required is a list of points through which the desired path must pass.

## Ear-Clipping Triangulator ##

One way to triangulate a simple polygon is based on the fact that any simple polygon with at least four vertices and with no holes has at least two so called 'ears', which are triangles with two sides being the edges of the polygon and the third one completely inside it. The [Ear-Clipping Triangulator](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/EarClippingTriangulator.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/EarClippingTriangulator.java) class implements this idea, producing a list of triangles from a list of supplied points representing a two-dimensional polygon. The input polygon may be concave and the resulting triangles have a clockwise order.

## Windowed Mean ##

The [Windowed Mean](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/WindowedMean.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/WindowedMean.java) class is useful for tracking the mean of a running stream of floating point values within a certain window. This can be useful for basic statistical analysis such as measuring average network speed, gauging user reaction times for dynamic difficulty adjustment, or energy-based beat detection in music visualizations.