---
title: "Getting ready for #libGDXJAM"
# Not listed in ToC
---
The [#libGDXJAM](https://twitter.com/hashtag/libGDXJam?src=hash) was organized by the libGDX community and took place in December 2015. You can find all the entries [here](https://itch.io/jam/libgdxjam).
{: .notice--info}

This article will take you through the rules and help you get ready to jam!

## The 10 Rules of Jamming

The jam will be held from December 18th to January 18th. Here are the rules:

1. You must use libGDX to create a game that fits the theme.
2. You may work alone or in a team. Only one submission per person/team is allowed.
3. You may use pre-existing code, e.g. libraries like Ashley, or your own code libraries.
4. You may use pre-existing art, e.g. assets from OpenGameArt, or your own art.
5. You may use external tools like Tiled or Overlap2D.
6. You must not re-skin an already existing game or prototype!
7. You must submit your game before the end of the 18th of January via the jam’s site on itch.io (to be made public).
8. You must publish the source of your game, e.g. to GitHub.
9. You must submit your game to the itch.io libGDX Jam page before the end of day January 18th, UTC-12!
10. If you want to win one of the sponsored prizes, you must tweet about your game and document its development, using the hashtag [#libGDXJam](https://twitter.com/search?f=tweets&vertical=default&q=%23libGDXJam&src=tyah) and the handles [@robovm](https://twitter.com/robovm) and [@robotality](https://twitter.com/robotality).

First of all, you can participate in the jam without following these rules! In that case, you will not qualify for the prizes though.

Documenting your progress is a great way of sharing your experience, and an invaluable tool for others to learn. Making a bit of noise on Twitter is also a great way to give back to our sponsors. Chaining those 2 things together via rule 9 is my evil overlord plan to make everyone happy.

Here are a few examples of tweets:

> Progress screenshot of my #libGDXJam entry <url> @robovm @robotality

> New dev log entry for my #libGDXJam game <url> @robovm @robotality

For the dev logs, we want quality first and foremost! Progress screenshots, descriptions of problems you ran into and their solutions, streaming and so on is what we want to see! Just mindless spamming will not get you anywhere.

## Prizes & Judging

We are happy to have [RoboVM](https://robovm.com/) and [Robotality](http://robotality.com/blog/) as sponsors for the following prizes:

* Grand Prize: Mac Mini, sponsored by RoboVM.
* Silver: iPad, sponsored by RoboVM.
* Bronze: iPod Touch, sponsored by RoboVM.
* For 20 random submissions: Steam keys for Halfway, sponsored by Robotality.
* For another 5 random submissions: libGDX Jam t-shirt.

To qualify for any of the prizes, you'll need to follow rule 10 as outlined above. Judging works as follows:

* The community can vote on itch.io from the 19th of January to the 2nd of February.
* The Grand Prize will be awarded to the entry with the highest community votes on itch.io. This way the highest quality entry will win!
* The Silver and Bronze prizes will be awarded to the entries with the best mixture of dev logs and tweets and community votes. * Our sponsors and the libGDX core team will pick these entries. This should motivate people to make some noise on the web and document their progress for the greater good of the community!
* The random awards guarantee that everyone has a chance to win a prize!
* The winners will be announced on the 3rd of February!

## Timetable

* Theme Voting round 1: Nov. 22nd – Dec. 11th
* Final Theme Voting: Dec. 11th – Dec. 18th
* Jam: Dec. 18th – Jan. 18th
* Judging: Jan 19th – Feb. 2nd

## Survival guide

All hail ye who are brave enough to take up on the #libGDXJam challenge, have you done all the preparations prior the competition?

> What preparation?

Make sure you have decided on:

* Libraries: obviously Libgdx, but... Are you using any extensions or third party libraries?
* Programming language and IDE: Java, Kotlin, Clojure or Scala? Eclipse, Intellij, Netbeans, Sublime, Vim, Emacs?
* Graphic editors
* Level editors
* Sound generators and editors

**Golden advice**: use what you already know. If you experiment too much, you will most likely not finish a game on time!

### Tools & Resources

#### Audio

[BFXR](https://www.bfxr.net/): web based sound effect generator.

![images/bfxr.png](/assets/wiki/images/bfxr.png)

[Audiotool](https://www.audiotool.com/): web based music synthesizer.

![images/audiotool.png](/assets/wiki/images/audiotool.png)

[Audacity](https://www.audacityteam.org/): open source audio editor.

![images/audacity.png](/assets/wiki/images/audacity.png)

Free sound effects and music:

* [FreeSound](https://www.freesound.org/)
* [SoundCloud](https://soundcloud.com/)
* [Open Music Archive](http://openmusicarchive.org/)
* [CC Mixter](http://dig.ccmixter.org/)

#### Graphics

[Gimp](https://www.gimp.org/): open source image editor.

![images/gimp.png](/assets/wiki/images/gimp.png)

[Paint.NET](https://www.getpaint.net/index.html): open source image editor.

![images/paint.net.jpg](/assets/wiki/images/paint.net.jpg)

[Inkscape](https://inkscape.org/en//): open source vector editor.

![images/inkscape.png](/assets/wiki/images/inkscape.png)

[Spine](http://esotericsoftware.com/): skeletal 2D animation tool.

![images/spine.png](/assets/wiki/images/spine.png)

[Blender](https://www.blender.org/): open source 3D editor.

![images/blender.jpg](/assets/wiki/images/blender.jpg)

Free game art:

* [Open Game Art](https://opengameart.org/)
* [Kenney](https://kenney.nl/)
* [Pixabay](https://pixabay.com/)
* [Game Art 2D](https://www.gameart2d.com/)

#### Map editors

[Tiled Map Editor](http://www.mapeditor.org/): open source tile based editor.

![images/tiled.png](/assets/wiki/images/tiled.png)

[Overlap2D](https://github.com/UnderwaterApps/overlap2d): open source game editor. Make sure to check the [Overlap2D survival guide for #libGDXJAM](/wiki/misc/overlap2d-survival-guide-for-libgdxjam).

![images/overlap2d.png](/assets/wiki/images/overlap2d.png)

[BDX](https://github.com/GoranM/bdx/wiki): Open source 3D game engine integrated with Blender.		

![](https://lh5.googleusercontent.com/-66Li4J9maL4/VP8ICZcGAxI/AAAAAAAABIo/Mth2R1Qo81w/w1038-h586-no/BlenderWithBDX2.png)

### Team structure

Gather your quest party and put your specialist hats on!

#### Programmers

* Do the programmy bits
* Split tasks among them: graphics, controls, physics, UI
* The less code overlap, the easier!
* Need to tell the artists what formats they need
* Need to define how level designers create content

#### Graphics and audio artists

* Do the artsy bits
* Need to spit up tasks among them: UI, background, characters, effects...
* Agree on a consistent style
* May need to create placeholder art early on

#### Game and Level designer

* Does the content bits
* Needs to define the game mechanics
* Needs to define the game progression
* Needs to create levels
* Needs to playtest and give feedback to programmers and artists

#### Coordinator

* Makes sure everyone knows what to do
* Keeps track of things to be done
* Keeps track of dependencies between members
* Keeps track of time
* Keeps track of human needs (food, sleep)

**Note**: depending on your actual team, some roles could be blurred or shared.
* No artists? Use pre-existing art.
* No designers? Everybody becomes a games designer.
* No coordinator? Pick one person.
* Alone? You do everything!

### The 5 phases of Jamming

Now let's get onto it!

#### Brainstorming

Goals:
* Consider the set theme.
* Get a high-level understanding of your game: genre, mechanics, setting, story, art style...
* Take time limits into account. FPS, MMO and RTS games might not be your best choices.
* Think outside the box.

To-do:
  1. Gather ideas from everyone.
  2. Pick the most promising ones via vote.
  3. Define genre and mechanics using pen and paper.
  4. Define setting and story.
  5. Define art style, artist could draw quick mockups.

#### Setup

Goals:
* Get a detailed understanding of your game:
  * What will programmers have to do?
  * What will artists have to do?
  * What will game designers have to do?
* Define interfaces between all team members
  * How do programmers work with each other?
  * How do artists get their art into the game?
  * How do game designers create game content?
* Define tasks and their order for every team member!
  * The coordinator is responsible for keeping track of tasks

To-do
  1. Programmers agree on platform and tools
  2. Artists agree on style
  3. Programmers and artists agree on how to get art into the game
  4. Programmers and game designers agree on how to create content
  5. Each subteam defines their initial task
  6. Coodinator keeps track of things

A super lightweight [Kanban](https://en.wikipedia.org/wiki/Kanban)-like board can help, such as [Trello](https://trello.com/).

#### Implementation

Goals:
* Get the damned game done!
* Ensure to have a playable prototype early
  * Prioritize tasks accordingly
  * Game mechanics first to see if they are fun!
* Realize you'll likely not get everything done!
  * Which is why you should have something playable at all times
  * Cut corners, kill features, focus on the core of your game

To-do
  1. Every sub-team works on their task
  2. Coordinator keeps track of progress
  3. Sub-teams talk whenever they need to re-define or prioritize new tasks
  4. Goto 1

**Have something playable early on**

##### Tips for programmers:
  * Use source control (git, SVN...), do not use shared drives, zip files nor e-mail
  * Don't code for re-use
  * Don't optimize
  * Try to create a modular-design so people don't depend on each other too much
  * Make sure the game designer can create content as early as possible
  * Make sure artists export to easy to use formats
  * Make sure artists and game designers understand limitations

##### Tips for artists:
  * Make it easy to export your art into the proper format
  * Make sure everyone uses the same coordinate system/resolution
  * Use descriptive names for files
  * Have one shared folder (Dropbox, Google Drive) containing assets ready to integrate into the game
    * Don't put multiple versions of the same thing there
    * Have whatever local folder structure for work in progress assets

##### Tips for game designers
  * Talk to the developers about what's possible and what not
  * Focus on simple mechanics but try to put in a twist
  * Favor simple level-design over brainy or complex levels, they take too long to design!
  * If you have down-time, try to help or be the coordinator

##### Tips for coordinators
  * Ensure that everyone can stay busy, gather them to discuss/re-prioritize current tasks
  * Check on progress regularly, if something takes too long, ask the team to kill the feature
  * Make sure everybody is reminded they are human. They need to take breaks, sleep and eat
  * If you have down time, pick a task you can do!


#### Finishing up!

Goals:
  * Submit a playable game before the deadline!

To-do:
  1. Feature freeze 2-3 hours before the deadline
  2. Create a build for submission
  3. Get the team together and decide what to polish in the remaining hours
  4. If polish works out, create a new build for submission
