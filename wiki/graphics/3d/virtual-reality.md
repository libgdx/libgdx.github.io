---
title: Virtual Reality (VR)
---
libGDX can be used to render to virtual reality headsets using LWJGL's OpenVR (HTC Vive) and OVR (Oculus) modules.

### Required Dependencies

The Maven coordinates can be found using the [LWJGL customize](https://www.lwjgl.org/customize) page.

### Example code

Example code can be found at [https://github.com/badlogic/gdx-vr](https://github.com/badlogic/gdx-vr).

Additionally, the following demos from LWJGL may be useful for debugging:
* [HelloOpenVR.java](https://github.com/LWJGL/lwjgl3/blob/master/modules/samples/src/test/java/org/lwjgl/demo/openvr/HelloOpenVR.java)
* [HelloLibOVR.java](https://github.com/LWJGL/lwjgl3/blob/master/modules/samples/src/test/java/org/lwjgl/demo/ovr/HelloLibOVR.java)

Also, see [https://github.com/Zomby2D/gdx-vr-extension](https://github.com/Zomby2D/gdx-vr-extension)

### OpenVR with offscreen GLFW window

Using an offscreen GLFW window allows to render to VR without rendering or maintaining a window on the monitor's screen. This will allow achieving the fastest performance with OpenVR.

This isn't supported yet by libGDX, because some hacking is required, but the general flow is the following.

```java
Lwjgl3NativesLoader.load();
errorCallback = GLFWErrorCallback.createPrint(System.err);
GLFW.glfwSetErrorCallback(errorCallback);
if (!GLFW.glfwInit())
{
   throw new RuntimeException("Unable to initialize GLFW");
}
GLFW.glfwWindowHint(GLFW.GLFW_VISIBLE, GLFW.GLFW_FALSE);
windowHandle = GLFW.glfwCreateWindow(640, 480, "", MemoryUtil.NULL, MemoryUtil.NULL);
GLFW.glfwMakeContextCurrent(windowHandle);
GL.createCapabilities();

Gdx.gl30 = new Lwjgl3GL30();
Gdx.gl = Gdx.gl30;
Gdx.gl20 = Gdx.gl30;
Gdx.files = new Lwjgl3Files();
Gdx.graphics = <minimal implementation of Graphics interface>
Gdx.app = <minimal implementation of Application interface>

// setup a scene and model batch

while (running) // See https://github.com/ValveSoftware/openvr/wiki/IVRCompositor_Overview
{
   // OpenVR waitGetPoses();
   // OpenVR poll events
   // OpenVR Submit eyes
}
GLFW.glfwDestroyWindow(windowHandle);
errorCallback.free();
errorCallback = null;
GLFW.glfwTerminate();
```

### Roadmap

VR support might become easier relatively soon via the use of [OpenXR](https://www.khronos.org/openxr/). The LWJGL project [plans to support this in the future](https://github.com/LWJGL/lwjgl3/issues/569#issuecomment-643830566). This would remove the need to support both OVR and OpenVR and instead just using OpenXR to support all hardware.
