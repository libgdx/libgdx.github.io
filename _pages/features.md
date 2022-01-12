---
permalink: /features/
title: "Features"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/features.jpg
  caption: "Photo credit: [**Residual by Orangepixel**](https://store.steampowered.com/app/1290780/Residual/)"
excerpt: "libGDX is a Java game development framework that provides a unified API that works across all supported platforms."

intro:
  - excerpt: 'libGDX is an open-source, cross-platform game development framework built in Java. Unlike many popular editor-based platforms, libGDX is entirely code-centric, offering developers fine-grained control over every aspect of their game. It is the perfect place for exploring ground-up implementations, built on top of lightning-fast OpenGL, and distributable to Desktop, HTML, Android, and iOS.'
feature_row:
  - image_path: /assets/images/features/crossplatform.jpeg
    title: "Cross-Platform"
    excerpt: 'libGDX offers a single API to target: **Windows, Linux (including the Raspberry Pi), macOS, Android, iOS and Web**. Developers can use various backends to access the capabilities of the host platform, **without having to write platform-specific code**. Rendering is handled on all platforms through Open GL ES 2.0/3.0.'
feature_row2:
  - image_path: /assets/images/features/reliable.png
    title: "Well proven"
    excerpt: 'The libGDX project was started [over 10 years ago](/history/). Over the years, libGDX and its community matured: nowadays, libGDX is a **[well proven](/showcase/) and reliable framework** with a sound base and documentation. Furthermore, there are plenty of games built on top of libGDX, many of which are open source.'
    url: "/showcase/"
    btn_label: "See some projects"
    btn_class: "btn--primary"
feature_row3:
  - image_path: /assets/images/features/ecosystem.png
    title: "Extensive third-party ecosystem"
    excerpt: 'libGDX offers a very extensive third-party ecosystem. There are numerous [tools](/dev/tools/) and libraries that take a lot of work off the hands of developers. [Awesome-libGDX](https://github.com/rafaskb/awesome-libgdx#readme) is a curated list of libGDX-centered **libraries** and a good starting point for anyone new in the libGDX world.'
    url: "https://github.com/rafaskb/awesome-libgdx"
    btn_label: "Check out Awesome-libGDX"
    btn_class: "btn--primary"
list1:
  - "[Streaming music](/wiki/streaming-music) and [sound effect playback](/wiki/audio/sound-effects) for WAV, MP3 and OGG"
  - "Direct access to audio device for [PCM sample playback](/wiki/audio/playing-pcm-audio) and [recording](/wiki/audio/recording-pcm-audio)"
list2:
  - "Abstractions for [mouse, keyboard, touchscreen](/wiki/input/mouse-touch-and-keyboard), [controllers](https://github.com/libgdx/gdx-controllers), [accelerometer](/wiki/input/accelerometer), [gyroscope](/wiki/input/gyroscope) and [compass](/wiki/input/compass)"
  - "[Gesture detection](/wiki/input/gesture-detection) (recognising taps, panning, flinging and pinch zooming)"
list3:
  - "[Matrix, vector and quaternion](/wiki/math-utils/vectors-matrices-quaternions) classes; accelerated via native C code where possible (if you are interested in that, also note our [gdx-jnigen](/wiki/utils/jnigen) project)"
  - "[Bounding shapes and volumes as well as a Frustum class for picking and culling](/wiki/math-utils/circles-planes-rays-etc)"
  - "[Intersection and overlap testing](https://libgdx.badlogicgames.com/ci/nightlies/docs/api/com/badlogic/gdx/math/Intersector.html)"
  - "[Steering Behaviours, Formation Motion, Pathfinding, Behaviour Trees and Finite State Machines](https://github.com/libgdx/gdx-ai)"
  - "Common [interpolators](/wiki/math-utils/interpolation), different [spline implementations](/wiki/math-utils/path-interface-and-splines), concave polygon triangulators and more"
  - "2D physics: JNI wrapper for the popular [Box2D physics](/wiki/extensions/physics/box2d) (see also [Box2DLights](https://github.com/libgdx/box2dlights)). Alternatively, you can take a look at [jbump](https://github.com/implicit-invocation/jbump) for a simpler physics implementation."
  - "3D physics: JNI Wrapper for [Bullet physics](/wiki/extensions/physics/bullet/bullet-physics)"
