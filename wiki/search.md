---
title: "Wiki Search"

layout: default_wiki # This page is a modified version of _layouts/wiki.html
description: "Ask, and it shall be given to you; seek, and you shall find!"
sitemap: false
---

<div id="main" role="main">
  <header>
    {% if page.title %}<h1 id="page-title" class="page__title" itemprop="headline">{{ page.title | markdownify | remove: "<p>" | remove: "</p>" }}</h1>{% endif %}

    <div class="header-meta">
    </div>
  </header>
  <article class="page h-entry" itemscope itemtype="https://schema.org/CreativeWork">
    <div class="page__inner-wrap">
      <section class="page__content e-content markdown-body" itemprop="text">
          <aside class="sidebar__right">
            <div class="toc">
              <div class="wiki_toc__menu">
                <input id="wiki_ac-toc" name="accordion-toc" type="checkbox" />
                <label for="wiki_ac-toc">{{ site.data.ui-text[site.locale].menu_label | default: "Toggle Menu" }}</label>

                {% capture sidebar_include %}{% include_cached wiki_sidebar.md %}{% endcapture %}
                <div class="wiki_nav__items">
                  {{ sidebar_include | markdownify }}
                </div>
              </div>
            </div>
          </aside>

          <input type="text" id="search" class="search-input" autofocus placeholder="{{ site.data.ui-text[site.locale].search_placeholder_text | default: 'Enter your search term...' }}" style="border: 1px solid #d4d8e3;border-radius: 4px;box-shadow: 0 1px 1px 0 rgba(85,95,110,.2); padding: 14px; font-size: 16px;" />
          <div id="results" class="results">
          </div>

      </section>
    </div>

  </article>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script> <!-- mmistakes jQuery isn't loaded yet -->
<script src="{{ '/assets/js/lunr/lunr.min.js' | relative_url }}"></script>

<script>
// STORE
var store = [
  {%- assign pages = site.pages | where_exp:'page','page.layout == "wiki"' | where_exp:'page','page.title != nil' | where_exp:'page','page.search != false' -%}
  {%- for page in pages -%}
    {
        "title": {{ page.title | jsonify }},
        "excerpt":
        {% if true %}
        {{ page.content | markdownify | newline_to_br |
              replace:"<br />", " " |
              replace:"</p>", " " |
              replace:"</h1>", " " |
              replace:"</h2>", " " |
              replace:"</h3>", " " |
              replace:"</h4>", " " |
              replace:"</h5>", " " |
              replace:"</h6>", " "|
            strip_html | strip_newlines | jsonify }},
        {% else %}
        {{ page.content | markdownify | newline_to_br |
              replace:"<br />", " " |
              replace:"</p>", " " |
              replace:"</h1>", " " |
              replace:"</h2>", " " |
              replace:"</h3>", " " |
              replace:"</h4>", " " |
              replace:"</h5>", " " |
              replace:"</h6>", " "|
            strip_html | strip_newlines | truncatewords: 100 | jsonify }},
        {% endif %}
        "url": {{ page.url | relative_url | jsonify }} }{%- unless forloop.last -%},{%- endunless -%}
  {%- endfor -%}
];

// PARSE
var idx = lunr(function () {
  this.field('title')
  this.field('excerpt')
  this.ref('id')

  this.pipeline.remove(lunr.trimmer)

  for (var item in store) {
    this.add({
      title: store[item].title,
      excerpt: store[item].excerpt,
      id: item
    })
  }
});

// ACTUAL SEARCH
$(document).ready(function() {
  $('input#search').on('keyup', function () {
    var resultdiv = $('#results');
    var query = $(this).val().toLowerCase();
    var result = idx.search(query);
    resultdiv.empty();
    resultdiv.prepend('<p class="results__found header-meta" style="border: none">'+result.length+' {{ site.data.ui-text[site.locale].results_found | default: "Result(s) found" }}</p>');
    for (var item in result) {
      var ref = result[item].ref;
    	 var searchitem =
        '<div class="list__item">'+
          '<article class="archive__item" itemscope itemtype="https://schema.org/CreativeWork">'+
            '<h2 class="archive__item-title" itemprop="headline" style="padding-bottom: 0px">'+
              '<a href="'+store[ref].url+'" rel="permalink">'+store[ref].title+'</a>'+
            '</h2>'+
            '<p class="archive__item-excerpt" itemprop="description" style="padding-bottom: 5px">'+store[ref].excerpt.split(" ").splice(0,45).join(" ")+'...</p>'+
          '</article>'+
        '</div>';

      resultdiv.append(searchitem);
    }
  });
});
</script>
