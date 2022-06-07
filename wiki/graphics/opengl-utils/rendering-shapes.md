---
title: Rendering shapes
---
[ShapeRenderer API](https://javadoc.io/doc/com.badlogicgames.gdx/gdx/latest/com/badlogic/gdx/graphics/glutils/ShapeRenderer.html) (Javadoc provides an example in the top level!)

### What can the ShapeRenderer do?

You can use ShapeRenderer to draw simple shapes. Types of shapes include rectangle and ellipse. The shapes can be outlined or filled. You can also set the color to use for each shape draw. It is very similar to use like sprite batch.

Example code that is taken from an actual project:

```java
public class MyGame extends Game {
        public final static float WIDTH = 100;
        public final static float HEIGHT = 16 * WIDTH / 9;

        FitViewport viewport;
	OrthographicCamera camera;
        ShapeRenderer shape;

        @Override
	public void create () {
		shape = new ShapeRenderer();
		camera = new OrthographicCamera();
		viewport = new FitViewport(WIDTH, HEIGHT, camera);
                ...
        }

        @Override
	public void resize(int width, int height) {
		viewport.update(width, height);
	}

        ...
}

public class Box {
        ...
}

public class ScreenPlay implements Screen {
        final Game g;
        Array<Box> boxes;
        ...
        
        @Override
	public void render(float delta) {
              for(Box box : boxes) {
			g.shape.setProjectionMatrix(g.camera.combined);
			g.shape.begin(ShapeType.Line);
			g.shape.setColor(Color.RED);
			g.shape.rect(box.x, box.y, box.width, box.height);
			g.shape.end();
			
			g.shape.setProjectionMatrix(g.camera.combined);
			g.shape.begin(ShapeType.Filled);
			g.shape.setColor(Color.BLUE);
			g.shape.ellipse(box.x, box.y, box.width, box.height);
			g.shape.end();
		}	
        }

        ...

}
```  

### Alternatives

One of the downsides of using a ShapeRenderer is that it uses its own Mesh, meaning if you want to alternate between ShapeRenderer and a Batch you need to start and end (and flush) each one before switching, which can significantly drop performance. An alternative is to use the third party library [ShapeDrawer](https://github.com/earlygrey/shapedrawer), which uses a user-provided Batch to draw shapes. It has most of the functionality of ShapeRenderer, plus some extras like line joining/bevelling. It also doesn't draw over itself when drawing shapes so it can be used with transparent colours, and doesn't need to be flushed when switching from drawing lines to filled shapes.

Typical usage looks something like this:

```java
// batch drawing
shapeDrawer.setColor(Color.RED);
shapeDrawer.line(0, 0, 100, 100);
// batch drawing
shapeDrawer.setColor(Color.BLUE);
shapeDrawer.filledCircle(50, 50, 20);
// batch drawing
```