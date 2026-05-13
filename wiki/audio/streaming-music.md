---
title: Streaming music
---
For any sound that's longer than a few seconds it is preferable to stream it from disk instead of fully loading it into RAM. libGDX provides a Music interface that lets you do that.

To load a Music instance we can do the following:

```java
Music music = Gdx.audio.newMusic(Gdx.files.internal("data/mymusic.mp3"));
```

This loads an MP3 file called `"mymusic.mp3"` from the internal directory `data`.

Playing back the music instance works as follows:

```java
music.play();
```

Of course you can set various playback attributes of the `Music` instance:

```java
music.setVolume(0.5f);                 // sets the volume to half the maximum volume
music.setLooping(true);                // will repeat playback until music.stop() is called
music.stop();                          // stops the playback
music.pause();                         // pauses the playback
music.play();                          // resumes the playback
boolean isPlaying = music.isPlaying(); // obvious :)
boolean isLooping = music.isLooping(); // obvious as well :)
float position = music.getPosition();  // returns the playback position in seconds
```

`Music` instances are heavy on some backends (such as Android), you should usually not have more than about 10 loaded and more than 1 or 2 playing at the same time.

A `Music` instance needs to be disposed if it is no longer needed, to free up resources.

```java
music.dispose();
```

## Seamless Music

If you have music that needs to loop seamlessly be aware that whilst the MP3 format is compatible across all platforms it has technical limitations preventing fully seamless play (see 'Why cant MP3 files be seamlessly spliced together?' at [LAME Technical FAQ](https://lame.sourceforge.io/tech-FAQ.txt)). The approach to solving this will vary depending on the platforms you need to target:

- For **desktop and web only** the Ogg format may work better as it avoids the gap issue of MP3 and (as a bonus) has higher fidelity for the same bitrates. The format is not supported on iOS however and on Android there will still be some gap due to current limitations of the LibGDX Audio module.
- If targeting **iOS and Android** look at using a third-party cross-platform audio backend [alternative](https://libgdx.com/wiki/audio/audio#alternatives), in particular [gdx-miniaudio](https://github.com/rednblackgames/gdx-miniaudio).
- For **web only** you could also consider streaming pre-looped music directly from your server. Do this by excluding the music from the preload filter and not using the AssetManager. This allows you to loop music for as long as needed, without increasing game load times.
