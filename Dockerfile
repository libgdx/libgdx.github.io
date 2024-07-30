FROM ruby:3.2.5
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll
ADD Gemfile /srv/jekyll/Gemfile
ADD Gemfile.lock /srv/jekyll/Gemfile.lock
RUN bundle install