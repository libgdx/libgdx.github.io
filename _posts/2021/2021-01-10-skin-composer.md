---
title: "Community Showcase: Skin Composer"
excerpt: "Raeleus presents his Skin Composer tool in our first ever Community Showcase!"
classes: wide2
header:
  teaser: /assets/images/posts/2021-01-10/header.png

show_author: true
author_username: "raeleus"
author_displayname: "raeleus"

categories: news

carousel_elements:
    - image: /assets/images/posts/2021-01-10/main.png
    - image: /assets/images/posts/2021-01-10/drawables.png
    - image: /assets/images/posts/2021-01-10/ninepatch.png
    - image: /assets/images/posts/2021-01-10/ftf.png
    - image: /assets/images/posts/2021-01-10/scene-composer.png
---

<div class="notice--primary">
  <p>
    Hey everybody! As announced in <a href="/news/2021/01/devlog_5_community_showcases">Status Report #5</a> we want to give creators of interesting community projects the opportunity to present their exciting libraries or tools on the official blog. This is the very first of these <b>Community Showcases</b>, in which Raeleus is going to present his tool <a href="https://github.com/raeleus/skin-composer">Skin Composer</a>!
  </p>
  <p>
    If you are interested in other cool community projects, be sure to check out the <a href="https://github.com/rafaskb/awesome-libgdx#readme">libGDX Awesome List</a> as well. To participate in future showcases, take a look <a href="https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases">here</a>.
  </p>
</div>

![](/assets/images/posts/2021-01-10/logo.png){: .align-center}

Skin Composer is a tool to help creators make skins for libGDX’s extensive user-interface library, Scene2D.UI. When I started, I found very few resources in regards to custom designed  libGDX menus. I tried creating my own skin, which involves creating a JSON file, texture atlas, and a bitmap font. The process was slow, unintuitive, and irksome. With research and experimentation, I created Skin Composer to address the issue.

<br/>

# Features
- Live preview of all widgets as they are designed within the GUI.
- Drawables view allowing easy selection of images for widgets.
- Creation of tinted and tiled versions of drawables directly in the tool.
- An editor for quick creation and editing of nine-patch images.
- Multiple tools for creating bitmap fonts and freetype fonts to support a variety of font techniques.
- TenPatch, an extension to libGDX’s basic drawable classes, is fully integrated, allowing for animations, gradients, smart-resizing, and more.
- [VisUI](https://github.com/kotcrab/vis-ui#readme) and user created widgets are supported with the custom class functionality.
- Scene Composer module allows the user to create their menus in a WYSIWYG editor and export directly to their game.
- An [extensive wiki](https://github.com/raeleus/skin-composer/wiki) which explains every aspect of the tool and even covers the basics of Scene2D layout.

<div style="max-width: 545px; margin-left: auto; margin-right: auto;">
      {% include carousel.html elements=page.carousel_elements height="103.8" unit="%" duration="7" control_color="#373737" %}
</div>

<br/>

# Example skins
These are just some of the skins created with Skin Composer:

![](/assets/images/posts/2021-01-10/examples.png){: .align-center}

<br/>

# How to get started
- Download Skin Composer [from GitHub](https://github.com/raeleus/skin-composer#readme)
- Follow the [wiki](https://github.com/raeleus/skin-composer/wiki) to learn the tools provided
- Watch the [video tutorial series](https://www.youtube.com/playlist?list=PLl-_-0fPSXFfHiRAFpmLCuQup10MUJwcA)
{% include video id="78amAV0_e24?list=PLl-_-0fPSXFfHiRAFpmLCuQup10MUJwcA" provider="youtube" %}
- Raeleus is active on the libGDX Discord. Feel free to ask questions in the #Scene-2D channel!

<style>
.preview-images {
  max-width: 385px;
}
</style>
