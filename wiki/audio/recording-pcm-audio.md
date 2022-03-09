---
title: Recording PCM audio
---
You can access PCM data from the microphone on a PC or Android phone via the [AudioRecorder](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/audio/AudioRecorder.html) [(code)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/audio/AudioRecorder.java) interface. To create an instance of that interface use:

```java
AudioRecorder recorder = Gdx.audio.newAudioRecorder(22050, true);
```

This will create an `AudioRecorder` with a sampling rate of 22.05khz, in mono mode. If the recorder couldn't be created, a `GdxRuntimeException` will be thrown.

Samples can be read as 16-bit signed PCM:

```java
short[] shortPCM = new short[1024]; // 1024 samples
recorder.readSamples(shortPCM, 0, shortPCM.length);
```

Stereo samples are interleaved as usual (first sample -> left channel, second sample -> right channel).

An `AudioRecorder` is a native resource and needs to be disposed of if no longer in use:

```java
recorder.dispose();
```

Audio recording is not supported in the JavaScript/WebGL backend.
