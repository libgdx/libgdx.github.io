---
permalink: /dev/tools/
title: "Tools"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/dev/tools.jpeg
  caption: "Photo credit: [**Marvin Meyer**](https://unsplash.com/photos/SYTO3xs06fU)"

excerpt: "There are different tools – both official and community-made – that can help make the development process for libGDX much easier."

feature_row:
  - image_path: /assets/images/dev/tools/spine.jpg
    title: "Spine"
    excerpt: 'An animation tool that focuses specifically on 2D game animations'
    url: "http://en.esotericsoftware.com/"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/talos.jpg
    title: "Talos"
    excerpt: 'A node based, open source VFX Editor with powerful interface'
    url: "https://talosvfx.com"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/hyperlap.gif
    title: "HyperLap2D"
    excerpt: 'A visual editor for complex 2D worlds and scenes'
    url: "https://github.com/rednblackgames/HyperLap2D"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"

feature_row2:
  - image_path: /assets/images/dev/tools/flame.gif
    title: "Setup Tool"
    excerpt: 'A simple wizard tool for libGDX projects'
    url: "/assets/gdx-setup.jar"
    btn_label: "Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/setup_tool_old.jpg
    title: "Skin Composer"
    excerpt: 'A skin creator for libGDX'
    url: "https://github.com/raeleus/skin-composer/wiki"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/particle_editor.png
    title: "Particle Editor"
    excerpt: 'A powerful tool for making 2D particle effects'
    url: "https://github.com/libgdx/libgdx/wiki/2D-Particle-Editor"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"

feature_row3:
  - image_path: /assets/images/dev/tools/flame.gif
    title: "Flame"
    excerpt: 'A powerful 3D particle editor'
    url: "https://github.com/libgdx/libgdx/wiki/3D-Particle-Effects"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/hiero.png
    title: "Hiero"
    excerpt: 'A bitmap font packing tool'
    url: "https://github.com/libgdx/libgdx/wiki/Hiero"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"
  - image_path: /assets/images/dev/tools/fbx_conv.gif
    title: "fbx-conv"
    excerpt: 'A command line for converting FBX/Collada/Obj to libGDX friendly formats'
    url: "https://github.com/libgdx/fbx-conv"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"

feature_row4:
  - image_path: /assets/images/dev/tools/texture_packer.jpeg
    title: "Texture Packer"
    excerpt: 'A tool for packing images into atlases'
    url: "https://github.com/libgdx/libgdx/wiki/Texture-packer"
    btn_label: "Documentation & Download"
    btn_class: "btn--primary"

sidebar:
  nav: "dev"

---

{% include breadcrumbs.html %}

{% include feature_row %}

{% include feature_row id="feature_row2" %}

{% include feature_row id="feature_row3" %}

{% include feature_row id="feature_row4" %}
