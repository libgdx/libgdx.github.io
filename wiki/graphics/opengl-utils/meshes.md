---
title: Meshes
---
A [mesh](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Mesh.html) is a collection of vertices (and optionally indices) which describe a batch of geometry for rendering. The vertices are held either in VRAM in form of vertex buffer objects (VBOs) or in RAM in form of vertex arrays. VBOs are faster and are used by default if the hardware supports it. Like [Textures](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html), meshes are managed and will be automatically reloaded when the context is lost.

Meshes are used by many core graphics classes in Libgdx, such as [SpriteBatch](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g2d/SpriteBatch.html) and [DecalBatch](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/decals/DecalBatch.html) as well as the various 3D format loaders. A key design principle of libGDX is in storing geometry in a mesh in order to upload all vertex information in one batch for rendering. Especially on mobile platforms, there are significant performance gains in batching by reducing the overhead of individual draw calls.

## Creating a Mesh

Sometimes a procedural mesh is preferred over the use of an imported model from a 3D modeling application. The following code creates a simple full screen quad often useful for frame-based shader effects:

```java
public Mesh createFullScreenQuad() {

  float[] verts = new float[20];
  int i = 0;

  verts[i++] = -1; // x1
  verts[i++] = -1; // y1
  verts[i++] = 0;
  verts[i++] = 0f; // u1
  verts[i++] = 0f; // v1

  verts[i++] = 1f; // x2
  verts[i++] = -1; // y2
  verts[i++] = 0;
  verts[i++] = 1f; // u2
  verts[i++] = 0f; // v2

  verts[i++] = 1f; // x3
  verts[i++] = 1f; // y2
  verts[i++] = 0;
  verts[i++] = 1f; // u3
  verts[i++] = 1f; // v3

  verts[i++] = -1; // x4
  verts[i++] = 1f; // y4
  verts[i++] = 0;
  verts[i++] = 0f; // u4
  verts[i++] = 1f; // v4

  Mesh mesh = new Mesh( true, 4, 0,  // static mesh with 4 vertices and no indices
    new VertexAttribute( Usage.Position, 3, ShaderProgram.POSITION_ATTRIBUTE ),
    new VertexAttribute( Usage.TextureCoordinates, 2, ShaderProgram.TEXCOORD_ATTRIBUTE+"0" ) );

  mesh.setVertices( verts );
  return mesh;
}
// original code by kalle_h
```

Notice the use of a simple `float` array to build the basic vertex information. We define four vertices each composed of a position in window coordinates as well as a texture coordinate. Next we tell the mesh constructor this will be a static mesh with 4 vertices and no indices. We define two vertex attributes, stating their respective sizes and describing their properties using the built-in libGDX constants for common attribute types. The usage constants tell libGDX how to interpret each of the float values so that it can point OpenGL at the proper data when rendering. Note that in OpenGL ES2, the use of [Shaders](/wiki/graphics/opengl-utils/shaders) does free one up to include other types of attributes in vertices (ie. vertex illumination values in a baked vertex-lighting situation, or even physical properties like mesh flexibility for simple wind based vertex animation). Finally we set the the mesh vertices using our previously built `float` array.

Notice also the use of ShaderProgram constants to name the attributes. While not mandatory, it can be useful to maintain the same name for shader attributes for common properties such as vertex positions, normals, or texture coordinates as these are the names used across common libGDX shaders. This naming uniformity can help when one wants to swap shaders on the same meshes. See [Shaders](/wiki/graphics/opengl-utils/shaders) for more information.

## Rendering

To render a mesh, simply set up the environment and call render with the desired primitive type. To render the above full-screen quad, we use a triangle fan (because that was how we structured the vertex positions):

```java
mesh.render( GL10.GL_TRIANGLE_FAN );
```

More typically you will render with other primitives:

```java
mesh.render( GL10.GL_TRIANGLES );           // OpenGL ES1.0/1.1

mesh.render( shader, GL20.GL_TRIANGLES );   // OpenGL ES2 requires a shader

mesh.render( shader, GL20.GL_LINES );       // renders lines instead
```

By default, a mesh will auto-bind its data upon a call to `render()`. Prior to calling `render()`, you will need to bind the texture and set model transformations and if using OpenGL ES2 you will need bind an appropriate [Shaders](/wiki/graphics/opengl-utils/shaders) and pass whatever uniforms it requires.
