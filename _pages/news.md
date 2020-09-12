---
permalink: /news/
title: "News"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.35"
  overlay_image: /assets/images/news.jpeg
  caption: "Photo credit: [**Chris Ried**](https://unsplash.com/photos/ieic5Tq8YMk)"
#excerpt: "All the latest news concerning libGDX and its development."
---

<div class="grid__wrapper">
  {% for post in site.posts limit:8 %}
    {% include archive-single.html type="grid" %}
  {% endfor %}
</div>

<a href="/archive/"><i class="fa fa-arrow-right" aria-hidden="true"></i> Show all posts</a>
