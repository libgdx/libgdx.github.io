---
title: "Community Showcase: Mundus Editor"
excerpt: "JamesTKhan presents Mundus Editor and libGDX runtime"
classes: wide2

header:
  teaser: /assets/images/posts/2023-07-05/screenshot-1.png

show_author: true
author_username: "JamesTKhan"
author_displayname: "JamesTKhan"

categories: news

carousel_elements:
    - image: /assets/images/posts/2023-07-05/carousel-1.png
    - image: /assets/images/posts/2023-07-05/carousel-2.png
    - image: /assets/images/posts/2023-07-05/carousel-3.png
    - image: /assets/images/posts/2023-07-05/carousel-4.png
---

 <div class="notice--primary">
   <p>
     Hey everybody! As announced last year, we want to give creators of interesting community projects the opportunity to present their exciting libraries or tools on the official blog. In this <b>Community Showcase</b>, JamesTKhan is going to present his <a href="https://github.com/JamesTKhan/Mundus">Mundus library</a>!
   </p>
   <p>
     If you are interested in other cool community projects, be sure to check out the <a href="https://github.com/rafaskb/awesome-libgdx#readme">libGDX Awesome List</a> as well. To participate in future showcases, take a look <a href="https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases">here</a>.
   </p>
 </div>

![](/assets/images/posts/2023-07-05/logo.svg){: .align-center}

# What is Mundus

Mundus is a 3D level editor built with libGDX and provides a libGDX runtime. Mundus was originally created by mbrlabs on GitHub from 2016 to 2018. Development halted on Mundus around 2018. I started working on Mundus in February 2022. I originally started working on a fork from the original repository. Soon after that I detached my fork into its own repository. 

# Why use it?

So, what sets Mundus apart? The majority of libGDX users appreciate a code-first approach, prompting some to question the need for a 3D editor for libGDX. In the realm of 2D, libGDX enthusiasts have numerous tools at their disposal, including Tiled and Hyperlap2D, to craft their unique worlds. However, when venturing into the 3D space, the options for fully-functional editors are somewhat limited. There are several 3D editors in various states of development. 

This is where Mundus steps in, filling this gap by providing tools for 3D object placement, terrain creation and editing, water rendering, fog, and model rendering. It allows all game logic to be coded as usual within a libGDX runtime application, thus offering a smoother transition into 3D game development.

![](/assets/images/posts/2023-07-05/screenshot-1.png){: .align-center}

# Features

- A complete terrain editing system.
- Splat map painting as well as sculpting tools.
- Terrain noise and heightmap generation with more improvements in development.
- [gdx-gltf](https://github.com/mgsx-dev/gdx-gltf) integration for PBR rendering of models and terrains with UI for editing materials with live preview.
- Water rendering with reflections, refractions, foam and lots of options for customizing.
- Skybox rendering with easy setup via UI.
- Projects can have multiple scenes.
- Component based scenegraph with parent to child relationships.
- GWT support.
- Asset cleanup system.
- Asynchronous project loading.

<div style="max-width: 720px; margin-left: auto; margin-right: auto;">
      {% include carousel.html elements=page.carousel_elements height="400" unit="px" duration="7" %}
</div>

# Motivations and Future

My personal motivation for working on Mundus stems from a combination of my enjoyment of the project and my goals to make 3D development more accessible for the libGDX community. It is my hope that Mundus will inspire more people to contribute to libGDX 3D APIs and Mundus.

Mundus version 0.5.0 was just released on June 30th, 2023 and several features are already in development for 0.6.0. 

{% include video id="e7g5q4I1gdM" provider="youtube" %}

I do not work on Mundus alone though. Making an editor like this is a challenge and requires herculean effort. We encourage contributions and I mark issues with “good first issue” to encourage new contributors. DGZT contributes fixes and features and Antz has been invaluable in testing Mundus and suggesting enhancements.

You can check out other games made with Mundus in our ["Made with Mundus"](https://github.com/JamesTKhan/Mundus#made-with-mundus) section!

# How to get started
- Check out the wiki [here](https://github.com/JamesTKhan/Mundus/wiki) (Mundus is under alot of development so some guides may fall out of date)
- We also provide a runtime example application you can run locally [here](https://github.com/JamesTKhan/MundusRuntimeExample)
