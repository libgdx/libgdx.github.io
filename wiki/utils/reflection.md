---
title: Reflection
---
In order to utilize reflection in a cross-platform way, libGDX provides a small wrapper around Java's reflection API. The wrapper consists mainly of two classes containing the static methods you will use to perform reflection operations:

  * `ArrayReflection` - encapsulates access to java.lang.reflect.Array
  * `ClassReflection` - encapsulates access to java.lang.Class

Other classes included in the wrapper provide access to Constructors, Fields, and Methods. These classes (for the most part) mirror their java.lang.reflect equivalent. and can be used in the same way.

# Usage

In general, you will use the reflection wrapper the same way you would use Java's reflection API, except you'd route the calls through the appropriate wrapper class instead of calling the methods directly.

Examples:

| *Operation* | *Java* | *Wrapper* |
| ----------- | ------ | --------- |
| Create a new instance of an array of a specified component type | `Array.newInstance(clazz, size)` | `ArrayReflection.newInstance(clazz, size)` |
| Obtain the Class object for a class by name | `Class.forName("java.lang.Object")` | `ClassReflection.forName("java.lang.Object")` |
| Create a new instance of a class | `clazz.newInstance()` | `ClassReflection.newInstance(clazz)` |
| Get the fields of a class | `clazz.getFields()` | `ClassReflection.getFields(clazz)` |

# GWT

Because GWT does not allow for reflection in the same way as Java, extra steps are required to make reflection information available to your GWT application. In short, you must specify which classes you plan to use with reflection. When compiling the HTML project, libGDX takes that information and generates a reflection cache containing information about and providing access to the constructors, fields and methods of the specified classes. libGDX then uses this reflection cache to implement the reflection api.

Classes are specified by including a special configuration property in your GWT module definition (`*`.gwt.xml).

To include a single class:
```xml
<extend-configuration-property name="gdx.reflect.include" value="com.me.reflected.ReflectedClass" />
```

To include an entire package:
```xml
<extend-configuration-property name="gdx.reflect.include" value="com.me.reflected" />
```

You can also exclude classes of packages (for example when you include a package, but you don't want all classes or subpackages in that package):
```xml
<extend-configuration-property name="gdx.reflect.exclude" value="com.me.reflected.NotReflectedClass" />
```

## Notes
  * You must specify the fully qualified name of the class or package.
  * You must specify each class or package in its own `extend-configuration-property` element.
  * Any classes referenced by those classes you include will automatically be included, so you need only include your own classes.
  * Nested classes cannot be included directly. If, e.g., you want to have `CustomActor$CustomActorStyle` available for reflection (maybe to be used in uiskin.json), just include the parent class (i.e. CustomActor in this example)
  * Visibility restrictions may cause the compiler to not include your class in the IReflectionCache. Public visibility is therefore recommended.
  * `static` fields cannot be accessed directly via `field.get(Example.class);`, instance must be passed in as a parameter `field.get(new Example());`
