---
title: Pollfish in libGDX
---
# **Introduction**

This is a simple tutorial that will help you integrate Pollfish surveys in your libGDX Android app.

Integration of Pollfish in an Android application is simple, and is described in detail in the official guide here: [Pollfish Android Documentation](https://www.pollfish.com/docs/android)

## STEPS SUMMARY

1. [Sign Up](https://www.pollfish.com/login/publisher) as a Publisher at Pollfish website, create a new app and grab its API key from the dashboard
2. [Download](https://www.pollfish.com/docs/android) Pollfish SDK (either Google Play or Universal) or reference it in your gradle file through jcenter()
3. Add relevant Pollfish aar or jar file in your project, import relevant classes and add required permissions in your app's manifest as described in the [documentation](https://www.pollfish.com/docs/android)
4. Call Pollfish init function in your onResume of your AndroidLauncher

```java

package com.mygdx.game.android;

import android.os.Bundle;
import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;
import com.mygdx.game.MyGdxGame;

import com.pollfish.main.PollFish;
import com.pollfish.constants.Position;

public class AndroidLauncher extends AndroidApplication{

 @Override
 protected void onCreate (Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   
   AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
   initialize(MyGdxGame(), config);
 }

 @Override
 public void onResume() {
     super.onResume();
 
     PollFish.initWith(this, new ParamsBuilder("YOUR_API_KEY").build());
 }

}
```

With this simple implementation you should be able to see Pollfish surveys in your app within a few minutes.

## Optional Steps


### 1. Listen to Pollfish listeners (optional)

You can listen to Pollfish listeners by implementing them in your AndroidLauncher, for example:

```java
import com.pollfish.interfaces.PollfishSurveyCompletedListener;
```
```java
public class AndroidLauncher extends AndroidApplication implements PollfishSurveyCompletedListener{
```

```java
@Override
public void onPollfishSurveyCompleted(boolean playfulSurveys , int surveyPrice) {
 
  Log.d("Pollfish", "Pollfish survey completed - Playful survey: " + playfulSurveys + " with price: " + surveyPrice);
 
}
```

### 2. Manually show or hide Pollfish (optional)

You can manually show or hide Pollfish in your Android App with a simple implementation as the following one:

In your and in your `AndroidLauncher.java` file: 

```java

package com.mygdx.game.android;

import android.os.Bundle;
import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;
import com.mygdx.game.MyGdxGame;

import com.pollfish.main.PollFish;
import com.pollfish.constants.Position;

public class AndroidLauncher extends AndroidApplication implements MyGdxGame.MyPollfishCallbacks {
 
 protected MyGdxGame myGdxGame;
 
 @Override
 protected void onCreate (Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   
   AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
   
   myGdxGame=new MyGdxGame();
   myGdxGame.setMyPollfishCallbacks(this);

   initialize(myGdxGame, config);
 }

 @Override
 public void onResume() {  
    super.onResume();
    
    PollFish.initWith(this, new ParamsBuilder("YOUR_API_KEY")
            .customMode(true)
            .build());
            
    PollFish.hide();  
 }

 @Override
 public void onShowPollfish() {
     PollFish.show();
 }

 @Override
 public void hidePollfish() {
     PollFish.hide();
 }

}
```

and in your `MyGdxGame.java` file: 

```java
package com.mygdx.game;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;

public class MyGdxGame extends ApplicationAdapter {
    
    private SpriteBatch batch;
    private Skin skin;
    private Stage stage;

    // Define an interface for your various callbacks to the android launcher
    public interface MyPollfishCallbacks {
        public void showPollfish();
        public void hidePollfish();
    }

    // Local variable to hold the callback implementation
    private MyPollfishCallbacks myPollfishCallbacks;

    // ** Additional **
    // Setter for the callback
    public void setMyPollfishCallbacks(MyPollfishCallbacks callback) {
        myPollfishCallbacks = callback;
    }

    @Override
    public void create() {

        batch = new SpriteBatch();
        skin = new Skin(Gdx.files.internal("data/uiskin.json"));
        stage = new Stage();

        final TextButton showBtn = new TextButton("Show", skin, "default");

        showBtn.setWidth(400f);
        showBtn.setHeight(100f);
        showBtn.setPosition(Gdx.graphics.getWidth() /2 - 600f, Gdx.graphics.getHeight()/2 - 10f);

        showBtn.addListener(new ClickListener(){
            @Override
            public void clicked(InputEvent event, float x, float y){
                   if(myPollfishCallbacks!=null){
                         myPollfishCallbacks.showPollfish();
                   }
            }
        });

        final TextButton hideBtn = new TextButton("Hide", skin, "default");

        hideBtn.setWidth(400f);
        hideBtn.setHeight(100f);
        hideBtn.setPosition(Gdx.graphics.getWidth() /2 + 300f, Gdx.graphics.getHeight()/2 - 10f);

        hideBtn.addListener(new ClickListener(){
            @Override
            public void clicked(InputEvent event, float x, float y){
                   if(myPollfishCallbacks!=null){
                         myPollfishCallbacks.hidePollfish();
                   }
            }
        });

        stage.addActor(showBtn);
        stage.addActor(hideBtn);

        Gdx.input.setInputProcessor(stage);
    }

    @Override
    public void dispose() {
        batch.dispose();
    }

    @Override
    public void render() {
        Gdx.gl.glClearColor(1, 0, 1, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

        batch.begin();
        stage.draw();
        batch.end();
    }

    @Override
    public void resize(int width, int height) {
    }

    @Override
    public void pause() {
    }

    @Override
    public void resume() {
    }
}
```

### 3. Check if Pollfish survey is still available on your device

It happens that time had past since you initialized Pollfish and a survey is received. If you want to check if survey is still avaialble on your device and has not expired you can check by calling:

```
PollFish.isPollfishPresent();
```


