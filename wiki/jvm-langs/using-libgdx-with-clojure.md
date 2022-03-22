---
title: Using libgdx with Clojure
---
Clojure is a dialect of Lisp, written for the JVM and with functional programming in mind. Clojure comes with native Java interoperability, making it able to leverage the powerful existing libraries in the Java ecosystem. [ClojureTV on YouTube](https://www.youtube.com/user/ClojureTV) has a lot of good videos, specifically [Clojure for Java Programmers](https://www.youtube.com/watch?v=P76Vbsk_3J0) [(Part 2)](https://www.youtube.com/watch?v=hb3rurFxrZ8).

## Project setup

Your project's directory structure should look something like:
```
demo
- android
- desktop
  - resources
  - src
    - demo
      - core
        - desktop_launcher.clj
  - src-common
    - demo
      - core.clj
  - project.clj
```

### project.clj
```clj
(defproject demo "0.0.1-SNAPSHOT"
  :description "FIXME: write description"
  :dependencies [[com.badlogicgames.gdx/gdx "1.9.3"]
                 [com.badlogicgames.gdx/gdx-backend-lwjgl "1.9.3"]
                 [com.badlogicgames.gdx/gdx-box2d "1.9.3"]
                 [com.badlogicgames.gdx/gdx-box2d-platform "1.9.3"
                  :classifier "natives-desktop"]
                 [com.badlogicgames.gdx/gdx-bullet "1.9.3"]
                 [com.badlogicgames.gdx/gdx-bullet-platform "1.9.3"
                  :classifier "natives-desktop"]
                 [com.badlogicgames.gdx/gdx-platform "1.9.3"
                  :classifier "natives-desktop"]
                 [org.clojure/clojure "1.7.0"]]
  :source-paths ["src" "src-common"]
  :javac-options ["-target" "1.6" "-source" "1.6" "-Xlint:-options"]
  :aot [demo.core.desktop-launcher]
  :main demo.core.desktop-launcher)
```

### desktop_launcher.clj
```clj
(ns demo.core.desktop-launcher
  (:require [demo.core :refer :all])
  (:import [com.badlogic.gdx.backends.lwjgl LwjglApplication]
           [org.lwjgl.input Keyboard])
  (:gen-class))

(defn -main []
  (LwjglApplication. (demo.core.Game.) "demo" 800 600)
  (Keyboard/enableRepeatEvents true))
```

### core.clj
```clj
(ns demo.core
  (:import [com.badlogic.gdx Game Gdx Graphics Screen]
           [com.badlogic.gdx.graphics Color GL20]
           [com.badlogic.gdx.graphics.g2d BitmapFont]
           [com.badlogic.gdx.scenes.scene2d Stage]
           [com.badlogic.gdx.scenes.scene2d.ui Label Label$LabelStyle]))

(gen-class
  :name demo.core.Game
  :extends com.badlogic.gdx.Game)

(def main-screen
  (let [stage (atom nil)]
    (proxy [Screen] []
      (show []
        (reset! stage (Stage.))
        (let [style (Label$LabelStyle. (BitmapFont.) (Color. 1 1 1 1))
              label (Label. "Hello world!" style)]
          (.addActor @stage label)))
      (render [delta]
        (.glClearColor (Gdx/gl) 0 0 0 0)
        (.glClear (Gdx/gl) GL20/GL_COLOR_BUFFER_BIT)
        (doto @stage
          (.act delta)
          (.draw)))
      (dispose[])
      (hide [])
      (pause [])
      (resize [w h])
      (resume []))))

(defn -create [^Game this]
  (.setScreen this main-screen))
```

You can launch the window with `lein run` in the `project.clj` directory, or the repl of your choice by calling `(demo.core.desktop-launcher/-main)`.

For repl based dev have your `main-screen` call `fn`s for each lifecycle method you wish to re-evaluate.


## play-clj

The [play-clj](https://github.com/oakes/play-clj) library provides a Clojure wrapper for libGDX. To get started, install [Leiningen](http://leiningen.org/) and run the following command:

    lein new play-clj hello-world

A directory called `hello-world` should appear, and inside you'll find directories for `android` and `desktop`. Inside the `desktop` directory, you'll find a `src-common` directory, which contains the game code that both projects will read from. Navigate inside of it to find `core.clj`, which looks like this:

```clojure
(ns hello-world.core
  (:require [play-clj.core :refer :all]
            [play-clj.ui :refer :all]))

(defscreen main-screen
  :on-show
  (fn [screen entities]
    (update! screen :renderer (stage))
    (label "Hello world!" (color :white)))

  :on-render
  (fn [screen entities]
    (clear!)
    (render! screen entities)))

(defgame hello-world
  :on-create
  (fn [this]
    (set-screen! this main-screen)))
```

This will display a label on the bottom left corner, which you can see by running `lein run` inside the `desktop` directory. To generate a JAR file that you can distribute to other people, run `lein uberjar` and grab the file in the `target` directory that contains the word "standalone".

## Links

* The [play-clj tutorial](https://github.com/oakes/play-clj/blob/master/TUTORIAL.md) provides a more in-depth walk-through on how to use the library.
* The [Nightmod](https://sekao.net/nightmod/) game tool provides an easier way to use play-clj by integrating the game and the text editor together so you can see instant results when you save your code.