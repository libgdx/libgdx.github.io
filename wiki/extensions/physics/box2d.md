---
title: Box2d
---
# Setting up Box2D with libGDX

Box2D is a 2D physics library. It is one of the most popular physics libraries for 2D games and has been ported to many languages and many different engines, including libGDX. The Box2D implementation in libGDX is a thin Java wrapper around the C++ engine. Therefore, their [documentation](https://box2d.org/documentation/) may come in handy.

Box2D is an extension and not included with libGDX by default. Thus a manual installation is required.

## Table of Contents

  * [Initialization](/wiki/extensions/physics/box2d#initialization)
  * [Creating a World](/wiki/extensions/physics/box2d#creating-a-world)
  * [Debug Renderer](/wiki/extensions/physics/box2d#debug-renderer)
  * [Stepping the simulation](/wiki/extensions/physics/box2d#stepping-the-simulation)
  * [Rendering](/wiki/extensions/physics/box2d#rendering)
  * [Objects/Bodies](/wiki/extensions/physics/box2d#objectsbodies)
    * [Dynamic Bodies](/wiki/extensions/physics/box2d#dynamic-bodies)
    * [Static Bodies](/wiki/extensions/physics/box2d#static-bodies)
    * [Kinematic Bodies](/wiki/extensions/physics/box2d#kinematic-bodies)
  * [Impulses/Forces](/wiki/extensions/physics/box2d#wiki-impulsesforces)
  * [Joints and Gears](/wiki/extensions/physics/box2d#joints-and-gears)
  * [Fixture Shapes](/wiki/extensions/physics/box2d#fixture-shapes)
  * [Sprites and Bodies](/wiki/extensions/physics/box2d#sprites-and-bodies)
  * [Sensors](/wiki/extensions/physics/box2d#sensors)
  * [Contact Listeners](/wiki/extensions/physics/box2d#contact-listeners)
  * [Resources](/wiki/extensions/physics/box2d#resources)
  * [Tools](/wiki/extensions/physics/box2d#tools)

## Initialization

To initialize Box2D it is necessary to call `Box2D.init()`. For backwards compatibility, creating a `World` for the first time will have the same effect, but using the `Box2D` class should be preferred.

## Creating a World

When setting up Box2D the first thing we need is a world. The world object is basically what holds all your physics objects/bodies and simulates the reactions between them. It does not however render the objects for you; for that you will use libGDX graphics functions. That said, libGDX does come with a Box2D debug renderer which is extremely handy for debugging your physics simulations, or even for testing your game-play before writing any rendering code.

To create the world we use the following code:

```java
World world = new World(new Vector2(0, -10), true);
```

The first argument we supply is a 2D vector containing the gravity: 0 to indicate no gravity in the horizontal direction, and -10 is a downwards force like in real life (assuming your y axis points upwards). These values can be anything you like, but remember to stick to a constant scale. In Box2D 1 unit = 1 meter.

The second value in the world creation is a boolean value which tells the world if we want objects to sleep or not. Generally we want objects to sleep as this conserves CPU usage, but there are situations where you might not want your objects to sleep.

It is advised to use the same scale you use for Box2D to draw graphics. This means drawing a Sprite with a width/height in meters. To scale up the graphics to make them visible, you should use a camera with a viewportWidth / viewportHeight also in meters. E.g: drawing a Sprite with a width of 2.0f (2 meters) and using a camera viewportWidth of 20.0f, the Sprite will fill 1/10th of the width on the window.

**A common mistake** is measuring your world in pixels instead of meters. Box2D objects can only travel so fast. If pixels are used (such as 640 by 480) instead of meters (such as 12 by 9), objects will always move slowly no matter what you do.

## Debug Renderer

The next thing we are going to do is setup our debug renderer. You generally will not use this in a released version of your game, but for testing purposes we will set it up now like so:

```java
Box2DDebugRenderer debugRenderer = new Box2DDebugRenderer();
```



## Stepping the simulation

To update our simulation we need to tell our world to step. Stepping basically updates the world objects through time. The best place to call our step function is at the end of our `render()` loop. In a perfect world everyone's frame rate is the same

```java
world.step(1/60f, 6, 2);
```

The first argument is the time-step, or the amount of time you want your world to simulate. In most cases you want this to be a fixed time step. libGDX recommends using a value between `1/60f` (which is 1/60th of a second) and `1/240f` (1/240th of a second).

The other two arguments are `velocityIterations` and `positionIterations`. For now we will leave these at `6` and `2`, but you can read more about them in the Box2D documentation.

Stepping your simulation is a topic unto itself. See [this article](https://gafferongames.com/post/fix_your_timestep/) for an excellent discussion on the use of variable time steps.

The result might look similar to this:

```java
private float accumulator = 0;

private void doPhysicsStep(float deltaTime) {
    // fixed time step
    // max frame time to avoid spiral of death (on slow devices)
    float frameTime = Math.min(deltaTime, 0.25f);
    accumulator += frameTime;
    while (accumulator >= Constants.TIME_STEP) {
        WorldManager.world.step(Constants.TIME_STEP, Constants.VELOCITY_ITERATIONS, Constants.POSITION_ITERATIONS);
        accumulator -= Constants.TIME_STEP;
    }
}
```

## Rendering

It is recommended that you render all your graphics before you do your physics step, otherwise it will be out of sync. To do this with our debug renderer we do the following:

```java
debugRenderer.render(world, camera.combined);
```

The first argument is our Box2D world and the second argument is our libGDX camera.



## Objects/Bodies

Now if you run your game it will be pretty boring as nothing happens. The world steps but we don’t see anything as we don’t have anything to interact with it. So now we’re going to add some objects.

In Box2D our objects are called _bodies_, and each body is made up of one or more _fixtures_, which have a fixed position and orientation within the body. Our fixtures can be any shape you can imagine or you can combine a variety of different shaped fixtures to make the shape you want.

A fixture has a shape, density, friction and restitution attached to it. Shape is obvious. Density is the mass per square metre: a bowling ball is very dense, yet a balloon isn’t very dense at all as it is mainly filled with air. Friction is the amount of opposing force when the object rubs/slides along something: a block of ice would have a very low friction but a rubber ball would have a high friction. Restitution is how bouncy something is: a rock would have a very low restitution but a basketball would have a fairly high restitution. A body with a restitution of 0 will come to a halt as soon as it hits the ground, whereas a body with a restitution of 1 would bounce to the same height forever.

Bodies come in three different types: dynamic, kinematic and static. Each type is described below.


### Dynamic Bodies

Dynamic bodies are objects which move around and are affected by forces and other dynamic, kinematic and static objects. Dynamic bodies are suitable for any object which needs to move and be affected by forces.

We have now learned about fixtures which make up our bodies, so let's get dirty and start to create some bodies and add fixtures to them!

```java
// First we create a body definition
BodyDef bodyDef = new BodyDef();
// We set our body to dynamic, for something like ground which doesn't move we would set it to StaticBody
bodyDef.type = BodyType.DynamicBody;
// Set our body's starting position in the world
bodyDef.position.set(5, 10);

// Create our body in the world using our body definition
Body body = world.createBody(bodyDef);

// Create a circle shape and set its radius to 6
CircleShape circle = new CircleShape();
circle.setRadius(6f);

// Create a fixture definition to apply our shape to
FixtureDef fixtureDef = new FixtureDef();
fixtureDef.shape = circle;
fixtureDef.density = 0.5f;
fixtureDef.friction = 0.4f;
fixtureDef.restitution = 0.6f; // Make it bounce a little bit

// Create our fixture and attach it to the body
Fixture fixture = body.createFixture(fixtureDef);

// Remember to dispose of any shapes after you're done with them!
// BodyDef and FixtureDef don't need disposing, but shapes do.
circle.dispose();
```

Now we have created a ball like object and added it to our world. If you run the game now you should see a ball fall down the screen. This is still fairly boring though, as it has nothing to interact with. So let's create a floor for our ball to bounce on.



### Static Bodies

Static bodies are objects which do not move and are not affected by forces. Dynamic bodies are affected by static bodies. Static bodies are perfect for ground, walls, and any object which does not need to move. Static bodies require less computing power.

Let's go ahead and create our floor as a static body. This is much like creating our dynamic body earlier.

```java
// Create our body definition
BodyDef groundBodyDef = new BodyDef();  
// Set its world position
groundBodyDef.position.set(new Vector2(0, 10));  

// Create a body from the definition and add it to the world
Body groundBody = world.createBody(groundBodyDef);  

// Create a polygon shape
PolygonShape groundBox = new PolygonShape();  
// Set the polygon shape as a box which is twice the size of our view port and 20 high
// (setAsBox takes half-width and half-height as arguments)
groundBox.setAsBox(camera.viewportWidth, 10.0f);
// Create a fixture from our polygon shape and add it to our ground body  
groundBody.createFixture(groundBox, 0.0f);
// Clean up after ourselves
groundBox.dispose();
```

See how we created a fixture without the need to define a `FixtureDef`? If all you need to specify is a shape and a density, the `createFixture` method has a useful overload for that.

Now if you run the game you should see a ball fall and then bounce on our newly created ground. Play around with some of the different values for the ball like density and restitution and see what happens.



### Kinematic Bodies

Kinematic bodies are somewhat in between static and dynamic bodies. Like static bodies, they do not react to forces, but like dynamic bodies, they do have the ability to move. Kinematic bodies are great for things where you, the programmer, want to be in full control of a body's motion, such as a moving platform in a platform game.

It is possible to set the position on a kinematic body directly, but it's usually better to set a velocity instead, and letting Box2D take care of position updates.

You can create a kinematic body in much the same way as the dynamic and static bodies above. Once created, you can control the velocity like this:

```java
// Move upwards at a rate of 1 meter per second
kinematicBody.setLinearVelocity(0.0f, 1.0f);
```

## Impulses/Forces

Impulses and Forces are used to move a body in addition to gravity and collision.

Forces occur gradually over time to change the velocity of a body. For example, a rocket lifting off would slowly have forces applied as the rocket slowly begins to accelerate.

Impulses on the other hand make immediate changes to the body's velocity. For example, playing Pac-Man the character always moved at a constant speed and achieved instant velocity upon being moved.

First you will need a Dynamic Body to apply forces/impulses to, see the [Dynamic Bodies](#dynamic_bodies) section above.

**Applying Force**

Forces are applied in Newtons at a World Point. If the force is not applied to the center of mass, it will generate torque and affect the angular velocity.

```java
// Apply a force of 1 meter per second on the X-axis at pos.x/pos.y of the body slowly moving it right
dynamicBody.applyForce(1.0f, 0.0f, pos.x, pos.y, true);

// If we always want to apply force at the center of the body, use the following
dynamicBody.applyForceToCenter(1.0f, 0.0f, true);
```

**Applying Impulse**

Impulses are just like Forces with the exception that they immediately modify the velocity of a body. As with forces, if the impulse is not applied at the center of a body, it will create torque which modifies angular velocity. Impulses are applied in Newton-seconds or kg-m/s.

```java
// Immediately set the X-velocity to 1 meter per second causing the body to move right quickly
dynamicBody.applyLinearImpulse(1.0f, 0, pos.x, pos.y, true);
```

Keep in mind applying forces or impulses will wake the body. Sometimes this behavior is undesired. For example, you may be applying a steady force and want to allow the body to sleep to improve performance. In this case you can set the wake boolean value to false.

```java
// Apply impulse but don't wake the body
dynamicBody.applyLinearImpulse(0.8f, 0, pos.x, pos.y, false);
```

**Player Movement Example**

In this example, we will make a player run left or right and accelerate to a maximum velocity, just like Sonic the Hedgehog. For this example we have already created a Dynamic Body named 'player'. In addition we have defined a MAX_VELOCITY variable so our player won't accelerate beyond this value. Now it's just a matter of applying a linear impulse when a key is pressed.

```java
Vector2 vel = this.player.body.getLinearVelocity();
Vector2 pos = this.player.body.getPosition();

// apply left impulse, but only if max velocity is not reached yet
if (Gdx.input.isKeyPressed(Keys.A) && vel.x > -MAX_VELOCITY) {			
     this.player.body.applyLinearImpulse(-0.80f, 0, pos.x, pos.y, true);
}

// apply right impulse, but only if max velocity is not reached yet
if (Gdx.input.isKeyPressed(Keys.D) && vel.x < MAX_VELOCITY) {
     this.player.body.applyLinearImpulse(0.80f, 0, pos.x, pos.y, true);
}
```

## Joints and Gears

Every joint requires to have definition set up before creating it by box2d world. Using *initialize* helps with ensuring that all joint parameters are set.

Note that destroying the joint after the body will cause crash. Destroying the body also destroys joints connected to it.

```java
DistanceJointDef defJoint = new DistanceJointDef ();
defJoint.length = 0;
defJoint.initialize(bodyA, bodyB, new Vector2(0,0), new Vector2(128, 0));

DistanceJoint joint = (DistanceJoint) world.createJoint(defJoints); // Returns subclass Joint.
```

### DistanceJoint

Distance joint makes length between bodies constant.

Distance joint definition requires defining an anchor point on both bodies and the non-zero length of the distance joint.

The definition uses local anchor points so that the initial configuration can violate the constraint slightly. This helps when saving and loading a game.

**Do not use a zero or short length!**

```java
// DistanceJointDef.initialize (Body bodyA, Body bodyB, Vector2 anchorA, Vector2 anchorB)

DistanceJointDef defJoint = new DistanceJointDef ();
defJoint.length = 0;
defJoint.initialize(bodyA, bodyB, new Vector2(0,0), new Vector2(128, 0));
```

### FrictionJoint

Friction joint is used for top-down friction. It provides 2D translational friction and angular friction.

```java
FrictionJointDef jointDef = new FrictionJointDef ();
jointDef.maxForce = 1f;
jointDef.maxTorque = 1f;
jointDef.initialize(bodyA, bodyB, anchor);
```

### GearJoint

A gear joint is used to connect two joints together. Either joint can be a revolute or prismatic joint. You specify a gear ratio to bind the motions together: coordinate1 + ratio * coordinate2 = constant The ratio can be negative or positive. If one joint is a revolute joint and the other joint is a prismatic joint, then the ratio will have units of length or units of 1/length.

```java
GearJointDef jointDef = new GearJointDef (); // has no initialize
```

### MotorJoint
A motor joint is used to control the relative motion between two bodies. A typical usage is to control the movement of a dynamic body with respect to the ground.

```java
MotorJointDef jointDef = new MotorJointDef ();
jointDef.angularOffset = 0f;
jointDef.collideConnected = false;
jointDef.correctionFactor = 0f;
jointDef.maxForce = 1f;
jointDef.maxTorque = 1f;
jointDef.initialize(bodyA, bodyB);
```

### MouseJoint
The mouse joint is used in the testbed to manipulate bodies with the mouse. It attempts to drive a point on a body towards the current position of the cursor. There is no restriction on rotation.

```java
MouseJointDef jointDef = new MouseJointDef();
jointDef.target = new Vector2(Gdx.input.getX(), Gdx.input.getY());

MouseJoint joint = (MouseJoint) world.createJoint(jointDef);
joint.setTarget(new Vector2(Gdx.input.getX(), Gdx.input.getY()));
```

### PrismaticJoint

A prismatic joint allows for relative translation of two bodies along a specified axis. A prismatic joint prevents relative rotation. Therefore, a prismatic joint has a single degree of freedom.

```java
PrismaticJointDef jointDef = new PrismaticJointDef ();
jointDef.lowerTranslation = -5.0f;
jointDef.upperTranslation = 2.5f;

jointDef.enableLimit = true;
jointDef.enableMotor = true;

jointDef.maxMotorForce = 1.0f;
jointDef.motorSpeed = 0.0f;
```

### PulleyJoint

A pulley is used to create an idealized pulley. The pulley connects two bodies to ground and to each other. As one body goes up, the other goes down. The total length of the pulley rope is conserved according to the initial configuration.

```java
JointDef jointDef = new JointDef ();
float ratio = 1.0f;
jointDef.Initialize(myBody1, myBody2, groundAnchor1, groundAnchor2, anchor1, anchor2, ratio);
```

### RevoluteJoint

A revolute joint forces two bodies to share a common anchor point, often called a hinge point. The revolute joint has a single degree of freedom: the relative rotation of the two bodies. This is called the joint angle

```java
RevoluteJointDef jointDef = new RevoluteJoint();
jointDef.initialize(bodyA, bodyB, new Vector2(0,0), new Vector2(128, 0));

jointDef.lowerAngle = -0.5f * b2_pi; // -90 degrees
jointDef.upperAngle = 0.25f * b2_pi; // 45 degrees

jointDef.enableLimit = true;
jointDef.enableMotor = true;

jointDef.maxMotorTorque = 10.0f;
jointDef.motorSpeed = 0.0f;
```

### RopeJoint

A rope joint enforces a maximum distance between two points on two bodies. It has no other effect. Warning: if you attempt to change the maximum length during the simulation you will get some non-physical behavior. A model that would allow you to dynamically modify the length would have some sponginess, so I chose not to implement it that way. See b2DistanceJoint if you want to dynamically control length.

```java
RopeJointDef jointDef = new RopeJointDef (); // has no initialize
```

### WeldJoint

A weld joint essentially glues two bodies together. A weld joint may distort somewhat because the island constraint solver is approximate.

```java
WeldJointDef jointDef = new WeldJointDef ();
jointDef.initialize(bodyA, bodyB, anchor);
```

### WheelJoint

A wheel joint. This joint provides two degrees of freedom: translation along an axis fixed in bodyA and rotation in the plane. You can use a joint limit to restrict the range of motion and a joint motor to drive the rotation or to model rotational friction. This joint is designed for vehicle suspensions.

```java
WheelJointDef jointDef = new WheelJointDef();
jointDef.maxMotorTorque = 1f;
jointDef.motorSpeed = 0f;
jointDef.dampingRatio = 1f;
jointDef.initialize(bodyA, bodyB, anchor, axis); // axis is Vector2(1,1)

WheelJoint joint = (WheelJoint) physics.createJoint(jointDef);
joint.setMotorSpeed(1f);
```

## Fixture Shapes

As mentioned previously, a fixture has a shape, density, friction and restitution attached to it.
Out of the box you can easily create boxes (as seen in the section [Static Bodies](/wiki/extensions/physics/box2d#static-bodies) section) and circle shapes (as seen in the [Dynamic Bodies](/wiki/extensions/physics/box2d#dynamic-bodies) section).

You can programatically define more complex shapes using the following classes
* ChainShape,
* EdgeShape,
* PolygonShape

However using third party tools you can simply define your shapes and import them into your game.

### Importing Complex Shapes using box2d-editor

[box2d-editor](https://github.com/julienvillegas/box2d-editor) is a free open source tool to define complex shapes and load them into your game.
An example of how to import a shape into your game using box2d-editor is available on [Libgdx.info](https://libgdxinfo.wordpress.com/box2d-importing-complex-bodies/).

Check out the [Tools section](/wiki/extensions/physics/box2d#Tools) for more tools.

In a nutshell, if you are using Box2d-editor:
* Create your shape within Box2d-editor.
* Export your scene and copy the file into your asset folder.
* Copy file BodyEditorLoader.java into your "core" module source folder.

Then in your game you can do:

```java
BodyEditorLoader loader = new BodyEditorLoader(Gdx.files.internal("box2d_scene.json"));

BodyDef bd = new BodyDef();
bd.type = BodyDef.BodyType.KinematicBody;
body = world.createBody(bd);

// 2. Create a FixtureDef, as usual.
FixtureDef fd = new FixtureDef();
fd.density = 1;
fd.friction = 0.5f;
fd.restitution = 0.3f;

// 3. Create a Body, as usual.
loader.attachFixture(body, "gear", fd, scale);
```

## Sprites and Bodies

The easiest way to manage a link between your sprites or game objects and Box2D is with Box2D’s User Data. You can set the user data to your game object and then update the object's position based on the Box2D body.

Setting a body's user data is easy

```java
body.setUserData(Object);
```

This can be set to any Java object. It is also good to create your own game actor/object class which allows you to set a reference to its physics body.

Fixtures can also have user data set to them in the same way.

```java
fixture.setUserData(Object);
```

To update all your actors/sprites you can loop through all the world's bodies easily in your game/render loop.

```java
// Create an array to be filled with the bodies
// (better don't create a new one every time though)
Array<Body> bodies = new Array<Body>();
// Now fill the array with all bodies
world.getBodies(bodies);

for (Body b : bodies) {
    // Get the body's user data - in this example, our user
    // data is an instance of the Entity class
    Entity e = (Entity) b.getUserData();

    if (e != null) {
        // Update the entities/sprites position and angle
        e.setPosition(b.getPosition().x, b.getPosition().y);
        // We need to convert our angle from radians to degrees
        e.setRotation(MathUtils.radiansToDegrees * b.getAngle());
    }
}
```

Then render your sprites using a libGDX `SpriteBatch` as usual.

## Sensors
Sensors are Bodies that do not produce automatic responses during a collision (such as applying force). This is useful when one needs to be in complete control of what happens when two shapes collide.
For example, think of a drone that has some kind of circular distance of sight. This body should follow the drone but shouldn't have a physical reaction to it, or any other bodies. It should detect when some target is inside it's shape.

To configure a body to be a sensor, set the 'isSensor' flag to true. An example would be:

```java
//At the definition of the Fixture
fixtureDef.isSensor = true;
```

In order to listen to this sensor contact, we need to implement the ContactListener interface methods.

## Contact Listeners
The Contact Listeners listen for collisions events on a specific fixture. The methods are passed a Contact object, which contain information about the two bodies involved.
The beginContact method is called when the object overlaps another. When the objects are no longer colliding, the endContact method is called.

```java
public class ListenerClass implements ContactListener {
		@Override
		public void endContact(Contact contact) {

		}

		@Override
		public void beginContact(Contact contact) {

		}
	};
```

This class needs to be set as the world's contact listener in the screen's show() or init() method.

```java
world.setContactListener(ListenerClass);
```

We might get information about the bodies from the contact fixtures.
Depending on the application design, the Entity class should be referenced in the Body or Fixture user data, so we can use it from the Contact and make some changes (e.g. change the player health).

## Resources

There are a lot of really good Box2D resources out there and most of the code can be easily converted to libgdx.

  * A basic implementation and code sample for Box2D with Scene2D is also available on [LibGDX.info](https://libgdxinfo.wordpress.com/box2d-basic/).
  * [Box2D documentation](https://box2d.org/documentation/) and [Discord](https://discord.com/invite/NKYgCBP) are a great place to find help.
  * A really good [tutorial series on Box2D](https://www.iforce2d.net/b2dtut/). Covers a lot of different problems which you will more than likely run across in your game development.

## Tools

The following is a list of tools for use with box2d and libgdx:

### Free Open Source

  * [Physics Body Editor](https://github.com/julienvillegas/box2d-editor)

Code sample available on [LibGDX.info](https://libgdxinfo.wordpress.com/box2d-importing-complex-bodies//)

### Commercial

  * [RUBE](https://www.iforce2d.net/rube/) editor for creating box2d worlds. Use[RubeLoader](https://github.com/indiumindeed/RubeLoader) for loading RUBE data into libgdx.
  * [PhysicsEditor](https://www.codeandweb.com/physicseditor)
