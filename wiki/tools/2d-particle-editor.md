---
title: 2D Particle Editor
---
The libGDX 2D Particle Editor is a powerful tool for making particle effects. See the video and documentation below. The Java API works (the editor is built using it) but could use some clean up and definitely some documentation. There is a [runnable example](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/ParticleEmitterTest.java), though unfortunately it isn't the simplest for typical usage. Improvements to particles is planned, but will be some time until we can get to it.

![images/particle-editor.png](/assets/wiki/images/particle-editor.png)

## Running the 2D Particle Editor

To run the editor, you can check out libGDX and run it [from source](https://libgdx.com/dev/from_source/). The editor is in the gdx-tools project. **Alternatively, download the editor [here](https://libgdx-nightlies.s3.eu-central-1.amazonaws.com/libgdx-runnables/runnable-2D-particles.jar).**

Thirdly, if you are using Gradle and you added "Tools" extension to your project, you can easily run the particle editor from your IDE. For example, in IntelliJ: Open the Navigate menu (Cmd-N on OSX) and type ParticleEditor, and IntelliJ should find the ParticleEditor.java file. It has a .main() method that is used to launch the file. Right-click and select "Run ParticleEditor.main()" and IntelliJ will open the run configuration dialog box. In the "Use classpath of module:" dropdown, select your desktop project, and then click Run. This will create a run configuration that you can use later to launch the particle editor easily.

## Using the Particle Editor

Video:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=w8xkf3O4nho
" target="_blank"><img src="http://img.youtube.com/vi/w8xkf3O4nho/0.jpg"
alt="Particle Editor Usage" width="480" height="360" border="10" /></a>

Also see this [tutorial on JGO](https://jvm-gaming.org/t/particle-effects-in-libgdx/41758).

Briefly, a particle effect consists of some images that are moved around. The images usually use additive blending and some pretty stunning results can be produced with only a few images. Particle effects are good for fire, explosions, smoke, etc. Each particle has many properties that control how it behaves: life, velocity, rotation, scale, etc. The particle editor allows you to manipulate these properties and observe the result in real time. You can also create effects programmatically, but it is much more difficult and time consuming to create great effects.

The first step to creating an effect is to choose an image. The default image is just a simple round gradient. Experiment with different images to create a wide variety of effects. Images will often combine for some surprising and sometimes very cool looking results.

When you are configuring properties, you are actually configuring the particle emitter that will create and manage the particles. In code, the emitter is represented by the ParticleEmitter class. A particle effect is made up of one or more emitters, which is managed in the lower left of the particle editor. In code, the effect is represented by the ParticleEffect class, which has a list of ParticleEmitters.

### Properties Panel Elements

There are some common elements that appear in several of the properties panels.

#### Active button

Properties with an "Active" toggle button can be turned off, which can minimize some of the work that needs to be done at run-time.

#### Number / number range

Some of the number fields have a `>` button beside them. Clicking this button changes the number into a number range, where at runtime, a random value is selected from between the two specified values, every time the number is referenced. For example, if a range of 1-2 is selected for the Life property, each new particle will have some random length life between 1 and 2 seconds.

#### Chart

A chart is used to control the value of a property over time. The word "Duration" or "Life" in the middle of the chart indicates whether the horizontal timeline of the chart is relative to the duration of the emitter, or the lifetime of each single particle.

The "High" and "Low" number fields indicate the values that correspond with the top and bottom of the chart. Like other number fields, they can be expanded into a range with the `>` button. The random number in the range is chosen when the effect starts for a “Duration” chart, and when a particle is spawned for a “Life” chart.

Within the chart itself:
* To add nodes, click anywhere in the chart.
* To move nodes, click and drag an existing node. You can hold CTRL while dragging to drag all nodes at once. You can hold CTRL-SHIFT to drag all nodes proportionally, relative to the bottom, which is especially useful for the Transparency parameter.
* To delete a node, double-click it.

The `+` button expands the chart for fine-tuning.

The “Relative” checkbox. When unchecked, the value at any one point in time for the property will be what the chart shows. When checked, the value shown on the chart is added to the initial value of the property. Why? Imagine you have rotation set to start at 0 and go to 360 degrees over the life of a particle. This is nice, but all the particles start at the same zero rotation, so you change the “Low” value to start between 0 and 360. Now your particles will start between 0 and 360, and rotate to exactly 360 degrees. If a particle spawns at 330 degrees, it will only rotate 30 degrees. Now, if you check “Relative”, a particle that spawns at 330 degrees will rotate to 330 + 360 degrees, which is probably what you want in this case.

Finally, the "Independent" checkbox. Some properties allow switching how the chart controls the property over time from emitter to single/independent particle. Let's imagine that we have a chart with ranged values defined on the "Life" property. By default the chart affects the emitter as a whole. Each time the emitter generates particles, a random value within the appropriate range for that time will be chosen and all emited particles will have that value set as life. On the other hand, if "Independent" is checked, a new random value will be calculated per emitted particle and set as life to each of them independently.

### Properties

**Delay:** When an effect starts, this emitter will do nothing for this many milliseconds. This can be used to synchronize multiple emitters.

**Duration:** How long the emitter will emit particles. Note this is not the same as how long particles will live.

**Count:** Controls the minimum number of particles that must always exist, and the maximum number of particles that can possibly exist. The minimum is nice for making sure particles are always visible, and the maximum lets the emitter know how much memory to allocate.

**Emission:** How many particles will be emitted per second.

**Life:** How long a single particle will live.

**Life Offset:** How much life is used up when a particle spawns. The particle is still moved/rotated/etc for the portion of its life that is used up. This allows particles to spawn, eg, halfway through their life.

**X Offset and Y Offset:** The amount in pixels to offset where particles spawn.

**Spawn:** The shape used to spawn particles: point, line, square, or ellipse. Ellipse has additional settings.

**Spawn Width and Spawn Height:** Controls the size of the spawn shape.

**Size:** The size of the particle.

**Velocity:** The speed of the particle.

**Angle:** The direction the particle travels. Not very useful if velocity is not active.

**Rotation:** The rotation of the particle.

**Wind and Gravity:** The x-axis or y-axis force to apply to particles, in pixels per second.

**Tint:** The particle color. Click the little triangle and then use the sliders to change the color. Click in the bar above the triangle to add more triangles. This allows you to make particles change to any number of colors over their lifetime. Click and drag to move a triangle (if it isn’t at the start or end). Double-click to delete.

**Transparency:** Controls the alpha of the particle. This chart is different than the others because you cannot modify its vertical range. It is always from 0 to 1.

**Options**
 - **Additive:** For additive blending.
 - **Pre-multiplied alpha:** For pre-multiplied alpha blending, which enables a mixture of alpha and additive blending. If this is selected, the Additive option is ignored.
 - **Attached:** Means existing particles will move when the emitter moves.
 - **Continuous:** Means the emitter restarts as soon as its duration expires. Note that this means an effect will never end, so other emitters in the effect that are not continuous will never restart.
 - **Aligned:** The angle of a particle is added to the rotation. This allows you to align the particle image to the direction of travel.

In the upper left of the particle editor, “Count” shows how many particles exist for the currently selected emitter. “Max” shows how many particles exist for all emitters over the past few seconds. Below that is a percentage that represents the duration percent of the currently selected emitter.

Effect settings saved with the particle editor are written to a text file, which can be loaded into a ParticleEffect instance in your game. The ParticleEffect can load images from a directory, or a SpriteSheet. Of course, a SpriteSheet is recommended and can easily be made with the SpriteSheetPacker.

Most effects can be simplified to use just a few images. My most complex effects that use 4 or more emitters typically only need 15 or so total particles alive at once. See ParticleEmitterTest in gdx-tests if you'd like to test how many particles your device can handle. However, the performance varies greatly with the particle image size.
