---
permalink: /news/
title: "News"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.35"
  overlay_image: /assets/images/news/news.jpeg
  caption: "Photo credit: [**Tim Mossholder**](https://unsplash.com/photos/H6eaxcGNQbU)"
#excerpt: "All the latest news concerning libGDX and its development."
---

<div class="grid__wrapper">
  {% for post in site.posts limit:8 %}
    {% include archive-single.html type="grid" %}
  {% endfor %}
</div>

<a href="/news/all/"><i class="fa fa-arrow-right" aria-hidden="true"></i> Show all posts</a>{: .align-right}
