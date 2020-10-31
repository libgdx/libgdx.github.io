---
title: "Status Report #3: Roadmap for 1.10"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/posts/2020-10-05/header.jpg
  caption: "Photo credit: [**Slidebean**](https://unsplash.com/photos/iW9oP7Ljkbg)"
  teaser: /assets/images/posts/2020-10-05/header.jpg

excerpt: libGDX 1.10 - where, when, what, why? This post tells you everything you need to know about our plans for the next version of libGDX.

show_author: true
author_username: "crykn"
author_displayname: "damios"

categories: news
---

In this Status Report we want to give you an overview of our plans for the upcoming version 1.10 of libGDX. As mentioned in [Status Report #2](/news/2020/09/devlog_2_release_schedule), we are on track to release it around the end of October.

## gdx-controller Improvements
**MrStahlfelge**'s hard work improving the controller functionality of libGDX will finally come to fruition: version 2.0 of gdx-controllers is set to release. It will include, inter alia, more [reliable mappings](https://github.com/libgdx/gdx-controllers/wiki#mappings-and-codes), hotplugging, [vibration](https://github.com/libgdx/gdx-controllers/wiki#vibration) (on most platforms), as well as methods to [query controller features](https://github.com/libgdx/gdx-controllers/wiki#query-available-features), and an all-new iOS implementation. The desktop implementation is now based on SDL, with a Java wrapper named Jamepad - if you are interested in some of the internals, check out the [jamepad repo](https://github.com/libgdx/Jamepad). That means, next to other advantages, arm is supported on Linux!

A pre-release version of gdx-controllers is available as `2.0.0-SNAPSHOT`. Be sure to take a look at the [v2 migration guide](https://github.com/libgdx/gdx-controllers/wiki/Migrate-from-v1) before updating!

## Packr
Packr has got a new maintainer: **karlsabo** - Welcome to the team! Karlsabo was very busy in the last few weeks porting over the changes from his fork and fixing the issues that have piled up in the repo. Packr now supports Mac OS signing and notarisation and works with Java 11 and 14 - but there is more, a lot (and I mean _a lot_!) [more](https://github.com/libgdx/packr/pull/163). The latest jar can be tried [here](https://github.com/orgs/libgdx/packages?repo_name=packr).

## gdx-video
As mentioned in Status Report #1, there were some plans drawn up to revive the old gdx-video extension. **SimonIT** was the one to take the lead and has done quite some work in the last weeks.

![gdx-video: first tries](/assets/images/posts/2020-10-05/gdx_video_attempt.png)
> _Some hurdles had to be taken along the way, but **mgsx-dev** was quick to help._

Sadly, we can't give an ETA for a release yet, as there are still some things having to be worked out.

## New Web-Based Setup Tool
As some of you may have noticed, there was quite some talk on our Discord server relating to our setup tool and how we could improve on it. There are a lot of different suggestions in the room and a lot of people interested to help, so we have still some things to sort out - but we are positive that we can show a working prototype before 1.10!

Just to give you all a quick teaser, this is a draft for a new GUI that **raeleus** has been working on:

![Preview of the Setup Tool](/assets/images/posts/2020-10-05/setup_preview.gif)

## Miscellaneous
There are also a lot of other features and improvements planned for 1.10 and beyond, some of which we already talked about:
- **iOS MOE** is set to be **removed**
- **Linux ARM builds** are included with libGDX (if you have some screenshots or videos to show off, hit me up on Discord!)
- A **Box2D** update to version [2.4.0](https://github.com/erincatto/box2d/releases/tag/v2.4.0): **MobiDevelop** is checking out what we can do here, but no promises yet!
- **GWT improvements** (we already mentioned those in Status Report #1)
- **LWJGL3 backend improvements** (get ready for a `foregroundFPS` option!)
- As always: general Scene2D Improvements
- We are also continuing to go through the issues and pull requests on GitHub, so you can be sure that gdx 1.10 will also include a plethora of bug fixes.

This is it for today's Status Report! If you yourself want to get involved in the development process, we are always happy for comments on PRs as well as issues and welcome you to join our official [Discord server](/community/)! If some of you are interested in working on [Ashley](https://github.com/libgdx/ashley), we could use some help there as well. Otherwise, see you in Status Report #4, which will probably be released around the end of October!
