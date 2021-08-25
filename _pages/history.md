---
permalink: /history/
title: "History"
classes: wide2
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/history.jpeg
  caption: "Photo credit: [**Mr Cup / Fabien Barral**](https://unsplash.com/photos/Fo5dTm6ID1Y)"
excerpt: "The libGDX project was started over 10 years ago. Over the years, libGDX and its community matured: nowadays, libGDX is a well proven and reliable framework with a sound base and documentation."
---

<style>
* {
  box-sizing: border-box;
}

/* The actual timeline (the vertical ruler) */
.timeline {
  position: relative;
  max-width: 1200px;
  margin: 0 auto;
}

/* The actual timeline (the vertical ruler) */
.timeline::after {
  content: '';
  position: absolute;
  width: 6px;
  background-color: #e8e8e8;
  top: 0;
  bottom: 0;
  left: 50%;
  margin-left: -3px;
  z-index: -1;
}

/* Container around content */
.container {
  padding: 10px 40px;
  position: relative;
  background-color: inherit;
  width: 50%;
}

/* The circles on the timeline */
.container::after {
  content: '';
  position: absolute;
  width: 25px;
  height: 25px;
  right: -17px;
  background-color: #e8e8e8;
  border: 4px solid #f5370c;
  top: 15px;
  border-radius: 50%;
  z-index: 1;
}

/* Place the container to the left */
.left {
  left: 0;
}

/* Place the container to the right */
.right {
  left: 50%;
}

/* Add arrows to the left container (pointing right) */
.left::before {
  content: " ";
  height: 0;
  position: absolute;
  top: 22px;
  width: 0;
  z-index: 1;
  right: 30px;
  border: medium solid #9da3a8;
  border-width: 10px 0 10px 10px;
  border-color: transparent transparent transparent #9da3a8;
}

/* Add arrows to the right container (pointing left) */
.right::before {
  content: " ";
  height: 0;
  position: absolute;
  top: 22px;
  width: 0;
  z-index: 1;
  left: 30px;
  border: medium solid #9da3a8;
  border-width: 10px 10px 10px 0;
  border-color: transparent #9da3a8 transparent transparent;
}

/* Fix the circle for containers on the right side */
.right::after {
  left: -16px;
}

/* The actual content */
.content {
  padding:  1px 18px;
  background-color: #9da3a8;
  position: relative;
  border-radius: 6px;
  color: white;
  font-size: 18px;
}

/* Media queries - Responsive timeline on screens less than 600px wide */
@media screen and (max-width: 600px) {
  /* Place the timelime to the left */
  .timeline::after {
  left: 31px;
  }

  /* Full-width containers */
  .container {
  width: 100%;
  padding-left: 70px;
  padding-right: 25px;
  }

  /* Make sure that all arrows are pointing leftwards */
  .container::before {
  left: 60px;
  border: medium solid #9da3a8;
  border-width: 10px 10px 10px 0;
  border-color: transparent #9da3a8 transparent transparent;
  }

  /* Make sure all circles are at the same spot */
  .left::after, .right::after {
  left: 15px;
  }

  /* Make all right containers behave like the left ones */
  .right {
  left: 0%;
  }
}

p a {
  color: #e83107;
}
p a:visited {
  color: #e83107;
}
p a:hover {
  color: #ff4c24;
}
p a:active {
  color: #ff4c24;
}
</style>

<link rel="stylesheet" href="/assets/css/aos.css" />

