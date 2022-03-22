---
title: Saved game serialization
---
# JSON serialization

The [JSON](/wiki/utils/reading-and-writing-json) class can automatically convert Java objects to and from JSON.

# Binary serialization

[Kryo](https://github.com/EsotericSoftware/kryo) can be used to automatically and [efficiently](https://github.com/eishay/jvm-serializers/wiki) serialize game state.

## libGDX Kryo Serializers

Kryo can handle most POJOs and other classes, but some classes need special handling. Below are a few serializers for libGDX classes. 

Note that classes like Texture should not be serialized in most cases. It would be better to have a String instead of a Texture object in your object graph. After serializing you would process the objects and look up the texture using the string path.

```java
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