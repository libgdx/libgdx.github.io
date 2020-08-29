---
permalink: /dev/natives/
title: "Building the libGDX Natives"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.3"
  overlay_image: /assets/images/dev/dev.jpeg
  caption: "Photo credit: [**Florian Olivo**](https://unsplash.com/photos/Ek9Znm8lQ1U)"

toc: true
toc_sticky: false

---

{% include breadcrumbs.html %}

# Prerequisites
Building the natives is slightly more involved. The natives are built for every platform we target:

- Desktop Windows, Linux and Mac both 32 and 64 bit
- Android arm6, arm7, x86, x86_64
- iOS i386, arm7, arm64, x86_64

To do this we use a Linux host for crosscompilation of Windows/Linux and Android natives. We also use a Mac host for the iOS and macOS natives. Mac and iOS natives can only be built on macOS.

# Linux host
What you need:

- 64 bit Linux distro (we use Ubuntu 13.10)
- openjdk-7-jdk
- Ant 1.9.3+ (must be on path)
- Maven 3+ (must be on path)
- Android NDK r13b (ANDROID_NDK and NDK_HOME variables set)
- Android SDK with latest targets (ANDROID_SDK variable set)
- Compilers
- gcc, g++, gcc-multilib, g++-multilib, (32 bit and 64 bit Linux compilers)
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
Compiling the natives is handled through **Ant** scripts.

To compile the Mac and iOS natives, run:

```
./ant -f build-mac-ios.xml
```

To compile the Windows, Linux and Android natives, run:

```
./ant -f build.xml -Dbuild-natives=true -Dversion=nightly
```

You can also run each individual platforms script to build natives for just that platform, for example just the Android natives, just run that particular script itself, (you may have to set some extra command line properties yourself, so check out each script to see what it expects).
