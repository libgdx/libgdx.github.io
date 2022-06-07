---
title: ModelBatch
---
[ModelBatch](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/ModelBatch.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/ModelBatch.java)) is a class used for managing render calls. It is typically used to render instances of [models](/wiki/graphics/3d/models), although it is not restricted to models. The ModelBatch class abstracts away all rendering code, providing a layer on top of it and allowing you to focus on more game specific logic. Every part of the ModelBatch functionality is customizable by design.

**Caution:** because ModelBatch manages the render calls and therefore the rendering context, you should not try to manually modify the render context (e.g. bind shaders, texture or meshes, or call any function starting with `gl`) in between the `ModelBatch.begin()` and `ModelBatch.end()` calls. This will not work and might cause unpredictable behavior. Instead use the customization options that ModelBatch offers.

* [Common misconceptions](#common-misconceptions)
* [Overview](#overview)
* [Using ModelBatch](#using-modelbatch)
* [Gather render calls](#gather-render-calls)
  * [What are render calls?](#what-are-render-calls)
  * [RenderableProvider](#renderableprovider)
* [Gather Shaders](#gather-shaders)
  * [What is a shader?](#what-is-a-shader)
  * [ShaderProvider](#shaderprovider)
  * [Default shader](#default-shader)
* [Sorting render calls](#sorting-render-calls)
* [Managing the render context](#managing-the-render-context)
  * [RenderContext](#rendercontext)
  * [TextureBinder](#texturebinder)
    * [TextureDescriptor](#texturedescriptor)

# Common misconceptions
* ModelBatch is often compared to [SpriteBatch](/wiki/graphics/2d/spritebatch-textureregions-and-sprites). While this might be understandable from an API view, there are some very big differences making them less comparable. The main difference is that SpriteBatch merges multiple sprites into a single draw call, while ModelBatch doesn't combine render calls. This does have performance implications, so be aware to merge any render calls before sending them to the ModelBatch.
* ModelBatch does not perform (frustum) culling. It simply hasn't enough information to do this using the best performing method. By default, every call to `ModelBatch.render()` will at least lead to one actual render call. ModelBatch does allow you to customize this though and perform frustum culling prior to actually rendering. However, typically, you should perform (frustum) culling prior to calling `ModelBatch.render()`.

# Overview
So what does ModelBatch actually do?

1. It gathers render calls
2. It gathers a shader for each render call
3. It sorts the render calls
4. It manages the rendering context
5. It executes the render calls

That's it. Nothing more, nothing less. And every part of this is customizable. Please be aware that because of this design, there might be multiple ways to accomplish the same basic task.

# Using ModelBatch
ModelBatch is a relatively heavy weight object, because of the shaders it might create. When possible you should try to reuse it. You'd typically create a ModelBatch in the `create()` method. Because it contains native resources (like the shaders it uses), you'll need to call the `dispose()` method when no longer needed.

Rendering should be done every frame, typically in your `render()` method. To start rendering you should call `modelBatch.begin(camera);`. Next use the `modelBatch.render(...);` method to add one or more render calls. When done adding render calls, you must call `modelBatch.end();` to actually render to specified calls.
```java
    ModelBatch modelBatch;
    ...

    @Override
    public void create () {
        modelBatch = new ModelBatch();
        ...
    }

    @Override
    public void render () {
        ... // call glClear etc.
        modelBatch.begin(camera);
        modelBatch.render(...);
        ... // add other render calls
        modelBatch.end();
        ...
    }

    @Override
    public void dispose () {
        modelBatch.dispose();
        ...
    }
```
The call to `modelBatch.render(...)` is only valid in between the call to `modelBatch.begin(camera)` and `modelBatch.end()`. The actual rendering is performed at the call to `end();`. If you want to force rendering in between, then you can use the `modelBatch.flush();` method.

The [`Camera`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/Camera.html) you supply is hold by reference, meaning that it must not be changed in between the begin and end calls. If you need to switch camera in between the begin and end calls, then you can call the `modelBatch.setCamera(camera);`, which will `flush()` the batch if needed.

# Gather render calls
## What are render calls?
The purpose of ModelBatch is to manage render calls. So what exactly is a render call and how do you specify them?

A "render call" (often also referred to as "draw call") is basically the instruction to the GPU to render (display) something. Simply said, each "render call" displays a shape with some properties (e.g. a location, image, color, etc). Or to be more precise, it instructs the GPU to render a given part of a mesh using a given shader in a given context. We will look more in depth on this later.

> For basic usage, you don't have to know the exact details about a render call, because ModelBatch abstracts them away. However, there's a performance impact of render calls. Typically each render call is executed on the GPU, meaning that it is executed in parallel to CPU code. Whenever a new render call is executed, it might imply that GPU and CPU need to be synchronized. Or in other words, having are few large render calls is typically better performing than having many smaller render calls.

To specify a render call, libGDX contains the [Renderable](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/Renderable.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/Renderable.java)) class, which contains almost everything (except for the camera) required to perform a single render call. Basically it contains how (the shader) and where (the transformation) to render the shape (the mesh part) in which context (the environment and material).

The `render(...)` method of `ModelBatch` has many signatures (variations with different method arguments), one of which is `ModelBatch.render(Renderable);`. Using this method you can directly specify the render call you want to add to the ModelBatch. The other `render(...)` methods allow you to specify one or more render calls using a `RenderableProvider`. In those methods, the other arguments let you provide default values for those render calls. For example, when using the `ModelBatch#render(RenderableProvider, Environment, Shader)` method it will set (override) the `environment` and `shader` members of every `Renderable` the `RenderableProvider` provides.

## RenderableProvider
[`RenderableProvider`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/RenderableProvider.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/RenderableProvider.java)) is an interface which you can implement to supply one or more `Renderable` instances. Probably the most common implementation of this interface is the [`ModelInstance`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/ModelInstance.html) class, which traverses all [nodes](/wiki/graphics/3d/models#nodes) ([parts](/wiki/graphics/3d/models#nodepart)) and translates them into a `Renderable` instance. However, you can use the `RenderableProvider` anyway you need. For example, when creating a voxel engine, you could create a `Renderable` for each chunk. Or when using an entity component system, you could use `RenderableProvider` as component.

`RenderableProvider` only has one method:
```java
public void getRenderables (Array<Renderable> renderables, Pool<Renderable> pool);
```
This is a very open API (e.g. it gives you access to the `Array` of all previously added `Renderable`s), but you should restrict your usage to only adding elements to the array. The pool can optionally be used to avoid allocation. You're free to ignore it or to use it for any dynamic `Renderable` needed. Any `Renderable` you `obtain()` from it, will be automatically be free'd by the `ModelBatch`, you don't have to take care for that.

# Gather shaders
## What is a shader?
A [`Shader`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/Shader.html)  ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/Shader.java)) is an interface that abstracts the implementation of actually performing the render call. Typically its implementation uses a [`ShaderProgram`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/glutils/ShaderProgram.html) which is the GPU program (e.g. the _vertex shader_ and _fragment shader_) needed to perform the render call. The `Shader` implementation also contains everything needed to use this `ShaderProgram`, like setting _uniform_ values.

## ShaderProvider
Independent of how the actual rendering is performed, the ModelBatch needs one `Shader` per `Renderable`. For this it uses the [`ShaderProvider`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/ShaderProvider.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/ShaderProvider.java)) interface. For every `Renderable` added to the batch (even if it contains a shader), the `getShader` of the `ShaderProvider` will be called to fetch to shader to render it.

```java
public Shader getShader (Renderable renderable);
```

By default the [DefaultShaderProvider](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/DefaultShaderProvider.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/DefaultShaderProvider.java)) is used, which will create a [DefaultShader](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.html) whenever a previous created shader can't be reused. You can, however, customize this by supplying your own `ShaderProvider` or by extending the `DefaultShaderProvider`.

`ModelBatch` delegates managing `Shader`'s to the `ShaderProviders`. Because a `Shader` typically uses a `ShaderProgram`, they need to be disposed. When `modelBatch.dispose();` is called, `ModelBatch` will call the `dispose()` method the `ShaderProvider`.

To help managing and reusing shaders, libGDX offers the abstract [`BaseShaderProvider`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/BaseShaderProvider.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/BaseShaderProvider.java)). This class keeps track of all shaders created, reuses them if possible and disposes them when no longer needed. If you extend this class, it will call the `createShader(Renderable)` method when it hasn't got a shader it can reuse. Whether a `Shader` can be reused, is determined by the call to [`shader.canRender(Renderable)`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/Shader.html#canRender-com.badlogic.gdx.graphics.g3d.Renderable-).

A typical use-case is to extend `DefaultShaderProvider` (which extends BaseShaderProvider) and provide a custom shader when needed, while falling back to the DefaultShader when you can't use your custom shader.
```java
public static class MyShaderProvider extends DefaultShaderProvider {
	@Override
	protected Shader createShader (Renderable renderable) {
		if (renderable.material.has(CustomColorTypes.AlbedoColor))
			return new MyShader(renderable);
		else
			return super.createShader(renderable);
	}
}
```
Here the [Material](/wiki/graphics/3d/material-and-environment) is used to decide whether the custom shader should be used. This is the preferred and easiest method. However, you can use any value, including the generic [`renderable.userData`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/Renderable.html#userData) to decide which shader to use, as long as its `shader.canRender(renderable)` method returns true for the given renderable.

## Default shader
When you don't specify a custom `ShaderProvider`, then `ModelBatch` will use the `DefaultShaderProvider`. This provider creates a new [`DefaultShader`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.html) instance when needed.

The `DefaultShader` class provides a default implementation of most of the standard [material and environment attributes](/wiki/graphics/3d/material-and-environment), including lighting, normal maps, reflection cubemaps, etc. That is: it binds the attribute values to the corresponding `uniform`s. [A list of uniform names can be found here](https://github.com/libgdx/libgdx/blob/1.7.0/gdx/src/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.java#L81-L120).

> **NOTE: by default, the shader program (the glsl files) use per-vertex lighting ([Gouraud shading](https://en.wikipedia.org/wiki/Gouraud_shading)).Normal mapping, reflection etc. is not applied by default.**

The behavior of this class is configurable by supplying a [`DefaultShader.Config`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.Config.html) instance to the `DefaultShaderProvider`.

```java
DefaultShader.Config config = new DefaultShader.Config();
config.numDirectionalLights = 1;
config.numPointLights = 0;
config.numBones = 16;
modelBatch = new ModelBatch(new DefaultShaderProvider(config));
```

> **NOTE:** the default configuration is rarely the most optimal for each use-case. For example it uses 5 point lights and 2 directional lights, even if you're only using 1 direction and 1 point light. Make sure to adjust it to your specific use-case to get the most out of it. [If you're using skinning, then the number of bones must match the number of bones the model is created with.](/wiki/graphics/3d/3d-animations-and-skinning)

The [GPU shader](/wiki/graphics/opengl-utils/shaders) (the vertex and fragment shader) to be used is also configurable using this config. Because this shader can be used for various combinations of attributes, it typically is a so-called *ubershader*. This is shader glsl code of which parts are enabled or disabled based on the `Renderable` by using [pre-processor macro directives](https://www.opengl.org/wiki/Core_Language_(GLSL)#Preprocessor_directives). For example:

```glsl
#ifdef blendedFlag
	gl_FragColor.a = diffuse.a * v_opacity;
	#ifdef alphaTestFlag
		if (gl_FragColor.a <= v_alphaTest)
			discard;
	#endif
#else
	gl_FragColor.a = 1.0;
#endif
```

In this snippet, the actual code used for the shader depends on whether `blendedFlag` and/or `alphaTestFlag` are defined. [The `DefaultShader` class defines these based on the values of the `Renderable`.](https://github.com/libgdx/libgdx/blob/1.7.0/gdx/src/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.java#L631-L702)

If you don't specify a custom ubershader, then the default ubershader will be used (see the source of the: [vertex shader](https://github.com/libgdx/libgdx/blob/1.7.0/gdx/src/com/badlogic/gdx/graphics/g3d/shaders/default.vertex.glsl) and [fragment shader](https://github.com/libgdx/libgdx/blob/1.7.0/gdx/src/com/badlogic/gdx/graphics/g3d/shaders/default.fragment.glsl)). Although this shader supports most basic attributes (like skinning, diffuse and specular per-vertex lighting etc.), it is very generic and cannot support every possible combination of attributes.

> If you want to have per-fragment lighting, normal mapping, reflection then you can use [this "unofficial" shader](https://gist.github.com/xoppa/9766698). But, please note that this shader adds this functionality at the cost of e.g. being restricted to a single directional light.

If you look at the source of the default ubershader, then you'll probably notice that it is huge and almost impossible to read, let alone maintain it. Luckily you don't have to support every possible combination of attributes and as we've seen in the previous paragraph you can extend the `DefaultShaderProvider` and break it into multiple shaders to make it easier to maintain. For example:

```java
public static class MyShaderProvider extends DefaultShaderProvider {
	DefaultShader.Config albedoConfig;

	public MyShaderProvider(DefaultShader.Config defaultConfig) {
		super(defaultConfig);
		albedoConfig = new DefaultShader.Config();
		albedoConfig.vertexShader = Gdx.files.internal("data/albedo.vertex.glsl").readString();
		albedoConfig.fragmentShader = Gdx.files.internal("data/albedo.fragment.glsl").readString();
	}
	@Override
	protected Shader createShader (Renderable renderable) {
		if (renderable.material.has(CustomColorTypes.AlbedoColor))
			return new DefaultShader(renderable, albedoConfig);
		else
			return super.createShader(renderable);
	}
}
```

# Sorting render calls
If render calls would be executed in a random order, then it would cause strange and less performing result. For example, if a transparent object would be rendered prior to an object that's behind it then you won't see the object behind it. This is because the depth buffer will prevent the object further away from being rendered. Sorting the render calls helps to solve this.

By default `ModelBatch` will use the [DefaultRenderableSorter](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/DefaultRenderableSorter.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/DefaultRenderableSorter.java)) to sort the render calls. This implementation will cause that opaque objects are rendered first from front to back, after which transparent objects are rendered from back to front. To decide whether an object is transparent or not, the default implementation checks the [BlendingAttribute#blended](/wiki/graphics/3d/material-and-environment) value.

Customizing sorting can help increase performance. For example, sorting based on shader, mesh or used textures might help decreasing shader, mesh or texture switches. These kind of optimizations are very application specific. You can customize sorting by specifying your own [`RenderableSorter`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/RenderableSorter.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/RenderableSorter.java)) implementation while constructing the `ModelBatch`. This interface contains only one method:
```java
public void sort (Camera camera, Array<Renderable> renderables);
```
This method provides all information the `ModelBatch` has just before the actually rendering. It is also a very open API, you are allowed to modify the array as needed. This makes it possible to perform any last-minute actions (that might not be even related to sorting, like frustum culling) in this interface. The order of the `renderables` after this method completes, will be the order in which the render calls will be actually executed.

# Managing the render context
`ModelBatch` allows you to avoid redundant OpenGL calls, including texture binds, across multiple `Shader` implementations. For example, when a `Shader` requires backface culling and a previous shader enabled backface culling, then the redundant call to `glEnable` and `glCullFace` can be avoided.

## RenderContext
The [`RenderContext`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/RenderContext.html) class tries to avoid these unnecessary calls. This class acts as a thin layer on top of OpenGL ES that keeps track of previous calls and therefore avoids making redundant calls. Only a small subset of the GL calls is implemented, but you can extend it to add additional calls. When not specified as argument in the constructor, `ModelBatch` will create and manage a `RenderContext` for you.

**Caution:** Obviously this will only work if all `Shader` implementations use the `RenderContext` instead of directly making GL calls. You should always use the `RenderContext` if possible, instead of directly calling the corresponding GL call.

For example: When depth testing is enabled using the RenderContext, then it will enable depth testing for you. Now when you use e.g. SpriteBatch then that disables depth testing but doesn't update the RenderContext. This will lead to unexpected results. To avoid this, by default (when you don't specify a RenderContext yourself) ModelBatch will _reset_ the RenderContext on both the `begin()` and `end()` methods, by calling the same named methods on the RenderContext. This is to make sure that context switches outside the ModelBatch don't interfere with the rendering.

However, when you specify your own `RenderContext` (which doesn't have to be a custom implementation of it) then you're responsible for calling the `context.begin()` and `context.end()` methods. This allows you use the same context for multiple ModelBatch instances or even avoid having to reset the context all together.

> If you specify a RenderContext on construction then you own that RenderContext and are expected to reset (call its begin() and end() methods) when needed. You can call the [modelBatch.ownsRenderContext](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/ModelBatch.html#ownsRenderContext--) method to check whether the ModelBatch owns and manages the RenderContext.

## TextureBinder
To keep track of the textures currently being bound, RenderContext contains a [textureBinder](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/RenderContext.html#textureBinder) member. [`TextureBinder`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/TextureBinder.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/TextureBinder.java)) is an interface used to keep track of texture binds, as well as texture context (e.g. the minification/magnification filters). By default the [`DefaultTextureBinder`](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/g3d/utils/DefaultTextureBinder.html) ([code](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g3d/utils/DefaultTextureBinder.java)) is used. Although you can specify your own implementation, this is rarely required.

The DefaultTextureBinder uses every available texture unit (within the specified range) to avoid unneeded texture binds. A typical modern mobile GPU offers around 16 or 32 texture units to which textures can be bound. OpenGL ES limits the number of units to 32. You can specify the range to use when constructing the DefaultTextureBinder, using the `offset` and `count` arguments. If you don't specify an offset, then 0 is assumed. If you don't specify a count then all available remaining units will be used. ModelBatch will, by default, exclude texture unit 0 from the range, because this is often used for GUI. So by default, texture unit `1` to `31` will be used, unless the GPU supports less texture units.

`DefaultTextureBinder` supports two methods:
* **ROUNDROBIN:** When a texture is already bound, then it is reused. Otherwise the first texture is bound to the first available unit, the next texture is bound to the next available unit, and so on. When all available units are used, then binding restarts at the first available unit, overwriting the previous bound texture.
* **WEIGHTED:** Weights the textures by counting the number of times a texture is used or not. Often reused textures are less likely to be overwritten, while less reused textures are more likely to be overwritten.

By default ModelBatch will use the _WEIGHTED_ method.

You can bind a texture using `TextureBinder` by calling the `bind(...)` method. This method will return the unit the texture is bound to. So, practically, you can bind a texture in your `Shader` to an _uniform_ like this:
```java
program.setUniformi(uniformLocation, context.textureBinder.bind(texture));
```

### TextureDescriptor
The api often uses a `TextureDescriptor` when specifying a texture. This is because you might want to use a texture but do require specific context properties. These properties currently include the minification and magnification filters, as well as the horizontal wrapping and vertical wrapping. Therefor the TextureDescriptor is also used by e.g. the [TextureAttribute](/wiki/graphics/3d/material-and-environment#textureattribute) and [CubemapAttribute](/wiki/graphics/3d/material-and-environment#cubemapattribute). For convenience, TextureBinder allows you to directly specify a TextureDescriptor:
```java
program.setUniformi(uniformLocation, context.textureBinder.bind(
    (TextureAttribute)(renderable.material.get(TextureAttribute.Diffuse)))
        .textureDescription));
```
