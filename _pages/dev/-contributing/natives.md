---
permalink: /dev/natives/
title: "Building the libGDX Natives"
classes: wide
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

sidebar:
  nav: "dev"
---

{% include breadcrumbs.html %}

# Prerequisites
Building the natives is slightly more involved. The natives are built for every platform we target:

- Windows (32 and 64 bit), Linux (arm32, arm64, x86_64), macOS (arm64, x86_64)
- Android (armeabi-v7a, arm64-v8a, x86, x86_64)
- iOS (armv7, arm64, x86_64)

To do this we use [GitHub Actions](https://github.com/libgdx/libgdx/actions), which compiles the Windows, Linux and Android natives on a Linux host and the macOS and iOS natives on a mac host. If you are interested in the behind-the-scenes stuff, you should take a look at the [gdx-jnigen project](https://github.com/libgdx/gdx-jnigen).

Please note that the information below may not be up to date. If you are interested in building libGDX's natives yourself, be sure to check out our actual [build configuration](https://github.com/libgdx/libgdx/blob/master/.github/workflows/build-publish.yml) on GitHub.
{: .notice--info}

# Linux host
What you need:

- 64 bit Linux distro (we use Ubuntu 18.04)
- openjdk-7-jdk
- Ant 1.9.3+ (must be on path)
- Android NDK r13b (ANDROID_NDK and NDK_HOME variables set)
- Android SDK with latest targets (ANDROID_SDK variable set)
- Compilers
- gcc, g++, gcc-multilib, g++-multilib, (64 bit Linux compilers)
- mesa-common-dev, libxxf86vm-dev, libxrandr-dev, libx11-dev:i386, jglfw only
- mingw-w64 (Windows compiler 32 bit and 64 bit)
- ccache (optional)
- lib32z1

# macOS host
What you need:

- JDK 8+
- XCode, through Mac app store
- XCode command line utilities for latest XCode
- Ant 1.9.3+ (must be on path, use homebrew)
- ccache (optional, use homebrew)

# Compiling
Compiling the natives is handled through Gradle.

To compile the **macOS and iOS** natives, run:

```
./gradlew jnigen jnigenBuildMacOsX64 jnigenBuildMacOsXARM64 jnigenBuildIOS
```

To compile the **Windows, Linux and Android** natives, run:

```
./gradlew jnigen jnigenBuild
```

You can also run each individual platforms tasks to build natives for just that platform, for example just the Android natives, just run `./gradlew jnigen jnigenBuildAndroid`. You can get the list of available tasks by running `./gradlew tasks`.
