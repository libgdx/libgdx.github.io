---
permalink: /dev/contributing/
title: "Contributing Guidelines"
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

Contributing to libGDX can come in a few different forms: you can [report issues](/dev/issues/), help out on the [Discord](/community/) and IRC, pledge to the [Patreon](/funding/) page, and submit [code](https://github.com/libgdx/libgdx/) and [documentation](https://github.com/libgdx/libgdx/wiki) back to the project on GitHub.

If you want to submit code back to the project, please take a moment to review our guidelines below.

# Guidelines
## API Changes & Additions
If you modify a public API, or add a new one, make sure to add these changes to the [CHANGES](https://github.com/libgdx/libgdx/blob/master/CHANGES) file in the root of the repository.

If you want to poll the brains of other devs, either open an issue on our issue tracker, send a pull request and start a conversation on Github, or join our official [Discord server](/community/discord/).

## Contributor License Agreement
Libgdx is licensed under the [Apache 2.0 license](http://en.wikipedia.org/wiki/Apache_License). Before we can accept (major) code contributions, we need you to sign our [Contributor License Agreement](https://github.com/libgdx/libgdx/blob/master/CLA.txt). Just print it out, fill in the blanks and send a copy to contact@badlogicgames.com, with the subject `[Libgdx] CLA`.

Signing the CLA will allow us to use and distribute your code. This is a non-exclusive license, so you retain all rights to your code. It's a fail-safe for us should someone contribute essential code and later decide to take it back.

## Formatting
If you are working on any of the libGDX code, we require you to use the formatter that we use. You can find it [here](https://github.com/libgdx/libgdx/blob/master/eclipse-formatter.xml). Failure to use the formatter will most likely get your pull request rejected. The formatter provided can be imported into Intellij and Android Studio also, its not just for Eclipse. See [here](https://blog.jetbrains.com/idea/2014/01/intellij-idea-13-importing-code-formatter-settings-from-eclipse/) for official documentation on this.

Don't let the formatter run automatically, or on the whole file you are changing. Only run the formatter on the lines you are specifically changing.
{: .notice--primary}

## Code Style
libGDX doesn't have an official coding standard, but we stand by the usual Java style, as should you.

**Please do <u>not</u> do any of the following:**
- Underscores in identifiers
- [Hungarian notation](http://en.wikipedia.org/wiki/Hungarian_notation)
- Prefixes for fields or arguments
- Curly braces on new lines

A few additional notes to keep in mind:

- When creating a new file, make sure to add the Apache file header, as you can see [here](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Application.java#L1-L15)
- Follow the style of the code in the file you are changing
- If you create a new class, please add documentation that explains the usage and scope of the class. You don't have to add javadocs for methods that are self explanatory.
- If your class is thread safe, mention it in the documentation. Its assumed that libGDX classes are not thread safe by default, so please mention it.

## Compatibility
Due to the cross platform nature of libGDX, there are some things you have to avoid when contributing code. For example. GWT [does not support all java features](http://www.gwtproject.org/doc/latest/RefJreEmulation.html), and Android [does not support all desktop JVM features](https://developer.android.com/studio/write/java8-support).

### Considerations for GWT compatibility
If some java features are not supported on GWT they must either be emulated or avoided. Emulation is also required for native code (`Matrix4`). An example of emulation is shown [here](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backends-gwt/src/com/badlogic/gdx/backends/gwt/emu/com/badlogic/gdx/math/Matrix4.java).

Common limitations on GWT include:
- Formatting: String.format() is not supported.
- Regular expressions. However, a basic emulation of [Pattern](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backends-gwt/src/com/badlogic/gdx/backends/gwt/emu/java/util/regex/Pattern.java) and [Matcher](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backends-gwt/src/com/badlogic/gdx/backends/gwt/emu/java/util/regex/Matcher.java) is provided.
- Reflection. Use [libGDX reflection](https://github.com/libgdx/libgdx/wiki/Reflection) instead.
- Multithreading: [Timers](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/utils/Timer.java) are supported on GWT, but threads are strictly not.

Determine if any new classes are compatible with GWT, and either **include** or **exclude** elements to the [GWT module](https://github.com/libgdx/libgdx/blob/master/gdx/res/com/badlogic/gdx.gwt.xml). See for example [this PR](https://github.com/libgdx/libgdx/pull/5018/files#diff-13b547f0d1b0872d60d67db4ca0b266d).
If the new file isn't added to `gdx/src/com/badlogic/gdx.gwt.xml`, an error similar to

```
[ERROR] Errors in 'jar:file:<...>'
[ERROR] Line <line num>: No source code is available for type com.badlogic.gdx.graphics.g3d.environment.PointShadowLight; did you forget to inherit a required module?
[ERROR] Aborting compile due to errors in some input files
```

may be seen.

## Performance considerations
Due to some of the targets of the framework being mobile and the web, along with it being a game development focused framework, its important to keep performance as tight as possible. On mobile platforms especially, memory management is very important, so we don't create any garbage in the core of libGDX. (Its advised you don't in your applications either)

A couple of guidelines regarding performance:
- Avoid any temporary object allocation
- Do not make defensive copies
- Avoid locking, libGDX is not thread safe, unless explicitly specified.
- Use the Collection classes libGDX provides in the [com.badlogic.gdx.utils](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/utils) package, do not use java collections
- Do not perform argument checks for methods that may be called thousands of times per frame
- Use pooling if necessary, if possible avoid exposing the internal pooling to the user

## Size of code changes
To reduce the chances of introducing errant behavior and to increase the chance that your pull request gets merged, we ask you to keep the requests small and focused.

- Submit a pull request dedicated to solving _one_ issue or feature. Pull requests confusing multiple things are much harder to review and will be denied.
- Keep the code changes as small as possible.

<br/>

# How to contribute code
libGDX uses git, with our codebase situated on GitHub. In order to submit changes back to the official libGDX project, you will need to fork the project, clone your fork, [work on its source](/dev/from-source/), push changes back to your fork, and then submit a pull request based on your changes.

Pull requests will then be checked by automation tools as well as the core contributors before merging. Please do not leave it up to the core contributors to test your code, make sure it compiles, and test on every platform you can. State in your pull request what you have tested on.

To sum it up, this is the general workflow:
- [Fork](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo) the libGDX repository on GitHub.
- Clone the forked repository either via the command line or your IDE.
- Add the libGDX repository as a remote (to sync latest changes).
- Make your changes to your locally cloned (of your fork), repository, ideally on a new branch. See [here](/dev/from-source/) for a guide on how to get the libGDX code running locally.
- Commit your changes, and push the changes back to your forked repository on GitHub.
- Go to GitHub, view your forked repository, select your branch and create a pull request.
- Write a detailed description of what your pull request does, how it has been tested, what platforms it has been tested on, and why it belongs in libGDX.

For a very extensive explanation of how the pull request system on GitHub is supposed to work, check out [this guide](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project#Forked-Public-Project).

Pull requests may be denied for not being ready, or not fitting the scope of the project. Please do not take any offense to having a pull request rejected. We appreciate every contribution, but some code submissions are just not a good fit for the project.
