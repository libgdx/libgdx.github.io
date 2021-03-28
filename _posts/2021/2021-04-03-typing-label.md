---
title: "Community Showcase: Typing Label"
excerpt: "Rafa Skoberg presents his Typing Label library in our Community Showcase!"
classes: wide2
header:
  teaser: /assets/images/posts/2021-04-03/logo.png 
  actions:
    - label: "typing-label"
      url: "https://github.com/rafaskb/typing-label"

show_author: true
author_username: "RafaSKB"
author_displayname: "Rafa Skoberg"

categories: news

gallery:
- url: /assets/images/posts/2021-04-03/effect-ease.gif
  image_path: /assets/images/posts/2021-04-03/effect-ease.gif
  alt: "Ease Token"
  title: "Ease Token"
- url: /assets/images/posts/2021-04-03/effect-hang.gif
  image_path: /assets/images/posts/2021-04-03/effect-hang.gif
  alt: "Hang Token"
  title: "Hang Token"
- url: /assets/images/posts/2021-04-03/effect-jump.gif
  image_path: /assets/images/posts/2021-04-03/effect-jump.gif
  alt: "Jump Token"
  title: "Jump Token"
- url: /assets/images/posts/2021-04-03/effect-shake.gif
  image_path: /assets/images/posts/2021-04-03/effect-shake.gif
  alt: "Shake Token"
  title: "Shake Token"
- url: /assets/images/posts/2021-04-03/effect-sick.gif
  image_path: /assets/images/posts/2021-04-03/effect-sick.gif
  alt: "Sick Token"
  title: "Sick Token"
- url: /assets/images/posts/2021-04-03/effect-slide.gif
  image_path: /assets/images/posts/2021-04-03/effect-slide.gif
  alt: "Slide Token"
  title: "Slide Token"
- url: /assets/images/posts/2021-04-03/effect-wave.gif
  image_path: /assets/images/posts/2021-04-03/effect-wave.gif
  alt: "Wave Token"
  title: "Wave Token"
- url: /assets/images/posts/2021-04-03/effect-wind.gif
  image_path: /assets/images/posts/2021-04-03/effect-wind.gif
  alt: "Wind Token"
  title: "Wind Token"
- url: /assets/images/posts/2021-04-03/effect-fade.gif
  image_path: /assets/images/posts/2021-04-03/effect-fade.gif
  alt: "Fade Token"
  title: "Fade Token"
- url: /assets/images/posts/2021-04-03/effect-blink.gif
  image_path: /assets/images/posts/2021-04-03/effect-blink.gif
  alt: "Blink Token"
  title: "Blink Token"
- url: /assets/images/posts/2021-04-03/effect-gradient.gif
  image_path: /assets/images/posts/2021-04-03/effect-gradient.gif
  alt: "Gradient Token"
  title: "Gradient Token"
- url: /assets/images/posts/2021-04-03/effect-rainbow.gif
  image_path: /assets/images/posts/2021-04-03/effect-rainbow.gif
  alt: "Rainbow Token"
  title: "Rainbow Token"
---

 <div class="notice--primary">
   <p>
     Hey everybody! As announced a few months ago, we want to give creators of interesting community projects the opportunity to present their exciting libraries or tools on the official blog. In this <b>Community Showcase</b>, Rafa Skoberg is going to present his <a href="https://github.com/rafaskb/typing-label#readme">Typing Label library</a>!
   </p>
   <p>
     If you are interested in other cool community projects, be sure to check out the <a href="https://github.com/rafaskb/awesome-libgdx#readme">libGDX Awesome List</a> as well. To participate in future showcases, take a look <a href="https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases">here</a>.
   </p>
 </div>


![](/assets/images/posts/2021-04-03/logo.png){: .align-center}

Have you ever wanted to create RPG-like dialogues where the text appears letter by letter? Perhaps play sounds as glyphs are rendered? How about injecting variables inside your dialogues, such as the character's name chosen by the player? Or even fire and listen to events placed in the middle of sentences, and shake the screen when that happens?

