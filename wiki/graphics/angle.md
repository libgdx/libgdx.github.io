---
title: ANGLE
---

# What is ANGLE?

ANGLE (Almost Native Graphics Layer Engine) is an open-source, cross-platform graphics engine abstraction layer developed by Google.
ANGLE translates OpenGL ES 2/3 calls to Direct3D9, 11, OpenGL, Vulkan or Metal API calls.[^1]

## libGDX limitation

Currently, libGDX only supports OpenGL ES 2 on Windows, Linux and MacOS.

# Usage

Add `gdx-lwjgl3-angle` as a dependency to your LWJGL3 desktop project:

```gradle
implementation "com.badlogicgames.gdx:gdx-lwjgl3-angle:<version>"
```

Then use `GLEmulation.ANGLE_GLES20` in your `Lwjgl3ApplicationConfiguration`:

```java
config.setOpenGLEmulation(GLEmulation.ANGLE_GLES20, 0, 0);
```

## Verification

If you print out OpenGL renderer and vendor:

```java
public void create () {
    System.out.println("OpenGL renderer: " + Gdx.graphics.getGLVersion().getRendererString());
    System.out.println("OpenGL vendor: " + Gdx.graphics.getGLVersion().getVendorString());
    ...
}
```

Then you can see something similar:

```
OpenGL renderer: ANGLE (AMD, AMD Radeon(TM) 860M Graphics (0x00001114) Direct3D11 vs_5_0 ps_5_0, D3D11-32.0.22024.17002)
OpenGL vendor: Google Inc. (AMD)
```

[^1]: https://en.wikipedia.org/wiki/ANGLE_(software)