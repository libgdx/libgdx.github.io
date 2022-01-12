---
title: "Status Report #6: 1.9.14 Code Freeze"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/posts/2021-01-26/header.jpeg
  caption: "Photo credit: [**Tom Barrett**](https://unsplash.com/photos/dkv2CXSoVfs)"
  teaser: /assets/images/posts/2021-01-26/header.jpeg

excerpt: Try out the latest snapshots for 1.9.14 and find out more about some of our other projects.

show_author: true
author_username: "crykn"
author_displayname: "damios"

tags:
  - devlog

categories: news
---

First things first - let's start with the biggest news for today's Status Report: we just entered into our **code freeze period for libGDX 1.9.14**. This means that we won't be adding any material changes to the current branch until libGDX 1.9.14 is released, which will be this weekend. We would like to welcome everybody to try out our snapshot builds (`1.9.14-SNAPSHOT`) during this time, so we can catch any potential issues before release. 1.9.14 won't contain any major features, but a few [quality of life improvements](https://github.com/libgdx/libgdx/blob/master/CHANGES).

In our last Status Report we announced regular **Community Showcases**, which started off mid January with raeleus, who [presented his Skin Composer project](/news/2021/01/skin-composer). Be sure to check it out if you haven't already! We are very pleased that our idea was received as well as it was and that quite a lot of you have expressed their interest in participating in our showcases. Over the next few months, we'll try to give everyone a chance to show off their exciting libGDX projects. To find out more about our plans take a look [here](https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases).

On another note: version 2.0.0 of **[gdx-jnigen](https://github.com/libgdx/gdx-jnigen)** was released last week. Jnigen is the tool used to write native C/C++ code within libGDX's Java source code. If you want to find out more, check out the corresponding [wiki entry](/wiki/utils/jnigen). This change brings us another step closer to switch our internal build system over to Gradle. We also released version 2.0.1 of **[gdx-controllers](https://github.com/libgdx/gdx-controllers/releases/tag/2.0.1)** and removed any and all code left in the main repository. Work on **[gdx-video](https://github.com/libgdx/gdx-video/)** is also still progressing (current version: `1.3.2-SNAPSHOT`) – we appreciate any help in testing!

And last but not least: When merging pull request [#6327](https://github.com/libgdx/libgdx/pull/6327) we reached a very cool milestone! Since this project started in 2009, **500 people have contributed to libGDX's code base**. If you want to become one of those people, be sure to check out our [roadmap](/roadmap/) and talk to the contributors on our [Discord server](/community/discord/)!

And that was it for today's Status Report – see you all in #6!