Enter [Typing Label](https://github.com/rafaskb/typing-label#readme), a Scene2D Label that appears as if it was being typed in real time. 😁

![](/assets/images/posts/2021-04-03/sample.gif){: .align-center}

### Magic Tricks

[Tokens](https://github.com/rafaskb/typing-label/wiki/Tokens) are the heart of Typing Label, and they define how your text will behave. Here are some examples of tokens that modify the appearance of a label:

{% include gallery layout="half" %}

It's really simple to apply tokens to your text, check it out:

```java
// Create some text with tokens
String text = "{JUMP}{COLOR=GREEN}Hello,{WAIT} world!{ENDJUMP}" +
    "\n{COLOR=ORANGE}{SLOWER} Did you know {WAVE}orange{ENDWAVE}" +
    " is my {SLIDE}favorite{ENDSLIDE} color?";

// Create a TypingLabel instance with your custom text
TypingLabel label = new TypingLabel(text, skin);

// Add the actor to any widget like you normally would
stage.add(label);
```

You can also use variable and event tokens for some pretty advanced stuff. Lets say the player can name their cat in your game, and in a certain dialogue you want to say its name and play a meow sound. Here's how that would work:

```java
// Create some text with tokens
String text = "Every time {COLOR=IMPORTANT}{VAR=CatName}{RESET} wants some milk " +
    "{VAR=CatPronoum1} meows uncontrollably.{EVENT=Meow}{WAIT=1}" + 
    "{SLOWER} Yep, just like that... 😻";

// Create a TypingLabel instance with your custom text
TypingLabel label = new TypingLabel(text, skin);

// Assign variables to replace {VAR} tokens
label.setVariable("CatName", "Daisy Purrington");
label.setVariable("CatPronoum1", "she");

// Add the actor to any widget like you normally would
stage.add(label);

// Create a TypingListener or TypingAdapter to listen to events as they're fired
label.setTypingListener(new TypingAdapter() {
    @Override
    public void event (String event)  {
        if("Meow".equalsIgnoreCase(event)) {
            Sound meowSound = getMeowSoundSomehow();
            meowSound.play();
        }
    }
});
```

_More examples and the complete token list can be found in the [Typing Label's wiki](https://github.com/rafaskb/typing-label/wiki/Examples#using-tokens)._
{: .notice--info }

### Real Life Example

Typing Label was originally created in 2016 for a libGDX game called [Grashers](http://grashers.com/), and then transformed into an open source library so other developers could use its features in their games.

Here's an example of the library being used in the game while using several tokens, variables, and listeners:

{% include video id="UafQrXP_tE8" provider="youtube" %}

To achieve this sort of effect, I use a code similar to this one:

```java
/*
 * Constants
 */
/** Default TypingLabel token used in all dialogue labels. */
public static final String DIALOGUE_DEFAULT_TOKEN = "{EASE=1;1}{FADE=0;1;0.1}";

/** Character's name. This would be defined by the player in a real scenario. */
public static final String CHAR_NAME = "Stella";

/*
 * Label
 */
// Create dialogue label
TypingLabel dialogLabel = new TypingLabel("", skin);
dialogLabel.setDefaultToken(DIALOGUE_DEFAULT_TOKEN);
dialogLabel.setVariable("PLAYER", CHAR_NAME);

// Play mumble sound every time a character is typed
dialogLabel.setTypingListener(new TypingAdapter() {
    @Override
    public void onChar(Character ch) {
        // Each character has their own sounds here
        Sound reallyShortMumbleSound = getRandomMumbleSound();
        reallyShortMumbleSound.play();
    }
});

/*
 * Dialogue Texts
 */
String[] dialogueTexts = {
    "Thanks for coming, uh... {VAR=PLAYER}. {SHAKE}{COLOR=WHISPER}*cough* *cough*",

    "{SICK}Sorry, don't get too close.",

    "There's a {COLOR=IMPORTANT}really weird stink{CLEARCOLOR} comin' from somewhere in here. And sometimes there's these, like {JUMP}\"bum-BUMP\"{ENDJUMP} noises.",

    "{SLOWER}It's the {COLOR=IMPORTANT}physical manifestation of the darkness within men's hearts.",

    "{COLOR=WHISPER}*bleep*"
}
```

### Installing
Typing Label works as a drop-in replacement for normal Scene2D Labels, so getting it to work is really simple. All you have to do is add Typing Label to your Gradle dependencies and that's it! You can find the instructions in the [repository's README](https://github.com/rafaskb/typing-label#installation).

### Development Status
I consider Typing Label to be in a mature state. It's been tested by many developers over the years, and thankfully it has proven to be very stable. The library is compatible with the most recent libGDX version, and should continue to be as future updates are released as well.

That being said, there are no major changes or additions planned for Typing Label right now, however improvements and additions are always welcome! 💜

### External References
- [GitHub page and readme](https://github.com/rafaskb/typing-label#readme)
- [Tokens](https://github.com/rafaskb/typing-label/wiki/Tokens)
- [Combining effects](https://github.com/rafaskb/typing-label/wiki/Tokens#combining-effects)
- [Create your own effects!](https://github.com/rafaskb/typing-label/wiki/Tokens#custom-effects)
