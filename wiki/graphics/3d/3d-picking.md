---
title: 3D Picking
---
1. Compose a pick ray with and origin and direction:
```
float viewportX = (2.0f * getMousePosX()) / viewportWidth - 1.0f;
float viewportY = (2.0f * (viewportHeight - getMousePosY())) / viewportHeight - 1.0f;

Vector3 gdxOrigin = new Vector3();
gdxOrigin.set(viewportX, viewportY, -1.0f);
gdxOrigin.prj(camera.invProjectionView);

Vector3 gdxDirection = new Vector3();
gdxDirection.set(viewportX, viewportY, 1.0f);
gdxDirection.prj(camera.invProjectionView);
gdxDirection.sub(gdxOrigin).nor();

// collide geometries
```

One way to do picking is to do CPU based collision math using [Euclid](https://github.com/ihmcrobotics/euclid), a performant and comprehensive vector math and geometry library.