---
title: Google Summer of Code 2014
# Not listed in ToC
---

This page was a [RFC](https://en.wikipedia.org/wiki/Request_for_Comments) for the GSoC 2014.
{: .notice--info}

## Introduction ##
We assume you already know what Google Summer of Code is, if not, please check out the [Google Summer of Code](http://www.google-melange.com/gsoc/homepage/google/gsoc2013) site for general information.

For **students**, we recommend to read up on what libGDX is, then proceed to the [Information For Students](/wiki/misc/google-summer-of-code-2014#Information_for_Students) section.

*Mentors* must read the [Information for Mentors](/wiki/misc/google-summer-of-code-2014#Information_for_Mentors)  section, add themselves to existing ideas in the list below, and optionally create and add new ideas.

## What is libGDX? ##

[libGDX](http://libgdx.badlogicgames.com) is a cross-platform game development framework. You write your game in Java, and have it working instantly on Windows, Linux, Mac, [Steam](http://store.steampowered.com/app/207710), [Android](https://play.google.com/store/apps/details?id=com.moistrue.zombiesmasher), [iOS](https://itunes.apple.com/ph/app/clash-of-the-olympians/id590049663?mt=8), [Facebook](https://www.facebook.com/stargazergame) and HTML/WebGL. The entire Java code base is shared across all these platforms. You can find more information on libGDX's feature set [here](http://libgdx.badlogicgames.com/features.html).

libGDX was born 3 years ago, out of a desire to target multiple platforms with a single code base. It has since grown into a big OSS project with over [100 professional and amateur contributors](http://www.ohloh.net/p/libgdx), and is used by thousands of developers to create the games of their dreams. From [entries](http://www.ludumdare.com/compo/author/bompo/) for the 48 hour [Ludum Dare](http://www.ludumdare.com/) challenge, to [top grossing mobile games](https://play.google.com/store/apps/details?id=com.bithack.apparatus&feature=search_result#?t=W251bGwsMSwxLDEsImNvbS5iaXRoYWNrLmFwcGFyYXR1cyJd) to augmented reality experiments like [Google's Ingress](https://play.google.com/store/apps/details?id=com.nianticproject.ingress&feature=search_result#?t=W251bGwsMSwxLDEsImNvbS5uaWFudGljcHJvamVjdC5pbmdyZXNzIl0).

libGDX has achieved wide adoption, especially on Android where it is powering [3.2% of all installed applications](http://www.appbrain.com/stats/libraries/details/libgdx/libgdx), with numerous top-grossing games. On that platform it can already compete with Unity3D.

Our [Community](https://libgdx.com/community/) as well as the entire libGDX development team are looking forward to welcome you among us. Contribute to powering thousands of applications and bringing joy to millions of users!

## Information for Students ##
As a student you may ask yourself why you should take part in libGDX's Google Summer of Code effort. Here we try to give you some food for thought that may help you decide whether you want to apply for our project.

libGDX offers students to explore a wide range of technologies:

  * Different operating systems, platforms  and hardware (desktop, Android, iOS, HTML5/WebGL)
  * Different languages (C, C++, Java, C#, Javascript)
  * Different fields of software development (data structures, 2D & 3D graphics, audio, peripheral  communication, etc.)

Such broad environments are usually rare to find in many university settings.

You will work in a globally distributed team, a setup that is becoming more common. You'll learn how to deal with the difficulties that arise in communication in such environments. Different time zones, different language skills (English is our lingua franca, but not everyone is a native speaker), miscommunication arising from limited expressiveness of text and so shapes how the team functions.

libGDX is an industrial strength framework used in production. It is employed in thousands of games that are played by millions of users every day. Modifying libgdx's code means taking responsibility, and considering the impact it has on all the applications that are build on top of it. Big changes need to be discussed with the team, learning how to put forward a solid argument is crucial.

Finally, and maybe most importantly, libGDX means games. Many of the libGDX team members got into programming due to a desire to write games. If you want to improve your skillset while working within the game development field, then libGDX is for you.

### Steps ###
The ideas below have been compiled by the libGDX contributors and community. If you want to pick any of those for your proposal, or come up with your own idea, it's best to get to know libGDX and the backing technologies before starting with your proposal. That let's you better estimate what is needed to finish a specific project. If you plan on applying for libGDX for your GSoC project you should follow these steps:

  1. Fork the project on [Github](https://www.github.com/libgdx/libgdx).
  2. Get familiar on how to work with [libgdx's source](/wiki/start/import-and-running).
  3. Register on the forums and introduce yourself. Drop by on IRC (#libgdx, irc.freenode.org), get to know the community. [This forum thread](https://web.archive.org/web/20200928221625/https://www.badlogicgames.com/forum/viewtopic.php?f=11&t=7889) is where most of the GSoC students introduced themselves so far, make sure to subscribe to it to receive notifications for new messages. The subscribe button is at the bottom of the page.
  4. Pick one of the project ideas below or come up with your own. Prepare your application using our [student application template] (FIXME (todo)). You'll have to submit this application via the [Google Summer of Code 2013 site](http://www.google-melange.com/), from April 22 - May 3, 2013. You'll also need to sign the [Student Participation Agreement](http://www.google-melange.com/gsoc/document/show/gsoc_program/google/gsoc2013/student_agreement). For more information on the process, read the [GSoC FAQ](http://www.google-melange.com/gsoc/document/show/gsoc_program/google/gsoc2013/help_page). Reading it is mandatory!
  5. Get in contact with the mentors listed below, on IRC (irc.freenode.org, #libgdx) or the forums.
  6. Send a pull request for some issue or improvement you made to libGDX on Github, note that in your application. When selecting students, we'll favor those that already demonstrated that they can interact with our community and read the docs on [how to contribute](https://libgdx.com/dev/contributing/)

## Information for Mentors ##
Since mentors have quite a bit of responsibility, I (badlogic) would want to limit potential mentors to the group of contributors. Exceptions to this rule may be made of course. Nex and I take on the project administrator role, which is different to that of a mentor.

Mentoring means commitment, once you agree to be a mentor, there's no way back after we submit the application to GSoC.

### Steps ###
 1. Drop me (badlogic) an e-mail
 2. Improve or add new ideas to the list below
 3. Read the [GSoC FAQ](http://www.google-melange.com/gsoc/document/show/gsoc_program/google/gsoc2013/help_page), which explains all the obligations of a mentor.
 4. Read the [GSoC Mentor Handbook](http://en.flossmanuals.net/GSoCMentoring/) which provides guidance on how to approach mentoring
 5. We organize our mentor activity on [this thread](https://web.archive.org/web/20150920202444/http://www.badlogicgames.com/forum/viewtopic.php?f=23&t=8113). Subscribe to it, the subscription button is at the bottom of the page.
 6. Look out for students on the forum and on IRC, welcome them to the community and show them around

## Idea List Guidelines ##
Please use the following format for ideas:

  * **Title** use `### Project: Title ###`
  * **Goals:** keep it short, can be vague
  * **Required Skills:** language, platforms, etc.
  * **Links:** further information, forum threads, etc.
  * **Potential Mentors:** contributors only

If you are not a contributor, post your idea in [this thread](https://web.archive.org/web/20200928221625/https://www.badlogicgames.com/forum/viewtopic.php?f=11&t=7889) (FIXME (todo))

Please add `----` after each idea as a separator.

## Ideas ##

### Project: In-app Purchase Extension ###
**Goals**: create a libGDX extension that allows to incorporate in-app purchases across as many platforms as possible. iOS and Android are a must, GWT/desktop would be a nice to have.

**Required Skills**: Java, C#, basic iOS knowledge (bonus if you know Xamarin.iOS), basic Android knowledge (FIXME (xamarin -> robovm))

**Links**: https://github.com/libgdx/libgdx/pull/146 API draft by a core contributor

**Mentors**: [noblemaster](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Noblemaster), [tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Social Network Extension ###
**Goals**: create a libGDX extension that allows to incorporate social network interactions, e.g. get friend lists. Ideally this should work across all platforms (desktop, GWT, Android, IOS).

**Required Skills**: Java, C#, basic iOS knowledge (bonus if you know Xamarin.iOS), basic Android knowledge (FIXME (xamarin -> robovm))

**Mentors**: [nex](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nexsoftware), [tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: RoboVM/iOS backend ###

(FIXME done?)
**Goals**: create a libGDX backend based on [RoboVM](http://www.robovm.org) for iOS.

**Required Skills**: Java, C/C++, OpenGL ES, iOS, maybe LLVM

**Links**: https://web.archive.org/web/20200426122040/https://www.badlogicgames.com/forum/viewtopic.php?f=23&t=7883 instructions on how to possibly approach this.

**Mentors**: [noblemaster](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Noblemaster), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----
### Project: Avian VM/iOS backend ###
**Goals**: create a libGDX backend based on [Avian VM](http://oss.readytalk.com/avian/) for iOS.

**Required Skills**: Java, C/C++, ObjectiveC, OpenGL ES, iOS

**Links**: https://web.archive.org/web/20200426122040/https://www.badlogicgames.com/forum/viewtopic.php?f=23&t=7883 instructions on how to possibly approach this for RoboVM, the same approach is applicable to Avian VM.

**Mentors**: [noblemaster](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Noblemaster), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Generic 2D Level Editor ###

**Goals**: create a 2D level editor, using libgdx's scene2d for portability, that allows creating arbitrary level maps that can be loaded via the maps API. As a bonus point, make it extensible through plugins.

**Required Skills**: Java, basic graphics programming, bonus if you know scene2d, maybe OSGi

**Links**: https://docs.google.com/document/d/1iNo5yB39-iXV10I2bxPHpuk84EoEpU7_L9HSuPKN5tE quick draft of features/requirements we'd like to include.

**Mentors**: [nex](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nexsoftware), [nate](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nate), [bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Oculus Rift backend ###
*Goals*: create a backend so libGDX supports [Oculus Rift](http://www.oculusvr.com/), a virtual reality headset with insanely low latency. We'll probably have to provide the headset to the student. We'll either buy it or ask the good folks at Oculus if they'd contribute one. We'd want to either extend an existing backend or write a new one specifically for the Oculus rift. This extension allows to expand libgdx's domain to non-game related areas, like art installations, scientific visualizations and so on.

**Required Skills**: Java, C/C++, 3D programming, including GLSL shaders, linear algebra

**Links**: [Oculus Rift first reactions, just because it's funny :)](http://www.youtube.com/watch?v=KJo12Hz_BVI)

**Mentors**: [xoppa](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Xoppa), [bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: XBox Kinect extension ###

**Goals**: Create an extension that allows people to use the Kinect in their libGDX desktop projects. Kinect may have to be provided by us or sponsored in some way. The extension should also provide one or more demos that demonstrate how the extension works and what potential it has. This extension allows to expand libgdx's domain to non-game related areas, like art installations, scientific visualizations and so on.

**Required Skills**: Java, C/C++, 3D programing, including GLSL shaders, linear algebra

**Links**: [OpenKinect, library we could wrap and expose](http://openkinect.org/wiki/Main_Page)

*Mentors*: [xoppa](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Xoppa), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Leap Motion extension ###

**Goals**: [Leap Motion](https://www.leapmotion.com/) is a new kind of controller that tracks your hand and finger movement and allows you to interact with digital media in a more natural way (think Minority Report). Creating an extension that gives libGDX users access to this device would be the goal for this project. On top of the extension, a set of demos should be created that demonstrate how to use the extension as well as its overall potential. This extension allows to expand libgdx's domain to non-game related areas, like art installations, scientific visualizations and so on.

Devices would either have to be sponsored or bought by students/mentors. The devices are meant to ship in May, that may be too late.

This idea was orginally submitted by Fisherman on the forums.

**Required Skills**: Java, game programming, potentially a scripting language like Lua, JavaScript, Squirrel etc.

**Links**:
[Block54 Leap Motion demo](http://www.youtube.com/watch?v=1x-eAvASIFc)
[Information for Leap Motion developers](https://www.leapmotion.com/developers)

*Mentors*: [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic),
[Xoppa](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Xoppa)

----

### Project: Experimental Features for new 3D API ###

**Goals**: libgdx's 3D API is currently being worked on by a few of the core contributors. We'd like to explore some experimental features, including but not limited to: deferred rendering, different [shadow mapping](http://en.wikipedia.org/wiki/Shadow_mapping) techniques, especially those suited for mobiles, [CPU-side skinning](http://en.wikipedia.org/wiki/Skeletal_animation) (may require modifications to the API), mobile GPU specific optimizations for the default über-shader, using tools by [GPU manufacturers](https://developer.qualcomm.com/mobile-development/development-devices/trepn-profiler) to profile and improve the shader, [dynamic lighting ala God of War 3](https://developer.qualcomm.com/mobile-development/development-devices/trepn-profiler). We are open for other more experimental features. Most of the above will not take a full 3 months, students are advised to pick at least two.

**Required Skills**: Java, 3D programming, including GLSL shaders, linear algebra

**Links**: [Discussion by core developers on the new 3D API](https://web.archive.org/web/20200928230726/https://www.badlogicgames.com/forum/viewtopic.php?f=23&t=7020), for topic specific links see goals text above.

*Mentors*: [xoppa](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Xoppa), [bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Improve GDX Remote ###

**Goals**: Gdx remote allows you to run your application on the desktop, to which you can connect a device that sends input events to the application. This allows testing things like accelerometer controls in the desktop environment without having to deploy the application to the device. The current implementation is very primitive. Ideally, we'd like to also stream video from the desktop to the device, with minimal latency.

**Required Skills**: Java, network programming

**Links**: [blog post with video of current implementation](https://web.archive.org/web/20200928224908/https://www.badlogicgames.com/wordpress/?p=1590)

**Mentors**: [nate](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nate), [nex](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nexsoftware), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Websocket Support ###

**Goals**: libGDX currently only has rudimentary networking support (HTTP, TCP). We'd like to add Websocket support, allowing network programming with the HTML5 backend. This would allow us to do things like [Chrome World Wide Maze](http://chrome.com/maze/) or [Browser Quest](http://browserquest.mozilla.org/). Adding Websocket support would require a change in our current networking APIs, namely Socket#getInputStream needs to be changed.

**Required Skills**: Java, C#, network programming, GWT

*Links*: [Entry-point to libGDX networking API](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Net.java)

*Mentors*: [tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas), [nex](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nexsoftware), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Simplified 3D Physics API and HTML5 implementation ###
**Goals**: libGDX wraps [bullet physics](http://bulletphysics.org/wordpress/), an OSS 3D physics library. Currently, the bullet extension is only supported on the desktop and Android (iOS pending). We'd like to create a simplified 3D physics API, maybe modelled after [Bullet's C-API](https://code.google.com/p/bullet/source/browse/trunk/src/Bullet-C-Api.h). This would allow us to also create an implementation for the HTML5 backend based on [ammo.js](https://github.com/kripken/ammo.js/) or other Javascript 3D physics libraries.

Note that we already have Box2D fully working on all platforms, including HTML5. This was achieved by using JBox2D for the HTML5 backend. Doing this for bullet seems less feasible.

**Required Skills**: Java, GWT

**Links**: See links in goals above.

**Mentors**: [xoppa](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Xoppa), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Scripting Support ###

**Goals**: libGDX is currently tighly coupled to JVM languages. Scripting can help game developers to quickly prototype ideas and also have technical artists interact with the game mechanics more easily. A scripting extension that is cross-platform could be created. It does not need to provide specific bindings to libgdx, but should be easy to integrate and customize on all supported platforms. Javascript seems to be the best candidate (through e.g. [Nashorn on the desktop](http://openjdk.java.net/projects/nashorn/), plain Javascript in GWT, [V8](https://code.google.com/p/v8/) on Android and [JavascriptCore](http://trac.webkit.org/wiki/JavaScriptCore) on iOS, [Lua](http://www.lua.org/) may be an option as well. The end result would be a libGDX extension that lets users integrate scripts in their games more easily.

This project could be done in collaboration with the High-Level Game Engine project below.

**Required Skills**: Java, C/C++, familiarity with at least one potential scripting language

**Links**: see links in goals description

**Mentors**: [bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: High-level Game Engine ###

**Goals**: libGDX is a framework which can be overwhelming for people who do not have previous experience with game programming. A high-level game engine on top of libGDX could lower the barrier of entry. We propose to build a high-level 2D game engine on top of libGDX. Good API design, documentation and examples are part of the challenge. Inspiration can be found in projects such as [Corona](http://www.coronalabs.com/products/corona-sdk/), [Flixel](http://flixel.org/), [HaxePunk](http://haxepunk.com/) or [Cocos2D](http://www.cocos2d-iphone.org/). We do not rule out a 3D engine either, but think 2D would have more chances of success given the time frame of Google Summer of Code. Ideally, the engine would be based on the [component/entity system pattern](http://gamadu.com/artemis/).

This project could be done in collaboration with the Scripting Support project above.

**Required Skills**: Java, game programming, potentially a scripting language like Lua, JavaScript, Squirrel etc.

**Links**: see links in description above.

**Mentors**: [bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas), [nate](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nate), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Command Line Project Management ###

(FIXME done with Gradle?)

**Goals**: libGDX projects are usually done with Eclipse in mind. While we support [Maven](/wiki/articles/maven-integration) and other IDEs and development environments, integration isn't as straight forward. Maven is problematic due to GWT and Android being somewhat second class citizens in that area. Also, IDE integration of Maven Android and GWT projects is lacking. In addition to IDE woes, packaging and deploying projects can be cumbersome. We'd like to develop a command line application that allows the creation of new libGDX projects, create project files for various IDEs, create POM and Gradle build files, can update dependencies automatically, can remove and add extensions, and package and deploy the application to connected devices. [Loom Engine](http://theengine.co/loom) and [Haxe NME](http://www.nme.io/developer/documentation/getting-started/) provide similar tools.

**Required Skills**: Java, Maven, Gradle, Eclipse, Intellij, Netbeans
**Links**: [Google Doc with requirements](https://docs.google.com/document/d/1yy3Q5B0K06yz_Oool1ZCtavtSvASJa56lic_5Yg1C9c/edit?usp=sharing)

**Mentors**:
[tamas](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Tamas),[bach](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Bach), [nate](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nate), [badlogic](https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic)

----

### Project: Increase Robustness through Static Code Analysis Tools ###

**Goals**: libGDX is used in production, and as such requires high robustness. One way of increasing robustness is to use static analysis tools that uncover bad practices and bugs. Applying such analysis to a code base as big as libGDX's is a challenge. Not only is the size an issue, but a gaming framework may have to rely on patterns for performance that are wrongly identified as issues by static analysis tools. For this idea, we'd like to see how static analysis tools can be exploited to increase libGDX's quality and how we could integrate them into our everyday workflow. It is expected that whatever tool is used for analysis needs to be adapted with new rules that fit for the requirements of a gaming framework.

**Required Skills**: Java, Maven, Gradle, Eclipse, Intellij, Netbeans

**Links**: [List of static analysis tools on Wikipedia](http://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis#Java)

**Mentors**:
[https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Nate nate], [https://code.google.com/p/libgdx/wiki/GoogleSummerOfCode2013Mentors?ts=1363700945&updated=GoogleSummerOfCode2013Mentors#Badlogic badlogic]


(FIXME, maybe add the mentor list here... idk)
