---
title: Using libGDX with Python
---
Python is a dynamic and strongly typed language that supports many programming paradigms, such as procedural, object-oriented, and functional programming.

Python has been implemented in several different ways: the standard interpreter in C (CPython), in Python itself (PyPy), in the .Net Dynamic Language Runtime (C#) (IronPython), and in Java on the Java Virtual Machine (Jython). Jython comes with Java interoperability, allowing it to leverage powerful Java libraries, such as libGDX, while keeping the succinctness and readability of Python.

This article uses the Jython 2.7b1, which aims to bring compatibility with CPython 2.7. We will be programming with Python 2.7 syntax in this article. The current and older versions are available [here](https://www.jython.org/download.html).

**Note:** At the time of writing, you can only use Jython with libGDX on the desktop.

## Setup

Jython can be worked on with any text editor, including Vim or Emacs. [PyDev](http://pydev.org/) is an option for Eclipse users. Once the environment is set up, create a new Jython project and add all the libGDX dependencies to the `PYTHONPATH`. For using the desktop LWJGL3 backend, this includes `gdx.jar`, `gdx-backend-lwjgl3.jar`, `gdx-platform-natives-desktop.jar`, and `gdx-sources.jar`.

## Coding With Python

The entirety of the [Drop Tutorial](/wiki/start/a-simple-game) can be contained into a single python file.

```python
from com.badlogic.gdx.backends.lwjgl import Lwjgl3Application, Lwjgl3ApplicationConfiguration
from com.badlogic.gdx.utils import TimeUtils, Array
from com.badlogic.gdx.math import MathUtils, Rectangle, Vector3
from com.badlogic.gdx import ApplicationListener, Gdx, Input
from com.badlogic.gdx.graphics.g2d import SpriteBatch
from com.badlogic.gdx.graphics import Texture, OrthographicCamera, GL20

class PyGdx(ApplicationListener):
    def __init__(self):
        self.camera = None
        self.batch = None
        self.texture = None
        self.bucketimg = None
        self.dropsound = None
        self.rainmusic = None
        self.bucket = None
        self.raindrops = None
        
        self.lastdrop = 0
        self.width = 800
        self.height = 480
    
    def spawndrop(self):
        raindrop = Rectangle()
        raindrop.x = MathUtils.random(0, self.width - 64)
        raindrop.y = self.height
        raindrop.width = 64
        raindrop.height = 64
        self.raindrops.add(raindrop)
        self.lastdrop = TimeUtils.nanoTime()
        
    def create(self):        
        self.camera = OrthographicCamera()
        self.camera.setToOrtho(False, self.width, self.height)
        self.batch = SpriteBatch()
        
        self.dropimg = Texture("assets/droplet.png")
        self.bucketimg = Texture("assets/bucket.png")
        self.dropsound = Gdx.audio.newSound(Gdx.files.internal("assets/drop.wav"))
        self.rainmusic = Gdx.audio.newSound(Gdx.files.internal("assets/rain.mp3"))
        
        self.bucket = Rectangle()
        self.bucket.x = (self.width / 2) - (64 / 2)
        self.bucket.y = 20
        self.bucket.width = 64
        self.bucket.height = 64
        
        self.raindrops = Array()
        self.spawndrop()
        
        self.rainmusic.setLooping(True, True)
        self.rainmusic.play()
    
    def render(self):
        Gdx.gl.glClearColor(0,0,0.2,0)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
        
        self.camera.update()
        
        self.batch.setProjectionMatrix(self.camera.combined)
        self.batch.begin()
        self.batch.draw(self.bucketimg, self.bucket.x, self.bucket.y)
        for drop in self.raindrops:
            self.batch.draw(self.dropimg, drop.x, drop.y)
        self.batch.end()
        
        if Gdx.input.isTouched():
            touchpos = Vector3()
            touchpos.set(Gdx.input.getX(), Gdx.input.getY(), 0)
            self.camera.unproject(touchpos)
            self.bucket.x = touchpos.x - (64 / 2)
        if Gdx.input.isKeyPressed(Input.Keys.LEFT): self.bucket.x -= 200 * Gdx.graphics.getDeltaTime()
        if Gdx.input.isKeyPressed(Input.Keys.RIGHT): self.bucket.x += 200 * Gdx.graphics.getDeltaTime()
        
        if self.bucket.x < 0: self.bucket.x = 0
        if self.bucket.x > (self.width - 64): self.bucket.x = self.width - 64
        
        if (TimeUtils.nanoTime() - self.lastdrop) > 1000000000: self.spawndrop()
                        
        iterator = self.raindrops.iterator()
        while iterator.hasNext():
            raindrop = iterator.next()
            raindrop.y -= 200 * Gdx.graphics.getDeltaTime();
            if (raindrop.y + 64) < 0: iterator.remove()
            if raindrop.overlaps(self.bucket):
                self.dropsound.play()
                iterator.remove()
        
    def resize(self, width, height):
        pass

    def pause(self):
        pass

    def resume(self):
        pass
    
    def dispose(self):
        self.batch.dispose()
        self.dropimg.dispose()
        self.bucketimg.dispose()
        self.dropsound.dispose()
        self.rainmusic.dispose()


def main():

    config = Lwjgl3ApplicationConfiguration()
    config.setTitle("PyGdx")
    config.setWindowedMode(800, 480)
    
    Lwjgl3Application(PyGdx(), config)
        
if __name__ == '__main__':
    main()
```

**Note that during asset creation we need to specify the `assets/` folder. When not using Android, we must specify the folder structure that we use, whereas on Android all internal assets are assumed to be in the `assets/` directory.**
