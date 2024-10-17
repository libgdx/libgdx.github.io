# This plugin automatically fetches the name of the latest version of libGDX

require "jekyll"
require 'json'
require 'open-uri'

module LibGDXFetchVersions
  class VersionDataGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
        latestReleaseApiResponse = JSON.load(URI.open('https://api.github.com/repos/libgdx/libgdx/releases/latest'))
        site.data['versions'] = Hash.new
        site.data['versions']['libgdxRelease'] = latestReleaseApiResponse['name']
    end

  end
end
