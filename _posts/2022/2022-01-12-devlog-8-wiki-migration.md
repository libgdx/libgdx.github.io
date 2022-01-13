---
title: "Status Report #8: Wiki Migration"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/posts/2022-01-12/header.png
  teaser: /assets/images/posts/2022-01-12/header.png

excerpt: We moved our GitHub wiki to the libGDX website!

show_author: true
author_username: "crykn"
author_displayname: "damios"

tags:
  - devlog

categories: news
---

A couple of months ago, [GitHub enforced their exclusion of wikis from crawling](https://github.com/github/feedback/discussions/4992#discussioncomment-1448177), leading to them not being indexed by (and thus findable via) search engines. While their reasoning behind this change is understandable (abusive behaviour in wikis has had a negative impact on their search engine ranking), this made our wiki basically invisible to users not knowing where to find it, and far less accessible to those that did. As a consequence, we set out to look for a solution and settled on moving the wiki to our [main website](/wiki/).

## How?
Our old wiki was basically a bunch of markdown files located in a GitHub wiki repo. Luckily, Jekyll, the static site generator our website depends on, also uses Markdown. So, the main steps in migrating were comparatively minor. In particular, the wiki-style links (`[[graphics]]` -> `[graphics](/wiki/graphics)`) and the asset paths needed changing. In addition, the pages were organised in categories to make editing easier (previously, all ~200 pages were located in one directory) and the URLs more SEO-friendly. This was done with the help of [@Spaio](https://github.com/Spaio) – thank you very much for this! Going forward, the wiki pages are located within the [/wiki/](https://github.com/libgdx/libgdx.github.io/tree/dev/wiki) directory of the [website repo](https://github.com/libgdx/libgdx.github.io) and use a special version of the [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme that we already use for the rest of the website.

## And now?
The wiki can now be accessed via [https://libgdx.com/wiki/](https://libgdx.com/wiki/). To **edit a page**, use the "Edit on GitHub" link on top of each page. This will redirect you to GitHub, where you can submit a PR with your changes. We know that that makes contributing a bit of a hassle, but hope that it isn't too much of an inconvenience.

Our new **wiki style guide** can be found [here](/wiki/misc/wiki-style-guide). Please give it a read before contributing.

As an added bonus, the migration allows us to use normal HTML, JS and CSS code in the wiki, which offers a few interesting possibilities:

<style>
.example {
  background-color: yellow;
}
.example:hover {
  background-color: orange;
}
.example2 {
  padding-top: -10px;
  transform: translate(-50%, -50%);
	letter-spacing:0.1em;
  -webkit-text-fill-color: transparent;
  -webkit-text-stroke-width: 2px;
  -webkit-text-stroke-color: #eeeeee;
  text-shadow:
						8px 8px #ff1f8f,
						20px 20px #000000;
}
</style>

- Text <span style="color:blue">can</span> be <span class="example">formatted</span> in <span class="example2">various</span> new ways
- Videos can easily be included: `{% raw %}{% include video id="3kPK_O6Q4wA" provider="youtube" %}{% endraw %}`
- Jekyll elements like, for example, [carousels](https://github.com/libgdx/libgdx.github.io/wiki/Custom-Additions#carousel) can be used
- libGDX GWT apps can be embedded on wiki pages, allowing us to showcase live libGDX examples

Feedback on this migration is very much welcome – just join our [Discord](/community/discord/) and let us know what you think!
