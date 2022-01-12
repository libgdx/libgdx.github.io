---
title: Models
---
A model represents a 3D asset consisting of a hierarchy of nodes, where each node is a combination of a geometry (mesh) and material. Optionally a model can also contain information about [animation and/or skinning](/wiki/graphics/3d/3d-animations-and-skinning).

A model is not intended to be rendered directly. Instead you should create one or more ModelInstances of a Model, which are used for the actual rendering. The structure of a ModelInstance is roughly the same as a Model.

## Nodes
A model is a hierarchical representation of nodes. In practice this means that a model contains an array of nodes and each node contains also an array of nodes. Nodes can be accessed using the public `nodes` array or using one of the `getNode(...)` methods. Each node has a unique `id` within a model.

Each Node can belong to only one Model or one ModelInstance at a time and is never shared amongst multiple Models or ModelInstances. Modifications to a Node of a ModelInstance will therefore only affect that particular ModelInstance. Modifications to a Node of a Model will affect that Model and all ModelInstances created from it after the modifications, but previously created ModelInstances from that Model remain unchanged.

### Node transformation
Nodes can be transformed (translate, rotate and/or scale), causing all child nodes to be also transformed. This transformation can be set while loading the model and/or changed programmatically. To change the transformation the node has a `translation` and `scale` vector and a `rotation` quaternion. When these values are changed the transformation (including all children) must be updated to reflect the changes. This can be done using the `model.calculateTransforms();` method (also available for the ModelInstance class).

When the Node transformations are calculated or recalculated, they are stored in the `localTransform` and `globalTransform` matrices. The `localTransform` matrix represents the transformation of the node relative to its parent node. The `globalTransform` matrix represents the transformation of the node relative to the model or modelinstance. In other words: the `globalTransform` of a Node is the `globalTransform` of its parent node multiplied by the node's `localTransform`.

When an animation is applied to a ModelInstance, the `isAnimated` value is set to true. This will cause the `translation`, `scale` and `rotation` values not to be used when recalculating the transforms.

### NodePart
A node can optionally have a visual representation. Therefor the Node class contains an array of NodeParts. Each NodePart consist of a MeshPart and Material, specifying how (the material) and where (the node transformation) the shape (the MeshPart) should be rendered. Optionally it also contains information about mesh deformation (used for skinning) and UV mapping (used for multiple texture coordinates).

## Managing resources
A model consists of one or more meshes and in most cases one or more textures. Both the Mesh and Texture classes (and potentially other resources) must be properly disposed when no longer needed. A model is responsible for disposing all the resources it contains. When no longer needed, a model should be disposed using it's `dispose();` method, causing all backing resources to be disposed and therefor invalidating all depending objects (like `ModelInstance`).

To get the list of Disposables a model is responsible for, use the `getManagedDisposables()` method. To programmatically make a model responsible for a resource, use the `manageDisposable(Disposable)` method. For example, when changing the texture of a model and you want the texture to be disposed when the model is disposed.

Because a model is responsible for its resources, it is recommended to keep them separated. For example, it is not advised to share resources amongst multiple models. Instead, in most cases it is possible to combine models completely (prior to loading or building them) or to share resources amongst ModelInstances instead of Models.
