---
title: Clipping, with the use of scissorstack
---
# Clipping #

```java
Rectangle scissors = new Rectangle();
Rectangle clipBounds = new Rectangle(x,y,w,h);
ScissorStack.calculateScissors(camera, spriteBatch.getTransformMatrix(), clipBounds, scissors);
if (ScissorStack.pushScissors(scissors)) {
    spriteBatch.draw(...);
    spriteBatch.flush();
    ScissorStack.popScissors();
}
```

This will limit rendering to within the bounds of the rectangle "clipBounds". The actual drawing is encapsulated by the if-statement because the program would otherwise crash in some situations where the scissor couldn't be pushed to the stack (happens for example when the window is minimized on desktop, it's ok to not draw in this case though).
You may also need to flush or end the `spriteBatch` before starting the active scissor region (that is, before calling `ScissorStack.pushScissors`) to prevent queued draw calls from before the scissor start getting flushed inside the active scissor region.

It is also possible to push multiple rectangles. Only the pixels of the sprites that are within <b>all</b> of the rectangles will be rendered.