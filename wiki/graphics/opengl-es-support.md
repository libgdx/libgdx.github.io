---
title: OpenGL (ES) Support
---
# What is what (GL, GL ES, GLSL)?

Whenever libGDX is talking about GL20 or GL30, it is in fact referring to GL ES 2.0 and GL ES 3.0. OpenGL ES can be seen as a subset of OpenGL and is designed for embedded systems (smartphones in particular).

By default, version 2.0 of OpenGL ES is used, but libGDX can be configured to use 3.0 as well. The LWJGL 3 backend also supports GLES 3.1 and 3.2. See for example:

```java
Lwjgl3ApplicationConfiguration cfg = new Lwjgl3ApplicationConfiguration();
// ...
cfg.setOpenGLEmulation(GLEmulation.GL30, 3, 2); // use GL 3.0 (emulated by OpenGL 3.2)
```

## And what about GLSL (ES)?
GLSL (or GLSL ES for mobile and web) is the language used for shaders. Its versioning is somewhat confusing:

<details>
  <summary><b><i>GLSL - click to expand</i></b></summary>

<br/>
<div markdown="1">
| Open GL Version | GLSL Version |
| --- | --- |
| 2.0 | 110 |
| 2.1 | 120 |
| 3.0 | 130 |
| 3.1 | 140 |
| 3.2 | 150 |
| 3.3 | 330 |
| 4.0 | 400 |
| 4.1 | 410 |
| 4.2 | 420 |
| 4.3 | 430 |
| 4.4 | 440 |
| 4.5 | 450 |
| 4.6 | 460 |

For some advice on porting shaders from version 120 to 330+, see [here](https://github.com/mattdesl/lwjgl-basics/wiki/GLSL-Versions#version-330).
</div>

</details>

<details>
  <summary><b><i>GLSL ES - click to expand</i></b></summary>

<br/>
<div markdown="1">
| OpenGL ES Version | GLSL EL Version | Based on GLSL Version (OpenGL) |
| --- | --- | --- |
| 2.0 | 100 | 120 (2.1) |
| 3.0 | 300 es | 330 (3.3) |

</div>

</details>

## Platform specificities
### Desktop (Windows, Mac, Linux)
On Desktop, libGDX is mapping all its graphics calls to OpenGL.

**GL ES 2.0** is roughly based on Open GL 2.0, however, there are some incompatibilities that weren't resolved until Open GL 4.1. To mimic GL ES 2.0, libGDX does not request any specific OpenGL version, so the driver will be more forgiving.

**GL ES 3.0** is the successor of OpenGL ES 2.0. On desktop, OpenGL 4.3 provides full compatibility with OpenGL ES 3.0. For mimicking GL ES 3.0 on desktop, one can specify the exact OpenGL version, that should be used. Please note that MacOS only supports the [OpenGL 3.2 core](https://www.khronos.org/opengl/wiki/OpenGL_Context#OpenGL_3.2_and_Profiles) profile.

**GL ES 3.1 & 3.2** have done a lot of work to bring the API's functionality significantly closer to it's desktop counterpart. OpenGL 4.5 should be able to fully emulate GL ES 3.1.

### Android
On Android Open GL ES 2.0 and 3.0 can be used. To prevent your application from being shown to unsupported devices in the Play Store, add one of the following lines to your Android Manifest:
- OpenGL ES 2: `<uses-feature android:glEsVersion="0x00020000" android:required="true" />`
- OpenGL ES 3: `<uses-feature android:glEsVersion="0x00030000" android:required="true" />`

### iOS
Please note that support for OpenGL ES 3.0 is experimental on iOS.

### Web
On Web, the graphic stuff is handled by WebGL. Web only supports GL ES 2.0.

## Precision modifiers
OpenGL ES 2.0 requires the specification of precision modifiers for attributes, uniforms and locals. Desktop OpenGL does not support this. You will have to guard against that in your fragment shader with something similar to this code snippet:

```java
#ifdef GL_ES
#define LOW lowp
#define MED mediump
#define HIGH highp
precision mediump float;
#else
#define MED
#define LOW
#define HIGH
#endif
```

This will define the LOWP, MED, and HIGH macros to equivalent OpenGL ES precision modifiers and sets the default precision for float to medium. This will only happen on platforms actually running OpenGL ES, on the desktop, the macros are defined to be empty.

## OpenGL ES 2.0 Documentation
* [OpenGL ES 2.0 Reference Pages](https://www.khronos.org/registry/OpenGL-Refpages/es2.0/)
* [OpenGL ES 2.0 Reference Card](https://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf)
* [OpenGL ES 2.0 Specification](https://www.khronos.org/registry/OpenGL/index_es.php#specs2)
* [OpenGL ES Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Introduction/Introduction.html): the core concepts are valid for other platforms as well
* [OpenGL ES 2.0 Pipeline Structure](https://en.wikibooks.org/wiki/OpenGL_Programming/OpenGL_ES_Overview#OpenGL_ES_2.0_Pipeline_Structure)
