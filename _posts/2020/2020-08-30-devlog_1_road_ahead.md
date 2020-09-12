---
title: "Status Report #1: The Road Ahead"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/posts/2020-08-30/header.jpeg
  caption: "Photo credit: [**Scott Graham**](https://unsplash.com/photos/5fNmWej4tAA)"
  teaser: /assets/images/posts/2020-08-30/teaser.png

excerpt: What is currently happening behind the scenes?

show_author: true
author_username: "crykn"
author_displayname: "damios"

categories: news
---

As some of you may have noticed, the libGDX team was expanded in the last couple days: **ten** new faces were welcomed as members of the contributors team!

To keep you all updated on what is happening behind the scenes, we want to give you an overview of the things we are currently working on as well as our plans for the upcoming **version `1.10`**.

## Release Schedule?
We are very much committed to increasing the frequency of releases. Thus, we are currently working out a broad release schedule that fits both our plans and goals for libGDX as well as our time available and the needs of you, the developers using libGDX. We will keep you posted, as soon as we have something more concrete to share. We also want to involve the community in such decisions, so please feel free to join our official [Discord](/community/) and give us some feedback!

## What Is Planned?
There are different areas of focus for our development efforts. While most certainly not all of them will make it into the ``1.10`` release, we hope most will – and you can be sure that some other improvements, not mentioned here, will be part of ``1.10`` as well. If you yourself want to work on some (major) features, join our community and talk to the contributors team!

### Linux ARM builds
They are finally here: Linux ARM builds. These allow developers to deploy their games, for example, on the [Raspberry Pi](https://www.raspberrypi.org). When can you start trying this out? Right now! Just use the latest snapshot of libGDX.

![](/assets/images/posts/2020-08-30/rpi.png)

### GWT Improvements
We have even more long-awaited improvements, this time for the GWT backend:
- Webaudio will be used instead of the SoundManager2 lib
- The possibility to lazy load assets is added
- [Mobile] Retina and HDPI screens are coming
- [Mobile] Support for gyroscopes
- [Mobile] Some general quality of life improvements

These efforts are spearheaded primarily by **MrStahlfelge**.

### Gradle Build Migration
We also want to migrate our whole build process to Gradle. For this, the work on ``gdx-jnigen`` (mostly done by **PokeMMO**) has to be completed. Moreover, **SimonIT** has started implementing the Android backend as proper Android library (AAR) in order to facilitate the deployment of libGDX. This migration has been long in the making and there is still a lot of work to be done, but we're crossing our fingers it gets finished without any major hurdles.

### iOS MOE – quo vadis?
In April 2016, the iOS Multi-OS Engine backend was introduced because RoboVM was discontinued and hence its future uncertain. However, the MOE backend never quite caught up to the RoboVM in features and the [MobiVM](http://robovm.mobidevelop.com) fork of RoboVM proved to be a worthy successor of RoboVM. As a consequence, we are removing the MOE backend in the next version of libGDX.

### gdx-video
There are also currently some plans drawn up to revive the ``gdx-video`` extension.

<br/>

We hope you enjoyed us sharing our current development focus and would appreciate your feedback on these kind of posts as well as on our communication in general (preferably on our official [Discord server](/community/)). Also, we ourselves are very much looking forward to the changes coming to libGDX in the coming weeks and months!
