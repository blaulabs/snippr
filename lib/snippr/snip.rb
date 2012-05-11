# # -*- encoding : utf-8 -*-
# = Snippr::Snip
#
# Represents a single snip and provides methods to read data.
module Snippr
  class Snip

    extend ActiveSupport::Memoizable

    FILE_EXTENSION = 'snip'

    def initialize(*names)
      names = strip_empty_values(names)
      @opts = names.last.kind_of?(Hash) ? names.pop : {}
      @opts.symbolize_keys!
      @name = "#{Path.normalize_name(*names)}#{ I18n.locale(@opts[:i18n]) }"
      @path = Path.path_from_name @name, (@opts[:extension] || FILE_EXTENSION)
      @unprocessed_content, @meta = MetaData.extract(names, raw_content)
    end

    attr_reader :name, :path, :opts, :unprocessed_content, :meta

    # Returns the processed and decorated content.
    def content
      if missing?
        "<!-- missing snippr: #{name} -->"
      else
        content = Processor.process unprocessed_content, opts
        "<!-- starting snippr: #{name} -->\n#{content}\n<!-- closing snippr: #{name} -->"
      end
    end
    memoize :content
    alias :to_s :content

    def raw_content
      missing? ? '' : File.read(@path).strip
    end
    memoize :raw_content

    # Returns whether the snip is missing or not.
    def missing?
      !File.exist? @path
    end

    # Returns whether the snip is empty or not.
    def empty?
      unprocessed_content.blank?
    end

  private

    def strip_empty_values(names)
      names - [nil, ""]
    end

  end
end