list4:
  - "[File system abstraction](/wiki/file-handling) for all platforms"
  - "Straight-forward [asset management](/wiki/managing-your-assets)"
  - "[Preferences](/wiki/preferences) for lightweight settings storage"
  - "[JSON](/wiki/utils/reading-and-writing-json) and [XML](/wiki/utils/reading-and-writing-xml) serialisation"
  - "Custom, [optimised collections](/wiki/utils/collections), with primitive support"
list5:
  - "Easy integration of [game services](https://github.com/MrStahlfelge/gdx-gamesvcs), such as Google Play Games, Apple Game Center, and more."
  - "Cross-platform API for [in-app purchases](https://github.com/libgdx/gdx-pay)."
  - "Third-party support for Google's [Firebase](https://github.com/mk-5/gdx-fireapp), the [Steamworks API](https://github.com/code-disaster/steamworks4j), [gameanalytics.com](https://github.com/MrStahlfelge/gdx-gameanalytics) and Facebook's [Graph API](https://github.com/TomGrill/gdx-facebook)."
  - "Easy integration of [AdMob](/wiki/third-party/admob-in-libgdx)"
list6:
  - "Rendering through [OpenGL ES 2.0/3.0](/wiki/graphics/opengl-es-support) on all platforms"
  - a:
    title: "**Low-Level OpenGL helpers:**"
    items:
      - "Vertex arrays and vertex buffer objects"
      - "[Meshes](/wiki/graphics/opengl-utils/meshes)"
      - "[Textures](/wiki/graphics/2d/spritebatch-textureregions-and-sprites)"
      - "[Framebuffer objects](/wiki/graphics/opengl-utils/frame-buffer-objects)"
      - "[Shaders](/wiki/graphics/opengl-utils/shaders), integrating easily with meshes"
      - "[Immediate mode rendering](https://libgdx.badlogicgames.com/ci/nightlies/docs/api/com/badlogic/gdx/graphics/glutils/ImmediateModeRenderer.html) emulation"
      - "Simple [shape rendering](/wiki/graphics/opengl-utils/rendering-shapes)"
      - "Automatic software or hardware mipmap generation"
      - "Automatic handling of OpenGL ES context loss"
  - b:
    title: "**High-level 2D APIs:**"
    items:
      - "[Orthographic camera](/wiki/graphics/2d/orthographic-camera)"
      - "High-performance [sprite](/wiki/graphics/2d/spritebatch-textureregions-and-sprites) batching and caching"
      - "[Texture atlases](/wiki/graphics/2d/using-textureatlases), with whitespace stripping support. Either generated [offline](/wiki/graphics/2d/packing-atlases-offline) or [at runtime](/wiki/graphics/2d/packing-atlases-at-runtime)"
      - "[Bitmap fonts](/wiki/graphics/2d/fonts/bitmap-fonts). Either generated offline or [loaded from TTF files](/wiki/extensions/gdx-freetype)"
      - "[2D Particle system](/wiki/graphics/2d/2d-particleeffects)"
      - "[TMX tile map support](/wiki/graphics/2d/tile-maps)"
      - "[2D scene-graph API](/wiki/graphics/2d/scene2d/scene2d)"
  - c:
    title: "**A Powerful UI Solution:**"
    items:
      - "[2D UI library](/wiki/graphics/2d/scene2d/scene2d-ui), based on scene-graph API"
      - "A plethora of [official](/wiki/graphics/2d/scene2d/scene2d-ui#widgets) and third-party widgets"
      - "Fully [skinnable](/wiki/skin); [Composer](https://github.com/raeleus/skin-composer) for creating UI skins"
  - d:
    title: "**High-Level 3D APIs:**"
    items:
      - "Decal batching, for 3D billboards or [particle systems](/wiki/graphics/3d/3d-particle-effects)"
      - "Basic loaders for Wavefront OBJ and MD5"
      - "[3D rendering API](/wiki/graphics/3d/3d-graphics) with materials, animation and lighting system and support for loading FBX models via fbx-conv"
      - "Third-party support for [GLTF 2.0](https://github.com/mgsx-dev/gdx-gltf)"
      - "Rudimentary [VR support](/wiki/graphics/3d/virtual-reality)"
  - "Third-party [post-processing](https://github.com/crashinvaders/gdx-vfx) shader effects"
