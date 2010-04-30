# = Snippr
# ==== File based content management
#
# A snippr is a piece of HTML to be included in a website. They are plain text
# files stored on the file system.
#
# == Snippr path
#
# You need to specify the path to the snippr directory:
#
#   Snippr.path = File.join(File.dirname(__FILE__), "..", "snipprs")
#
# When running on JRuby, you can also set the path via JVM properties. The property
# you need to specify is defined in +SnipprPath::JVMProperty+. This allows system
# administrators to change the path without having to touch your application.
#
# == Instantiation
#
# Instantiating a new snippr is done by passing in the path to the snippr file as
# a String (including path separators):
#
#   Snippr.new "tariff/einheit"
#
# or by using multiple Strings or Symbols:
#
#   Snippr.new :tariff, :einheit
#
# === Dynamic values
#
# A snippr may contain placeholders to be replaced with dynamic values. Placeholders
# are wrapped in curly braces.
#
#   <p>You're topup of {topup_amount} at {date_today} was successful.</p>
#
# To replace both {topup_amount} and {date_today} with a dynamic value, you just pass
# in a Hash of placeholders and dynamic values when instantiating a new snippr.
#
#   Snippr.new :topup, :success, :topup_amount => number_to_currency(15), :date_today => Date.today
#
# The result will obviously be something like:
#
#   <p>You're topup of 15,00 &euro; at 2010-04-03 was successful.</p>
#
# == Links
#
# ...
#
# == Snippr content
#
# Returning the snippr content is done by calling the +to_s+ method. This will replace
# all specified placeholders and links.
#
#   Snippr.new(:tariff, :einheit).to_s
#
# == Rails Helper
#
# When using the Snippr component with Rails, it automatically adds the +SnipprHelper+
# module to your views. You can then use the +snippr+ helper method to load snippr files.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
class Snippr
  extend SnipprPath

  # The snippr file extension.
  SnipprFileExtension = ".snip"

  # The comments wrapping a snippr.
  SnipprWrapper = "<!-- starting with snippr: %s -->\n%s\n<!-- ending with snippr: %s -->"

  # The fallback for a missing snippr.
  MissingSnippr = '<samp class="missing snippr" />'

  # Expects the paths to a snippr. Also accepts a Hash of placeholders
  # to be replaced with dynamic values.
  def initialize(*args)
    @dynamic_values = args.last.kind_of?(Hash) ? args.pop : {}
    @snippr_name = args.join("/")
  end

  # Returns the snippr content.
  def to_s
    wrap_in_comments { snippr }
  end

private

  # Returns the raw snippr content or a +MissingSnippr+ tag in case
  # the snippr file does not exist.
  def snippr
    return MissingSnippr unless File.exist? snippr_file
    
    snippr = File.read(snippr_file).strip
    insert_dynamic_values snippr
    snippr
  end

  # Replaces placeholders with dynamic values.
  def insert_dynamic_values(snippr)
    @dynamic_values.each { |placeholder, value| snippr.gsub! "{#{placeholder}}", value.to_s }
  end

  # Returns the complete path to a snippr file.
  def snippr_file
    File.join self.class.path, "#{@snippr_name}#{SnipprFileExtension}"
  end

  # Wraps the content from a given +block+ in descriptive comments.
  def wrap_in_comments
    SnipprWrapper % [@snippr_name, yield, @snippr_name]
  end

end