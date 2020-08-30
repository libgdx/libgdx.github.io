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
  - excerpt: 'libGDX is an open-source, cross-platform game development framework built in Java. Unlike many popular editor-based platforms, libGDX is entirely code-centric, offering developers fine-grain control over every aspect of their game. It is the perfect place for exploring ground-up implementations, built on top of lightning-fast OpenGL, and distributable to Desktop, HTML, Android, and iOS.'
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
    excerpt: 'libGDX offers a very extensive third-party ecosystem. There are numerous [tools](/dev/tools/) and libraries that take a lot of work off the hands of developers. [Awesome-libGDX](https://github.com/rafaskb/awesome-libgdx) is a curated list of libGDX-centered **libraries** and a good starting point for anyone new in the libGDX world.'
    url: "https://github.com/rafaskb/awesome-libgdx"
    btn_label: "Check out Awesome-libGDX"
    btn_class: "btn--primary"
---

{% include feature_row type="left" %}

{% include feature_row id="feature_row2" type="right" %}

{% include feature_row id="feature_row3" type="left" %}

# Feature Packed
_libGDX comes with batteries included. Write 2D or 3D games and let libGDX worry about low-level details._

- libGDX provides you with everything you need for proper **2D development**, right out-of-the-box.
- **3D Graphics** are also supported via various high-level APIs. Take a look at our [showcase](/showcase/) to see some 3D games made with libGDX.
- **Physics, Audio, Networking, Input Handling, File I/O & Storage, Asset Loading:** you name it, we got it! Check out [our wiki](https://github.com/libgdx/libgdx/wiki) for an extensive list of features.
- **Super Fast:** Heavy emphasis was put on avoiding garbage collection for Dalvik/JavaScript by careful API design and the use of custom collections.
- **Small game sizes:** libGDX games can be very small – starting from around a couple MBs for Android games and even less than <60 MB for desktop projects with a bundled JRE

<br/>

# Do whatever you want
_Unlike many popular editor-based platforms, libGDX is entirely code-centric, offering developers fine-grain control over every aspect of their game._

- **Freedom:** While libGDX gives you access to various different tools and abstractions, you can still access the underlying base. libGDX doesn't force you too use certain tools or coding styles: you are free to do whatever you want!
- **Open Source:** libGDX is licensed under Apache 2.0 and maintained by the community, so you can take a look [under the hood](https://github.com/libgdx/libgdx) and see how everything works.
- **Java:** Since libGDX uses Java, you can profit from the wide java ecosystem – Powerful IDEs, out-of-the-box support for Git, fined-tuned debuggers, performance profilers, and an abundance of well tried libraries and frameworks, as well as many resources and extensive documentation.

<br/>

# And...
**...a Great Community!** Get support from a very friendly [community](/community/) of game and application developers or use any of the libraries and tools created by members of our community. Join us today and get started with your very first libGDX game!

<center><a href="/dev/setup/" class="btn btn--primary btn--large">Get Started!</a></center>