list7:
  - "[Gdx.net](/wiki/networking) for simple networking (TCP sockets and HTTP requests)"
  - "Cross-platform [WebSocket support](https://github.com/MrStahlfelge/gdx-websockets)"
  - "Common Java networking solutions: [KryoNet](https://github.com/EsotericSoftware/kryonet) & [Netty](https://github.com/netty/netty) (not supported on Web)"

---
<link rel="stylesheet" href="/assets/css/aos.css" />

<div data-aos="fade-right" data-aos-anchor-placement="top-bottom">
{% include feature_row type="left" %}
</div>

<div data-aos="fade-left" data-aos-anchor-placement="top-bottom">
{% include feature_row id="feature_row2" type="right" %}
</div>

<div data-aos="fade-right" data-aos-anchor-placement="top-bottom">
{% include feature_row id="feature_row3" type="left" %}
</div>

# Do whatever you want
_Unlike many popular editor-based platforms, libGDX is entirely code-centric, offering developers fine-grained control over every aspect of their game._

- **Freedom:** While libGDX gives you access to various different tools and abstractions, you can still access the underlying base. libGDX acknowledges that there is no one-size-fits-all solution, so it doesn't force you to use certain tools or coding styles: you are free to do whatever you want!
- **Open Source:** libGDX is licensed under Apache 2.0 and maintained by the community, so you can take a look [under the hood](https://github.com/libgdx/libgdx) and see how everything works.
- **Java:** Since libGDX uses Java, you can profit from the wide Java ecosystem – Powerful IDEs, out-of-the-box support for Git, fined-tuned debuggers, performance profilers, and an abundance of well-tried libraries and frameworks, as well as many resources and extensive documentation.

<br/>

# Feature Packed
_libGDX comes with batteries included. Write 2D or 3D games and let libGDX worry about low-level details._
<div class="row">
  <div class="column">
    {% include list.html title="Audio" items=page.list1 %}
    {% include list.html title="Input Handling" items=page.list2 %}
    {% include list.html title="Math & Physics" items=page.list3 %}
    {% include list.html title="Integration of Services" items=page.list5 %}
    {% include list.html title="File I/O & Storage" items=page.list4 %}
  </div>
  <div class="column">
    {% include list.html title="Graphics" items=page.list6 %}
    {% include list.html title="Networking" items=page.list7 %}
  </div>
</div>

<br/>

# And...
**...a Great Community!** Get support from a very friendly [community](/community/) of game and application developers or use any of the libraries and tools created by members of our community. Join us today and get started with your very first libGDX game!

<center><a href="/dev/setup/" class="btn btn--primary btn--large">Get Started!</a></center>

<style>
/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

.column {
  float: left;
  width: 50%;
  padding-left: 15px;
  padding-right: 20px;
}

@media screen and (max-width: 600px) {
  .column {
    width: 100%;
  }
}
</style>

<script src="/assets/js/aos.js"></script>
<script>
  AOS.init({
    disable: window.matchMedia('(prefers-reduced-motion: reduce)').matches,
    once: true
  });
</script>
