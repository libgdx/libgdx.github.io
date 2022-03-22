---
title: Bullet Wrapper Contact callbacks
---
Contact callbacks allow you to be notified when a contact/collision on two objects occur ([more info and a performance related warning](https://web.archive.org/web/20180906172418/http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Callbacks_and_Triggers)).

By default there are three callbacks: [`onContactAdded`](https://web.archive.org/web/20180906172418/http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Callbacks_and_Triggers#gContactAddedCallback), [`onContactProcessed`](https://web.archive.org/web/20180906172418/http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Callbacks_and_Triggers#gContactProcessedCallback) and [`onContactDestroyed`](https://web.archive.org/web/20180906172418/http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Callbacks_and_Triggers#gContactDestroyedCallback)) . The wrapper adds two additional callbacks: `onContactStarted` and `onContactEnded` ([more info](https://pybullet.org/Bullet/phpBB3/viewtopic.php?t=7739&p=32470)). The callbacks are global (independent of e.g. the collision world), there can be only one implementation per callback active at any given time.

### Contact Listeners
You can extend the ContactListener class to implement one or more callbacks:
```java
public class MyContactListener extends ContactListener {
	@Override
	public void onContactStarted (btCollisionObject colObj0, btCollisionObject colObj1) {
		// implementation
	}
	@Override
	public void onContactProcessed (int userValue0, int userValue1) {
		// implementation
	}
}
```

Note that there can only be one listener enabled for each callback at a time. You can use the `enable();` method to set the listener active, which disables any other listeners on that particular callback. Use the `disable();` method to stop being notified for that particular callback. Instantiating a listener automatically enables that callback and destroying (`dispose();` method) automatically disables it.

The ContactListener class provides one or more method signatures per callback you can override. For example the `onContactAdded` callback can be overridden using the following signatures:

```java
boolean onContactAdded(btManifoldPoint cp, btCollisionObjectWrapper colObj0Wrap, int partId0, int index0, btCollisionObjectWrapper colObj1Wrap, int partId1, int index1);

boolean onContactAdded(btManifoldPoint cp, btCollisionObject colObj0, int partId0, int index0, btCollisionObject colObj1, int partId1, int index1);

boolean onContactAdded(btManifoldPoint cp, int userValue0, int partId0, int index0, int userValue1, int partId1, int index1);

boolean onContactAdded(btCollisionObjectWrapper colObj0Wrap, int partId0, int index0, btCollisionObjectWrapper colObj1Wrap, int partId1, int index1);

boolean onContactAdded(btCollisionObject colObj0, int partId0, int index0, btCollisionObject colObj1, int partId1, int index1);

boolean onContactAdded(int userValue0, int partId0, int index0, int userValue1, int partId1, int index1);
```

As you can see it has three methods which provide the `btManifoldPoint` and three which don’t.  To provide the actual collision objects, you can choose between either the `btCollisionObjectWrapper`, `btCollisionObject` or the `userValue`.

Make sure to override the method that only provides the arguments you are actually going to use. For example, if you are not going to use the `btManifoldPoint` then it wouldn’t make sense to create an object for that argument each time the callback is called. Likewise using `btCollisionObject` is more performant than using `btCollisionObjectWrapper`, because the `btCollisionObject` is reused. The `userValue` is even more performant, because the object isn’t mapped at all  (see [#btCollisionObject btCollisionObject] on how to use the useValue).

The `onContactAdded` callback will only be triggered if at least one of the two colliding bodies has the `CF_CUSTOM_MATERIAL_CALLBACK` set:
```java
body.setCollisionFlags(e.body.getCollisionFlags() | btCollisionObject.CollisionFlags.CF_CUSTOM_MATERIAL_CALLBACK);
```

To identify a contact along the added, processed and destroyed callbacks, you can use the `setUserValue(int);` and `getUserValue();` of the `btManifoldPoint` instance that the callback provides. This is also the value supplied to the `onContactDestroyed(int)` method of the `ContactListener` class. Note that the `onContactDestroyed` callback is only triggered if the user value is non-zero.

### <a id="Contact_Filtering"></a>Contact Filtering

Contact callbacks are invoked a lot. JNI bridging between C++ and Java on every call adds quite an overhead, which decreases performance. Therefor the bullet wrapper allows you to specify for which objects you would like to receive contacts. This is done by contact filtering.

Similar to collision filtering, for every `btCollisionObject`, you can specify a flag using the `setContactCallbackFlag(int);` method and a filter using the `setContactCallbackFilter(int);` method. The filter of object A matches object B if `A.filter & B.flag == B.flag`. Only if one or both of the filters match the contact is passed to the listener.

```java
static int PLAYER_FLAG = 2; // second bit
static int COIN_FLAG = 4; // third bit
btCollisionObject player;
btCollisionObject coin;
...
player.setContactCallbackFlag(PLAYER_FLAG);
coin.setContactCallbackFilter(PLAYER_FLAG);
// The listener will only be called if a coin collides with player
```

By default the `contactCallbackFlag` of a `btCollisionObject` is set to 1 and the `contactCallbackFilter` is set to 0. Note that setting the flag to zero will cause the callback always to be invoked for that object (because `x & 0 == 0`).

Whether or not contact filtering is used, is decided by which method signature you override. For every callback that supports contact filtering the `ContactListener` class provides method signatures with the `boolean match0` and `boolean match1` arguments. If you override such method, contact filtering is used on that method. If you override a method that doesn’t have the `boolean match` arguments, then contact filtering is not used for that method.

You can use the `boolean match0` and `boolean match1` values to check which of both filters matches.
```java
public class MyContactListener extends ContactListener {
	@Override
	public void onContactEnded (int userValue0, boolean match0, int userValue1, boolean match1) {
		if (match0) {
			// collision object 0 (userValue0) matches
		}
		if (match1) {
			// collision object 1 (userValue1) matches
		}
	}
}
```

Even when using contact filtering, the callbacks can be invoked quite often on collision. To avoid this you can set the filter to zero after processing. For example, in the case of the player and the coin, it's best to let the coin collide with the player and than set it's filter to zero on first contact, instead of letting the player collide with the coin.
