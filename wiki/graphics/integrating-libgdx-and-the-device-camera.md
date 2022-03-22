---
title: Integrating libgdx and the device camera
---
This article shows how to integrate the Android device camera with your libGDX application. 
This functionality can be used in order to let the user see what going on behind the device while playing and walking on the street, or even have some interaction between  the game and the real world (FPS game using the face detection mechanism?)


# A Quick Outline
  * Create the libGDX view with alpha channel (this is not the default), so that the camera preview will be shown behind it.
  * Create the DeviceCameraController object responsible for the Camera surface where the preview is drawn.
  * Interact with the DeviceCameraController from your application code, most of the camera functionality is called asynchronously according to: [https://code.google.com/p/libgdx-users/wiki/IntegratingAndroidNativeUiElements3TierProjectSetup](https://code.google.com/p/libgdx-users/wiki/IntegratingAndroidNativeUiElements3TierProjectSetup)
  * Take a picture
    * For taking a picture the Camera has a specific state machine that should be followed.
    * After getting the picture date from the camera, merge it with the libGDX screen-shot and write the result, this process is quite slow and can be done in a separate thread.
  * Continue with the preview (The picture taken is frozen on the screen until the preview is explicitly restarted) or hide the CameraSurface all together.

The sample application does the following:
  * draws a cube with the libGDX splash screen as its faces' texture
  * upon the user touching the screen the Camera preview is started and drawn behind the cube
  * when the user untouch the screen:
    * the Camera starts auto-focusing ;
    * take a picture if succeeded to focus ;
    * take a screen-shot of the libGDX scene according to: [https://libgdx.com/wiki/graphics/taking-a-screenshot](https://libgdx.com/wiki/graphics/taking-a-screenshot) ;
    * saves the merged picture to the storage ;
    * and remove the Preview.

# The Gory Details

## Creating the libGDX application
Initialize your Application in the !MainActivity class in the Android project, but modify the AndroidApplicationConfiguration object before passing it to the initialize method:
```java
        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();
        cfg.useGL20 = false;
        // we need to change the default pixel format - since it does not include an alpha channel 
        // we need the alpha channel so the camera preview will be seen behind the GL scene
        cfg.r = 8;
        cfg.g = 8;
        cfg.b = 8;
        cfg.a = 8;
```
After the initialization make sure the OpenGL surface format is defined as TRANSLUCENT
```java
        if (graphics.getView() instanceof SurfaceView) {
        	SurfaceView glView = (SurfaceView) graphics.getView();
			// force alpha channel - I'm not sure we need this as the GL surface is already using alpha channel
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
		}
	}
```
We also create a new method in the !MainActivity class to help us call asynchronous functions:
```java
	public void post(Runnable r) {
		handler.post(r);
	}
```

## Draw frame in the render() method
The important thing in this part is to clear the screen using the `glClearColor()` with a color with its alpha channel set to 0 when you want the Camera preview to be shown behind your scene.
```java	
	Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 0.0f); 
```
After clearing the screen you can draw everything else as usual. note that object drawn with a transparent color will show through to the Camera preview (even if there is an object behind it that has a non transparent color, but is not drawn due to the objects Z-order).

## Camera State Machine
The android camera has a specific state machine that must be followed. This state machine can be managed by the application using callbacks. This state machine is managed by the AndroidDeviceCameraController (This class implements an abstract interface defined in the base project, In the Desktop application this interface is implemented by an empty class just for compilation compatibility).

The Camera State machine is:
Ready -> Preview -> autoFocusing -> ShutterCalled -> Raw PictureData -> Postview PictureData -> Jpeg PictureData -> Ready

From this state machine the sample code only implements:
Ready -> Preview -> autoFocusing -> Jpeg PictureData -> Ready

So The AndroidDeviceCameraController implements the additional two Camera interfaces: Camera.PictureCallback & Camera.AutoFocusCallback
```
public class AndroidDeviceCameraController implements DeviceCameraControl, Camera.PictureCallback, Camera.AutoFocusCallback {
.
.
.
}
```

## Preparing the Camera
We create a CameraSurface object which holds the Camera object and manages the Surface on which the Camera draws the preview images
```java
	public class CameraSurface extends SurfaceView implements SurfaceHolder.Callback {
		private Camera camera;

		public CameraSurface( Context context ) {
			super( context );
			// We're implementing the Callback interface and want to get notified
			// about certain surface events.
			getHolder().addCallback( this );
			// We're changing the surface to a PUSH surface, meaning we're receiving
			// all buffer data from another component - the camera, in this case.
			getHolder().setType( SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS );
		}

		public void surfaceCreated( SurfaceHolder holder ) {
			// Once the surface is created, simply open a handle to the camera hardware.
			camera = Camera.open();
		}

		public void surfaceChanged( SurfaceHolder holder, int format, int width, int height ) {
			// This method is called when the surface changes, e.g. when it's size is set.
			// We use the opportunity to initialize the camera preview display dimensions.
			Camera.Parameters p = camera.getParameters();
			p.setPreviewSize( width, height );
			camera.setParameters( p );

			// We also assign the preview display to this surface...
			try {
			    camera.setPreviewDisplay( holder );
			} catch( IOException e ) {
			    e.printStackTrace();
			}
		}

		public void surfaceDestroyed( SurfaceHolder holder ) {
			// Once the surface gets destroyed, we stop the preview mode and release
			// the whole camera since we no longer need it.
			camera.stopPreview();
			camera.release();
			camera = null;
		}

		public Camera getCamera() {
			return camera;
		}
	}
```

The camera object is only created by calling the static Camera.open() method after the `surfaceCreated()` callback is being called.
Until then the camera is not ready and cannot be used. 

## Showing the Camera preview
When the `surfaceChanged()` callback is called, we set the camera preview size and sets our CameraSurface object as the Camera preview display.

Now back to the AndroidDeviceCameraController Class. In the next method we prepare the Camera by creating the CameraSurface object (only if needed) and add it as !ContentView to the activity:
```java
	@Override
	public void prepareCamera() {
		if (cameraSurface == null) {
			cameraSurface = new CameraSurface(activity);
		}
		activity.addContentView( cameraSurface, new LayoutParams( LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT ) );
	}
```
This method should be called asynchronous from the libGDX rendering thread so we actually call the `prepareCameraAsync()` method
```java
	@Override
	public void prepareCameraAsync() {
		Runnable r = new Runnable() {
			public void run() {
				prepareCamera();
			}
		};
		activity.post(r);
	}
```

We know that we can pass from the prepare state to the preview state, when the !CameraSurface and the camera objects are ready (by checking that the !CameraSurface & Camera objects exists):
```java
	@Override
	public boolean isReady() {
		if (cameraSurface!=null && cameraSurface.getCamera() != null) {
			return true;
		}
		return false;
	}
```

We do this by calling startPreview method via its Async sibling
```java
	@Override
	public synchronized void startPreviewAsync() {
		Runnable r = new Runnable() {
			public void run() {
				startPreview();
			}
		};
		activity.post(r);
	}
	@Override
	public synchronized void startPreview() {
		// ...and start previewing. From now on, the camera keeps pushing preview
		// images to the surface.
		if (cameraSurface != null && cameraSurface.getCamera() != null) {
			cameraSurface.getCamera().startPreview();
		}
	}
```

In this state the user should see the Camera preview screen (assuming that we cleared the screen with a color having its alpha component sets to 0).  

## Taking a picture
When we would like to take the picture, we set the suitable Camera parameters (we can do it in any stage before actually taking the picture)
```java
	public void setCameraParametersForPicture(Camera camera) {
		// Before we take the picture - we make sure all camera parameters are as we like them
		// Use max resolution and auto focus
		Camera.Parameters p = camera.getParameters();
		List<Camera.Size> supportedSizes = p.getSupportedPictureSizes();
		int maxSupportedWidth = -1;
		int maxSupportedHeight = -1;
		for (Camera.Size size : supportedSizes) {
			if (size.width > maxSupportedWidth) {
				maxSupportedWidth = size.width;
				maxSupportedHeight = size.height;
			}
		}
		p.setPictureSize(maxSupportedWidth, maxSupportedHeight);
		p.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
		camera.setParameters( p );    	
	}
```

In this example we take a picture with the Camera maximal available resolution, and sets the focus mode to AutoFocus. After setting the camera parameters we call the camera autoFocus method, with the proper callback. this callback will be called when the camera is Focused, or after a timeout.
```java
	@Override
	public synchronized void takePicture() {
		// the user request to take a picture - start the process by requesting focus
	    	setCameraParametersForPicture(cameraSurface.getCamera());
	    	cameraSurface.getCamera().autoFocus(this);
	}
```
When reaching a Focus, we call the actual Camera takePicture() method, with only onJpegPicture callback set.
```java
	@Override
	public synchronized void onAutoFocus(boolean success, Camera camera) {
		// Focus process finished, we now have focus (or not)
		if (success) {
			if (camera != null) {
				camera.stopPreview();
				// We now have focus take the actual picture
				camera.takePicture(null, null, null, this);
			}
		}
	}

	@Override
	public synchronized void onPictureTaken(byte[] pictureData, Camera camera) {
		this.pictureData = pictureData;
	}
```

## Taking the libGDX screenshot
In the render() method we wait until the pictureData object contains the Jpeg image and then create a Pixmap object out of this data:
```java
	if (deviceCameraControl.getPictureData() != null) { // camera picture was actually taken
		Pixmap cameraPixmap = new Pixmap(deviceCameraControl.getPictureData(), 0, deviceCameraControl.getPictureData().length);
	}
```
and take the screenshot:
```java
	public Pixmap getScreenshot(int x, int y, int w, int h, boolean flipY) {
		Gdx.gl.glPixelStorei(GL10.GL_PACK_ALIGNMENT, 1);

		final Pixmap pixmap = new Pixmap(w, h, Format.RGBA8888);
		ByteBuffer pixels = pixmap.getPixels();
		Gdx.gl.glReadPixels(x, y, w, h, GL10.GL_RGBA, GL10.GL_UNSIGNED_BYTE, pixels);

		final int numBytes = w * h * 4;
		byte[] lines = new byte[numBytes];
		if (flipY) {
			final int numBytesPerLine = w * 4;
			for (int i = 0; i < h; i++) {
				pixels.position((h - i - 1) * numBytesPerLine);
				pixels.get(lines, i * numBytesPerLine, numBytesPerLine);
			}
			pixels.clear();
			pixels.put(lines);
		} else {
			pixels.clear();
			pixels.get(lines);
		}

		return pixmap;
	}
```

The next two operations are CPU and time consuming tasks so they should probably done in a separate thread with some kind of progress bar. In the code sample they are done directly in the rendering thread, so the screen is frozen during this processing. 

## Merging the screenshot and the Camera picture together
We now have to merge the two Pixmap object. The libGDX Pixmap object can do this for us, but since the camera picture may have different aspect ratio we first need to fix it manually.
```java
	private void merge2Pixmaps(Pixmap mainPixmap, Pixmap overlayedPixmap) {
		// merge to data and Gdx screen shot - but fix Aspect Ratio issues between the screen and the camera
		Pixmap.setFilter(Filter.BiLinear);
		float mainPixmapAR = (float)mainPixmap.getWidth() / mainPixmap.getHeight();
		float overlayedPixmapAR = (float)overlayedPixmap.getWidth() / overlayedPixmap.getHeight();
		if (overlayedPixmapAR < mainPixmapAR) {
			int overlayNewWidth = (int)(((float)mainPixmap.getHeight() / overlayedPixmap.getHeight()) * overlayedPixmap.getWidth());
			int overlayStartX = (mainPixmap.getWidth() - overlayNewWidth)/2;
			mainPixmap.drawPixmap(overlayedPixmap, 
						0, 
						0, 
						overlayedPixmap.getWidth(), 
						overlayedPixmap.getHeight(), 
						overlayStartX, 
						0, 
						overlayNewWidth, 
						mainPixmap.getHeight());
		} else {
			int overlayNewHeight = (int)(((float)mainPixmap.getWidth() / overlayedPixmap.getWidth()) * overlayedPixmap.getHeight());
			int overlayStartY = (mainPixmap.getHeight() - overlayNewHeight)/2;
			mainPixmap.drawPixmap(overlayedPixmap, 
						0, 
						0, 
						overlayedPixmap.getWidth(), 
						overlayedPixmap.getHeight(), 
						0, 
						overlayStartY, 
						mainPixmap.getWidth(), 
						overlayNewHeight);					
		}
	}
```

## Saving the resulting image as a Jpeg
In order to save the resulting image we can save it to the storage using the PixmapIO class. however, the CIM format is not interoperable, and the PNG format will probably result in huge files. 
One way is to save the resulting image as a Jpeg using the Android Bitmap class. This function is implemented inside the AndroidDeviceCameraController, since it is Android specific. 
However, the libGDX pixel format is RGBA and the Bitmap pixel format is ARGB so we need to shuffle some bits around to get the colors right. 
```java
	@Override
	public void saveAsJpeg(FileHandle jpgfile, Pixmap pixmap) {
		FileOutputStream fos;
		int x=0,y=0;
		int xl=0,yl=0;
		try {
			Bitmap bmp = Bitmap.createBitmap(pixmap.getWidth(), pixmap.getHeight(), Bitmap.Config.ARGB_8888);
			// we need to switch between libGDX RGBA format to Android ARGB format
			for (x=0,xl=pixmap.getWidth(); x<xl;x++) {
				for (y=0,yl=pixmap.getHeight(); y<yl;y++) {
					int color = pixmap.getPixel(x, y);
					// RGBA => ARGB
					int RGB = color >> 8;
					int A = (color & 0x000000ff) << 24;
					int ARGB = A | RGB;
					bmp.setPixel(x, y, ARGB);
				}
			}
			// Finished Color format conversion
			fos = new FileOutputStream(jpgfile.file());
			bmp.compress(CompressFormat.JPEG, 90, fos);
			// Finished Comression to JPEG file
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();			
		}
	}
```

## Stoping the preview
After finishing to save the picture, we stop the preview and remove the !CameraSurface from the Activity views, and we also stop the camera from sending the preview to the camera surface. Again we need to do this asynchronously.
```java
	@Override
	public synchronized void stopPreviewAsync() {
		Runnable r = new Runnable() {
			public void run() {
				stopPreview();
			}
		};
		activity.post(r);
	}

	@Override
	public synchronized void stopPreview() {
        // stop previewing. 
		if (cameraSurface != null) {
			if (cameraSurface.getCamera() != null) {
				cameraSurface.getCamera().stopPreview();
			}
			ViewParent parentView = cameraSurface.getParent();
			if (parentView instanceof ViewGroup) {
				ViewGroup viewGroup = (ViewGroup) parentView;
				viewGroup.removeView(cameraSurface);
			}
		}
	}
```

## Fixing Screen and Camera resolution discrepancies
There is still one problem in our Pixmaps merging process. The resolution of the Camera and our screenshot maybe very different (e.g. in my test on Sumsung Galaxy Ace, I was streaching a 480x320 screenshot to a 2560x1920 picture). one way around it is to enlarge the libGDX view size to a larger size than the actual physical device screen size.
This is done using the setFixedSize() function. The actual screen size that can be defined depends on the memory allocated to the GPU and again your mileage may vary.
I found that if I do it once during the initialization I can set the virtual screen size to 1920x1280, but this will results with a slower rendering.
Other way to do it is to call the setFixedSize() function only during the takingPicture procedure and returning it to its orignal afterwards. However, in this case I managed to set the virtual screen size to 960x640 (probably because some of the GPU memory is already allocated for the screen with the original size)

```java
	public void setFixedSize(int width, int height) {
		if (graphics.getView() instanceof SurfaceView) {
			SurfaceView glView = (SurfaceView) graphics.getView();
			glView.getHolder().setFixedSize(width, height);
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
		}
	}

	public void restoreFixedSize() {
		if (graphics.getView() instanceof SurfaceView) {
			SurfaceView glView = (SurfaceView) graphics.getView();
			glView.getHolder().setFixedSize(origWidth, origHeight);
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
		}
	}
```

## Some Notes

### Note#
This code is Android specific, and will not work with the generic cross platform code, but I guess one can provide similar functionality, at least for the desktop application.

### Another note#
The process of merging and writing the merge image to the storage, takes quite a lot of time due to the format mismatch between libGDX color scheme (RGBA) and the Bitmap class used here (ARGB), if someone find a quicker way, I'd be happy to hear about it.

### Last note#
I tested this only with a handful of Android devices, and experienced different behaviors probably due to the different GPU implementations. The Samsung GSIII even managed to XOR white elements with the camera image instead of simply overlaying them (Other colors didn't showed this effects). So your mileage may vary depending on the actual phone used.

# The Code

Here's the full code for the projects' classes: 

## Android Project 

MainActivity.java:
```java
/*
 * Copyright 2012 Johnny Lish (johnnyoneeyed@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.johnny.camerademo;

import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.SurfaceView;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;

public class MainActivity extends AndroidApplication {
    private int origWidth;
	private int origHeight;

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();
        cfg.useGL20 = false;
        // we need to change the default pixel format - since it does not include an alpha channel 
        // we need the alpha channel so the camera preview will be seen behind the GL scene
        cfg.r = 8;
        cfg.g = 8;
        cfg.b = 8;
        cfg.a = 8;
        
        DeviceCameraControl cameraControl = new AndroidDeviceCameraController(this);
        initialize(new CameraDemo(cameraControl), cfg);

        if (graphics.getView() instanceof SurfaceView) {
        	SurfaceView glView = (SurfaceView) graphics.getView();
			// force alpha channel - I'm not sure we need this as the GL surface is already using alpha channel
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
		}
        // we don't want the screen to turn off during the long image saving process 
        graphics.getView().setKeepScreenOn(true);
        // keep the original screen size  
    	origWidth = graphics.getWidth();
    	origHeight = graphics.getHeight();
    }
    
    public void post(Runnable r) {
    	handler.post(r);
    }
    
    public void setFixedSize(int width, int height) {
        if (graphics.getView() instanceof SurfaceView) {
        	SurfaceView glView = (SurfaceView) graphics.getView();
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
        	glView.getHolder().setFixedSize(width, height);
        }
    }

    public void restoreFixedSize() {
        if (graphics.getView() instanceof SurfaceView) {
        	SurfaceView glView = (SurfaceView) graphics.getView();
			glView.getHolder().setFormat(PixelFormat.TRANSLUCENT);
        	glView.getHolder().setFixedSize(origWidth, origHeight);
        }
    }
}
```

CameraSurface.java:
```java
/*
 * Copyright 2012 Johnny Lish (johnnyoneeyed@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.johnny.camerademo;

import java.io.IOException;

import android.content.Context;
import android.hardware.Camera;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class CameraSurface extends SurfaceView implements SurfaceHolder.Callback {
    private Camera camera;
 
    public CameraSurface( Context context ) {
        super( context );
        // We're implementing the Callback interface and want to get notified
        // about certain surface events.
        getHolder().addCallback( this );
        // We're changing the surface to a PUSH surface, meaning we're receiving
        // all buffer data from another component - the camera, in this case.
        getHolder().setType( SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS );
    }
 
    public void surfaceCreated( SurfaceHolder holder ) {
        // Once the surface is created, simply open a handle to the camera hardware.
        camera = Camera.open();
    }
 
    public void surfaceChanged( SurfaceHolder holder, int format, int width, int height ) {
        // This method is called when the surface changes, e.g. when it's size is set.
        // We use the opportunity to initialize the camera preview display dimensions.
        Camera.Parameters p = camera.getParameters();
        p.setPreviewSize( width, height );
        camera.setParameters( p );
 
        // We also assign the preview display to this surface...
        try {
            camera.setPreviewDisplay( holder );
        } catch( IOException e ) {
            e.printStackTrace();
        }
    }
 
    public void surfaceDestroyed( SurfaceHolder holder ) {
        // Once the surface gets destroyed, we stop the preview mode and release
        // the whole camera since we no longer need it.
        camera.stopPreview();
        camera.release();
        camera = null;
    }

	public Camera getCamera() {
		return camera;
	}

}
```

AndroidDeviceCameraController.java
```java
/*
 * Copyright 2012 Johnny Lish (johnnyoneeyed@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.johnny.camerademo;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import com.badlogic.gdx.files.FileHandle;
import com.badlogic.gdx.graphics.Pixmap;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.hardware.Camera;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewGroup.LayoutParams;

public class AndroidDeviceCameraController implements DeviceCameraControl, Camera.PictureCallback, Camera.AutoFocusCallback {

	private static final int ONE_SECOND_IN_MILI = 1000;
	private final MainActivity activity;
    private CameraSurface cameraSurface;
	private byte[] pictureData;

	public AndroidDeviceCameraController(MainActivity activity) {
		this.activity = activity;
	}

	@Override
	public synchronized void prepareCamera() {
		activity.setFixedSize(960,640);
		if (cameraSurface == null) {
			cameraSurface = new CameraSurface(activity);
		}
		activity.addContentView( cameraSurface, new LayoutParams( LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT ) );
	}

	@Override
	public synchronized void startPreview() {
		// ...and start previewing. From now on, the camera keeps pushing preview
		// images to the surface.
		if (cameraSurface != null && cameraSurface.getCamera() != null) {
			cameraSurface.getCamera().startPreview();
		}
	}

	@Override
	public synchronized void stopPreview() {
        // stop previewing. 
        if (cameraSurface != null) {
			ViewParent parentView = cameraSurface.getParent();
			if (parentView instanceof ViewGroup) {
				ViewGroup viewGroup = (ViewGroup) parentView;
				viewGroup.removeView(cameraSurface);
			}
			if (cameraSurface.getCamera() != null) {
				cameraSurface.getCamera().stopPreview();
			}
        }
		activity.restoreFixedSize();
	}

    public void setCameraParametersForPicture(Camera camera) {
        // Before we take the picture - we make sure all camera parameters are as we like them
    	// Use max resolution and auto focus
        Camera.Parameters p = camera.getParameters();
        List<Camera.Size> supportedSizes = p.getSupportedPictureSizes();
        int maxSupportedWidth = -1;
        int maxSupportedHeight = -1;
        for (Camera.Size size : supportedSizes) {
        	if (size.width > maxSupportedWidth) {
        		maxSupportedWidth = size.width;
        		maxSupportedHeight = size.height;
        	}
        }
    	p.setPictureSize(maxSupportedWidth, maxSupportedHeight);
    	p.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
        camera.setParameters( p );    	
    }

	@Override
	public synchronized void takePicture() {
		// the user request to take a picture - start the process by requesting focus
    		setCameraParametersForPicture(cameraSurface.getCamera());
    		cameraSurface.getCamera().autoFocus(this);
	}

	@Override
	public synchronized void onAutoFocus(boolean success, Camera camera) {
		// Focus process finished, we now have focus (or not)
		if (success) {
			if (camera != null) {
				camera.stopPreview();
				// We now have focus take the actual picture
				camera.takePicture(null, null, null, this);
			}
		}
	}

	@Override
	public synchronized void onPictureTaken(byte[] pictureData, Camera camera) {
		// We got the picture data - keep it
		this.pictureData = pictureData;
	}

	@Override
	public synchronized byte[] getPictureData() {
		// Give to picture data to whom ever requested it
		return pictureData;
	}

	@Override
	public void prepareCameraAsync() {
		Runnable r = new Runnable() {
			public void run() {
				prepareCamera();
			}
		};
		activity.post(r);
	}

	@Override
	public synchronized void startPreviewAsync() {
		Runnable r = new Runnable() {
			public void run() {
				startPreview();
			}
		};
		activity.post(r);
	}

	@Override
	public synchronized void stopPreviewAsync() {
		Runnable r = new Runnable() {
			public void run() {
				stopPreview();
			}
		};
		activity.post(r);
	}

	@Override
	public synchronized byte[] takePictureAsync(long timeout) {
		timeout *= ONE_SECOND_IN_MILI;
		pictureData = null;
		Runnable r = new Runnable() {
			public void run() {
				takePicture();
			}
		};
		activity.post(r);
		while (pictureData == null && timeout > 0) {
			try {
				Thread.sleep(ONE_SECOND_IN_MILI);
				timeout -= ONE_SECOND_IN_MILI;
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (pictureData == null) {
			cameraSurface.getCamera().cancelAutoFocus();
		}
		return pictureData;
	}

	@Override
	public void saveAsJpeg(FileHandle jpgfile, Pixmap pixmap) {
		FileOutputStream fos;
		int x=0,y=0;
		int xl=0,yl=0;
		try {
			Bitmap bmp = Bitmap.createBitmap(pixmap.getWidth(), pixmap.getHeight(), Bitmap.Config.ARGB_8888);
			// we need to switch between libGDX RGBA format to Android ARGB format
			for (x=0,xl=pixmap.getWidth(); x<xl;x++) {
				for (y=0,yl=pixmap.getHeight(); y<yl;y++) {
					int color = pixmap.getPixel(x, y);
					// RGBA => ARGB
					int RGB = color >> 8;
					int A = (color & 0x000000ff) << 24;
					int ARGB = A | RGB;
					bmp.setPixel(x, y, ARGB);
				}
			}
			fos = new FileOutputStream(jpgfile.file());
			bmp.compress(CompressFormat.JPEG, 90, fos);
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();			
		}
	}

	@Override
	public boolean isReady() {
		if (cameraSurface!=null && cameraSurface.getCamera() != null) {
			return true;
		}
		return false;
	}
}
```

## Base Project
DeviceCameraControl.java
```java
/*
 * Copyright 2012 Johnny Lish (johnnyoneeyed@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.johnny.camerademo;

import com.badlogic.gdx.files.FileHandle;
import com.badlogic.gdx.graphics.Pixmap;

public interface DeviceCameraControl {

	// Synchronous interface
	void prepareCamera();

	void startPreview();

	void stopPreview();

	void takePicture();

	byte[] getPictureData();

	// Asynchronous interface - need when called from a non platform thread (GDX OpenGl thread)
	void startPreviewAsync();

	void stopPreviewAsync();

	byte[] takePictureAsync(long timeout);

	void saveAsJpeg(FileHandle jpgfile, Pixmap cameraPixmap);

	boolean isReady();

	void prepareCameraAsync();
}
```

CameraDemo.java:

```java
/*
 * Copyright 2012 Johnny Lish (johnnyoneeyed@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package com.johnny.camerademo;

import java.nio.ByteBuffer;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.files.FileHandle;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL10;
import com.badlogic.gdx.graphics.Mesh;
import com.badlogic.gdx.graphics.PerspectiveCamera;
import com.badlogic.gdx.graphics.Pixmap;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.VertexAttribute;
import com.badlogic.gdx.graphics.Pixmap.Filter;
import com.badlogic.gdx.graphics.Pixmap.Format;
import com.badlogic.gdx.graphics.VertexAttributes.Usage;

public class CameraDemo implements ApplicationListener {

	public enum Mode {
		normal,
		prepare,
		preview,
		takePicture, 
		waitForPictureReady, 
	}

	public static final float vertexData[] = {   
		1.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 0/Vertex 0 
		0.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 0/Vertex 1
		0.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 0/Vertex 2
		1.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 0/Vertex 3

		1.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 1/Vertex 4
		1.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 1/Vertex 5
		1.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 1/Vertex 6
		1.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 1/Vertex 7
		
		1.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 2/Vertex 8
		1.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 2/Vertex 9
		0.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 2/Vertex 10
		0.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 2/Vertex 11
		
		1.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 3/Vertex 12
		0.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 3/Vertex 13
		0.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 3/Vertex 14
		1.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 3/Vertex 15

		0.0f,  1.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 4/Vertex 16
		0.0f,  1.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 4/Vertex 17
		0.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 4/Vertex 18
		0.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 4/Vertex 19
		
		0.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  1.0f, 1.0f, // quad/face 5/Vertex 20
		1.0f,  0.0f,  0.0f, Color.toFloatBits(255,255,255,255),  0.0f, 1.0f, // quad/face 5/Vertex 21
		1.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  0.0f, 0.0f, // quad/face 5/Vertex 22
		0.0f,  0.0f,  1.0f, Color.toFloatBits(255,255,255,255),  1.0f, 0.0f, // quad/face 5/Vertex 23
	};


	public static final short facesVerticesIndex[][] = {
		{ 0, 1, 2, 3 },
		{ 4, 5, 6, 7 },
		{ 8, 9, 10, 11 },
		{ 12, 13, 14, 15 },
		{ 16, 17, 18, 19 },
		{ 20, 21, 22, 23 }
	};

	private final static VertexAttribute verticesAttributes[] = new VertexAttribute[] { 
		new VertexAttribute(Usage.Position, 3, "a_position"), 
		new VertexAttribute(Usage.ColorPacked, 4, "a_color"),
		new VertexAttribute(Usage.TextureCoordinates, 2, "a_texCoords"),
	};


	private Texture texture;


	private Mesh[] mesh = new Mesh[6];


	private PerspectiveCamera camera;


	private Mode mode = Mode.normal;


	private final DeviceCameraControl deviceCameraControl;


	public CameraDemo(DeviceCameraControl cameraControl) {
		this.deviceCameraControl = cameraControl;
	}

	@Override
	public void create() {		
		
		// Load the libGDX splash screen texture
		texture = new Texture(Gdx.files.internal("data/libgdx.png"));
		texture.setFilter(TextureFilter.Linear, TextureFilter.Linear);
	
		// Create the 6 faces of the Cube
		for (int i=0;i<6;i++) {
			mesh[i] = new Mesh(true, 24, 4, verticesAttributes);
			mesh[i].setVertices(vertexData);
			mesh[i].setIndices(facesVerticesIndex[i]);
		}
		
		// Create the OpenGL Camera
		camera = new PerspectiveCamera(67.0f, 2.0f * Gdx.graphics.getWidth() / Gdx.graphics.getHeight(), 2.0f);
		camera.far = 100.0f;
		camera.near = 0.1f;
		camera.position.set(2.0f,2.0f,2.0f);
        camera.lookAt(0.0f, 0.0f, 0.0f);

	}

	@Override
	public void dispose() {
		texture.dispose();
		for (int i=0;i<6;i++) {
			mesh[i].dispose();
			mesh[i] = null;
		}
		texture = null;
	}

	@Override
	public void render() {		
		if (Gdx.input.isTouched()) {
			if (mode == Mode.normal) {
				mode = Mode.prepare;
				if (deviceCameraControl != null) {
					deviceCameraControl.prepareCameraAsync();
				}
			}
		} else { // touch removed
			if (mode == Mode.preview) {
				mode = Mode.takePicture;
			}
		}

		Gdx.gl10.glHint(GL10.GL_PERSPECTIVE_CORRECTION_HINT, GL10.GL_NICEST);
		if (mode == Mode.takePicture) {
			Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
			if (deviceCameraControl != null) {
				deviceCameraControl.takePicture();
			}
			mode = Mode.waitForPictureReady;
		} else if (mode == Mode.waitForPictureReady) {
			Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);			
		} else if (mode == Mode.prepare) {
			Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
			if (deviceCameraControl != null) {
				if (deviceCameraControl.isReady()) {
					deviceCameraControl.startPreviewAsync();
					mode = Mode.preview;
				}
			}
		} else if (mode == Mode.preview) {
			Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		} else { // mode = normal
			Gdx.gl10.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		}
		Gdx.gl10.glClear(GL10.GL_COLOR_BUFFER_BIT | GL10.GL_DEPTH_BUFFER_BIT);
		Gdx.gl10.glEnable(GL10.GL_DEPTH_TEST);
		Gdx.gl10.glEnable(GL10.GL_TEXTURE);			
		Gdx.gl10.glEnable(GL10.GL_TEXTURE_2D);			
		Gdx.gl10.glEnable(GL10.GL_LINE_SMOOTH);
		Gdx.gl10.glDepthFunc(GL10.GL_LEQUAL);
		Gdx.gl10.glClearDepthf(1.0F);
		camera.update(true);
		camera.apply(Gdx.gl10);
		texture.bind();
		for (int i=0;i<6;i++) {
			mesh[i].render(GL10.GL_TRIANGLE_FAN, 0 ,4);
		}
		if (mode == Mode.waitForPictureReady) {
			if (deviceCameraControl.getPictureData() != null) { // camera picture was actually taken
				// take Gdx Screenshot
				Pixmap screenshotPixmap = getScreenshot(0, 0, Gdx.graphics.getWidth(), Gdx.graphics.getHeight(), true);
				Pixmap cameraPixmap = new Pixmap(deviceCameraControl.getPictureData(), 0, deviceCameraControl.getPictureData().length);
				merge2Pixmaps(cameraPixmap, screenshotPixmap);
				// we could call PixmapIO.writePNG(pngfile, cameraPixmap);
				FileHandle jpgfile = Gdx.files.external("libGdxSnapshot.jpg");
				deviceCameraControl.saveAsJpeg(jpgfile, cameraPixmap);
				deviceCameraControl.stopPreviewAsync();
				mode = Mode.normal;
			}
		}
	}
	
	private Pixmap merge2Pixmaps(Pixmap mainPixmap, Pixmap overlayedPixmap) {
		// merge to data and Gdx screen shot - but fix Aspect Ratio issues between the screen and the camera
		Pixmap.setFilter(Filter.BiLinear);
		float mainPixmapAR = (float)mainPixmap.getWidth() / mainPixmap.getHeight();
		float overlayedPixmapAR = (float)overlayedPixmap.getWidth() / overlayedPixmap.getHeight();
		if (overlayedPixmapAR < mainPixmapAR) {
			int overlayNewWidth = (int)(((float)mainPixmap.getHeight() / overlayedPixmap.getHeight()) * overlayedPixmap.getWidth());
			int overlayStartX = (mainPixmap.getWidth() - overlayNewWidth)/2;
			// Overlaying pixmaps
			mainPixmap.drawPixmap(overlayedPixmap, 0, 0, overlayedPixmap.getWidth(), overlayedPixmap.getHeight(), overlayStartX, 0, overlayNewWidth, mainPixmap.getHeight());
		} else {
			int overlayNewHeight = (int)(((float)mainPixmap.getWidth() / overlayedPixmap.getWidth()) * overlayedPixmap.getHeight());
			int overlayStartY = (mainPixmap.getHeight() - overlayNewHeight)/2;
			// Overlaying pixmaps
			mainPixmap.drawPixmap(overlayedPixmap, 0, 0, overlayedPixmap.getWidth(), overlayedPixmap.getHeight(), 0, overlayStartY, mainPixmap.getWidth(), overlayNewHeight);					
		}
		return mainPixmap;
	}

	public Pixmap getScreenshot(int x, int y, int w, int h, boolean flipY) {
		Gdx.gl.glPixelStorei(GL10.GL_PACK_ALIGNMENT, 1);

		final Pixmap pixmap = new Pixmap(w, h, Format.RGBA8888);
		ByteBuffer pixels = pixmap.getPixels();
		Gdx.gl.glReadPixels(x, y, w, h, GL10.GL_RGBA, GL10.GL_UNSIGNED_BYTE, pixels);

		final int numBytes = w * h * 4;
		byte[] lines = new byte[numBytes];
		if (flipY) {
			final int numBytesPerLine = w * 4;
			for (int i = 0; i < h; i++) {
				pixels.position((h - i - 1) * numBytesPerLine);
				pixels.get(lines, i * numBytesPerLine, numBytesPerLine);
			}
			pixels.clear();
			pixels.put(lines);
		} else {
			pixels.clear();
			pixels.get(lines);
		}

		return pixmap;
	}

	@Override
	public void resize(int width, int height) {
		camera = new PerspectiveCamera(67.0f, 2.0f * width / height, 2.0f);
		camera.far = 100.0f;
		camera.near = 0.1f;
		camera.position.set(2.0f,2.0f,2.0f);
        camera.lookAt(0.0f, 0.0f, 0.0f);

	}

	@Override
	public void pause() {
	}

	@Override
	public void resume() {
	}
}
```