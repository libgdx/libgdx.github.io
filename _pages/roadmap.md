---
permalink: /roadmap/
title: "Roadmap"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.45"
  overlay_image: /assets/images/roadmap.jpg
  caption: "Photo credit: [**Slidebean**](https://unsplash.com/photos/iW9oP7Ljkbg)"

excerpt: "Here you can learn more about our plans for the future of libGDX and what to expect from upcoming updates."
---

<!--
Available status values:

{% include status.html is='planned' %} // is planned for the future
{% include status.html is='wip' %} // work in progress
{% include status.html is='close' %} // nearly done
{% include status.html is='done' %} //in the next release
 -->

This is a broad list of the **major features and improvements** we have currently planned for libGDX. As we're all doing this in our spare time, we refrained from giving any concrete dates and deadlines – plans are always subject to change.

There are also a lot of other improvements in the works, which may not be not big enough to be mentioned on here, but are no less noteworthy. If you want to keep up to date with what is going on with libGDX at the moment, be sure to read our **regular [Status Reports](/news/devlog/)**.

<table>
  <tr>
    <td><h4>Box2D Update</h4>
    <br>In July, the original <a href="https://github.com/erincatto/box2d">Box2D</a> received its first update in over 6 years! Now we're working to include those changes in libGDX.<sup><a href="https://github.com/libgdx/libgdx/issues/5948#issuecomment-727643568">1</a></sup></td>
    <td>{% include status.html is='wip' %}</td>
  </tr>
  <tr>
    <td><h4>Geometry/Tesslation/Compute Shaders</h4>
    <br>We really want to look into geometry, tesselation and compute shaders. However, we can't give any promises yet, as this is still just a far-off idea.<sup><a href="https://github.com/libgdx/libgdx/pull/4963">1</a>, <a href="https://github.com/mgsx-dev/libgdx/tree/modern-shaders/compute">2</a></sup></td>
    <td>{% include status.html is='planned' %}</td>
  </tr>
  <tr>
    <td><h4>gdx-video Resurrection</h4>
    <br>We have some plans drawn up to revive the <a href="https://github.com/libgdx/gdx-video">gdx-video</a> extension.</td>
    <td>{% include status.html is='wip' %}</td>
  </tr>
  <tr>
    <td><h4>GL ES 3.1 Support</h4>
    <br>Currently, the libGDX backends are aimed at offering support for OpenGL ES 2.0 and 3.0. This could be expanded to include the feature set of OpenGL ES 3.1.<sup><a href="https://github.com/libgdx/libgdx/pull/4628">1</a></sup></td>
    <td>{% include status.html is='planned' %}</td>
  </tr>
  <tr>
    <td><h4>GWT 2.9.0</h4>
    <br>The Web backend of libGDX is currently based on GWT 2.8.2. An update to version 2.9.0 would offer support for Java 11 language features, like the 'var' keyword.<sup><a href="https://github.com/tommyettinger/gdx-backends#19120">1</a>, <a href="http://www.gwtproject.org/release-notes.html#Release_Notes_2_9_0">2</a></sup></td>
    <td>{% include status.html is='wip' %}</td>
  </tr>
  <tr>
    <td><h4>Gradle Build Migration</h4>
    <br>We want to migrate our whole build process to Gradle. This migration has been long in the making and there is still a lot of work to be done, but we’re crossing our fingers it gets finished without any major hurdles.</td>
    <td>{% include status.html is='wip' %}</td>
  </tr>
  <tr>
    <td><h4>Kotlin-Compatible Web Backend</h4>
    <br>A Web backend that is compatible with other JVM languages has been talked about a few times now.<sup><a href="https://github.com/squins/gdx-backend-bytecoder">1</a>, <a href="https://github.com/Anuken/Arc/tree/master/backends/backend-teavm">2</a></sup></td>
    <td>{% include status.html is='planned' %}</td>
  </tr>
  <tr>
    <td><h4>Metal Support</h4>
    <br>We are well aware that Apple has deprecated OpenGL (ES) on iOS and macOS. Thus, we are looking into Metal support in the near future. Projects like <a href="https://github.com/google/angle">ANGLE</a> look very promising for this.<sup><a href="https://github.com/libgdx/libgdx/issues/5251">1</a></sup></td>
    <td>{% include status.html is='planned' %}</td>
  </tr>
  <tr>
    <td><h4>Web-Based Setup Tool</h4>
    <br>We already have a working prototype of our new web-based setup tool and are now working on polishing it up to start public testing.<sup><a href="https://github.com/MrStahlfelge/gdx-setup">1</a>, <a href="https://raeleus.itch.io/libgdx-project-setup">2</a></sup></td>
    <td>{% include status.html is='close' %}</td>
  </tr>
  <tr>
    <td><h4>WebGL 2.0</h4>
    <br>Our web backend is the last one, where support for OpenGL ES 3.0 (~ WebGL 2.0) is still lacking. We have plans to change that!<sup><a href="https://github.com/libgdx/libgdx/pull/5763">1</a></sup></td>
    <td>{% include status.html is='planned' %}</td>
  </tr>

</table>
