---
title: Bullet Wrapper Custom classes
---
In some cases it's not possible to wrap a C++ bullet class/method in a Java class/method, in which case a custom class or method is used to bridge the two. The following list describes those. Note that the list might not be complete.

### <a id="btCollisionObject"></a>btCollisionObject

The btCollisionObject is modified to reuse Java objects instead of creating a new Java object every time. This is done using the static `btCollisionObject.instances` map. To remove an object from the map and delete the native object use the `dispose` method.

Besides reusing instances, the Bullet wrappers allows you to provide a unique number to identify the instance. For example the index/ID of the entity in your entity system. Some frequently called methods allow you to use that value instead of the instance itself. This completely eliminates the overhead of mapping C++ and Java instances. You can set this value using the `setUserValue(int);` method and retrieve the value using the `getUserValue();` method.

```java
public class MyGameObject {
  public btCollisionObject body;
}
...
Array<MyGameObject> gameObjects;
...
gameObjects.add(myGameObject);
myGameObject.body.setUserValue(gameObjects.size-1);
```

You can use the `userData` field to add some additional data. For example:
```java
btCollisionObject obj = new btCollisionObject();
obj.userData = myGameObject;
...
if (obj.userData instanceof MyGameObject)
  myGameObject = (MyGameObject)obj.userData;
```

`btCollisionObject` adds the methods `takeOwnership` and `releaseOwnership` which can be used to remove or make the wrapper responsable for destroying the native object when the Java object is destroyed by the garbage collector.

The `btCollisionObject` also adds the following methods:
 * `getAnisotropicFriction(Vector3)`
 * `getWorldTransform(Matrix4)`
 * `getInterpolationWorldTransform(Matrix4)`
 * `getInterpolationLinearVelocity(Vector3)`
 * `getInterpolationAngularVelocity(Vector3)`
 * `getContactCallbackFlag()` and `setContactCallbackFlag(int)`
 * `getContactCallbackFilter()` and `setContactCallbackFilter(int)`

### ClosestNotMeConvexResultCallback
The `ClosestNotMeConvexResultCallback` class is a custom `ClosestConvexResultCallback` implementation which you can use to perform a `convexSweepTest` on all objects except the specified one.

### <a id="ClosestNotMeRayResultCallback"></a>ClosestNotMeRayResultCallback

The `ClosestNotMeRayResultCallback` class is a custom `ClosestRayResultCallback` implementation which you can use to perform a `rayTest` on all objects except the specified one.

### <a id="InternalTickCallback"></a>InternalTickCallback

The `InternalTickCallback` is implemented to bridge the callback required by `btDynamicsWorld#setInternalTickCallback` to a java class. You can extend the class and override `onInternalTick` method. You can use the `attach` and `detach` methods to start and stop getting tick callbacks.

### <a id="btDefaultMotionState"></a>btDefaultMotionState

In some cases it's easier to use `btDefaultMotionState` instead of extending `btMotionState`. The following custom methods are available for `btDefaultMotionState`.
 * `getGraphicsWorldTrans(Matrix4)`
 * `getCenterOfMassOffset(Matrix4)`
 * `getStartWorldTrans(Matrix4)`
Note that extending `btMotionState` with your own implementation is the preferred method.

### <a id="btCompoundShape"></a>btCompoundShape

The `btCompoundShape` class allows to keep a reference to child shapes, so you don't have to do that. To use it, use the `addChildShape` with the third `managed` argument set to true. Note that this will delete the managed child shape if the compound shape is deleted. Therefor the managed shapes should be exclusive for the compound shape.

### <a id="btIndexedMesh"></a>btIndexedMesh

The `btIndexedMesh` class adds the constructor:
 * `btIndexedMesh(Mesh)`
And the methods:
 * `setTriangleIndexBase(ShortBuffer)`
 * `setVertexBase(FloatBuffer)`
 * `set(Mesh)`
For easy constructing or setting a `btIndexedMesh` based on a `Mesh` instance or a vertex and index buffer. The buffers itself are not managed by the wrapper and should out-live the object.

### <a id="btTriangleIndexVertexArray"></a>btTriangleIndexVertexArray

The `btTriangleIndexVertexArray` class adds the ability to maintain a reference to the Java `btIndexedMesh` classes it holds. To use it call `addIndexedMesh` with the last argument `managed` set to true. When the `btTriangleIndexVertexArray` is destroyed it will also destroy it's managed `btIndexedMesh` children.

Also, the `btTriangleIndexVertexArray` class adds the `addMesh` and `addModel` methods and likewise constructors, for easy constructing and setting the class.

### <a id="btBvhTriangleMeshShape"></a>btBvhTriangleMeshShape

The `btBvhTriangleMeshShape` class adds the ability to maintain a reference to the Java `btStridingMeshInterface` class. To use it construct the class with the argument `managed` set to true. When the `btBvhTriangleMeshShape` is destroyed it will also destroy the managed `btStridingMeshInterface`.

Also, the `btBvhTriangleMeshShape` class add constructors for easy constructing one or more `Mesh` or `Model` instances.

### <a id="btConvexHullShape"></a>btConvexHullShape

The `btConvexHullShape` class adds a convenience constructor `btConvexHullShape(btShapeHull)`.

### <a id="btBroadphasePairArray"></a>btBroadphasePairArray

The `btBroadphasePairArray` class adds methods to get all collision objects within it at once:
```java
btBroadphasePairArray.getCollisionObjects(Array<btCollisionObject> out, btCollisionObject other, int[] tempArray)
btBroadphasePairArray.getCollisionObjectsValue(int[] out, btCollisionObject other)
```
### <a id="FilterableVehicleRaycaster"></a>FilterableVehicleRaycaster

The `FilterableVehicleRaycaster` class extends `btDefaultVehicleRaycaster` and adds support for collision filtering using groups and masks:
```java
FilterableVehicleRaycaster raycaster = new FilterableVehicleRaycaster(dynamicsWorld);
raycaster.setCollisionFilterGroup(FILTER_GROUP);
raycaster.setCollisionFilterMask(FILTER_MASK);
btRaycastVehicle vehicle = new btRaycastVehicle(vehicleTuning, chassis, raycaster);
```
