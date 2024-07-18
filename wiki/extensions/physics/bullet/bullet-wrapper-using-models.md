---
title: Bullet Wrapper Using models
---
## Using models
[`Model`](/wiki/graphics/3d/models) and `ModelInstance` are typically used for the visual representation of objects. `btCollisionObject` or `btRigidBody` are used for the physical representation of these objects.

### Using motion states
To synchronize the location and orientation between a `ModelInstance` and `btRigidBody`, Bullet provides the `btMotionState` class that you can extend. A very basic example of such synchronization is:
```java
static class MyMotionState extends btMotionState {
    Matrix4 transform;
    @Override
    public void getWorldTransform (Matrix4 worldTrans) {
        worldTrans.set(transform);
    }
    @Override
    public void setWorldTransform (Matrix4 worldTrans) {
        transform.set(worldTrans);
    }
}
```
Which you can use as follows:
```java
btRigidBody body;
ModelInstance instance;
MyMotionState motionState;
...
motionState = new MyMotionState();
motionState.transform = instance.transform;
body.setMotionState(motionState);
```
Now the location and orientation of `ModelInstance` will be updated (by Bullet) whenever the `btRigidBody` moves. This approach is not restricted to `ModelInstance`, it will work for any object that contains a `Matrix4` transformation, like e.g. also `Renderable`. Moreover, it is possible to add simple logic to a motion state, for example:
```java
static class PlayerMotionState extends btMotionState {
    final static Vector3 position = new Vector3();
    Player player;
    @Override
    public void getWorldTransform (Matrix4 worldTrans) {
        worldTrans.set(player.transform);
    }
    @Override
    public void setWorldTransform (Matrix4 worldTrans) {
        player.transform.set(worldTrans);
        player.transform.getTranslation(position);
        if (position.y < 0)
            player.die();
    }
}
```
Note that the transformation (location and rotation) of a `btRigidBody` is typically relative to the center of mass (most commonly the center of the shape). When needed, a `btCompoundShape` can be used to move the center of mass. It is advised to keep the origin of the visual model the same as the origin of the physical object. If this is not possible, then you can modify the transformation in the motion state accordingly.

> Keep in mind that Bullet's transformation only supports translation (location) and rotation (orientation). Any other transformation, like scaling, is not supported.

The motion state has to be disposed when no longer needed: `motionState.dispose();`.

### Create a collision object from a model
A Model boils down to a bunch of triangles with some properties which are rendered with a specific transformation. It is optimized for rendering, not for physics. Therefore a Model is rarely useful for an efficient representation of a physics shape.

To understand why this is, consider a simple box model. The physics shape of a box would contain eight corners. The visual model however, will contain 24 corners (vertices). This is because the vertices are specified for each face of the box, where each vertex contains the "normal" of the face. Otherwise visual effects, like lighting, would not be possible. So, instead of a solid box, the visual model is actually made up of six independent rectangles. Theses rectangles (or the triangles it is made up) are infinitely thin, they have no volume. This makes it unsuitable for dynamic physics.

There are several more issues, e.g. a model typically contains more detail than would be needed for the physics. In fact, for some shapes it is possible to use a much cheaper collision detection algorithm than using the model's vertices. For example, in case of the box shape, it would be possible to use a single detection against a box, instead of a detection against the 12 triangles it is made of.

There are several ways to work around these problems, ranging from approximating a model using primitive shapes to using a dedicated model or sharing vertices between visual model and physics shape. The [Bullet manual](https://github.com/bulletphysics/bullet3/blob/master/docs/Bullet_User_Manual.pdf?raw=true)
provides a decision chart to help you decide which method you should choose:
![images/bullet_shape_decision.png](/assets/wiki/images/bullet_shape_decision.png)

For the case of a static model, the Bullet wrapper provides a convenient method to create a collision shape of it:
```java
btCollisionShape shape = Bullet.obtainStaticNodeShape(model.nodes);
```
In this case the collision shape will share the same data (vertices) as the model. This will include [node transformation](/wiki/graphics/3d/models#node-transformation) by using a `btCompoundShape` if needed, but will not include any scaling applied to nodes.