<div class="timeline">
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2020 - New Beginnings</h2>
      <p>The year 2020 brought a plethora of fixes and improvements for libGDX. In August, our <a href="/2020/08/welcome_to_the_new_website/">new website</a> went online. Since then, the development pace has picked up again: the contributors team saw some major growth and we are excited for the features and improvements <a href="/roadmap/">planned</a>.</p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2019</h2>
      <p>In 2019, libGDX kept moving forward: <a href="/news/2019/07/gdx_1_9_10/">version 1.9.10</a>, containing lots of fixes and improvements, was released. The majority of work done in the libGDX ecosystem is now done outside of the main repo: libGDX as a framework is mature enough to not require substantial changes, but the <a href="/dev/#tools--libraries">toolset and frameworks</a> surrounding libGDX are constantly improved upon by the community.</p>
    </div>
  </div>
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2018</h2>
      <p>In 2018, version 1.9.9 of the framework was released. Furthermore, since February 2018 the libGDX community is organizing regular <a href="/community/jams/">libGDX game jams</a>.</p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2017 - Parting Ways</h2>
      <p>By 2017, libGDX had become quite a bit more mature, so major changes were not as frequently needed as in the early years. Nonetheless, the versions 1.9.6 and 1.9.7 were released (the latter not by Mario Zechner – a first for libGDX) and some experimentation was done in the area of <a href="https://github.com/badlogic/gdx-vr">VR</a>.</p>
    </div>
  </div>
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2016</h2>
      <p>Apart from versions 1.8 and 1.9, 2016 brought us a new iOS backend based on Intel's Multi-OS Engine. It was released to replace the RoboVM one, since RoboVM itself was discontinued.</p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2015</h2>
      <p>2015 was another year of improvements: the versions 1.6 and 1.7 saw the light. From 18 December 2015 to 18 January 2016 the big <a href="https://github.com/libgdx/libgdx/wiki/Getting-ready-for-%23libGDXJAM">libGDX game jam</a> was organized together with RoboVM, itch.io and Robotality. From initially 180 theme suggestions "Life in space" was chosen and 83 games were created over the course of the competition.</p>
    </div>
  </div>
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2014 - libGDX 1.0</h2>
      <p>With all pieces in place, Q1 of 2014 was used to polish up libGDX’s user experience and documentation for the 1.0 release. After 4 years of development, on 20 April 2014, libGDX had finally reached <a href="http://web.archive.org/web/20210213212631/https://www.badlogicgames.com/wordpress/?p=3412">version 1.0</a>. The remainder of 2014 brought a lot of different libGDX iterations: the versions 1.1 (May), 1.2 (June), 1.3 (August), 1.4 (October) and 1.5 (December) were released.</p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2013 – Polishing</h2>
      <p>In the first half of 2013, we cleaned up many parts of libGDX, from the build system to tile map supported. The fragile iOS backend based on MonoTouch was replaced by a libGDX RoboVM backend. In June, our now old, but then <a href="http://web.archive.org/web/20170622002445/http://www.badlogicgames.com/wordpress/?p=3093">new and improved website</a>, (created by a lot of awesome volunteers) went live. With the new site, we made it possible for people to submit their games to a gallery. Moreover, we transferred the wiki and the issues, that were up until now still on Google Code, <a href="http://web.archive.org/web/20201111200443/https://www.badlogicgames.com/wordpress/?p=3176">with more or less issues</a>. At the end of 2013 we started looking into Gradle as our new savior. Up until that point, libGDX was bound to Eclipse and dependency management had to be done manually (i.e., copy jar X into folder y).</p>
    </div>
  </div>
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2012 - New Worlds</h2>
      <p>In 2012, <a href="http://web.archive.org/web/20170608015410/http://www.badlogicgames.com/wordpress/?p=2254">gdx-jnigen</a> was created. It became an integral part of libGDX's native code development, making it a lot easier to integrate C/C++ libraries with the framework. Apart from that, 2012 became the year of discovering new worlds: HTML5/WebGL, iOS, GitHub and Maven. Inspired by Google's <a href="https://github.com/playn/playn">PlayN</a> Mario started working on the GWT backend, which to this day remains an essential part of libGDX' identity. The next big change came in June, when the team <a href="http://web.archive.org/web/20200928225224/https://www.badlogicgames.com/wordpress/?p=2450">started investigating iOS</a>, again based on work done in the PlayN camp. In August, discussing started regarding <a href="http://web.archive.org/web/20200928230258/https://www.badlogicgames.com/wordpress/?p=2551">moving to GitHub and adding proper Maven support</a>.
      </p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2011 - Incremental Improvements</h2>
      <p>At the end of February 2011, <a href="http://web.archive.org/web/20170621234149/http://www.badlogicgames.com/wordpress/?p=1596">version 0.9 was released</a>. In this time, so many internal changes happened to libGDX that it was hard keeping track of what was going on. But it paid off: libGDX 0.9 saw immense adoption, not only due to feature density, but also due to us starting to create video tutorials and making the setup process a lot easier.</p>
    </div>
  </div>
  <div class="container left" data-aos="zoom-in-left" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2010 - Going Open Source</h2>
      <p>In March 2010, Zechner decided to open-source AFX, hosting it on Google Code under the GNU Lesser General Public License (LGPL). On the 6th of March 2010, the world saw the <a href="http://web.archive.org/web/20200928222604/https://www.badlogicgames.com/wordpress/?p=267">first libGDX code</a>. In early April 2010, libGDX got its first contributor, Christoph Widulle. He helped with various bits and pieces and was a nice wall to bounce ideas against. His involvement was a sign to other people that contributing to libGDX is a thing. From then on, the list of contributors to libGDX started to grow slowly but steadily.</p>
    </div>
  </div>
  <div class="container right" data-aos="zoom-in-right" data-aos-anchor-placement="top-bottom">
    <div class="content">
      <h2>2009 – When It All Began</h2>
      <p>It all started in the middle of 2009, when <a href="https://twitter.com/badlogicgames">Mario Zechner</a>, the creator of libGDX, started developing a framework called AFX (Android Effects) to create Android Games. When he discovered that deploying the changes from desktop to an Android device was cumbersome, he modified AFX to work on desktop as well, making it easier to test programs.</p>
    </div>
  </div>
</div>

<script src="/assets/js/aos.js"></script>
<script>
  AOS.init({
    disable: window.matchMedia('(prefers-reduced-motion: reduce)')
  });
</script>
