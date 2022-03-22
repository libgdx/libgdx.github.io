---
title: Playing PCM audio
---
The audio module can provide you direct access to the audio hardware for writing [PCM samples](https://en.wikipedia.org/wiki/Pulse-code_modulation) to it.

The audio hardware is abstracted via the [AudioDevice](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/audio/AudioDevice.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/audio/AudioDevice.java) interface.

To create a new `AudioDevice` instance we do the following:

```java
AudioDevice device = Gdx.audio.newAudioDevice(44100, true);
```

This creates a new `AudioDevice` that has a sampling frequency of 44.1khz and outputs mono. If the device couldn't be created, a `GdxRuntimeException` will be thrown.

We can write either 16-bit signed PCM or 32-bit float PCM data to the device:

```java
float[] floatPCM = ... generated from a sine for example ...
device.writeSamples(floatPCM, 0, floatPCM.length);

short[] shortPCM = ... generated from a decoder ...
device.writeSamples(shortPCM, 0, shortPCM.length);
```

If stereo is used, left and right channel samples are interleaved as usual (first float/short -> left, second float/short -> right).

The latency in milliseconds can be queried like this:

```java
int latencyInSamples = device.getLatency();
```

This will return the size of the audio buffer in samples and thus give you a good indicator about the latency. The bigger the return value, the longer it takes for the audio to arrive at the recipient after it was written.

Note that latency on almost all Android phones is ridiculously high. Real-time audio applications have a hard time to get in the useful 10-30ms range. Usually you can achieve 100ms latency, many phones will have up to 400ms latency. Sadly, this is a driver/OS related problem and can't be worked around.

An `AudioDevice` is a native resource and needs to be disposed of when no longer used:

```java
device.dispose();
```

Direct PCM output is not supported in the JavaScript/WebGL backend.
