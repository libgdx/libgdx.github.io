---
permalink: /dev/versions/
title: "Versions"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

description: "Keep up to date with the latest versions of dependencies and dev tools! Each libGDX version supports certain RoboVM, Android SDK, Gradle and GWT releases."

sidebar:
  nav: "dev"
---

{% include breadcrumbs.html %}

<!-- THIS DATA IS AUTOMATICALLY FETCHED BY _plugins/libgdx_fetch_versions.rb -->

# libGDX 1.12.1
Keep up to date with the latest versions of dependencies and dev tools! Instructions on how to  update your Gradle files can be found [here](/wiki/articles/updating-libgdx).

### RoboVM
- RoboVM Version: {{ site.data.versions.robovmVersion }}
- RoboVM Gradle Plugin Version: {{ site.data.versions.robovmPluginVersion }}

### Android
- Android Build Tools Version: {{ site.data.versions.androidBuildtoolsVersion }}
- Android SDK Version: {{ site.data.versions.androidSDKVersion }}
- Android Gradle Tool Version: {{ site.data.versions.androidGradleToolVersion }}

### GWT
- GWT Version: {{ site.data.versions.gwtVersion }}
- GWT Gradle Plugin Version: {{ site.data.versions.gwtPluginVersion }}

### Extensions
Our extensions use their own versioning schemes. You cand find their latest versions on the respective release pages: [Ashley](https://github.com/libgdx/ashley/releases), [Box2DLights](https://github.com/libgdx/box2dlights/releases), [gdx-ai](https://github.com/libgdx/gdx-ai/releases), [gdx-controllers](https://github.com/libgdx/gdx-controllers/releases), [gdx-pay](https://github.com/libgdx/gdx-pay/releases)
