---
permalink: /roadmap/
title: "Roadmap"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.45"
  overlay_image: /assets/images/roadmap.jpg
  caption: "Photo credit: [**Slidebean**](https://unsplash.com/photos/iW9oP7Ljkbg)"

excerpt: "Here you can learn more about our plans for the future of libGDX and get an idea of when you can expect new features."
published: false
---

<!--
Available status values:

{% include status.html is='planned' %}
{% include status.html is='drafting' %}
{% include status.html is='wip' %}
{% include status.html is='done' %}
 -->

<h1>Release Schedule</h1>

 Some interesting text.

 <br/>

<h1>Roadmap</h1>

<table>
  <tr>
     <td><h4>GWT Improvements</h4>
     <br>Web Audio, lazy loading of asset, support for hdpi screens and more.</td>
     <td>{% include status.html is='wip' %}</td>
   </tr>

   <tr>
     <td><h4>Welcome MobiVM, Goodbye MOE</h4>
     <br>MobiVM has proven to be a worthy successor of RoboVM. As a consequence, we are removing the MOE backend in favor of MobiVM.</td>
     <td>{% include status.html is='done' %}</td>
   </tr>

  <tr>
    <td><h4>Gradle Build Migration</h4>
    <br>We want to migrate our whole build process to gradle. This migration has been long in the making and there is still a lot of work to be done, but we’re crossing our fingers it gets finished without any major hurdles.</td>
    <td>{% include status.html is='wip' %}</td>
  </tr>

  <tr>
    <td><h4>gdx-video Resurrection</h4>
    <br>We have some plans drawn up to revive the gdx-video extension.</td>
    <td>{% include status.html is='planned' %}</td>
  </tr>

  <tr>
    <td><h4>Better Controller Support</h4>
    <br>There are plans to improve the controller support of libGDX on all backends.</td>
    <td>{% include status.html is='drafting' %}</td>
  </tr>
</table>
