---
title: Material and environment
---
In practice, when rendering, you are specifying what (the shape) to render and how (the material) to render. The shape is specified using the Mesh (or more commonly the MeshPart), which defines the vertices attributes for the shader. The material is most commonly used to specify the uniform values for the shader.

Uniforms can be grouped into model specific (e.g. the texture applied or whether or not to use blending) and environmental uniforms (e.g. the lights being applied or an environment cubemap). Likewise the 3D api allows you to specify a material and environment.

## Materials ##

Materials are model (or modelinstance) specific. You can access them by index `model.materials.get(0)`, by name `model.getMaterial("material3")` or by nodepart `model.nodes.get(0).parts(0).material`. Materials are copied when creating a ModelInstance, meaning that changing the material of a ModelInstance will not affect the original Model or other ModelInstances.

The Material class extends the Attributes class, see below for more information about Attributes.

## Environment ##

An Environment contains the uniform values specific for a location. For example, the lights are part of the Environment. Simple applications might use only Environment, while more complex applications might use multiple environments depending on the location of a ModelInstance. A ModelInstance (or Renderable) can only contain one Environment though.

The Environment class extends the Attributes class, see below for more information about Attributes.

### Lights ###

Since version 1.5.7 lights are moved to attributes, which means that you can attach a light to either an environment or a material. Adding a light to an environment can still be done using the [`environment.add(light)`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/Environment.html#add-com.badlogic.gdx.graphics.g3d.environment.BaseLight-) method. However, you can also use the `DirectionalLightsAttribute`, `PointLightsAttribute` and `SpotLightsAttribute` attributes (see below). Each of these attributes has an array which you can use to attach one or more lights to it. Note however that you typically can only use one of both. If you add a light to the `PointLightsAttribute` of the environment and then add another light to the `PointLightsAttribute` of the material, then the `DefaultShader` will ignore the point light(s) added to the environment. Lights are always used by reference.

Lights should be sorted by importance. Usually this means that lights should be sorted on distance. The `DefaultShader` for example by default [(configurable)](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/shaders/DefaultShader.Config.html#numPointLights) only uses the first five point lights for shader lighting. Any remaining lights will be added to an ambient cubemap which is much less accurate.

## Attributes ##

Both the Environment and Material classes extend the Attributes the class. Most commonly, the Attributes class is used to specify uniform values. For example a TextureAttribute can be used to specify an uniform to bound for a shader. However, attributes don't have to be uniforms, for example DepthTestAttribute is used to alter the opengl state and doesn't set an uniform.

The Attributes class is most comparable with a Set. It can contain at most one value for each attribute, just like an uniform can only be set to one value. Theoretically both the Material and Environment can contain the same attribute, the actual behavior in this scenario depends on the shader used, but in most cases the Materials attribute will be used instead of the Environment attribute.

### Attribute type ###

Every attribute has a `type` long value, which is a bitmask used to identify the attribute. Therefor a complete material or environment can be represented with a single long, where each bit represents an attribute. Some attribute classes are dedicated to a single type value (bit). Others can be used for multiple type values (bits), in which case you must specify the type on construction. For example:

```java
Attribute attribute = new ColorAttribute(ColorAttribute.Diffuse, Color.RED);
```

note that the ColorAttribute class contains a convenience method to do the same:

```java
Attribute attribute = ColorAttribute.createDiffuse(Color.RED);
```

### Using attributes ###

The most common actions for attributes are `set`, `has`, `remove`, and `get`.

You can use the `set` method to add or change an attribute. If there is already an attribute of the same type if will be first removed, after which the new attribute is added. For example: `material.set(FloatAttribute.createAlphaTest(0.25f));`

Using the `has` method it is possible to check if a specific attribute type is set. For example: `material.has(FloatAttribute.AlphaTest);`. It is also possible to check for multiple attributes, for example: `material.has(FloatAttribute.AlphaTest | ColorAttribute.Diffuse);`. In which case the `has` method will only return `true` if all attributes are set. Note that because the `has` method uses a bitwise check it is quite fast and can be used prior to e.g. a call to `remove` to ensure the attribute is actually set.

With the `remove` method you can remove an attribute of a specific type, for example:
`material.remove(FloatAttribute.AlphaTest);`. You can also remove multiple attributes at once, for example: `material.remove(FloatAttribute.AlphaTest | ColorAttribute.Diffuse);`.

The `get` method can be used to fetch an attribute of a specific type. For example: `material.get(FloatAttribute.AlphaTest);`. If the attribute isn't set the `get` method will return `null`. Because the type implies the class, you can safely cast the result without checking: `(FloatAttribute)material.get(FloatAttribute.AlphaTest);`. For convenience there's also a template method: `material.get(FloatAttribute.class, FloatAttribute.AlphaTest);`.

Besides that you can also `clear` (to remove all attributes), iterate (it implements `Iterable<Attribute>`) and compare (it implements `Comparator<Attribute>`, however the `same` method provides additional options) attributes. The `getMask()` method provides access to the mask containing all attributes, for example `material.getMask() & FloatAttribute.AlphaTest == FloatAttribute.AlphaTest` is the same as `material.has(FloatAttribute.AlphaTest)`.

### Custom attribute types ###

It is possible to use a standard attribute class for a new custom type. For example when you want to use the ColorAttribute class to specify a custom type of color. There are three things you must consider in that case:

1. Name your attribute type. Each attribute type must have an _unique_ alias (name). You might want to (but don't have to) use the uniform name for that. The alias will also be used for debugging, e.g. when calling `attribute.toString()`.
2. Register your attribute type. This is to make sure there is only one attribute type for each bit. This can be done only from within the Attribute class or a subclass.
3. Make ColorAttribute accept the custom type. The ColorAttribute class and most other attribute classes checks the type on construction, this allows you to cast attributes without having to check anything other then the type. For example `(ColorAttribute)material.get(ColorAttribute.Diffuse)` will always work because ColorAttribute is the only attribute accepting the `ColorAttribute.Diffuse` type.

Because of step 2 and 3, you must extend the Attribute class to add a custom attribute type:

```java
public class CustomColorTypes extends ColorAttribute {
    public final static String AlbedoColorAlias = "AlbedoColor"; // step 1: name the type
    public final static long AlbedoColor = register(AlbedoColorAlias); // step 2: register the type
    static {
        Mask |= AlbedoColor; // step 3: Make ColorAttribute accept the type
    }
    /** Prevent instantiating this class */
    private CustomColorTypes() {
        super(0);
    }
}
```

You can then create the custom attribute type using:

```java
Attribute attribute = new ColorAttribute(CustomColorTypes.AlbedoColor, Color.RED);
```

### Custom attributes
It is possible to create a custom attribute, in which case the process is not much different from above. You must extend the Attribute class, register at least one type and of course add some data to pass on to the shader. For example to add an attribute to pass a double value to the shader:

```java
public class DoubleAttribute extends Attribute {
    public final static String MyDouble1Alias = "myDouble1";
    public final static long MyDouble1 = register(MyDouble1Alias);
    public final static String MyDouble2Alias = "myDouble2";
    public final static long MyDouble2 = register(MyDouble2Alias);
    protected static long Mask = MyDouble1 | MyDouble2;
    /** Method to check whether the specified type is a valid DoubleAttribute type */
    public static Boolean is(final long type) {
        return (type & Mask) != 0;
    }

    public double value;

    public DoubleAttribute (final long type) {
        super(type);
        if (!is(type))
            throw new GdxRuntimeException("Invalid type specified");
    }

    public DoubleAttribute (final long type, final double value) {
        this(type);
        this.value = value;
    }

    /** copy constructor */
    public DoubleAttribute (DoubleAttribute other) {
        this(other.type, other.value);
    }

    @Override
    public Attribute copy () {
        return new DoubleAttribute(this);
    }

    @Override
    public int hashCode () {
        final int prime = /* pick a prime number and use it here */;
        final long v = NumberUtils.doubleToLongBits(value);
        return prime * super.hashCode() + (int)(v^(v>>>32));
    }

    @Override
    public int compareTo (Attribute o) {
        if (type != o.type) return type < o.type ? -1 : 1;
        double otherValue = ((DoubleAttribute)o).value;
        return value == otherValue ? 0 : (value < otherValue ? -1 : 1);
    }
}
```
Of course `MyDouble1Alias`, `MyDouble1`, `"myDouble1"`, `MyDouble2Alias`, `MyDouble2` and `"myDouble2"` should be replaced by a more meaningful description.

Note that the `copy()` method is for example called when creating a `ModelInstance` of a `Model`. It should return an identical instance of the attribute which can be modified independently of the attribute being copied. While not required, a *copy constructor* is typically a good method to implement this.

The `hashCode()` method should be implemented because it is used for comparing attributes and materials. For example, two materials are considered to be the same if they contain the same attributes (types) and the `equals()` method returns true for each pair of attribute types. By default, the `equals()` method of the `Attribute` class compares the `hashCode()` of both attributes for this.

The `compareTo(Attribute)` method must be implemented for sorting render calls based on the material. This implementation should typically always start with the line:
`if (type != o.type) return type < o.type ? -1 : 1;` to assure that it's comparing attributes of the same type.

> Attribute classes should be kept small and self contained, therefore it is best to always directly extend the `Attribute` class. Try to avoid extending a subclass of the Attribute class to add additional information.

## Available attributes
Like stated above its possible to create custom attributes. However, there are a few attributes already included, which are listed below.

### BlendingAttribute ###

By default the 3D api assumes everything is opaque. The `BlendingAttribute` is most commonly used for materials (in case of environment it will change the default behavior) and can be used to specify that the material is or is not blended. The `BlendingAttribute` doesn't require you to specify a type on construction, its type is always `BlendingAttribute.Type`, unless it's extended. It contains four properties which can be specified:
* `blended` indicates whether or not the material should be treated as blended. This is primarily used for sorting, for example opaque objects are drawn prior to transparent objects.
* `sourceFunction` OpenGL enum which specifies how the (incoming) red, green, blue, and alpha source blending factors are computed, by default it is set to GL_SRC_ALPHA.
* `destFunction` OpenGL enum which specifies how the (existing) red, green, blue, and alpha destination blending factors are computed, by default it is set to GL_ONE_MINUS_SRC_ALPHA. For additive blending you might want to set it to GL_ONE.
* `opacity` The amount of opacity (the source alpha value), ranging from 0 (fully transparent) to 1 (fully opaque).

### ColorAttribute ###

The `ColorAttribute` allows you to pass a color to the shader. For that it only contains one property: `.color`. You can set the color during construction (it will be set by value) or using the `.color.set(...)` method. The `ColorAttribute` requires an attribute type to be specified, by default the following types are available:
* `ColorAttribute.Diffuse`
* `ColorAttribute.Specular`
* `ColorAttribute.Ambient`
* `ColorAttribute.Emissive`
* `ColorAttribute.Reflection`
* `ColorAttribute.AmbientLight`
* `ColorAttribute.Fog`

Where the latter two are most commonly used for Environment, while the others or commonly used for Material.

### CubemapAttribute ###
To pass a `Cubemap` to the shader the `CubemapAttribute` can be used. It's value is the `textureDescription` member which can be used to specify the cubemap along with other texture related values. The `CubemapAttribute` requires an attribute type to be specified, by default the `CubemapAttribute.EnvironmentMap` is the only valid type.

### DepthTestAttribute ###
Just like the `BlendingAttribute`, does the `DepthTestAttribute` not require an attribute type. It is always `DepthTestAttribute.Type`. The `DepthTestAttribute` can be used to specify depth testing and writing, using the following properties:
* `depthFunc` The depth test function, or 0 (or GL_NONE) to disable depth test, by default it is GL20.GL_LEQUAL.
* `depthRangeNear` Mapping of near clipping plane to window coordinates, by default 0.0
* `depthRangeFar` Mapping of far clipping plane to window coordinates, by default 1.0
* `depthMask` Whether or not to write to the depth buffer, enabled by default.

### DirectionalLightsAttribute ###
The DirectionalLightsAttribute does not require an attribute type. It is always `DirectionalLightsAttribute.Type`. The ` DirectionalLightsAttribute` can be used to specify an array of [`DirectionalLight`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/environment/DirectionalLight.html) instances, using the following property:
* `lights` The array of lights, should be sorted on importance.

### FloatAttribute ###
To pass a single floating point value to the shader, the `FloatAttribute` can be used. The value can be specified on construction or using the `.value` member. The `FloatAttribute` requires an attribute type, which by default can be:
* `FloatAttribute.Shininess` Used for specular lighting.
* `FloatAttribute.AlphaTest` Used to discard pixels when the alpha value is equal or below the specified value.

### IntAttribute ###
Similar to the `FloatAttribute` class, the `IntAttribute` allows you to pass an integer value to the shader. Likewise the `.value` member can be used or the value can be set on construction. The `IntAttribute` requires an attribute type, which by default can be:
* `IntAttribute.CullFace` OpenGL enum to specify face culling, either GL_NONE (no culling), GL_FRONT (only render back faces) or GL_BACK (only render front faces). The default depends on the shader, the default shader uses GL_BACK by default.

### PointLightsAttribute ###
The PointLightsAttribute does not require an attribute type. It is always `PointLightsAttribute.Type`. The `PointLightsAttribute` can be used to specify an array of [`PointLight`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/environment/PointLight.html) instances, using the following property:
* `lights` The array of lights, should be sorted on importance.

### SpotLightsAttribute ###
Not supported by the default shader. The SpotLightsAttribute does not require an attribute type. It is always `SpotLightsAttribute.Type`. The `SpotLightsAttribute` can be used to specify an array of [`SpotLight`](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/g3d/environment/SpotLight.html) instances, using the following property:
* `lights` The array of lights, should be sorted on importance.

### TextureAttribute ###
`TextureAttribute` can be used to pass a `Texture` to the shader. Just like the `CubemapAttribute` it has a `textureDescription` member which allows you to set the `Texture` amongst some texture related values like repeat and filter. Additionally it contains the `offsetU`, `offsetV`, `scaleU` and `scaleY` members, which can be used to specify the region (texture coordinates transformation) of the texture to use. It also has an `uvIndex` member (defaults to 0) which can be used to specify which texture coordinates should be used. Note that the default shader currently ignores this uvIndex member and always uses the first texture coordinates.

The `TextureAttribute` requires an attribute type, which by default can be one of the following:
* `TextureAttribute.Diffuse`
* `TextureAttribute.Specular`
* `TextureAttribute.Bump`
* `TextureAttribute.Normal`