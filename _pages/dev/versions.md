---
permalink: /dev/versions/
title: "Versions"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

sidebar:
  nav: "dev"
---

{% include breadcrumbs.html %}

<!-- TO EDIT THIS DATA SEE _data/versions.json -->

# libGDX {{ site.data.versions.libgdxRelease }}
Keep up to date with the latest versions of dependencies and dev tools!

If you are using **Java 16**, be sure to update to Gradle 7.0 (`./gradlew wrapper --gradle-version 7.0`)! Please be aware, that as Gretty doesn't yet work with Gradle 7, you are advised to stay on Java 8-15 if you are using a Web subproject.
{: .notice--success}

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
