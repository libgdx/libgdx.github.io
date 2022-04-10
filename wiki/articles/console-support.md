---
title: Console support?
---
Console support for libGDX is a hotly debated topic. This page tries to give a broad overview of how you might go about getting your game to work on your favourite consoles, including Xbox, PlayStation and Nintendo Switch.

## Porting the Code Base Manually
A straight-forward, but quite time-consuming approach of getting your libGDX game to run on consoles is to (manually) port your code to a different language & engine. Usually this is done by dedicated teams. Successful examples of this include [Slay the Spire](https://pbs.twimg.com/media/ETkH_QvXkAAD2N7?format=png) as well as Orangepixel's [games](https://www.orangepixel.net/category/games/) (check out his devlogs for more information). A similar goal is being pursued by the [mini2Dx](https://github.com/mini2Dx/mini2Dx) project.

## Compiling/Transpiling
A more user-friendly (but technologically complex) way of porting your game is to compile/transpile it to code that can run on your targeted platform. This involves writing a custom backend for the platform in question. Inspiration can be drawn from libGDX's Web (see [GWT](https://www.gwtproject.org/)) and iOS (see [RoboVM](https://github.com/MobiVM/robovm)) backends, which already do this.

This approach was successfully employed by Robotality to port Pathway to the Nintendo Switch platform. For this, they used a custom fork of RoboVM and their own SDL backend. See [here](https://www.reddit.com/r/NintendoSwitch/comments/npx21u/comment/h07ls1u/) for a short write up.

Other options may include:
- CodenameOne's [ParparVM](https://github.com/codenameone/CodenameOne/tree/master/vm); [TheLogicMaster](https://github.com/TheLogicMaster) is working on a PoC for this
- IKVM (which was used by libGDX [in the past](https://code.google.com/archive/p/libgdx/wikis/IOSWIP.wiki)) & a SDL backend; see [here](https://github.com/ikvm-revived/ikvm) for IKVM's main fork and [here](https://github.com/Anuken/Arc/tree/master/backends/backend-sdl) for Ark's SDL backend
- GWT/[TeaVM](/roadmap/#teavm) -> UWP; see [here](https://web.archive.org/web/20200428040905/https://www.badlogicgames.com/forum/viewtopic.php?f=17&t=14766) and [here](https://github.com/libgdx/libgdx/issues/5330)
