---
title: Wiki Style Guide
# Not listed in ToC
---
This page gives some information on how to edit libGDX wiki pages. **Please read this before contributing to the libGDX wiki!** If you have any (additional) questions, please do not hesitate to ask! See our [Discord](/community/) for more information.

## How to?
Every wiki page has an "Edit on GitHub" button on top which redirects you to the GitHub Web Interface of the wiki repo. Use this for small fixes/typos. If you want to undertake more extensive changes, you should fork [the repo](https://github.com/libgdx/libgdx.github.io). The [wiki of our website repo](https://github.com/libgdx/libgdx.github.io/wiki) also offers some pointers on this.

## First Paragraph
Generally, each wiki page should start with an introductory paragraph. This improves useability for the wiki and allows the first few sentences to be used in the meta descriptions and the search results.

## Style
We use Markdown to format this wiki. To learn your way around this, here is GitHub's very concise [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet). As our wiki is hosted via GitHub Pages, you can also use HTML, JS and CSS as well as Jekyll's Liquid Tags. To find out more about your options, take a look [here](https://github.com/libgdx/libgdx.github.io/wiki).

### Notable syntax

* Wiki links are made like this:
   `[link text to networking](/wiki/networking)` renders this: [link text to networking](/wiki/networking)  

## Linking to code/docs
Links to code/docs should be done as follows: `[ClassName](link to docs) [(code)](link to code)`. For example:
```
[Texture](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/Texture.java)
```

renders the following:

[Texture](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html)
[(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/graphics/Texture.java)

Don't use non-alphabetic characters in Wiki page names, because not all operating systems can handle
them when cloning Wiki as Git repository (for example, Windows doesn't support ":").

{% capture docs-notice %}
- Please note that there should be a space in between `ClassName (Code)` style formatting, in order to differentiate the two.
- Please make the format `ClassName (Code)` with the word `Code`, not `Source` or any derivative of that. Consistency is key!
- If a link to documentation ends in a right parenthesis `)`, it will mess up the markdown. Take this example:
   ```
   https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html#getWidth()
   ```
   When using the markdown formatting of `[]()` the end parenthesis will mess up the link, so please remember to escape the ending parenthesis (`)`). In the example, it should be:
   ```markdown
   [Link to Texture#getWidth](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/graphics/Texture.html#getWidth(\))
   ```
   Without the escaped parenthesis, a 404 is imminent!
{% endcapture %}

<div class="notice notice--primary">{{ docs-notice | markdownify }}</div>

## The main table of contents

If you create a new page, you will most likely want it to be displayed on the main libGDX wiki [Table of contents](https://github.com/libgdx/libgdx.github.io/blob/dev/_includes/wiki_index.md) and the [sidebar Table of Contents](https://github.com/libgdx/libgdx.github.io/blob/dev/_includes/wiki_sidebar.md). Therefore, please include the changes to both ToCs with the appropriate positioning of your article in your PR.

Some pages are not listed in the ToC, in particular the ones located in the `/wiki/misc` folder. Those pages should contain a comment in the frontmatter, clarifying this: `# Not listed in ToC`.

## Tables of contents per page

Tables of contents have to be manually created on a per-page basis. For an example of how to do so outside of this section, please refer to our [Box2d](/wiki/extensions/physics/box2d) article.

When creating headers in markdown, we specify using a number of octothorpes (`#`) that define the header level. When we create a header `## Comments and Questions/Concerns` in an article entitled `Help Me` the corresponding link would be `help-me#comments-and-questionsconcerns`. So when we go to make our table of contents, those page fragment links would be placed in an unordered list.

## Adding images

Images are stored in the [`assets/wiki/` directory](https://github.com/libgdx/libgdx.github.io/blob/dev/assets/wiki/) of the libGDX wiki. To add an image, you must fork and [clone the repo](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository). Then add your images to the images folder using the appropriate naming scheme `my-page-name#` where `#` is the order of the picture displayed on the page (this can be ommitted if only one image is used in the page, but recommended). Images are linked to with the following syntax (assuming the image is stored in the `/assets/wiki/images/` directory) `![image name](/assets/wiki/images/flamedemo.gif)` which will display:

![image name](/assets/wiki/images/flamedemo.gif){: style="width: 300px;" }

If you want to style the image, use something like this: `![image name](/assets/wiki/images/flamedemo.gif){: style="width: 300px;" }` 

## Videos

Videos can be included like this:

```markdown
{% raw %}{% include video id="3kPK_O6Q4wA" provider="youtube" %}{% endraw %}
```

## Adding GWT examples

Actual libGDX examples can be embedded via GWT as iframes. To do this, use the `embed-gwt` element on a wiki page:
```yml
{% raw %}{% include embed-gwt.html dir='viewport-example' %}{% endraw %}
```

`dir` refers to the directory in the [libgdx-wiki-examples](https://github.com/libgdx/libgdx-wiki-examples) repo, where the source code of the examples is located. In particular, it denotes the path to the root folder of the example's Gradle project (without leading and trailing slashes; in this case, `viewport-example` refers to the  `/viewport-example/` folder which contains `/html/build.gradle`). The examples are automatically built via GH Actions (by calling `./gradlew html:dist`) and then deployed through GH Pages.

To style the embedded content, use the `containerstyle` and `iframestyle` attributes.

## Renaming pages

If you are moving/renaming pages and want to preserve their old links, use `redirect_from` in the frontmatter:
```yml
redirect_from:
  - /dev/setup/ # this page is now available via https://libgdx.com/dev/setup/ as well
```
