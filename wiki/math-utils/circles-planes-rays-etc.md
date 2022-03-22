---
title: Circles, planes, rays, etc.
---
# Introduction

libGDX has several geometric classes for dealing with shapes, areas, and volumes. These include:

  * *[Circle](https://en.wikipedia.org/wiki/Circle)*
  * *[Frustum](https://en.wikipedia.org/wiki/Frustum)* (sometimes written _frustrum_)
  * *[Plane](https://en.wikipedia.org/wiki/Plane_%28geometry%29)*
  * *[Spline](https://en.wikipedia.org/wiki/Catmull-Rom_spline#Catmull.E2.80.93Rom_spline)*
  * *[Polygon](https://en.wikipedia.org/wiki/Polygon)*
  * *[Ray](https://en.wikipedia.org/wiki/Ray_%28geometry%29#Ray)*
  * *[Rectangle](https://en.wikipedia.org/wiki/Rectangle)*

A full explanation of these concepts is beyond the current scope, but the above links may provide a starting point for further understanding. What follows is an overview of their use and implementation in Libgdx.

----

# [Bounding Boxes](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/BoundingBox.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/BoundingBox.java)

An axis-aligned bounding box useful for simple volume intersection tests. It is defined by a minimum and maximum point describing the rectangular extents of its volume. A point can be tested for containment within the box and the box can be easily resized to contain a given point. Intersection can also be tested against a [Frustum](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Frustum.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Frustum.java) or with a [Ray](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Ray.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Ray.java) using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.

----

# [Circles](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Circle.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Circle.java)

A simple class which describes a circle with a center point and a radius. Provides the ability to test a point for containment within the circle. Intersection with another circle, a line segment, or a [Rectangle](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Rectangle.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Rectangle.java) can be tested for using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.

----

# [Frustum](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Frustum.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Frustum.java)

A frustum is a four-sided pyramid with the top cut off. It can be used to describe the volume visible to a rectangular view into a space with a perspective projection such as the case with a 3D scene projected onto a 2D monitor.

Frustums can be useful for simplifying a scene by culling objects which do not intersect its volume and are therefore outside of the user's view. Simply pass the combined view-projection matrix of your camera to a frustum instance to create a frustum describing the viewing volume of the screen. libGDX then provides methods for testing points and simple collision volumes such as [bounding boxes](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/BoundingBox.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/BoundingBox.java) and [Spheres](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Sphere.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Sphere.java) against the volume of the frustum to determine visibility of scene objects. This is known as "frustum culling," a very common scene optimization technique.

----

# [Planes](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Plane.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Plane.java)

A plane is an infinite two-dimensional surface in three-dimensional space described by a point on that surface and a surface normal. Planes can be useful for partitioning spaces and determining in which sector an object resides. Intersection with a [ray](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Ray.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Ray.java) or line segment can be tested for using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.

----

# [Polygons](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Polygon.html)[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Polygon.java)

A simple class defining a two-dimensional polygon from a list of points. It can be easily translated, rotated, and scaled. It also provides the ability to test a point for containment within the polygon. Polygon to polygon intersection can be tested by using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class, assuming the polygons are convex.

----

# [Rays](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Ray.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Ray.java)

A ray is a line segment infinite in one direction. It is defined by an origin and a unit-length direction. Rays can be tested for intersection with [bounding boxes] (https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/BoundingBox.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/BoundingBox.java), [planes](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Plane.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Plane.java), [spheres](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Sphere.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Sphere.java), and triangles by using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.

Rays are particularly useful in picking operations. Cameras can provide a ray describing the current mouse or touch point in a window projected out into the scene from the point of view of the camera.

----

# [Rectangles](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Rectangle.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Rectangle.java)

A simple class which describes a two-dimensional axis-aligned rectangle described by its bottom-left corner point and a width and height. Provides the ability to test a point for containment within the rectangle. Rectangles can also be tested for intersection with other rectangles as well as with [circles](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Circle.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Circle.java) by using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.

----

# [Segments](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Segment.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Segment.java)

A simple class which describes a line segment in three-dimensional space defined by its two end points. Line segments can be tested for intersection with other line segments, [circles](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Circle.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Circle.java), and [planes](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Plane.html)[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Plane.java) by using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class. This class is merely for convenience in grouping end points as the above tests accept endpoints directly for parameters.

----

# [Spheres](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Sphere.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Sphere.java)

A simple class which describes a three-dimensional sphere defined by a center point and a radius. Can be tested for intersection with [Frustum](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Frustum.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Frustum.java) as well as [rays](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/collision/Ray.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/collision/Ray.java) by using the [Intersector](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/math/Intersector.java) class.