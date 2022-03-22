---
title: Deploying your application
---
The mechanism to deploy your game differs between platforms. This article aims to articulate, what is necessary to deploy to each platform that libGDX officially supports:

* [Deploy to Windows/Linux/Mac](#deploy-to-windowslinuxmac-os-x)
* [Deploy to Android](#deploy-to-android)
* [Deploy to iOS](#deploy-to-ios)
* [Deploy Web](#deploy-web)

# Deploy to Windows/Linux/Mac OS X
### As JAR file
The easiest way to deploy to Windows/Linux/Mac is to create a runnable JAR file. This can be done via the following console command:
`./gradlew desktop:dist`

If you are getting an error like `Unsupported class file major version 60`, your Java version (see [here](https://stackoverflow.com/q/9170832) for a list) is not supported by your Gradle version. To fix this, install an older JDK.

The generated JAR file will be located in the `desktop/build/libs/` folder. It contains all necessary code as well as all your art assets from the android/assets folder and can be run either by double clicking or on the command line via `java -jar jar-file-name.jar`. Your audience must have a JVM installed for this to work. The JAR will work on Windows, Linux and Mac OS X!

### Alternative (modern) ways of deployment
Distributing java applications as JAR file can be very unhandy and prone to issues, as not every user can be expected to have the right JRE (or even any JRE) installed. Other ways of deployment are for example:

* A very convenient way to distribute java application is to just bundle an JRE. See this [entry](/wiki/deployment/bundling-a-jre) on how to do this. (**This is the recommended way to distribute an application!**)
* Via electron, HTML5 applications can be deployed to desktop. See [here](https://medium.com/@bschulte19e/how-to-deploy-a-libgdx-game-with-electron-3f1b37f0c26e).
* GWT applications can also be bundled as UWP Apps, see [here](https://web.archive.org/web/20200428040905/https://www.badlogicgames.com/forum/viewtopic.php?f=17&t=14766).

# Deploy to Android
`gradlew android:assembleRelease`

This will create an unsigned APK file in the `android/build/outputs/apk` folder. Before you can install or publish this APK, you must [sign it](https://developer.android.com/studio/publish/app-signing). The APK build by the above command is already in release mode, you only need to follow the steps for keytool and jarsigner. You can install this APK file on any Android device that allows [installation from unknown sources](https://developer.android.com/distribute/marketing-tools/alternative-distribution#unknown-sources).

# Deploy to iOS
*This section assumes you're familiar with the basic deployment steps for iOS apps.*

### Prerequisites:
In order to upload the IPA to the app store, it must be signed with your distribution signature and linked to your provisioning profile.
You can follow Apple's guide on [app store distribution](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/Introduction/Introduction.html) to create provisioning profiles and certificates.
Once you have done that, you must define them in your root build.gradle file, in your IOS Project

```
project(":ios") {
    apply plugin: "java"
    apply plugin: "robovm"

    dependencies {
        // ...
    }

    robovm {
        iosSignIdentity = "[Signing identity name]"
        iosProvisioningProfile = "[provisioning profile name]"
        iosSkipSigning = false
        archs = "thumbv7:arm64"
    }
 }
```

- Your provisioning profile name is available in your developer portal (where you created your provisioning profile).
- Your Signing identity name is available in your keychain, under "My Certificates"

### Packaging:
To create your IPA, run

`gradlew ios:createIPA`

This will create an IPA in the `ios/build/robovm` folder that you distribute to the Apple App Store.
To upload your app you will need to use the application loader within XCode (Xode->Open Developer Tool->Application loader)

Note: as of iOS 11 instead of simply adding your icons into your data folder within your iOS project you need to include an asset Catalog.
If you do not include one, you can still submit your app but later you receive a message regarding `Missing Info.plist value - A value for the Info.plist key CFBundleIconName is missing in the bundle '...'. Apps that provide icons in the asset catalog must also provide this Info.plist key.` To fix this, follow these [instructions to include an asset catalog](https://github.com/MobiVM/robovm/wiki/Howto-Create-an-Asset-Catalog-for-XCode-9-Appstore-Submission%3F).

### Additional guides

Deploying to iOS is relatively straight forward, see [here](https://medium.com/@bschulte19e/deploying-your-libgdx-game-to-ios-in-2020-4ddce8fff26c) if you're having difficulties. Take a look at [this post](https://medium.com/dev-genius/deploying-your-libgdx-game-to-ios-testflight-163cada0696b), if you want to deploy your iOS application to TestFlight.

# Deploy Web
`gradlew html:dist`

This will compile your app to Javascript and place the resulting Javascript, HTML and asset files in the `html/build/dist/` folder. The contents of this folder have to be served up by a web server, e.g. Apache or Nginx. Just treat the contents like you'd treat any other static HTML/Javascript site. There is no Java or Java Applets involved!

When running the result, you might encounter errors like `Couldn't find Type for class ...`. To fix this, please see our wiki page [Reflection](/wiki/utils/reflection) and include the needed classes/packages.

With Python installed, you can test your distribution by executing the following in the `html/build/dist` folder:

**Python 2.x**

`python -m SimpleHTTPServer`

**Python 3.x**

`python -m http.server 8000`

You can then open a browser to [http://localhost:8000](http://localhost:8000) and see your project in action.

With Node.js `npm install http-server -g` then `http-server html/build/dist` and browse at <http://localhost:8080>. [docs](https://github.com/indexzero/http-server)

With PHP you may type `php -S localhost:8000` and browse at <http://localhost:8080>. [docs](http://php.net/manual/en/features.commandline.webserver.php)
