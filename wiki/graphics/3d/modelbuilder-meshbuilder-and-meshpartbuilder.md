---
title: ModelBuilder, MeshBuilder and MeshPartBuilder
---
# ModelBuilder
[ModelBuilder](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/ModelBuilder.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/ModelBuilder.java) is a utility class to create one or more [models](/wiki/graphics/3d/models) on code. It allows you to include one or more [nodes](/wiki/graphics/3d/models#nodes), each node consisting of one or more [parts](/wiki/graphics/3d/models#nodepart). It does, however, not support building a node hierarchy (child nodes). Be aware that building a model on code can be a costly operation and might trigger the garbage collector.
## Building one or more models
To start building a model use the `begin()` method, after which you must call the `end()` when you're done building the model. The `end()` method will return the newly created model. You can build multiple models using the same ModelBuilder, but not at the same time. For example:
```java
ModelBuilder modelBuilder = new ModelBuilder();

modelBuilder.begin();
... //build one or more nodes
Model model1 = modelBuilder.end();

modelBuilder.begin();
... //build one or more nodes
Model model2 = modelBuilder.end();
```
## Managing resources
Keep in mind that models contain one or more meshes and therefore [needs to be disposed](/wiki/graphics/3d/models#managing-resources). A model built via ModelBuilder will always be responsible for disposing all meshes it contains, even if you provide the Mesh yourself. Do not share a Mesh along multiple Models.

A Model built via ModelBuilder will not be made responsible for disposing any textures or any other resources contained in the [materials](/wiki/graphics/3d/material-and-environment). You can, however, use the `manage(disposable)` method to make the model responsible for disposing those resources. For example:
```java
ModelBuilder modelBuilder = new ModelBuilder();
modelBuilder.begin();
Texture texture = new Texture(...);
modelBuilder.manage(texture);
... //build one or more nodes
Model model = modelBuilder.end();
... //use the model and when done:
model.dispose(); // this will dispose the texture as well
```
## Creating nodes
A Model consists of one or more [nodes](/wiki/graphics/3d/models#nodes). To start building a new node inside the model you can use the `node()` method. This will add a new node and make it active for building. It will also return the [`Node`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/model/Node.html) so you can reference it for later use or for example set its `id`.
```java
ModelBuilder modelBuilder = new ModelBuilder();
modelBuilder.begin();
Node node1 = modelBuilder.node();
node1.id = "node1";
node1.translation.set(1, 2, 3);
...//build node1
Node node2 = modelBuilder.node();
node2.id = "node2";
...//build node2
Model model = modelBuilder.end();
```
Note that node id's should unique within the model. A typical use-case would be:
```java
ModelBuilder modelBuilder = new ModelBuilder();
modelBuilder.begin();
modelBuilder.node().id = "node1";
...//build node1
modelBuilder.node().id = "node2";
...//build node2
Model model = modelBuilder.end();
```
Using the `node()` method for the first node is optional. For example, for models consisting of only a single node, you can immediately start creating the node parts without having to call the `node()` method.

There can only be one `Node` active for building at a time. Calling the `node()` method will stop building the previous node (if any) and start building the newly created node. The nodes will only be valid (complete), however, after the Model is completely built (the call to `end()` is made).

## Creating node parts
A `Node` can contain one or more [parts](/wiki/graphics/3d/models#nodepart). Each part of a node will be rendered at the same location (the [node transformation](/wiki/graphics/3d/models#node-transformation)), but can be made up of a different [material](/wiki/graphics/3d/material-and-environment) (e.g. shader uniforms) and/or mesh (e.g. shader (vertex) attributes).

> A NodePart is the smallest renderable part of a Model. Every visible NodePart implies a render call (or "draw call" if you prefer). Reducing the number of render calls can help to decrease the time it takes to render the model. Therefore it is advised to try to combine multiple parts to a single part where possible.

To add a [`NodePart`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/model/NodePart.html) to the current node you can use one of the `part(...)` methods. A NodePart is basically the combination of a [`MeshPart`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/model/MeshPart.html) and [`Material`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/Material.html). You must always supply the material when calling one of the `part(...)` methods. For the `MeshPart`, however, `ModelBuilder` allows you to either specify the (part of the) mesh yourself, or to start building the `MeshPart` using a `MeshPartBuilder`.

> Keep in mind that the `Model` will always be made responsible for disposing the `Mesh`, regardless the method used to create part.

A `MeshPartBuilder` is an interface (implemented by `MeshBuilder`, see below) which contains various helper methods to create a mesh. If you use the `part(...)` method to construct the MeshPart using a MeshPartBuilder, then ModelBuilder will try to combine multiple parts into the same Mesh. This will in most cases reduce the number of Mesh binds. This is only possible if the parts are made up using the same vertex attributes. For example:
```java
ModelBuilder modelBuilder = new ModelBuilder();
modelBuilder.begin();
MeshPartBuilder meshBuilder;
meshBuilder = modelBuilder.part("part1", GL20.GL_TRIANGLES, Usage.Position | Usage.Normal, new Material());
meshBuilder.cone(5, 5, 5, 10);
Node node = modelBuilder.node();
node.translation.set(10,0,0);
meshBuilder = modelBuilder.part("part2", GL20.GL_TRIANGLES, Usage.Position | Usage.Normal, new Material());
meshBuilder.sphere(5, 5, 5, 10, 10);
Model model = modelBuilder.end();
```
This will create a model consisting of two nodes. Each node consisting of one part. The Mesh of both parts is shared, so there's only a single Mesh created for this Model. Note that in this example the vertex attributes are specified using a bit mask, which will cause `ModelBuilder` to create default (3D) `VertexAttributes`. You could also specify the [`VertexAttributes`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/VertexAttributes.html) yourself.

> Because `ModelBuilder` reuses the `MeshPartBuilder` instances for multiple parts, you cannot build multiple parts at the same time. Per `ModelBuilder` you can only build one `Model`, `Node` and `MeshPart` at any given time. **Calling the `part(...)` method will make the previous `MeshPartBuilder` invalid.**

See the MeshPartBuilder section below for more information on how to use the `MeshPartBuilder` to create the shape of the part.
# MeshBuilder
[MeshBuilder](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/MeshBuilder.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/MeshBuilder.java) is a utility class to create one or more [meshes](/wiki/graphics/opengl-utils/meshes), optionally consisting of one or more [MeshParts](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/model/MeshPart.html). While a `MeshBuilder` is typically constructed and maintained by the `ModelBuilder` using the `ModelBuilder#part(...)` method, it is possible to use `MeshBuilder` without using a `ModelBuilder`. For this, you can use the `begin(...)` method to start building a mesh, after which you must call the `end()` method when you're done building the mesh. The begin methods accepts various arguments to specify the vertex attributes and optionally primitive type (required when not creating mesh part(s)). The `end()` method will return the newly created [`Mesh`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/Mesh.html). You can build multiple meshes using the same `MeshBuilder` instance, but not at the same time:
```java
MeshBuilder meshBuilder = new MeshBuilder();
meshBuilder.begin(Usage.Position | Usage.Normal, GL20.GL_TRIANGLES);
...//build the first mesh
Mesh mesh1 = meshBuilder.end();

meshBuilder.begin(Usage.Position | Usage.Normal | Usage.ColorPacked, GL20.GL_TRIANGLES);
...//build the second mesh
Mesh mesh2 = meshBuilder.end();
```

> Keep in mind that the `Mesh` must be disposed when you no longer need it.

Use the `part(...)` method to create a Mesh consisting of multiple parts. This will create a new `MeshPart` and set it active for building.
```java
MeshBuilder meshBuilder = new MeshBuilder();
meshBuilder.begin(Usage.Position | Usage.Normal);
MeshPart part1 = meshBuilder.part("part1", GL20.GL_TRIANGLES);
... // build the first part
MeshPart part2 = meshBuilder.part("part2", GL20.GL_TRIANGLES);
... // build the second part
Mesh mesh = meshBuilder.end();
```
While the `part(...)` method returns the `MeshPart` so you can reference it for later use, it will not be valid until the `end()` method is called. You can only create one `MeshPart` at a time, calling the `part(...)` method will stop building the previous part and start building the new part.

All parts of the same `Mesh` share the same `VertexAttributes`. The primitive type can vary among parts though. For example, the following snippet creates two parts each with a different primitive type, but sharing the same mesh:
```java
meshBuilder.begin(Usage.Position | Usage.Normal);
MeshPart part1 = meshBuilder.part("part1", GL20.GL_TRIANGLES);
... // build the first part
MeshPart part2 = meshBuilder.part("part2", GL20.GL_TRIANGLE_STRIP);
... // build the second part
Mesh mesh = meshBuilder.end();
```

`MeshBuilder` implements `MeshPartBuilder`. Creating the actual shape of the (part of the) mesh, is described in the MeshPartBuilder section.

# MeshPartBuilder
[MeshPartBuilder](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/MeshPartBuilder.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/MeshPartBuilder.java)) is a utility interface which supplies various methods for creating a (part of a) mesh. You can either use `ModelBuilder.part(...)` or construct a `MeshBuilder` to obtain a `MeshPartBuilder`. All methods of the `MeshPartBuilder` interface can only be called as long as the `MeshPart` is being build (most commonly between the call to the `part(...)` method and the call to the next `part(...)` or `end()` method of either `ModelBuilder` or `MeshBuilder`).

Use the `getMeshPart()` method to obtain the `MeshPart` currently being build.
Use the `getAttributes()` method to obtain the `VertexAttributes` of the `Mesh` being build.

A `VertexAttribute` of `Usage.Position` (either 2D or 3D) is required. There are no further restriction on the specified vertex attributes. However, most (especially higher level) methods are only implemented for position, normal, color (either packed or unpacked) and texture coordinates attributes. If you use other attributes as well, then a default (commonly zero) value will be used.

Most methods allow multiple signatures to specify the values for the vertex attributes. A little helper class [`VertexInfo`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/MeshPartBuilder.VertexInfo.html) is used to specify these on a per vertex basis. For example the `rect(...)` method accepts a `VertexInfo` for each corner, instead of using a method with all possible combinations or arguments for the vertex values of each corner. Be aware that the `VertexInfo` keeps track of whether a specific value has been set, therefor you should always use the setXXX methods. Use `null` in case you want to unset a value.

Use the `setColor(...)` method to specify the default color that will be used when the `VertexAttributes` contain a color `VertexAttribute`, but no color is set in e.g. the `VertexInfo`. For example:
```java
meshPartBuilder.setColor(Color.RED);
VertexInfo v1 = new VertexInfo().setPos(0, 0, 0).setNor(0, 0, 1).setCol(null).setUV(0.5f, 0.0f);
VertexInfo v2 = new VertexInfo().setPos(3, 0, 0).setNor(0, 0, 1).setCol(null).setUV(0.0f, 0.0f);
VertexInfo v3 = new VertexInfo().setPos(3, 3, 0).setNor(0, 0, 1).setCol(null).setUV(0.0f, 0.5f);
VertexInfo v4 = new VertexInfo().setPos(0, 3, 0).setNor(0, 0, 1).setCol(null).setUV(0.5f, 0.5f);
meshPartBuilder.rect(v1, v2, v3, v4);
```
In this example, because the `VertexInfo` has no color set (`setCol(null)`), the default will be used which is set to a red color.

Use the `setUVRange` to specify the default texture coordinates range that will be used when no texture coordinates are specified. Along with the default color, this is especially useful for simple shapes where only positions are needed and other vertex information can be derived from the shape. For example:
```java
meshPartBuilder.setColor(Color.RED);
meshPartBuilder.setUVRange(0.5f, 0f, 0f, 0.5f);
meshPartBuilder.rect(0,0,0, 3,0,0, 3,3,0, 0,3,0, 0,0,1); // the last three arguments specify the normal
```
Use the `setVertexTransform(...)` method to supply a transformation matrix that should be applied to all vertices following after that call.
