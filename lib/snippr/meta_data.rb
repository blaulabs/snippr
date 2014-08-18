# -*- encoding : utf-8 -*-
require "yaml"

# = Snippr::MetaData
#
# Handles Snippr's YAML Front Matter inspired by Jekyll.
# Useful for passing meta information about a Snip to the app.
module Snippr

  class MetaData

    INCLUDE = "_include"

    def self.extract(name, content, snippet=nil)
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$?)/m
        content = Regexp.last_match.post_match.strip
        meta = yaml_load(name, $1)
        if meta && meta.keys.include?(INCLUDE)
          Array(meta[INCLUDE]).each do |include_path|
            if (snippet && include_path.start_with?("./"))
              include_path = snippet.name.gsub(/\/.*?$/,"") + "/" + include_path.gsub(/^\.\//, "")
            end
            snippet = Snippr.load(include_path)
            meta = snippet.meta.deep_merge(meta)
          end
        end
      end

      meta = meta ? meta : {}

      [content, meta]
    end

  private

    def self.yaml_load(name, yml)
      YAML.load(yml)
    rescue Exception => e
      Snippr.logger.warn "Unable to extract meta data from Snip #{name.inspect}: #{e.message}"
      {}
    end

  end

end
