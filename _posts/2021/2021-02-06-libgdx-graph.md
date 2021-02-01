---
title: "Community Showcase: libGDX-graph"
excerpt: "Gempukku Studio  presents libGDX-graph tool"
classes: wide2
header:
  teaser: /assets/images/posts/2021-02-06/header.png

show_author: true
author_username: "marcinsc"
author_displayname: "Gempukku Studio"

categories: news
---

<div class="notice--primary">
  <p>
    Hey everybody! As announced in <a href="/news/2021/01/devlog_5_community_showcases">Status Report #5</a> we want to give creators of interesting community projects the opportunity to present their exciting libraries or tools on the official blog. This is the second of these <b>Community Showcases</b>, in which Gempukku Studio is going to present his <a href="https://github.com/marcinsc/libgdx-graph">libGDX-graph tool</a>!
  </p>
  <p>
    If you are interested in other cool community projects, be sure to check out the <a href="https://github.com/rafaskb/awesome-libgdx#readme">libGDX Awesome List</a> as well. To participate in future showcases, take a look <a href="https://github.com/libgdx/libgdx.github.io/wiki/Community-Showcases">here</a>.
  </p>
</div>

# Introduction
LibGDX-graph is a GUI tool for designing rendering pipeline and graph-based shaders. It also has an accompanying library
that is used to render the pipeline in your own project. I have created this tool, because creating and managing rendering
in my own projects was getting complicated - with a lot of spaghetti-code that was taking care of all the off-screen
buffers, shaders, uniforms, meshes, textures, etc.

A lot of people, who try to write their own first shader, get very easily discouraged with the amount of additional
"plumbing" that has to be done in order to render something to screen - ie. pass all the values, execute all the OpenGL
commands in the right order, also not to forget all the disposing of resources required. This is probably the single
biggest barrier developers experience, when trying to create interesting and compelling visuals in their games. The code
that has to be written takes hours, and a huge amount of testing is required to ensure the shader does exactly what
it is supposed to do.

LibGDX-graph is not only taking away all the complexity of setting up and disposing of all the required objects, but
also makes creating new shaders much easier, with an instant preview available in the tool.

# Features
## Rendering pipeline definition
You can define the entire rendering pipeline workflow in your application, using nodes in a graph.

![](/assets/images/posts/2021-02-06/pipeline.png){: .align-center}

The execution flow in such pipeline is from "Pipeline start" to "Pipeline end" nodes. Properties are objects that can
be injected at runtime to assist the defined nodes.

## Post-processors (blur, bloom, depth of field, etc)
LibGDX-graph contains a few built in post-processing effects that can be used out of the box in your projects. Those are
the most common and most useful ones - Gaussian Blur, Bloom, Depth of Field and Gamma Correction. For further
information, on those nodes - please refer to this
[YouTube video](https://www.youtube.com/watch?v=wRWVgO0aAlk&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=3).

{% include video id="wRWVgO0aAlk?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

## Screen shaders
In addition to the post-processors - you might want to create other full-screen effects, these are achieved by
"Full Screen Shaders" node, that uses an entire screen as its canvas. For further information, please refer to this
[YouTube video](https://www.youtube.com/watch?v=E8XRboVG61M&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=16).

{% include video id="E8XRboVG61M?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

## Model shaders
LibGDX-graph allows defining custom rendering of 3D models. Using "Model Shaders" node, you take full control over how
a 3D model is rendered. For further information, please refer to these YouTube videos:
[Video 1](https://www.youtube.com/watch?v=8bavqhh9txE&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=6),
[Video 2](https://www.youtube.com/watch?v=oFi8CMZfPt8&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=7).

{% include video id="8bavqhh9txE?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

{% include video id="oFi8CMZfPt8?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

## Sprite shaders
For all those, who prefer using 2D in their games, there is the "Sprite Shaders" node. It allows rendering sprites
(rectangle 2D images) to screen. Those automatically handle z-ordering - defining which sprites should be rendered in
front of others, but also just like all the other shader nodes, allow defining how sprites are rendered using graph
created in the GUI tool.

This opens a lot of possibilities to you as a developer, starting with easily handling rendering of outlines (
[YouTube video 1](https://www.youtube.com/watch?v=pur596KeUK4&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=21),
[YouTube video 2](https://www.youtube.com/watch?v=fJ7jWKShZ74&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=22)),
creating parallax effect
([YouTube video](https://www.youtube.com/watch?v=aDPNMxUKLRw&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=20)),
as well as other custom rendering.

{% include video id="pur596KeUK4?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

{% include video id="fJ7jWKShZ74?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

{% include video id="aDPNMxUKLRw?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

## Particle shaders
Finally, no exciting looking game would be finished without some particle effects. LibGDX-graph allows creating and
define rendering of particle effects using graph nodes. Because rendering and updating of sprites is handled in
the shader, this means that libGDX-graph particle effects are usually more efficient than particle effects created with
built-in particle code in libGDX. See this [Jam entry](https://marcins.itch.io/december-2020-libgdx-jam) for an effect
with hundreds of thousands of particles.

Due to complete control over how and where the particles are rendered, you can create complex particle effects commonly
seen in other games, please refer to this
[YouTube video](https://www.youtube.com/watch?v=uGZrbE0ziEk&list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi&index=24)
for an example.

{% include video id="uGZrbE0ziEk?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi" provider="youtube" %}

# How to get started
The project's readme, as well as Wiki available on the project page is a good way to start:
[project's page](https://github.com/marcinsc/libgdx-graph).

In addition, there is a [Devlog playlist](https://www.youtube.com/playlist?list=PLqpawGIg6Qj5CvjOaCbB536z862XhjPQi)
available on [author's YouTube channel](https://www.youtube.com/GempukkuStudio). This devlog has plenty of examples
on how libGDX-graph can be used in your project, with various shader use cases presented.

Please also make sure to subscribe to the [author's YouTube channel](https://www.youtube.com/GempukkuStudio) to support
him, as well as to keep up to date with the latest developments.
