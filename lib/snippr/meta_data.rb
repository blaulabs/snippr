# -*- encoding : utf-8 -*-
require "yaml"

# = Snippr::MetaData
#
# Handles Snippr's YAML Front Matter inspired by Jekyll.
# Useful for passing meta information about a Snip to the app.
module Snippr

  class MetaData

    def self.extract(name, content)
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$?)/m
        content = Regexp.last_match.post_match.strip
        meta = yaml_load(name, $1)
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
