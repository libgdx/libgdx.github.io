---
title: 2D ParticleEffects
---
* [Basic ParticleEffect usage](#basic-particleeffect-usage)
* [Efficiently using ParticleEffects](#efficiency)
* [Examples](#examples)
  * [Pooled Effect example](#pooled-effect-example)
  * [Batched Effect example](#batched-effect-example)
* [Video example](#video-example)

# Basic ParticleEffect usage
Using Particle effects is easy, load up your particle that has been generated in the [ParticleEditor](/wiki/tools/2d-particle-editor)
```java
TextureAtlas particleAtlas; //<-load some atlas with your particle assets in
ParticleEffect effect = new ParticleEffect();
effect.load(Gdx.files.internal("myparticle.p"), particleAtlas);
effect.start();

//Setting the position of the ParticleEffect
effect.setPosition(x, y);

//Updating and Drawing the particle effect
//Delta being the time to progress the particle effect by, usually you pass in Gdx.graphics.getDeltaTime();
effect.draw(batch, delta);

```

# Efficiency
Rendering particles is great, rendering lots of particles is even better, here is how you do it without melting your users devices.

ParticleEffects are no different than Sprites, in fact they [ARE](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/graphics/g2d/ParticleEmitter.java#L98) sprites. Take everything you know already about efficiently rendering sprites and carry them across. 

 * Use an atlas!

 If your particle effect sprite shares a texture with all of your other gameplay assets, or at least the ones that are being batched together, you wont have to switch
 textures, which causes the Batch to flush. You don't want the batch to flush too often as its an expensive operation, and you won't get the most out of your Batch.

 * Pool your effects

 Creating new ParticleEffects willy nilly? Great, now stop doing that and use a Pool! Unfortunately garbage collection degrades the performance of your game, especially on the mobile platforms, so you want to avoid garbage at all costs. Use of the `ParticleEffectPool` completely mitigates garbage generation as you will be reusing your `ParticleEffect` when you are finished with them. No more wasted memory! No more garbage collection

 In simple terms, grab a new object from the Pool, use it, when you are finished, return it so you can use it again.

 See [the example below](#pooled-effect-example) for how to implement pooling.

* Batch your effects
  Draw all your ParticleEffects that have the same Textures/blend modes together. We don't want to interrupt the Batch, which means no texture swapping, no blend state changing. This gets the most out of our Batch, and keeps our device happy.

  If you have ParticleEffects that have different blending, for example some may have Additive, and others dont, group them together when you draw so you only swap the blend mode once.

  This also applies to ParticleEffects that may have a `Sprite` that belongs to a different `Texture` than another effect. Draw all your instances that use the same Texture first, then the rest. If you interleave these ParticleEffects with different Textures, you will be causing lots of draw calls.
  See [the example below](#batched-effect-example) for how to implement batching.

* Clean up the blend modes yourself
  Particles that have Additive Blending will change the state of the `Batch`. By default the ParticleEffect returns the Batch's state to the original state it was in, so the following draws are not effected by the ParticleEffect's blend mode. This is great, apart from if you want to draw multiple ParticleEffect instances, as this will change the blend mode after EACH instance is drawn, resulting in a draw call.

  ```java
  //original blendstate
  additiveParticleEffect.draw(batch, delta); //set the blend state to additive, (flushes the batch)
  //additiveParticleEffect will then reset the batch to the original blend state (flushes the batch)
  //repeat
  //original blendstate
  additiveParticleEffect.draw(batch, delta); //set the blend state to additive, (flushes the batch)
  //additiveParticleEffect will then reset the batch to the original blend state (flushes the batch)
  //repeat
  ```

  To avoid this, we can use ParticleEffect's `setEmittersCleanUpBlendFunction` function, and set it to false. This will prevent the ParticleEffect from resetting the blend mode to the original, and avoiding the extra flush of the Batch.

  ```java
  //original blendstate
  additiveParticleEffect.draw(batch, delta); //set the blend state to additive, (flushes the batch)
  //blendstate is now additive
  //repeat
  //additive blendstate
  additiveParticleEffect.draw(batch, delta); //already additive, no state change (no flush)
  //repeat
  ```

  This is great, efficiently drawing lots of ParticleEffects with the same blend state! Be careful with this function, you are now in charge of returning the Batch's blend state to the original, so you must do this after you are finished drawing all your particles.

# Examples

For a collection of community created particle effects for LibGDX see the [Particle Park](https://github.com/raeleus/Particle-Park)<br/>
A coding example is available on [LibGDX.info](https://libgdxinfo.wordpress.com/particleeffect/)

## Pooled effect example:
```java
ParticleEffectPool bombEffectPool;
Array<PooledEffect> effects = new Array();

//...

//Set up the particle effect that will act as the pool's template
ParticleEffect bombEffect = new ParticleEffect();
bombEffect.load(Gdx.files.internal("particles/bomb.p"), atlas);

//If your particle effect includes additive or pre-multiplied particle emitters
//you can turn off blend function clean-up to save a lot of draw calls, but
//remember to switch the Batch back to GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
//before drawing "regular" sprites or your Stage.
bombEffect.setEmittersCleanUpBlendFunction(false);

bombEffectPool = new ParticleEffectPool(bombEffect, 1, 2);

// Create effect:
PooledEffect effect = bombEffectPool.obtain();
effect.setPosition(x, y);
effects.add(effect);


// Update and draw effects:
for (int i = effects.size - 1; i >= 0; i--) {
	PooledEffect effect = effects.get(i);
	effect.draw(batch, delta);
	if (effect.isComplete()) {
		effect.free();
		effects.removeIndex(i);
	}
}

//...

// Reset all effects:
for (int i = effects.size - 1; i >= 0; i--)
    effects.get(i).free(); //free all the effects back to the pool
effects.clear(); //clear the current effects array
```

## Batched effect example:
```java
Array<PooledEffect> additiveEffects;
Array<PooledEffect> normalEffects;

ParticleEffect additiveEffect = new ParticleEffect();
additiveEffect.load(//...);
additiveEffect.setEmittersCleanUpBlendFunction(false); //Stop the additive effect restting the blend state

batch.begin();
//draw all additive blended effects
for (PooledEffect additiveEffect : additiveEffects) {
  additiveEffect.draw(batch, delta);
}

//We need to reset the batch to the original blend state as we have setEmittersCleanUpBlendFunction as false in additiveEffect
batch.setBlendFunction(GL20.GL_SRC_ALPHA, GL20.GL_ONE_MINUS_SRC_ALPHA);
//draw all 'normal alpha' blended effects
for (PooledEffect normalEffect : normalEffects) {
  normalEffect.draw(batch, delta);
}

batch.end();
```

## video-example


  * [Particle Effect Example on LibGDX.info](https://libgdxinfo.wordpress.com/particleeffect/)
  * [source](https://bitbucket.org/dermetfan/somelibgdxtests/src/207cfc0a6123b48200d5cf721df222cbe7faf1be/src/net/dermetfan/someLibgdxTests/screens/ParticleEffectsTutorial.java?at=default) of the video
  * [source](https://bitbucket.org/dermetfan/somelibgdxtests/src/4582a1bf94bded4f30df47b9195d1ae14728b847/src/net/dermetfan/someLibgdxTests/screens/ParticleEffectsTutorial.java?at=default) of the video using [pooling](https://www.youtube.com/watch?v=3OwIiELYa70)

<a href="http://www.youtube.com/watch?feature=player_embedded&v=LCLa-rgR_MA
" target="_blank"><img src="http://img.youtube.com/vi/LCLa-rgR_MA/0.jpg"
alt="libgdx 2D Particle Effects" width="480" height="360" border="10" /></a>
