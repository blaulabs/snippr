# = Snippet
# ==== File based content management
#
# A snippet is a piece of HTML to be included in a website. Snippets are plain text
# files stored on the file system.
#
# == Snippet path
#
# You need to specify the path to the snippet directory:
#
#   Snippet.snippet_path = File.join(File.dirname(__FILE__), "..", "snippets")
#
# When running on JRuby, you can also set the path via JVM properties. The property
# you need to specify is defined in +SnippetPath::SnippetPathProperty+. This allows
# system administrators to change the path without having to touch your application.
#
# == Instantiation
#
# Instantiating a new snippet is done by passing in the path to the snippet file as
# a String (including path separators):
#
#   Snippet.new "tariff/einheit"
#
# or by using multiple Strings or Symbols:
#
#   Snippet.new :tariff, :einheit
#
# === Dynamic values
#
# A snippet may contain placeholders to be replaced with dynamic values. Placeholders
# are wrapped in curly braces.
#
#   <p>You're topup of {topup_amount} at {date_today} was successful.</p>
#
# To replace the {topup_amount} with a dynamic value, you just pass in a Hash of
# placeholders and dynamic values when instantiating a new snippet.
#
#   Snippet.new :topup, :success, :topup_amount => number_to_currency(15), :date_today => Date.today
#
# The result will obviously be something like:
#
#   <p>You're topup of 15,00 &euro; at 2010-04-03 was successful.</p>
#
# == Links
#
# ...
#
# == Snippet content
#
# Getting the snippet content is done by calling the +to_s+ method. This will replace
# all specified placeholders and links.
#
#   Snippet.new(:tariff, :einheit).to_s
#
# == Rails Helper
#
# When using the Snippet component with Rails, it automatically adds the +SnippetHelper+
# module to your views. You can then use the +snippet+ helper method to load snippets.
#
#   %h1 Topup successful
#   .topup.info
#     = snippet :topup, :success
class Snippet
  extend SnippetPath

  # The snippet file extension.
  SnippetFileExtension = ".snip"

  # The comments wrapping a snippet.
  SnippetWrapper = "<!-- starting with snippet: %s -->\n%s\n<!-- ending with snippet: %s -->"

  # The fallback for a missing snippet.
  MissingSnippet = '<samp class="missing snippet" />'

  # Expects the paths to a snippet. Also accepts a Hash of placeholders
  # to be replaced with dynamic values.
  def initialize(*args)
    @dynamic_values = args.last.kind_of?(Hash) ? args.pop : {}
    @snippet_name = args.join("/")
  end

  # Returns the snippet content.
  def to_s
    wrap_in_comments { snippet }
  end

private

  # Returns the raw snippet content or a +MissingSnippet+ tag in case
  # the snippet file does not exist.
  def snippet
    return MissingSnippet unless File.exist? snippet_file
    
    snippet = File.read(snippet_file).strip
    insert_dynamic_values snippet
    snippet
  end

  # Replaces placeholders with dynamic values.
  def insert_dynamic_values(snippet)
    @dynamic_values.each { |placeholder, value| snippet.gsub! "{#{placeholder}}", value.to_s }
  end

  # Returns the complete path to a snippet file.
  def snippet_file
    File.join self.class.snippet_path, "#{@snippet_name}#{SnippetFileExtension}"
  end

  # Wraps the content from a given +block+ in descriptive comments.
  def wrap_in_comments
    SnippetWrapper % [@snippet_name, yield, @snippet_name]
  end

end