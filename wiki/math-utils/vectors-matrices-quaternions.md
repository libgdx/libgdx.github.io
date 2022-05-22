---
title: Vectors, matrices, quaternions
---
# Introduction

libGDX has several linear algebra classes for dealing with common tasks in physics and applied math. These include:

  * *[Vector](https://en.wikipedia.org/wiki/Euclidean_vector)*
  * *[Matrix](https://en.wikipedia.org/wiki/Matrix_%28mathematics%29)*
  * *[Quaternion](https://en.wikipedia.org/wiki/Quaternion)*

A full explanation of these concepts is beyond the current scope, but the above links may provide a starting point for further understanding. What follows is an overview of their use and implementation in Libgdx.

----

# Vectors

A vector is an array of numbers used to describe a concept with a direction and magnitude such as position, velocity, or acceleration. As such vectors are typically used to describe the physical properties of motion of a body through space. libGDX has vector classes for [two (Vector2)](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/math/Vector2.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Vector2.java) and [3-dimensional (Vector3)](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/math/Vector3.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Vector3.java) spaces. Each contains common operations for working with vector quantities such as addition, subtraction, normalization, and the cross and dot products. There are also methods for [linear](https://en.wikipedia.org/wiki/Linear_interpolation) and [spherical linear](https://en.wikipedia.org/wiki/Spherical_linear_interpolation) interpolation between two vectors.

## Method Chaining

A pattern also found elsewhere in libGDX is the use of method chaining for convenience and reduced typing. Each operation which modifies a vector returns a reference to that vector to continue chaining operations in the same line call. The following example creates a unit vector pointing along the direction from a point _(x1, y1, z1)_ to another point _(x2, y2, z2)_:

```java
Vector3 vec = new Vector3( x2, y2, z2 ).sub( x1, y1, z1 ).nor();
```

A new Vector3 is instantiated with the second point coordinates, the first point is subtracted from this, and the result is normalized. This is of course equivalent to:

```java
Vector3 vec = new Vector3( x2, y2, z2 );  // new vector at (x2, y2, z2)
vec.sub( x1, y1, z1 );                    // subtract point (x1, y1, z1)
vec.nor();                                // normalize result
```

----

# Matrices

A matrix is a two-dimensional array of numbers. Matrices are used in graphics to perform transformations on and projections of vertices in 3D space for display on 2D screens. As with OpenGL, libGDX stores matrices in column-major order. Matrices come in 
[3x3 (Matrix3)](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/math/Matrix3.html) 
[(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/Matrix3.java) and [4x4 (Matrix4)](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/math/Matrix4.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/Matrix4.java) varieties with convenient methods for moving values between the two. libGDX includes many common operations for working with matrices such as building translation and scaling transformations, building rotations from Euler angles, axis-angle pairs or quaternions, building projections, and performing multiplication with other matrices and vectors.

Probably the most common use for matrices in libGDX is through the view and projection matrices of the [Camera](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/Camera.html)[(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/Camera.java) class which are used to control how geometry is rendered to the screen. Cameras, which come in [OrthographicCamera](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/OrthographicCamera.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/OrthographicCamera.java) and [PerspectiveCamera](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/PerspectiveCamera.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/PerspectiveCamera.java) varieties, provide a convenient and intuitive way to control the view in a rendered scene through a position and viewing direction, yet underneath are a simple group of 4x4 matrices which are used to tell OpenGL how to process geometry for render.

## Method Chaining

As with vectors, operations on matrices in Libgdx return a reference to the modified matrix to allow chaining of operations in a single line call. The following creates a new 4x4 model-view matrix useful for an object with position _(x, y, z)_ and rotation described by an axis-angle pair:

```java
Matrix4 mat = new Matrix4().setToRotation( axis, angle ).trn( x, y, z );
```

This is of course equivalent to:

```java
Matrix4 mat = new Matrix4();       // new identity matrix
mat.setToRotation( axis, angle );  // set rotation from axis-angle pair
mat.trn( x, y, z );                // translate by x, y, z
```

## Native Methods

The matrix classes have a number of their operations available in static methods backed by fast native code. While member syntax is often easier to read and more convenient to write, these static methods should be used in areas where performance is a concern. The following example uses one of these methods to perform a multiplication between two 4x4 matrices:

```java
Matrix4 matA;
Matrix4 matB;
Matrix4.mul( matA.val, matB.val );     // the result is stored in matA
```

Notice the use of `.val` to access the underlying `float` array which backs each matrix. The native methods work directly on these arrays. The above is functionally equivalent to the member syntax:
```java
matA.mul( matB );
```

----

# Quaternions

Quaternions are four-dimensional number systems which extend complex numbers. They have many esoteric uses in higher mathematics and number theory. Specifically in the context Libgdx the use of unit-quaternions can be useful for describing rotations in three-dimensional space, as they provide for simpler composition, numerical stability, and the avoidance of [gimbal lock](https://en.wikipedia.org/wiki/Gimbal_lock) making them preferable often to other methods of rotational representation which may variously fall short in these areas.

Quaternions can be constructed by supplying their four components explicitly or by passing an axis-angle pair. Note that while a quaternion is often described as the combination of a vector and a scalar, **_it is not merely an axis-angle pair._** Libgdx also provide methods for converting between quaternions and the various other rotational representations such as Euler angles, rotation matrices, and axis-angle pairs.