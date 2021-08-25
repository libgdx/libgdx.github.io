---
permalink: /dev/import-and-running/
redirect_from:
  - /dev/import_and_running/
title: "Importing & Running a Project"
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

Next up, you need to import your project into your IDE.

{% include setup_flowchart.html current='2' %}


# Importing the Project
1. In **IntelliJ IDEA or Android Studio**, you can choose to open the `build.gradle` file and select "Open as Project" to get started.

   In **Eclipse**, choose `File -> Import... -> Gradle -> Existing Gradle Project` (make sure that your freshly generated project is not located inside of your workspace).

   In **Netbeans** it is `File -> Open Project`.

2. You may need to refresh the Gradle project after the initial import if some dependencies weren't downloaded yet.

   In **IntelliJ IDEA/Android Studio**, the `Reimport all Gradle projects` button is a pair of circling arrows at the top left in the Gradle tool window, which can be opened with `View -> Tool Windows -> Gradle`.

   In **Eclipse** right click on your project `Gradle -> Refresh Gradle Project`.

<br/>

# Getting it Running
If you want to execute your freshly imported project, you have to follow different steps, depending on your IDE and the platform you are targeting.
## Desktop
### In IDEA/Android Studio:
1. Extend the Gradle tab on the right sight of your window: <br/>
  ![](/assets/images/dev/idea/3.png)
2. Expand the tasks of your project and then select: desktop -> other -> run.

<b>Alternatively</b>, you can create a run configuration:
1. Right click your DesktopLauncher class
2. Select 'Run DesktopLauncher.main()'. This should fail with missing assets, because we need to hook up the assets folder first.
3. Open up Run Configurations <br/>
  ![](/assets/images/dev/idea/0.png)
4. Edit the Run Configuration that was just created by running the desktop project and set the working directory to point to your `core/assets` folder  (or `android/assets` if you are using an Android subproject)<br/>
  ![](/assets/images/dev/idea/1.png)

    On **macOS**, LWJGL3 projects require one extra step: In your Run Configuration you need to set the VM Options to `-XstartOnFirstThread`. Additional information can be found [here](https://github.com/libgdx/libgdx/wiki/Starter-classes-and-configuration#common-issues).
    {: .notice--warning}
5. Run your application using the run button

### In Eclipse:
1. Right click your desktop project -> Run as -> Run Configurations...
2. On the right side, select Java Application: <br/>
  ![](/assets/images/dev/eclipse/3.png)
3. At the top left, click the icon to create a new run configuration:
  ![](/assets/images/dev/eclipse/0.png)
4. As Main class select your `DesktopLauncher` class
5. After that, click on the Arguments tab
6. At the bottom, under 'Working directory' select 'Other' -> Workspace...
  ![](/assets/images/dev/eclipse/1.png)

    On **macOS**, LWJGL3 projects require one extra step: In your Run Configuration you need to set the VM arguments to `-XstartOnFirstThread`. Additional information can be found [here](https://github.com/libgdx/libgdx/wiki/Starter-classes-and-configuration#common-issues).
    {: .notice--warning}
7. Then select your asset folder located in `core/assets` (or `android/assets` if you are using an Android subproject)

### In Netbeans:
Right click the desktop project -> Run

<br/>

## Android
- **IDEA/Android Studio:** Right click AndroidLauncher -> Run AndroidLauncher
- **Eclipse:** Right click Android project -> Run As -> AndroidApplication
- **Netbeans:** Right click Android project -> Run As -> AndroidApplication

<br/>

## iOS
### In IDEA/Android Studio
1. Open Run/Debug Configurations
2. Create a new run configuration for a RoboVM iOS application

![](/assets/images/dev/idea/2.png)

3. Select the provisioning profile and simulator/device target
4. Run the created run configuration

For more information on using and configuring the RoboVM IntelliJ plugin please see the [documentation](http://robovm.mobidevelop.com).

### In Eclipse
- Right click the iOS RoboVM project > Run As > RoboVM runner of your choice

![](/assets/images/dev/eclipse/2.png)

For more information on using and configuring the RoboVM IntelliJ plugin please see the [documentation](http://robovm.mobidevelop.com).

<br/>

## HTML
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

## Command Line
All the targets can be run and deployed to via the command line interface.

**Desktop:**
```
./gradlew desktop:run
```

**Android:**
```
./gradlew android:installDebug android:run
```

The `ANDROID_HOME` environment variable needs to be pointing to a valid android SDK before you can do any command line wizardry for Android. On Windows, use: `set ANDROID_HOME=​C:/Path/To/Your/Android/Sdk`; on Linux and macOS: `export ANDROID_HOME=​/Path/To/Your/Android/Sdk`. Alternatively you can create a file called "local.properties" with the following content: `sdk.dir /Path/To/Your/Android/Sdk`.

**iOS:**
```
./gradlew ios:launchIPhoneSimulator
```

**HTML:**
```
./gradlew html:superDev
```

Then go to [`http://localhost:8080/index.html`](http://localhost:8080/index.html).

### Gradle tasks are failing?
If whenever you invoke Gradle, the build or refresh fails to get more information, run the same command again and add the `--debug` parameter to the command, e.g.:

```
./gradlew desktop:run --debug
```

This will provide you with a stacktrace and give you a better idea of why gradle is failing.


<br/>

# What to do next?
Now that you're done with the set up, you can get to do some real coding. Take a look at our post [A Simple Game](/dev/simple-game/) for a step-by-step guide.
