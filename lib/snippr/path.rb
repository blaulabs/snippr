# = Snippr::Path
#
# Extends the Snippr module with methods dealing the path to the snippr files.
module Snippr
  module Path

    # The JVM property to set the path to the snippr files.
    JVMProperty = "cms.snippet.path"

    # Returns the path to the snippr files (from JVM properties if available).
    def path
      @path ||= JavaLang::System.get_property(JVMProperty) rescue ""
    end

    # Sets the path to the snippr files.
    def path=(path)
      @path = path.to_s
    end

  private

    if RUBY_PLATFORM =~ /java/
      require 'java'
      module JavaLang
        include_package "java.lang"
      end
    end

  end
end
