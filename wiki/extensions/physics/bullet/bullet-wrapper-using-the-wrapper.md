---
title: Bullet Wrapper Using the wrapper
---
## <a id="Initializing_Bullet"></a>Initializing Bullet ##

Before you can use Bullet, you’ll need to load the libraries. This can be done by adding the following line in your create method:
```java
Bullet.init();
```

Be aware not to use bullet before it is initialized. For example, the following will result in an error because the `btGhostPairCallback` is created before the library is loaded.
```java
public class InvokeRuntimeExceptionTest {
  final static btGhostPairCallback ghostPairCallback = new btGhostPairCallback();
}
```

## <a id="Working_with_Bullet_wrapper"></a>Working with Bullet wrapper ##
The wrapper tends to follow the original bullet class names. Meaning that most classes are prefixed with “bt”. There are a few exceptions on this, which are mostly nested structs. These are custom implemented directly into the `com.badlogic.gdx.physics.bullet` package. Unfortunately some nested structs and some base classes are not suitable for a one on one translation. See the custom classes section for more information on that. If you find a class that is missing you can post it on the forums or issue tracker (https://github.com/libgdx/libgdx/issues), so it can be added to the wrapper.

## <a id="Callbacks"></a>Callbacks ##

Callbacks require some special attention. By default the wrapper only supports a one way interaction (from Java to C++). Callback interfaces, where C++ needs to call Java code are custom implemented. If you find a callback interface that isn't implemented yet, you can post it on the forums so it can be added to the wrapper.

List of callback interfaces (might not be complete):
 * `LocalShapeInfo`
 * `LocalRayResult`
 * `RayResultCallback`
 * `ClosestRayResultCallback`
 * `AllHitsRayResultCallback`
 * `LocalConvexResult`
 * `ConvexResultCallback`
 * `ClosestConvexResultCallback`
 * `ContactResultCallback`
 * `btMotionState`
 * `btIDebugDraw`
 * `InternalTickCallback`
 * `ContactListener`
 * `ContactCache`

## <a id="Properties"></a>Properties ##
Properties are encapsulated by getter and setter methods. The naming of the getter and setter methods omits the `m_` prefix. For example, the `m_collisionObject` member of the native class `btCollisionObjectWrapper` is implemented as `getCollisionObject()` and `setCollisionObject(...)`.

## <a id="Creating_and_destroying_objects"></a>Creating and destroying objects ##
Every time you create a bullet class in Java it also creates the corresponding class in C++. While the Java object is maintained by the garbage collector, the C++ object isn’t. To avoid having orphaned C++ objects resulting in memory leaks, the C++ object is by default automatically destroyed when the Java object is destroyed by the garbage collector. 

While this might be useful in some cases, it’s merely a fail-safe and you shouldn't rely on it. Since you can’t control the garbage collector, you can’t control _if_, _when_ and _in which order_ the objects are actually being destroyed. Therefore the wrapper logs an error when an object is automatically destroyed by the garbage collector. You can disable this error logging using the second argument of the `Bullet.init()` method, but you should preferably use the method in the following paragraph.

In order to ensure correct garbage collection you should keep a reference to every object you create until it’s not needed anymore and then destroy it yourself. You can destroy the C++ object by calling the `.dispose()` method on the Java object, after which you should remove all references to the Java object since it’s unusable after that. 

The above is only true for the objects you are responsible of, which are all Bullet classes you create with the `new` keyword as well as classes you create using helper methods. You don’t have to dispose objects that are returned by regular methods or provided to you in callback methods.

## <a id="Referencing_objects"></a>Referencing objects ##
As stated above, you should keep a reference to every Bullet class and call the dispose method when it’s no longer needed. When your application becomes more complex and objects are shared amongst multiple other objects, it can become difficult to keep track of references. Therefore the bullet wrapper support reference counting.

Reference counting is disabled by default. To enable it, call `Bullet.init();` with the first argument set to true:
```java
Bullet.init(true);
```

When using reference counting, you must call the `obtain()` method on each object you need to reference. When you no longer need to reference an object, you must call the `release()` method. The release method will dispose the object if it’s doesn't have any more references to it.

Some wrapper classes help you in managing references. For example the `btCompoundShape` class obtains a reference to all its child shapes and releases them when it is disposed.

## <a id="Extending_classes"></a>Extending classes ##
You can extend the bullet classes, but it’s recommended not to do so except for callback classes (in which case you should only override the intended methods). The information you add to a class is not available in C++. Furthermore the result of any method of the bullet wrapper that returns a class you’ve overridden will not implement that class. For example:
```java
btCollisionShape shape = collisionObjectA.getCollisionShape();
```

This will create a new Java btCollisionShape class which doesn’t implement any extended class.

There is one exception to this for btCollisionObject, where the wrapper tries to reuse the same Java class. Furthermore the Java implementation of the btCollisionObject class adds a `userData` member which can be used to attach additional data to the object. To accomplish this the wrapper maintains an array with references to all btCollisionObject instances. You can access that array using the static field `btCollisionObject.instances`. Check the btCollisionObject `./Bullet Wrapper: Custom classes#btcollisionobject` section for detailed information on this.

The upcast methods are not present because of a [issue](https://code.google.com/archive/p/libgdx/issues/1453). There is no need for them for classes that are created in java. These classes can directly be casted.

## <a id="Comparing_classes"></a>Comparing classes ##
You can compare wrapper classes using the `equals()` method, which checks if the classes both wrap the same native class. To get the pointer to the underlying C++ class you can use the `getCPointer` method of the specific object. You can also compare these pointers to check whether the Java classes wrap the same C++ class.

## <a id="Common_classes"></a>Common classes ##
Bullet uses some classes also available in the libGDX core. While these bullet classes are available for you to use, the wrapper tries to use the libGDX class where possible. Currently these are implemented for:

| *Bullet* | *Libgdx* |
|:--------:|:--------:|
| btVector3 | Vector3 |
| btQuaternion | Quaternion |
| btMatrix3x3 | Matrix3 |
| btTransform | Matrix4 |
| btScalar | float |

<sub>Note that the conversion from Matrix4 to btTransform might lose some information, because btTransform only contains an origin and rotation. In addition, note that btScalar is synonym for the primitive type float.</sub>

To avoid creating objects for these common classes, the wrapper reuses the same instances. Therefore, be aware of the following two cases:

 1. The result of wrapper methods that return such a class are overwritten by the next method that returns the same type:
```java
// Wrong method:
Matrix4 transformA = collisionObjectA.getWorldTransform();
// transformA now holds the worldTransform of collisionObjectA
Matrix4 transformB = collisionObjectB.getWorldTransform();
// transformA and transformB are the same object and now holds the worldTransform of collsionObjectB

// Correct method:
transformA.set(collisionObjectA.getWorldTransform());
transformB.set(collisionObjectB.getWorldTransform());
```
 2. The arguments of interface callbacks with arguments of such a class are unusable after the call:
```java
// Wrong method:
@Override
public void setWorldTransform (final Matrix4 worldTrans) {
	transform = worldTrans;
}
// Correct method:
@Override
public void setWorldTransform (final Matrix4 worldTrans) {
	transform.set(worldTrans);
}
```

## <a id="Using_arrays"></a>Using arrays ##
Where possible the wrapper uses direct ByteBuffer objects to pass arrays from Java to C++. This avoids copying the array on the call and allows you to share the same byte buffer for both OpenGL ES and Bullet. If needed you can create a new ByteByffer using `BufferUtils.newUnsafeByteBuffer`, which you should manually delete using `BufferUtils.disposeUnsafeByteBuffer`.

In cases where ByteBuffer can't be used or is unwanted, a normal array is used. By default this means that the array is copied using iteration from Java to C++ at start of the method and copied back at the end of the method. To avoid this overhead the wrapper tries to use the Java array directly from within C++ where possible using critical arrays. During such method Java garbage collecting is blocked. An example of such method is `btBroadphasePairArray.getCollisionObjects`.