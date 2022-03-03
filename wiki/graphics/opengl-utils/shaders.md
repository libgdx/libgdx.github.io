---
title: Shaders
---
If you want to work with OpenGL ES 2.0, you should know some shader basics. libGDX comes with a standard shader that will take care of rendering things via `SpriteBatch`. However, if you'd like to render a `Mesh` in OpenGL ES 2.0 you will have to supply a valid shader yourself. Basically, in OpenGL ES 2.0, everything is rendered with shaders. That's why it's called a programmable pipeline.

The thought of dabbling around in shaders might scare some people away from using ES 2.0, but it's well worth reading up on it as shaders allow you to do some pretty incredible things. And understanding the basics is actually quite straightforward.

## What are shaders?

Shaders in OpenGL are little programs written in a C-like language called **GLSL** (OpenGL Shading Language) that runs on the GPU and processes the data necessary to render things. A shader can simply be viewed as a processing stage on the GPU. It receives a set of inputs which you can do a set of operations on and finally sends them back out. Think of this like function parameters and return values.

Typically, when rendering something in OpenGL ES 2.0 the data will be sent through the **vertex** shader first and then through the **fragment** shader.

## Vertex shaders

As the name implies, vertex shaders are responsible for performing operations on vertices. More specifically, each execution of the program operates on exactly _one_ vertex. This is an important concept to understand. Everything you do in the vertex shader happens only on exactly _one_ vertex.

Here's a simple vertex shader:

```cpp
attribute vec4 a_position;

uniform mat4 u_projectionViewMatrix;

void main()
{
    gl_Position =  u_projectionViewMatrix * a_position;
} 
```

That doesn't look too bad, now does it? First, you have a vertex attribute called `a_position`. This attribute is a `vec4` which means it's a vector with 4 dimensions. In this sample, it holds the position information of the vertex.

Next, you have the `u_projectionViewMatrix`. This is a 4x4 matrix that holds the view and projection transform data. If those terms sound fuzzy to you I'd recommend [reading up on those topics here](https://web.archive.org/web/20210330141121/http://blog.db-in.com/cameras-on-opengl-es-2-x/). It's incredibly useful to understand it.

Inside the main method, we execute the operations on the vertex. In this case, all the shader does is multiply the vertex position with the matrix and assigns it to `gl_Position`. `gl_Position` is a predefined keyword by OpenGL and can't be used for anything else but passing through the processed vertex.

## Fragment shaders
A fragment shader functions in a very similar way to a vertex shader. But instead of processing it on a vertex it processes it once for each fragment. For simplicity's sake think of a fragment as one pixel. Now, you might notice that this is a very significant difference.

Let's say a triangle covers an area of 300 pixels. The vertex shader for this triangle would be executed 3 times. The fragment shader though would be executed 300 times. So when writing shaders, keep this in mind. Everything done in the fragment shader will be exponentially more expensive!

Here's a very basic fragment shader:

```cpp
void main()
{
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
```

This fragment shader will simply render every fragment with solid red. gl_FragColor is another pre-defined keyword. It's used to output the final color for the fragment. Notice how we use `vec4(x, y, z, w)` to define a vector inside the shader. In this case, the vector is used to define the color of the fragment.

## A simple ShaderProgram

Now that we have a basic understanding of what shaders do and how they work, let's create one in libGDX. This is done with the `ShaderProgram` class. A `ShaderProgram` is made up of a vertex shader and a fragment shader. You can either load from a file or just pass in a string and keep the shader code inside your Java files.

This is the shader setup we'll be working with:

```java
String vertexShader = "attribute vec4 a_position;" +
                      "attribute vec4 a_color;" +
                      "attribute vec2 a_texCoord0;" +
                      "uniform mat4 u_projTrans;" +
                      "varying vec4 v_color;" +
                      "varying vec2 v_texCoords;" +
                      "void main()" +
                      "{" +
                          "v_color = vec4(1, 1, 1, 1);" +
                          "v_texCoords = a_texCoord0;" +
                          "gl_Position =  u_projTrans * a_position;" +
                      "}";
String fragmentShader = "#ifdef GL_ES\n" +
                        "precision mediump float;" +
                        "#endif\n" +
                        "varying vec4 v_color;" +
                        "varying vec2 v_texCoords;" +
                        "uniform sampler2D u_texture;" +
                        "void main()" +
                        "{" +
                            "gl_FragColor = v_color * texture2D(u_texture, v_texCoords);" +
                        "}";
```

This is fairly standard setup for a shader that uses a position attribute, a color attribute and a texture coordinate attribute. Notice the 2 `varying`. They are outputs that we pass through to the fragment shader.

In the fragment shader, we have a `sampler2D`; this is a special uniform used for textures. As you can see in the main function, we multiply the vertex color with the color from the texture lookup to produce the final output color.

Here is a list of attributes that are in libGDX's own library for those who wish to easily attach shaders to `SpriteBatch`es and other parts of libGDX:
* `a_position`
* `a_normal`
* `a_color`
* `a_texCoord`, requires a number at the end, i.e. `a_texCoord0`, `a_texCoord1`, etc.
* `a_tangent`
* `a_binormal`

To create the `ShaderProgram` we do the following:

```java
ShaderProgram shader = new ShaderProgram(vertexShader, fragmentShader);
```

You can ensure that the shader compiled properly via `shader.isCompiled()`. A compile log can be spit out using `shader.getLog()`.

We also create a matching mesh and load the texture:

```java
mesh = new Mesh(true, 4, 6, VertexAttribute.Position(), VertexAttribute.ColorUnpacked(), VertexAttribute.TexCoords(0));
mesh.setVertices(new float[] {
    -0.5f, -0.5f, 0, 1, 1, 1, 1, 0, 1,
    0.5f, -0.5f, 0, 1, 1, 1, 1, 1, 1,
    0.5f, 0.5f, 0, 1, 1, 1, 1, 1, 0,
    -0.5f, 0.5f, 0, 1, 1, 1, 1, 0, 0
});
mesh.setIndices(new short[] {0, 1, 2, 2, 3, 0});
texture = new Texture(Gdx.files.internal("bobrgb888-32x32.png"));
```

In the render method we then simply call `shader.bind()` and pass the uniforms in and then render the mesh with the shader:

```java
texture.bind();
shader.bind();
shader.setUniformMatrix("u_projTrans", matrix);
shader.setUniformi("u_texture", 0);
mesh.render(shader, GL20.GL_TRIANGLES);
```

And that's it!

The good thing about shaders in OpenGL ES 2.0 is that you have a huge library of shaders available to you. Pretty much anything that's done in WebGL can be easily ported over to run on mobiles. Go and experiment!

A simple demo of a shockwave effect shader with libGDX is available on [LibGDX.info](https://libgdxinfo.wordpress.com/shaders/)
