# This plugin automatically fetches the latest version of libGDX's dependencies
# by parsing the DependencyBank file of the latest released version of gdx-setup
#
# https://github.com/libgdx/libgdx/blob/master/extensions/gdx-setup/src/com/badlogic/gdx/setup/DependencyBank.java
#
# This is basically a Ruby port of https://github.com/libgdx/libgdx-site/blob/master/src/main/java/com/badlogicgames/libgdx/site/GameService.java
# and https://github.com/libgdx/libgdx-site/blob/master/src/main/java/com/badlogicgames/libgdx/site/Versions.java

require "jekyll"
require 'json'
require 'open-uri'

module LibGDXFetchVersions
  class VersionDataGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
        latestReleaseApiResponse = JSON.load(URI.open('https://api.github.com/repos/libgdx/libgdx/releases/latest'))
        dependencyBankContent = URI.open("https://raw.githubusercontent.com/libgdx/libgdx/" + latestReleaseApiResponse['tag_name'] + "/extensions/gdx-setup/src/com/badlogic/gdx/setup/DependencyBank.java", &:read)

        site.data['versions'] = Hash.new

        site.data['versions']['libgdxRelease'] = getVersion(dependencyBankContent, 'libgdxVersion')
        site.data['versions']['libgdxNightlyVersion'] = getVersion(dependencyBankContent, 'libgdxNightlyVersion')
        site.data['versions']['robovmVersion'] = getVersion(dependencyBankContent, 'roboVMVersion')
        site.data['versions']['robovmPluginVersion'] = getVersion(dependencyBankContent, 'roboVMVersion')
        site.data['versions']['androidBuildtoolsVersion'] = getVersion(dependencyBankContent, 'buildToolsVersion')
        site.data['versions']['androidSDKVersion'] = getVersion(dependencyBankContent, 'androidAPILevel')
        site.data['versions']['androidGradleToolVersion'] = getPluginVersion(dependencyBankContent, 'androidPluginImport')
        site.data['versions']['gwtVersion'] = getVersion(dependencyBankContent, 'gwtVersion')
        site.data['versions']['gwtPluginVersion'] = getPluginVersion(dependencyBankContent, 'gwtPluginImport')
    end

    def getVersion(str, match)
        result = str.match(match + '\s=\s"(.*?)"')
        result.nil? ? "Unknown" : result[1]
    end

    def getPluginVersion(str, match)
        result = str.match(match + '\s=\s"(.*?)"')

        if result.nil?
          ret = "Unknown"
        else
          ret = result[1]
          ret = ret[ret.rindex(':') + 1, ret.length]
        end

        ret
    end

  end
end
