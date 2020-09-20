---
permalink: /dev/running/
title: "Running a Project"
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

This article explains how you can get your [freshly created](/dev/setup/) libGDX project running.

# Desktop
## In IDEA/Android Studio:
1. Right click your DesktopLauncher class
2. Select 'Run DesktopLauncher.main()'. This should fail with missing assets, because we need to hook up the assets folder first.
3. Open up Run Configurations

![](/assets/images/dev/idea/0.png)

4. Edit the Run Configuration that was just created by running the desktop project and set the working directory to point to your `core/assets` folder

![](/assets/images/dev/idea/1.png)

5. Run your application using the run button

## In Eclipse:
1. Right click your desktop project > Build Path > Configure Build Path
2. Click the sources tab, and click 'Add Folder'
3. Select the assets folder and hit OK.

![](/assets/images/dev/eclipse/0.png)

4. Right click your desktop project > Run as > Java Application

## In Netbeans:
Right click the desktop project > Run

<br/>

# Android
- **IDEA/Android Studio:** Right click AndroidLauncher > Run AndroidLauncher
- **Eclipse:** Right click Android project > Run As > AndroidApplication
- **Netbeans:** Right click Android project > Run As > AndroidApplication

<br/>

# iOS
## In IDEA/Android Studio
1. Open Run/Debug Configurations
2. Create a new run configuration for a RoboVM iOS application

![](/assets/images/dev/idea/2.png)

3. Select the provisioning profile and simulator/device target
4. Run the created run configuration

For more information on using and configuring the RoboVM intellij plugin please see the [documentation](http://robovm.mobidevelop.com).

**NOTE:** This documentation is for the 'Official' RoboVM plugin. We are currently using a forked version, which means some of the information (such as about licensing) may be redundant. Configuring and using the plugin should however be very similar.
{: .notice--primary}

## In Eclipse
- Right click the iOS RoboVM project > Run As > RoboVM runner of your choice

![](/assets/images/dev/eclipse/1.png)

For more information on using and configuring the RoboVM intellij plugin please see the [documentation](http://robovm.mobidevelop.com).

**NOTE:** This documentation is for the 'Official' RoboVM plugin. We are currently using a forked version, which means some of the information (such as about licensing) may be redundant. Configuring and using the plugin should however be very similar.
{: .notice--primary}

<br/>

# HTML
HTML is best suited to be run on command line. You are welcome to manually setup GWT in the IDE of your choice if you are familiar with it, but the recommended way is to drop down to terminal or command prompt.

The HTML target can be run in **Super Dev** mode, which allows you to recompile on the fly, and debug your application in browser.

To do so, open up your favourite shell or terminal, change directory to the project directory and invoke the respective gradle task:

```
./gradlew html:superDev
```

**On Unix:** If you get a permission denied error, set the execution flag on the gradlew file: `chmod +x gradlew`
{: .notice--primary}

You should see lots of text wizzing by, and if all goes well you should see the following line at the end:

![](/assets/images/dev/html/0.png)

You can then go to [`http://localhost:8080/index.html`](http://localhost:8080/index.html), to see your application running, with a recompile button.

For further info on configuring and debugging with SuperDev check the [GWT documentation](http://www.gwtproject.org/articles/superdevmode.html).

<br/>

# Command Line
All the targets can be run and deployed to via the command line interface.

**Desktop:**
```
./gradlew desktop:run
```

**Android:**
```
./gradlew android:installDebug android:run
```

The `ANDROID_HOME` environment variable needs to be pointing to a valid android SDK before you can do any command line wizardry for Android. On Windows, use: `set ANDROID_HOME=C:/Path/To/Your/Android/Sdk`; on Linux and Mac OS X: `export ANDROID_HOME=/Path/To/Your/Android/Sdk`. Alternatively you can create a file called "local.properties" with the following content: `sdk.dir /Path/To/Your/Android/Sdk`.

**iOS:**
```
./gradlew ios:launchIPhoneSimulator
```

**HTML:**
```
./gradlew html:superDev
```

Then go to [`http://localhost:8080/index.html`](http://localhost:8080/index.html).

## Gradle tasks are failing?
If when you invoke gradle, the build or refresh fails to get more information, run the same command again and add the --debug arguments to the command,
e.g.:

```
./gradlew desktop:run --debug
```

This will provide you with a stacktrace and give you a better idea of why gradle is failing.


<br/>

# What to do next?
Now that you're done with the set up, you can get to do some real coding. Take a look at our post [A Simple Game](/dev/simple_game/) for a step-by-step description.
