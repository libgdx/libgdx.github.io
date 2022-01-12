---
title: Reading and writing JSON
---
 * [Overview](#overview)
 * [Writing Object Graphs](#writing-object-graphs)
 * [Reading Object Graphs](#reading-object-graphs)
 * [Customizing Serialization](#customizing-serialization)
 * [Serialization Methods](#serialization-methods)
 * [Event Based Parsing](#event-based-parsing)
 * [Supported Classes](#supported-classes)

## <a id="overview"></a>Overview ##

libGDX can perform automatic object to JSON serialization and JSON to object deserialization. Four small classes make up the API:

  * `JsonWriter`: A builder style API for emitting JSON.
  * `JsonReader`: Parses JSON and builds a DOM of `JsonValue` objects.
  * `JsonValue`: Describes a JSON object, array, string, float, long, boolean, or null.
  * `Json`: Reads and writes arbitrary object graphs using `JsonReader` and `JsonWriter`.

To use these classes outside of libgdx, see the [JsonBeans](https://github.com/EsotericSoftware/jsonbeans/) project.

## <a id="writing-object-graphs"></a>Writing Object Graphs ##

The `Json` class uses reflection to automatically serialize objects to JSON. For example, here are two classes (getters/setters and constructors omitted):

```java
public class Person {
   private String name;
   private int age;
   private ArrayList numbers;
}

public class PhoneNumber {
   private String name;
   private String number;
}
```

Example object graph using these classes:

```java
Person person = new Person();
person.setName("Nate");
person.setAge(31);
ArrayList numbers = new ArrayList();
numbers.add(new PhoneNumber("Home", "206-555-1234"));
numbers.add(new PhoneNumber("Work", "425-555-4321"));
person.setNumbers(numbers);
```

The code to serialize this object graph:

```java
Json json = new Json();
System.out.println(json.toJson(person));

{numbers:[{class:com.example.PhoneNumber,number:"206-555-1234",name:Home},{class:com.example.PhoneNumber,number:"425-555-4321",name:Work}],name:Nate,age:31}
```

That is compact, but hardly legible. The `prettyPrint` method can be used:

```java
Json json = new Json();
System.out.println(json.prettyPrint(person));

{
numbers: [
	{
		class: com.example.PhoneNumber,
		number: "206-555-1234",
		name: Home
	},
	{
		class: com.example.PhoneNumber,
		number: "425-555-4321",
		name: Work
	}
],
name: Nate,
age: 31
}
```

Note that the class for the `PhoneNumber` objects in the `ArrayList numbers` field appears in the JSON. This is required to recreate the object graph from the JSON because `ArrayList` can hold any type of object. Class names are only output when they are required for deserialization. If the field was `ArrayList<PhoneNumber> numbers` then class names would only appear when an item in the list extends `PhoneNumber`. If you know the concrete type or aren't using generics, you can avoid class names being written by telling the `Json` class the types:

```java
Json json = new Json();
json.setElementType(Person.class, "numbers", PhoneNumber.class);
System.out.println(json.prettyPrint(person));

{
numbers: [
	{
		number: "206-555-1234",
		name: Home
	},
	{
		number: "425-555-4321",
		name: Work
	}
],
name: Nate,
age: 31
}
```

When writing the class cannot be avoided, an alias can be given:

```java
Json json = new Json();
json.addClassTag("phoneNumber", PhoneNumber.class);
System.out.println(json.prettyPrint(person));

{
numbers: [
	{
		class: phoneNumber,
		number: "206-555-1234",
		name: Home
	},
	{
		class: phoneNumber,
		number: "425-555-4321",
		name: Work
	}
],
name: Nate,
age: 31
}
```

The `Json` class can write and read both JSON and a couple JSON-like formats. It supports "JavaScript", where the object property names are only quoted when needed. It also supports a "minimal" format (the default), where both object property names and values are only quoted when needed.

```java
Json json = new Json();
json.setOutputType(OutputType.json);
json.setElementType(Person.class, "numbers", PhoneNumber.class);
System.out.println(json.prettyPrint(person));

{
"numbers": [
	{
		"number": "206-555-1234",
		"name": "Home"
	},
	{
		"number": "425-555-4321",
		"name": "Work"
	}
],
"name": "Nate",
"age": 31
}
```

Note: By default, the Json class will not write those fields which have values that are identical to a newly constructed instance. If you wish to disable this behavior and include all fields, call `json.setUsePrototypes(false);`.

## <a id="reading-object-graphs"></a>Reading Object Graphs ##

The `Json` class uses reflection to automatically deserialize objects from JSON. Here is how to deserialize the JSON from the previous examples:

```java
Json json = new Json();
String text = json.toJson(person);
Person person2 = json.fromJson(Person.class, text);
```

The type passed to `fromJson` is the type of the root of the object graph. From this, the `Json` class determines the types of all the fields and all other objects encountered, recursively. The "knownType" and "elementType" of the root can be passed to `toJson`. This is useful if the type of the root object is not known:

```java
Json json = new Json();
json.setOutputType(OutputType.minimal);
String text = json.toJson(person, Object.class);
System.out.println(json.prettyPrint(text));
Object person2 = json.fromJson(Object.class, text);

{
class: com.example.Person,
numbers: [
	{
		class: com.example.PhoneNumber,
		number: "206-555-1234",
		name: Home
	},
	{
		class: com.example.PhoneNumber,
		number: "425-555-4321",
		name: Work
	}
],
name: Nate,
age: 31
}
```

To read the JSON as a DOM of maps, arrays, and values, the `JsonReader` class can be used:

```java
Json json = new Json();
String text = json.toJson(person, Object.class);
JsonValue root = new JsonReader().parse(text);
```

The `JsonValue` describes a JSON object, array, string, float, long, boolean, or null.

## <a id="customizing-serialization"></a>Customizing Serialization ##

Usually automatic serialization is sufficient, however there are some classes where automatic serialization is not possible or custom serialization is desired. Serialization may be customized by having the class implement the `Json.Serializable` interface or by registering a `Json.Serializer` with the `Json` instance.

This example uses `Json.Serializable` to write a phone number as an object with a single field:

```java
static public class PhoneNumber implements Json.Serializable {
   private String name;
   private String number;

   public void write (Json json) {
      json.writeValue(name, number);
   }

   public void read (Json json, JsonValue jsonMap) {
      name = jsonMap.child().name();
      number = jsonMap.child().asString();
   }
}

Json json = new Json();
json.setElementType(Person.class, "numbers", PhoneNumber.class);
String text = json.prettyPrint(person);
System.out.println(text);
Person person2 = json.fromJson(Person.class, text);

{
numbers: [
	{
		Home: "206-555-1234"
	},
	{
		Work: "425-555-4321"
	}
],
name: Nate,
age: 31
}
```

The class implementing `Json.Serializable` must have a zero argument constructor because object construction is done for you. In the `write` method, the surrounding JSON object has already been written. The `read` method always receives a `JsonValue` that represents that JSON object.

`Json.Serializer` provides more control over what is output, requiring `writeObjectStart` and `writeObjectEnd` to be called if you require a JSON object like `Json.Serializable`. Alternatively, a JSON array or a simple value (string, int, boolean) could be output instead of an object. `Json.Serializer` also allows the object creation to be customized:

```java
Json json = new Json();
json.setSerializer(PhoneNumber.class, new Json.Serializer<PhoneNumber>() {
   public void write (Json json, PhoneNumber number, Class knownType) {
      json.writeObjectStart();
      json.writeValue(number.name, number.number);
      json.writeObjectEnd();
   }

   public PhoneNumber read (Json json, JsonValue jsonData, Class type) {
      PhoneNumber number = new PhoneNumber();
      number.setName(jsonData.child().name());
      number.setNumber(jsonData.child().asString());
      return number;
   }
});
json.setElementType(Person.class, "numbers", PhoneNumber.class);
String text = json.prettyPrint(person);
System.out.println(text);
Person person2 = json.fromJson(Person.class, text);
```

## <a id="serialization-methods"></a>Serialization Methods ##

`Json` has many methods to read and write data to the JSON. Write methods without a name string are used to write a value that is not a JSON object field (eg, a string or an object in a JSON array). Write methods that take a name string are used to write a field name and value for a JSON object. 

`writeObjectStart` is used to start writing a JSON object, then values can be written using the write methods that take a name string. When the object is finished, `writeObjectEnd` must be called:

```java
json.writeObjectStart();
json.writeValue("name", "value");
json.writeObjectEnd();
```

The `writeObjectStart` methods that take an actualType and a knownType will write a class field to the JSON if the types differ. This enables the actual type to be known during deserialization. For example, the known type may be java.util.Map but the actual type is java.util.LinkedHashMap (which extends HashMap), so deserialization needs to know the actual type to create.

Writing arrays works in a similar manner, except the values should be written using the write methods that do not take a name string:

```java
json.writeArrayStart();
json.writeValue("value1");
json.writeValue("value2");
json.writeArrayEnd();
```

The `Json` class can automatically write Java object fields and values. `writeFields` writes all fields and values for the specified Java object to the current JSON object:

```java
json.writeObjectStart();
json.writeFields(someObject);
json.writeObjectEnd();
```

The `writeField` method writes the value for a single Java object field:

```java
json.writeObjectStart();
json.writeField(someObject, "javaFieldName", "jsonFieldName");
json.writeObjectEnd();
```

Many of the write methods take an "element type" parameter. This is used to specify the known type of objects in a collection. For example, for a list:

```java
ArrayList list = new ArrayList();
list.add(someObject1);
list.add(someObject2);
list.add(someObject3);
list.add(someOtherObject);
...
json.writeObjectStart();
json.writeValue("items", list);
json.writeObjectEnd();

{
	items: [
		{ class: com.example.SomeObject, value: 1 },
		{ class: com.example.SomeObject, value: 2 },
		{ class: com.example.SomeObject, value: 3 },
		{ class: com.example.SomeOtherObject, value: four }
	]
}
```

Here the known type of objects in the list is Object, so each object in the JSON for "items" has a class field that specifies Integer or String. By specifying the element type, Integer is used as the known type so only the last entry in the JSON for "items" has a class field:

```java
json.writeObjectStart();
json.writeValue("items", list, ArrayList.class, Integer.class);
json.writeObjectEnd();

{
	items: [
		{ value: 1 },
		{ value: 2 },
		{ value: 3 },
		{ class: com.example.SomeOtherObject, value: four }
	]
}
```

For maps, the element type is used for the values. The keys for maps are always strings, a limitation of how object fields are described using JSON.

Note that the `Json` class uses generics on Java field declarations to determine the element type where possible.

## <a id="supported-classes"></a>Supported Classes ##

Note that when using GWT, not all classes are serializable. `Json` supports the following:
* POJOs
* OrderedMap (but not ArrayMap)
* Array
* String
* Float
* Boolean

Make sure to provide your own de/serializers or mark objects you don't intend to serialize with the 'transient' keyword.

## <a id="event-based-parsing"></a>Manual and Event Based Parsing ##

The `JsonReader` class reads JSON and has protected methods that are called as JSON objects, arrays, strings, floats, longs, and booleans are encountered. By default, these methods build a DOM out of `JsonValue` objects. These methods can be overridden to do your own event based JSON handling.

```java
// read something 
JsonValue fromJson = new JsonReader().parse(jsonAsString);
nickName = fromJson.getString("nickName");
// ...

// write something
JsonValue toJson = new JsonValue(JsonValue.ValueType.object);
toJson.addChild("name", new JsonValue("some name");
toJson.addChild("age", 12);
// ...
toJson.toJson(JsonWriter.OutputType.json);
```


