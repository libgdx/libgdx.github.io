---
title: "Status Report #9: New Particle Editor"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/posts/2023-11-26/header.png
  teaser: /assets/images/posts/2023-11-26/header.png

excerpt: There are some big changes happening with the Particle Editor!

show_author: true
author_username: "raeleus"
author_displayname: "raeleus"

tags:
  - devlog

categories: news
---

There are some big changes happening with the Particle Editor! For the longest time we simply had no solution for making it compatible with M1 Macs because it mixed Swing with LWJGL3. That's not allowed on new Apple computers. There were many other standing issues with the app as well which made it appear to be unmaintained.

That is no longer the case. We have developed a brand new app to replace it completely. This time, it's fully written in libGDX. It's not just a polished, new look: it has a ton of features and improvements to make it a joy to create particle effects again.

{% include figure image_path="/assets/images/posts/2023-11-26/gdx-particle-editor-interface.png" alt="GDX Particle Editor Interface" caption="The UI was completely remade with Scene2D" %}
[GDX Particle Editor](https://github.com/libgdx/gdx-particle-editor#gdx-particle-editor) is now feature complete, but we need your help. Please test the app and report any bugs to the [issue tracker](https://github.com/libgdx/gdx-particle-editor/issues). Once this stage of testing is completed, we'll officially switch over all documentation and tutorials to the new utility. The goal is to decouple the particle editor from the main libGDX repo and enable much faster bug fixing.

{% include figure image_path="/assets/images/posts/2023-11-26/gdx-particle-editor-preview.gif" alt="Particle Effect Example" %}
