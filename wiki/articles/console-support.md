---
title: Console support?
---
Console support for libGDX is a hotly debated topic. This page tries to give a broad overview of how you might go about getting your game to work on your favourite consoles, including Xbox, PlayStation and Nintendo Switch.

## The General Idea
To get your libGDX game running on consoles, you need to port your code base to a different language. While (in theory) this can be done manually, a considerably less time-consuming (but technologically complex) way of porting your game is to compile/transpile it to code that can run on your targeted platform. Inspiration can be drawn from libGDX's Web (see [GWT](https://www.gwtproject.org/)) and iOS (see [RoboVM](https://github.com/MobiVM/robovm)) backends, which already do this.

In addition, you need a custom libGDX backend with bindings for the device in question.

## Successful Examples
There are a couple of games, which have successfully done this in the past:
- [Slay the Spire](https://store.steampowered.com/app/646570/Slay_the_Spire/), which was ported by [Sickhead Games](https://www.sickhead.com/) first to C# and then to C++<sup><a href="https://pbs.twimg.com/media/ETkH_QvXkAAD2N7?format=png">[1]</a></sup>
- [Pathway](https://store.steampowered.com/app/546430/Pathway/), which uses a custom fork of RoboVM and a SDL backend<sup><a href="https://www.reddit.com/r/NintendoSwitch/comments/npx21u/comment/h07ls1u/">[2]</a></sup>
- [Orangepixel's games](https://www.orangepixel.net/category/games/) (check out his devlogs for more information)

## Different Approaches & Other Resources
- TheLogicMaster has a working PoC of a Nintendo Switch homebrew backend over at [SwitchGDX](https://github.com/TheLogicMaster/SwitchGDX), which uses a [custom fork](https://github.com/TheLogicMaster/clearwing-vm) of CodenameOne's [ParparVM](https://github.com/codenameone/CodenameOne/tree/master/vm)
- IKVM (which was used by libGDX [in the past](https://code.google.com/archive/p/libgdx/wikis/IOSWIP.wiki)) could prove as another viable option; see [here](https://github.com/ikvm-revived/ikvm) for IKVM's current main fork
- Anuken's Ark has a SDL backend [here](https://github.com/Anuken/Arc/tree/master/backends/backend-sdl); SDL has a [working port for Nintendo Switch](https://wiki.libsdl.org/Installation#nintendo_switch)
- GWT/[TeaVM](/roadmap/#teavm) could be used to transpile code to Javascript, which could then be used in a UWP app; see [here](https://web.archive.org/web/20200428040905/https://www.badlogicgames.com/forum/viewtopic.php?f=17&t=14766) and [here](https://github.com/libgdx/libgdx/issues/5330) for some thoughts on this approach
- A similar goal is being pursued by the [mini2Dx](https://github.com/mini2Dx/mini2Dx) project.
