---
title: Saved game serialization
---
For saving simpel data types, libGDX offers [Preferences](/wiki/preferences). However, if you want to save custom objects, in particular your whole game state – usually to save it to disk so it can be restored later – you need to serialize it first. There are a couple of different ways for doing this.

# JSON serialization

libGDX's [JSON](/wiki/utils/reading-and-writing-json) classes can automatically convert Java objects to and from JSON. Check out the corresponding wiki article to find out more.

# Binary serialization

Another option for [efficiently](https://github.com/eishay/jvm-serializers/wiki) serializing Java objects is the [Kryo](https://github.com/EsotericSoftware/kryo) library. Kryo can handle most POJOs and other classes, but some classes need special handling. Below are a few custom serializers for libGDX classes.

Note that classes like `Texture` should not be serialized in most cases. It would be better to have a String instead of a Texture object in your object graph. After serializing you would process the objects and look up the texture using the string path.
{: .notice--warning}

```java
// Register a custom Array serializer
kryo.register(Array.class, new Serializer<Array>() {
	{
		setAcceptsNull(true);
	}

	private Class genericType;

	public void setGenerics (Kryo kryo, Class[] generics) {
		if (generics != null && kryo.isFinal(generics[0])) genericType = generics[0];
		else genericType = null;
	}

	public void write (Kryo kryo, Output output, Array array) {
		int length = array.size;
		output.writeInt(length, true);
		if (length == 0) {
			genericType = null;
			return;
		}
		if (genericType != null) {
			Serializer serializer = kryo.getSerializer(genericType);
			genericType = null;
			for (Object element : array)
				kryo.writeObjectOrNull(output, element, serializer);
		} else {
			for (Object element : array)
				kryo.writeClassAndObject(output, element);
		}
	}

	public Array read (Kryo kryo, Input input, Class<Array> type) {
		Array array = new Array();
		kryo.reference(array);
		int length = input.readInt(true);
		array.ensureCapacity(length);
		if (genericType != null) {
			Class elementClass = genericType;
			Serializer serializer = kryo.getSerializer(genericType);
			genericType = null;
			for (int i = 0; i < length; i++)
				array.add(kryo.readObjectOrNull(input, elementClass, serializer));
		} else {
			for (int i = 0; i < length; i++)
				array.add(kryo.readClassAndObject(input));
		}
		return array;
	}
});

// Register a custom IntArray serializer
kryo.register(IntArray.class, new Serializer<IntArray>() {
	{
		setAcceptsNull(true);
	}

	public void write (Kryo kryo, Output output, IntArray array) {
		int length = array.size;
		output.writeInt(length, true);
		if (length == 0) return;
		for (int i = 0, n = array.size; i < n; i++)
			output.writeInt(array.get(i), true);
	}

	public IntArray read (Kryo kryo, Input input, Class<IntArray> type) {
		IntArray array = new IntArray();
		kryo.reference(array);
		int length = input.readInt(true);
		array.ensureCapacity(length);
		for (int i = 0; i < length; i++)
			array.add(input.readInt(true));
		return array;
	}
});

// Register a custom FloatArray serializer
kryo.register(FloatArray.class, new Serializer<FloatArray>() {
	{
		setAcceptsNull(true);
	}

	public void write (Kryo kryo, Output output, FloatArray array) {
		int length = array.size;
		output.writeInt(length, true);
		if (length == 0) return;
		for (int i = 0, n = array.size; i < n; i++)
			output.writeFloat(array.get(i));
	}

	public FloatArray read (Kryo kryo, Input input, Class<FloatArray> type) {
		FloatArray array = new FloatArray();
		kryo.reference(array);
		int length = input.readInt(true);
		array.ensureCapacity(length);
		for (int i = 0; i < length; i++)
			array.add(input.readFloat());
		return array;
	}
});

// Register a custom Color serializer
kryo.register(Color.class, new Serializer<Color>() {
	public Color read (Kryo kryo, Input input, Class<Color> type) {
		Color color = new Color();
		Color.rgba8888ToColor(color, input.readInt());
		return color;
	}

	public void write (Kryo kryo, Output output, Color color) {
		output.writeInt(Color.rgba8888(color));
	}
});
```
