---
title: "Community Showcase: Shape Drawer"
excerpt: "Early Grey presents their Shape Drawer library in our Community Showcase!"
classes: wide2
header:
  teaser: /assets/images/posts/2021-05-17/teaser.png

show_author: true
author_username: "earlygrey"
author_displayname: "Early Grey"

categories: news
---

 <div class="notice--primary">
   <p>
     Hey everybody! As announced a few months ago, we want to give creators of interesting community projects the opportunity to present their exciting libraries or tools on the official blog. In this <b>Community Showcase</b>, Early Grey is going to present their <a href="https://github.com/earlygrey/shapedrawer">Shape Drawer library</a>!
   </p>
   <p>
     If you are interested in other cool community projects, be sure to check out the <a href="https://github.com/rafaskb/awesome-libgdx#readme">libGDX Awesome List</a> as well. To participate in future showcases, take a look <a href="https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases">here</a>.
   </p>
 </div>

# Shape Drawer

## What does it do?

Shape drawer draws 2D shapes, such as lines and polygons, using a Batch. It solves the age old problem of "how do I draw a line in libGDX?". Well ok, actually you could use ShapeRenderer, but as we'll see later that's not really the best solution. It's essentially a fancy wrapper around a Batch: you tell it what to draw (eg a hexagon) and it calculates the geometry required to stretch a texture region into various shapes, and uses the Batch to draw them.

## How does it work?

Shape Drawer draws using a Batch, so let's start at the beginning - how does a Batch work? There are already some pretty good explanations in the context of libGDX in the wiki (see [here](https://github.com/libgdx/libgdx/wiki/Spritebatch%2C-Textureregions%2C-and-Sprites) and [here](https://github.com/libgdx/libgdx/wiki/Shaders)), so we'll just illustrate it with a quick example.

Let's say we want to draw a picture of a [pretty flower](https://duckduckgo.com/?t=canonical&q=pretty+flower&iax=images&ia=images) with a SpriteBatch. We tell the Batch where we want to draw it, how big, and give it the texture by calling `batch#draw`. The batch then splits that rectangular image into two triangles, and sends the triangle vertices to the graphics card, along with the texture you want to stretch over the triangles and some colours (eg the colour we set with `batch#setColor`). On the graphics card, a shader program figures out which pixels on the screen are contained in each triangle and what colour each should be based on the texture and the colours we gave it, and then outputs that to the screen.

Since with Shape Drawer we want to use a Batch to draw our shapes, we need to give it something it can digest - triangles, a texture and some colours. This is really all that Shape Drawer does - you tell it what you want to draw (eg a bunch of lines), and it breaks the shape down into a bunch of triangles and gives it to a Batch with some colour information. And since we (usually) only care about having a single colour for each shape, we usually just give Shape Drawer a single white pixel TextureRegion to make things easier.


## But why would I use it?
There are two main reasons: performance and quality. The performance benefit comes from reducing the frequency of sending batches of data to the graphics card (caching data so it can be "flushed" all at once is actually the raison d'être of a Batch, hence the name). Sending data to the graphics card actually has some pretty heavy overhead, so anything that allows us to reduce the frequency can usually give us some pretty good gains. Any time we do anything like change texture data or change the shader, we have to flush all stashed our vertex data to the graphics card, and this is what Shape Drawer tries to avoid. The quality part has to do with all the extra features Shape Drawer has, such as bevelling line corners and being able to draw paths without overlapping at the corners (important if you're drawing a transparent colour), and consistency across different hardware.

Actually since we already know we want to draw some shapes, maybe the real question is "why would I use Shape Drawer instead of Shape Renderer?". Well ok then, how does Shape Renderer work? As we said before, Shape Drawer subdivides shapes into triangles and draws those using a batch. Shape Renderer does the same thing for filled shapes, but for lines and points it  directly uses the `lines` or `points` modes of openGL. This is actually easier (for Shape Renderer), but comes with some downsides. First, openGL lines and points are not consistently implemented by hardware - for example you can't guarantee that your lines will be wider than 1px wide on every platform (imagine your game draws 4px lines on desktop but only 1px lines on HTML - embarrassing!). Second, every time you change shape type (eg from line to filled) you need to flush your data.   Third, using openGL lines gives you no ability to bevel corners or prevent line segments from drawing over each other where they join, resulting in layered colours when using blending. Last and most importantly, every time you use Shape Renderer you need to stop and flush any active Batch, then flush the Shape Renderer after using it.

