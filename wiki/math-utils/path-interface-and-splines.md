---
title: Path interface and Splines
---
# Introduction

The [Path interface](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Path.html) [(code)](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Path.html) have implementations that allows you to traverse smoothly through a set of defined points (in some cases, tangents too).

Paths can be defined to be bi-dimensional or tri-dimensional, because it is a template that takes a derived of the Vector class, thus you can either use it with a set of Vector2's or Vector3's.

Mathematically, it is defined as F(t) where t is [0, 1], where 0 is the start of the path, and 1 is the end of the path.

# Types

As of v0.9.9, we have 3 implementations of the Path interface (the splines), these are:
* [Bezier](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/Bezier.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/Bezier.java)
* [BSpline](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/BSpline.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/BSpline.java)
* [CatmullRomSpline](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/math/CatmullRomSpline.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/math/CatmullRomSpline.java)

# Use

Splines can be used statically like this:

```java
    Vector2 out = new Vector2();
    Vector2 tmp = new Vector2();
    Vector2[] dataSet = new Vector2[size];
    /* fill dataSet with path points */
    CatmullRomSpline.calculate(out, t, dataSet, continuous, tmp);// stores in the vector out the point of the catmullRom path of the dataSet in the time t. Uses tmp as a temporary vector. if continuous is true, the path is a loop.
    CatmullRomSpline.derivative(out, t, dataSet, continuous, tmp); // the same as above, but stores the derivative of the time t in the vector out
```

or they can be stored like this:

```java
    CatmullRomSpline<Vector2> myCatmull = new CatmullRomSpline<Vector2>(dataSet, true);
    Vector2 out = new Vector2();
    myCatmull.valueAt(out, t);
    myCatmull.derivativeAt(out, t);
```

It is preferred that you do the second way, since it's the only way guaranteed by the Path interface.

# Snippets

### Caching a spline

This is often done at loading time, where you load the data set, calculates the spline and stores the points calculated. So you only evaluates the spline once. Trading memory for CPU time. (You usually should always cache if drawing static things)

```java
/*members*/
    int k = 100; //increase k for more fidelity to the spline
    Vector2[] points = new Vector2[k];
/*init()*/
    CatmullRomSpline<Vector2> myCatmull = new CatmullRomSpline<Vector2>(dataSet, true);
    for(int i = 0; i < k; ++i)
    {
        points[i] = new Vector2();
        myCatmull.valueAt(points[i], ((float)i)/((float)k-1));
    }
```

### Rendering cached spline

How to render the spline previously cached

```java
/*members*/
    int k = 100; //increase k for more fidelity to the spline
    Vector2[] points = new Vector2[k];
    ShapeRenderer shapeRenderer;
/*render()*/
    shapeRenderer.begin(ShapeType.Line);
    for(int i = 0; i < k-1; ++i)
    {
        shapeRenderer.line(points[i], points[i+1]);
    }
    shapeRenderer.end();
```

### Calculating on the fly

Do everything at render stage

```java
/*members*/
    int k = 100; //increase k for more fidelity to the spline
    CatmullRomSpline<Vector2> myCatmull = new CatmullRomSpline<Vector2>(dataSet, true);
    Vector2 out = new Vector2();
    ShapeRenderer shapeRenderer;
/*render()*/
    shapeRenderer.begin(ShapeType.Line);
    for(int i = 0; i < k-1; ++i)
    {
        shapeRenderer.line(myCatmull.valueAt(points[i], ((float)i)/((float)k-1)), myCatmull.valueAt(points[i+1], ((float)(i+1))/((float)k-1)));
    }
    shapeRenderer.end();
```

### Make sprite traverse through the cached path

This way uses a LERP through the cached points. It looks roughly sometimes but is very fast.

```java
/*members*/
    float speed = 0.15f;
    float current = 0;
    int k = 100; //increase k for more fidelity to the spline
    Vector2[] points = new Vector2[k];

/*render()*/
    current += Gdx.graphics.getDeltaTime() * speed;
    if(current >= 1)
        current -= 1;
    float place = current * k;
    Vector2 first = points[(int)place];
    Vector2 second;
    if(((int)place+1) < k)
    {
        second = points[(int)place+1];
    }
    else
    {
        second = points[0]; //or finish, in case it does not loop.
    }
    float t = place - ((int)place); //the decimal part of place
    batch.draw(sprite, first.x + (second.x - first.x) * t, first.y + (second.y - first.y) * t);
```

### Make sprite traverse through path calculated on the fly

Calculate sprite position on the path every frame, so it looks much more pleasant (you usually should always calculate on the fly if drawing dynamic things)

```java
/*members*/
    float speed = 0.15f;
    float current = 0;
    Vector2 out = new Vector2();
/*render()*/
    current += Gdx.graphics.getDeltaTime() * speed;
    if(current >= 1)
        current -= 1;
    myCatmull.valueAt(out, current);
    batch.draw(sprite, out.x, out.y);
```

### Make sprite look at the direction of the spline

The angle can be found when applying the atan2 function to the normalised tangent(derivative) of the curve.

```java
    myCatmull.derivativeAt(out, current);
    float angle = out.angle();
```

### Make the sprite traverse at constant speed

As the arc-length of the spline through the dataSet points is not constant, when going from 0 to 1 you may notice that the sprite sometimes goes faster or slower, depending on some factors. To cancel this, we will change the rate of change of the time variable.
We can easily do this by dividing the speed by the length of the rate of change.
Instead of

```java
    current += Gdx.graphics.getDeltaTime() * speed;
```

change to:

```java
    myCatmull.derivativeAt(out, current);
    current += (Gdx.graphics.getDeltaTime() * speed / myCatmull.spanCount) / out.len();
```

You should change the speed variable too, since it doesn't take a "percent per second" value anymore, but a "meter(pixel?) per second") now. The spanCount is necessary since the derivativeAt method takes into account the current span only.