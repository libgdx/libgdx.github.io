---
title: Collections
---
# Lists #

## [Array](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/Array.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/Array.java) ##

A resizable, ordered or unordered array of objects. It often replaces ArrayList. It provides direct access to the backing array, which can be of a specific type rather than just Object[]. It can also be unordered, acting like a [bag/multiset](http://en.wikipedia.org/wiki/Set_%28computer_science%29#Multiset). In this case, a memory copy is avoided when removing elements (the last element is moved to the removed element's position).

The iterator returned by `iterator()` is always the same instance, allowing the Array to be used with the enhanced for-each (`for( : )`) syntax without creating garbage. Note however that this differs from most iterable collections! It cannot be used in nested loops, else it will cause hard to find bugs.

## Primitive lists ##


  * [IntArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/IntArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/IntArray.java)
  * [FloatArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/FloatArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/FloatArray.java)
  * [BooleanArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/BooleanArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/BooleanArray.java)
  * [CharArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/CharArray.html)
[(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/CharArray.java)
  * [LongArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/LongArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/LongArray.java)
  * [ByteArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ByteArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ByteArray.java)

These are identical to Array except they use primitive types instead of objects. This avoids boxing and unboxing.

## Specialized lists ##


### [SnapshotArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/SnapshotArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/SnapshotArray.java) ###

This is identical to Array except it guarantees that array entries provided by `begin()`, between indexes 0 and the size at the time `begin` was called, will not be modified until `end()` is called. This can be used to avoid concurrent modification. It requires iteration to be done a specific way:

```java
SnapshotArray array = new SnapshotArray();
// ...
Object[] items = array.begin();
for (int i = 0, n = array.size; i < n; i++) {
	Object item = items[i];
	// ...
}
array.end();
```

If any code inside `begin()` and `end()` would modify the SnapshotArray, the internal backing array is copied so that the array being iterated over is not modified. The extra backing array created when this occurs is kept so it can be reused if a concurrent modification occurs again in the future.

### [DelayedRemovalArray](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/DelayedRemovalArray.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/DelayedRemovalArray.java) ###

This is identical to Array except any removals done after `begin()` is called are queued and only occur once `end()` is called. This can be used to avoid concurrent modification. Note that code using this type of list must be aware that removed items are not actually removed immediately. Because of this, often SnapshotArray is easier to use.


### [PooledLinkedList](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/PooledLinkedList.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/PooledLinkedList.java) ###

A simple linked list that pools its nodes.

### [SortedIntList](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/SortedIntList.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/SortedIntList.java) ###

A sorted double linked list which uses ints for indexing.

# Maps #


## [ObjectMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ObjectMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ObjectMap.java) ##

An unordered map. This implementation is a cuckoo hash map using three hashes, random walking, and a small stash for problematic keys. Null keys are not allowed, null values are. No allocation is done except when growing the table size.

Keys may only be in one of three locations in the backing array, allowing this map to perform very fast get, containsKey, and remove. Put can be a bit slower, depending on hash collisions. Load factors greater than 0.91 greatly increase the chances the map will have to rehash to the next higher POT backing array size.

## Primitive maps ##

  * [IntMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/IntMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/IntMap.java)
  * [LongMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/LongMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/LongMap.java)
  * [ObjectIntMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ObjectIntMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ObjectIntMap.java)
  * [ObjectFloatMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ObjectFloatMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ObjectFloatMap.java)

These maps are identical to ObjectMap except they use primitive types for the keys, except ObjectIntMapand ObjectFloatMap which use primitive values. This avoids boxing and unboxing.

## Specialized maps ##

###  [OrderedMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/OrderedMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/OrderedMap.java) ###

This map is identical to ObjectMap except keys are also stored in an Array. This adds overhead to put and remove but provides ordered iteration. The key Array can be sorted directly to change the iteration order.

### [IdentityMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/IdentityMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/IdentityMap.java) ###

This map is identical to ObjectMap except keys are compared using identity comparison (`==` instead of `.equals()`).

### [ArrayMap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ArrayMap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ArrayMap.java)        

This map uses arrays for both the keys and values. This means get does a comparison for each key in the map, but provides fast, ordered iteration and entries can be looked up by index.

# Sets #

## [ObjectSet](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/ObjectSet.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/ObjectSet.java) ##

Exactly like ObjectMap, except only keys are stored. No values are stored for each key.

## Primitive sets ##

  * [IntSet](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/IntSet.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/IntSet.java)

These maps are identical to ObjectSet except they use primitive types for the keys. This avoids boxing and unboxing.

# Other collections #

### [BinaryHeap](http://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/utils/BinaryHeap.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/BinaryHeap.java) ###

A [binary heap](http://en.wikipedia.org/wiki/Binary_heap). Can be a min-heap or a max-heap.

# Benchmarks #
The benchmark below shows the difference between array and hashtable lookup (`.contains()` or `.get()`) using libGDX collection methods.
If you have less than 1024 elements in a list, you shouldn't bother whether you're using arrays or hashtables (Maps or Sets). Mind the fact that hashtables have significantly slower iteration than arrays and cannot be ordered.

```
                  array.size         GdxArray.contains()     GdxObjectSet.contains()
                           2                         0ms                         0ms
                           4                         0ms                         0ms
                           8                         0ms                         1ms
                          16                         0ms                         1ms
                          32                         0ms                         0ms
                          64                         0ms                         0ms
                         128                         0ms                         0ms
                         256                         1ms                         0ms
                         512                         1ms                         0ms
                        1024                         2ms                         0ms
                        2048                         4ms                         0ms
                        4096                        11ms                         0ms
                        8192                        22ms                         0ms
                       16384                        80ms                         0ms
                       32768                       112ms                         0ms
                       65536                       403ms                         0ms
                      131072                       615ms                         1ms
```
