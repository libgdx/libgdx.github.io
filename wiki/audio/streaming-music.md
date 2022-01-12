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

`Music` instances are heavy, you should usually not have more than one or two at most loaded.

A `Music` instance needs to be disposed if it is no longer needed, to free up resources.

```java
music.dispose();
```