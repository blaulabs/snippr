# = Snippr::Snip
#
# Represents a single snip and provides methods to read data.
module Snippr
  class Snip

    extend ActiveSupport::Memoizable

    FILE_EXTENSION = 'snip'

    attr_reader :name, :path, :opts

    def initialize(*names)
      @opts = names.last.kind_of?(Hash) ? names.pop : {}
      @opts.symbolize_keys!
      @name = "#{Path.normalize_name(*names)}#{I18n.locale}"
      @path = Path.path_from_name @name, (@opts[:extension] || FILE_EXTENSION)
    end

    # Returns the unprocessed, plain content from the file.
    def unprocessed_content
      missing? ? '' : File.read(@path).strip
    end
    memoize :unprocessed_content

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

    # Returns whether the snip is missing or not.
    def missing?
      !File.exist? @path
    end

    # Returns whether the snip is empty or not.
    def empty?
      unprocessed_content.blank?
    end

  end
end
