---
title: Console support?
---
Console support for libGDX is a hotly debated topic. This page tries to give a broad overview of how you might go about getting your game to work on your favourite consoles, including Xbox, PlayStation and Nintendo Switch.

## The General Idea
The main obstacle of getting libGDX games to run on consoles is that there is no JVM for those platforms. So to overcome this, you either need to transpile your code base to a language which can run on your target platform or compile your application in such a way. Inspiration for these approaches can be drawn from libGDX's Web backend (which uses [GWT](https://www.gwtproject.org/) to transpile Java source code to Javascript) and iOS backend (which uses the [RoboVM](https://github.com/MobiVM/robovm) ahead-of-time compiler). 

In addition, you need a custom libGDX backend with bindings for the device in question.

## Successful Examples
There are a couple of games, which have successfully done this in the past:
- [Orangepixel's games](https://www.orangepixel.net/category/games/), which are transpiled to C#<sup><a href="https://cdn.discordapp.com/attachments/348229413785305089/1154868391887245332/image.png">[1]</a></sup> 
- [Pathway](https://store.steampowered.com/app/546430/Pathway/), which uses a custom fork of RoboVM and a SDL backend<sup><a href="https://www.reddit.com/r/NintendoSwitch/comments/npx21u/comment/h07ls1u/">[2]</a></sup>
- [Slay the Spire](https://store.steampowered.com/app/646570/Slay_the_Spire/), which was ported by [Sickhead Games](https://www.sickhead.com/) first to C# and then to C++<sup><a href="https://pbs.twimg.com/media/ETkH_QvXkAAD2N7?format=png">[3]</a></sup>

## Other Resources
The following resources may also help you if you want to look into supporting libGDX on consoles:
- **[Graal Native Image](https://www.graalvm.org/22.0/reference-manual/native-image/)** might prove useful
-  The Javascript code produced by **GWT/[TeaVM](/roadmap/#teavm)** could be used in a UWP app; see [here](https://web.archive.org/web/20200428040905/https://www.badlogicgames.com/forum/viewtopic.php?f=17&t=14766) and [here](https://github.com/libgdx/libgdx/issues/5330) for some thoughts on this approach
- **[IKVM](https://github.com/ikvm-revived/ikvm)** (which was used by libGDX [in the past](https://code.google.com/archive/p/libgdx/wikis/IOSWIP.wiki)) could prove as another viable option
- Anuken's Ark has a **SDL backend** [here](https://github.com/Anuken/Arc/tree/master/backends/backend-sdl); SDL has a [working port for Nintendo Switch](https://wiki.libsdl.org/Installation#nintendo_switch)
- TheLogicMaster has a working PoC of a Nintendo Switch homebrew backend over at **[SwitchGDX](https://github.com/TheLogicMaster/SwitchGDX)**, which uses a [custom fork](https://github.com/TheLogicMaster/clearwing-vm) of CodenameOne's [ParparVM](https://github.com/codenameone/CodenameOne/tree/master/vm) to transpile Java code to C++
- **TeaVM** can also be used to generate C code, see the example [here](https://github.com/konsoletyper/teavm/blob/5a0c4183896f42ccfc8010c7a7dc2cceb5956c21/samples/benchmark/src/main/java/org/teavm/samples/benchmark/teavm/Gtk3BenchmarkStarter.java)
- A similar goal is being pursued by the **[mini2Dx](https://github.com/mini2Dx/mini2Dx)** project.