The last point is probably the most important. Since typically for a 2D game in libGDX you'll be using a batch to do most of your drawing, if you start trying to mix in Shape Renderer calls, you're going to increase the number of times you flush data to the graphics card, and this can result in considerable performance losses. Using a Batch to draw fits very naturally with Scene2D, since you can have you actors do whatever they want with shape drawer without having to worry about when and how often you're stopping and starting the batch.


## How do I use it?

### Setup

For instructions on importing shape drawer into your project, [see here](https://github.com/earlygrey/shapedrawer#including-in-project).

To create a ShapeDrawer instance you need to provide a Batch and a TextureRegion. I recommend putting a single white pixel region into your texture atlas to minimise batch flushes.

```java
ShapeDrawer drawer = new ShapeDrawer(batch, region);

...

batch.begin();
drawer.line(0, 0, 100, 100);
batch.end();
```

Internally, Shape Drawer keeps track of how large a screen pixel appears to be in world units, and uses this to do things like estimate how many sides are required to draw a smooth circle or decide when to automatically bevel path corners. You can set this manually via `ShapeDrawer#setPixelSize`, or you can call `ShapeDrawer#update` and it will calculate it from the batch projection matrix. Typically, your update method would look something like this:
```java
camera.update();
batch.setProjectionMatrix(camera.combined);
drawer.update();
```

### Drawing
Drawing shapes is done much in the same way as with Shape Renderer, eg you just call `drawer.circle(...)` or `drawer.line(...)`, though there are a few small differences:

  - Instead of switching between filled or outlined shapes via `renderer.begin(ShapeType.Filled)`, you just call different methods, eg `drawer.filledCircle(...)`.

  - There is no `line` vs `rectLine` as with Shape Renderer - all Shape Drawer lines are the equivalent of rectLines.

  - Since circles are just polygons with enough sides to make it look smooth, you cannot specify the number of sides for a circle - use `ShapeDrawer#polygon` instead.

## Extra Features

### Corner Bevelling

When calling methods that draw multiple lines which share an endpoint, for example `path` or `polygon`, it's possible to bevel the ends of the line so that thick lines fit together nicely and do not have any gaps at the joints, and transparent lines do not draw over each other.

Shape Drawer gives two options for this - "pointy" and "smooth" - as well no join type.

No Join |  Pointy Join | Smooth Join
:-------------------------:|:-------------------------:|:-------------------------:
![](/assets/images/posts/2021-05-17/none.png)  |  ![](/assets/images/posts/2021-05-17/pointy.png) |  ![](/assets/images/posts/2021-05-17/smooth.png)

You can specify the join type when calling the method, eg `path(points, JoinType.SMOOTH)`. If you don't specify, Shape Drawer will guess if it's needed using `isJoinNecessary()` (you can also override this method if it's not working out for you), using smooth joins for paths and pointy joins for polygons.

### Pixel Snapping

Sometimes when drawing lines, especially when individual pixels are noticeable (such as when drawing to a lower resolution frame buffer that will be upscaled later), it's important that the centres of the pixels you want drawn are contained within the line, because openGL will only draw a pixel if the centre point of that pixel falls within a triangle.

For example, if you're trying to draw a 1px width horizontal line, the centres of pixels might lie exactly on the edges of your line. Since positions are represented with floating point numbers, you might get either a 2px width line, or no line at all. Shape Drawer has an option (default off) to snap the endpoints of lines to the nearest pixel centre points, which ensures you'll always get the 1px line you want. It also lengthens the line a tiny bit, to make sure the pixels containing the endpoints are drawn. Since line endpoints tend to be given whole numbers, this problem is quite common.

## Future Directions

There's currently a feature where you can record what you're doing with shape drawer, and it will be saved into a Drawing object, which you can later draw via `drawing.draw()`. This has some performance benefit for complex shapes like long bevelled paths, but would be more useful if you could do things like copy it and apply linear transformations like translation, rotation and scaling. So for example you could create a drawing, then pass it around to different objects (like scene2D.ui elements), who could draw it with their own position/rotation/colour.

Another idea that's been floated a few times is the ability to draw textures over the shapes. So you could draw any arbitrary shape (or combinations) and repeat a texture over it.

> For God’s sake, please give it up. Fear it no less than the sensual passion, because it, too, may take up all your time and deprive you of your health, peace of mind and happiness in life.
> --- Farkas Bolyai

Shape Drawer is an open source project and contributions and ideas are welcome!
