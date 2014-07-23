# Snippr
## File based content management compatible with ruby 1.9
![Travis-CI](https://secure.travis-ci.org/blaulabs/snippr.png)

A snippr file is a piece of HTML or raw text to be included in a website. They are plain text
files stored on the file system. Snippr files end with ".snip" and are read from the Snippr path.

## Snippr path

You need to specify the path to the directory where your Snippr files are stored:

    Snippr.path = File.join File.dirname(__FILE__), "..", "snippr"

When running on JRuby, you can also set the path via JVM properties. The property you need to
specify is defined in Snippr::Path::JVMProperty. This allows system administrators to change the
path without having to touch your application.

## Loading a snippr

To load a snippr file, you can use the +load+ method, passing in the path to the snippr file as
a String (including path separators):

    Snippr.load "tariff/einheit"

or by using multiple Strings or Symbols:

    Snippr.load :tariff, :einheit

### Dynamic values

A snippr file may contain placeholders to be replaced with dynamic values. Placeholders are
wrapped in curly braces.

    <p>You're topup of {topup_amount} at {date_today} was successful.</p>

To replace both {topup_amount} and {date_today} with a dynamic value, you just pass in a Hash of
placeholders and dynamic values when loading a snippr file.

    Snippr.load :topup, :success, :topup_amount => number_to_currency(15), :date_today => Date.today

The result will obviously be something like:

    <p>You're topup of 15,00 &euro; at 2010-04-03 was successful.</p>

### calling methods on passed variables

You can call methods on passed parameters. Calling this:

    class Klazz
      def doit; "HELLO"; end
    end
    Snippr.load :snip :a_variable => Klass.new

on ...

    <p>Snippr says: {a_variable.doit()}</p>

will yield:
  
    <p>Snippr says: HELLO</p>

You can even pass parameters to the call. Those *must* be enclosed in double quotes ("):

    class Klazz
      def doitagain(p); "HELLO #{p}"; end
    end
    Snippr.load :snip :a_variable => Klass.new

on ...

    <p>Snippr says: {a_variable.doitagain("SNIPPR")}</p>

will yield:
  
    <p>Snippr says: HELLO SNIPPR</p>

The last parameter can also be passed in in 'block' form:

    {a_variable.doitagain()}
    SNIPPR
    {/a_variable.doitagain}

Notice that you have to leave that last parameter out of the signature of the snippr call:

    {two_parameters.signature("ONE","TWO")}

is equivalent to

    {two_parameters.signature("ONE")}
    TWO
    {/two_parameters.signature}

Snippr will check (via #respond_to?) if the method is available on the receiver variable.  
If that is not what you want and you want to force snippr to call the method on the receiver you can prepend a bang to the variable name (as of Snippr 0.15.8):

    {!a_variable.called_even_if_not_available()}

That would result in an ``NoMethodError``.
This can be very useful if you call a method on a proxy object with dynamic method generation that isn't so polite as to implement a meaningful ``respond_to?`` or ``respond_to_missing?`` (eg. The Draper::HelperProxy)

### Defaulting an empty {snippet_variable}
You can use `{variable|default_value}` to default this snippet to a value, here it would result in `default_value`. This also works on method invocations.

### Meta Infos

A snippet can not only hold content but also meta infos for this snippet.

Inspired by [jekyll](http://jekyllrb.com) a snippet can host metadata that is accessable via the `.meta` method on a loaded snippet.
`.meta' will return an empty hash when no data was found.

Metadata must be placed at the top of the snippet or directly after the segment filter and is delimited with three dashed.
The data itself is parsed as YAML:

    ---  
    a_yaml: hash  
    ---  
    normal snippet content comes here until the end of the file

Or with Segmentfilter:

    ---
    a_yaml: old
    ---
    old snippet content comes here until before segment filter
    ==== valid_from: 2013-05-17 13:15:00 ====
    ---
    a_yaml: new
    ---
    new snippet content after segment filter

You call also include other front matter blocks from another snippet with the magic `_include` YAML construct.  
If you have a snippet `a/path/snippet.snip`: 

    ---
    _include:
      - path/from/root/to/snippet
      - ./relative/to/this/snippet
    ---

This would merge the metadata from `path/from/root/to/snippet.snip` and `a/path/relative/to/this/snippet.snip` into the containing snippets metadata.  
If there are duplicate keys the metadata in the main/base snippet is chosen.

Be aware that the `_include` key is *removed* from the metadata after including.


### Including snippr files inside other files

    {snip:absolute/path/from/snippr/path}
    {snip:./relative/path/from/including/snippet}
    {snip:../relative/path/from/including/snippet}

A snippr file can include another snippr file:

    This snippr file includes another {snip:filepath/of/snip} file

This will cause `filepath/of/snip.snip` to be included in place.

You can also include relative to the including snippet. A snippet in `some/deep/path/deep.snip` containing `{snip:../../twoDown}` will include `some/twoDown.snip`.  
Also `{snip:./further/we/go}` would include `some/deep/path/further/we/go.snip`.

Note that it is not allowed to go outside of the designated `Snippr.path`: `{snip:../../../etc/password}` would then output `<!-- missing snippr: ./etc/password -->` wven if the file exists.

Dynamic values of the parent snip will be accessable inside the included snip file.

You can pass additional dynamic values when using `{snip}`. These will override any parent parameter.

    {snip:filepath/of/snip,dyn_key1=dyn_value,dyn_key2=dyn_value2}

or

    {snip:filepath/of/snip,dyn_key1="dyn_value",dyn_key2='dyn_value2'}

Those will be available as {dyn_key1} and {dyn_key2} in filepath/of/snip.snip  
Outer quotes and double quotes will be removed

### Segments (as of Snippr 0.15.0)

A snippet file can contain multiple snippet "segments".  
Those segment are delimited by a line containing only `==== somefilter: filtervalue ====`.  
Since there can be only one active content per snippet you must use segmentfilters to determine which segment of the enippet to use.  

Currently there are the following filters:  

#### valid_from
`valid_from: YYYY-MM-DD HH:MM:SS` :  
Activates the following snippet section if the current date is greater than the timestamp passed as the filtervalue.  
  
    First segment
    ==== valid_from: 2013-05-17 13:15:00 ====
    Second segement

Here the second segment would be the content on and after 2013-05-17 13:15:00.

#### valid_until
`valid_until: YYYY-MM-DD HH:MM:SS` :  
Same as `valid_from` only the other way round

#### valid_between
`valid_between: YYYY-MM-DD HH:MM:SS - YYYY-MM-DD HH:MM::SS` :  
Combines `valid_from` and `valid_until` segment filters

#### on_rails_env
`on_rails_env: production`:  
Shows the snippet only in the given environment(s).  
Separate environments with a comma (eg. production,test,unstable)

#### on_host
`on_host: thismachinehostname`:  
Shows the snippet segment only on a host with the name 'thismachinehostname'.  
Multiple hostnames can be given, separated with commas.

## I18n

Snippr comes with support for I18n, but up until further notice, you have to manually enable this
behavior in your application.

    Snippr.i18n = true

Afterwards Snippr uses the locale specified via I18n and automatically prepends the current locale
prefixed with a "_" to your snippr files.

    I18n.locale = :de
    Snippr.load :shop # tries to load "shop_de.snip" relative to your Snippr path

    I18n.locale = :en
    Snippr.load :shop # tries to load "shop_en.snip" relative to your Snippr path
  
## Wiki Syntax

Until now, only wiki links with text are supported by Snippr:

    [[http://www.blaulabs.de|blaulabs]]
  
will be converted to:

    <a href="http://www.blaulabs.de">blaulabs</a>

## Rails Helper

When using the Snippr module with Rails, it automatically adds the +Snippr::Helper+ module to
your views. You can then use the +snippr+ helper method to load snippr files.

    %h1 Topup successful
    .topup.info
      = snippr :topup, :success

## Configuration via railtie
Starting in version 0.13.2 you can configure snippr without the use of initializers when using Rails:

Edit `application.rb` (or the environment specific files in config/environments) and add:

    class Application < Rails::Application
      config.snippr.i18n = true
      # Add a Normalizer:
      config.snippr.normalizers = Snippr::Normalizer::DeRester.new
      config.snippr.path = "my/path/to/snippets"
      # or even for defered configuration with a lambda:
      # config.snippr.path = lambda { SomeClassThatsAvailableLater.path }
    end

## Bigger on the inside
Starting with 0.15.11 the gem supports rewinding and advancing time to display the state of a webpage on that moment.  
This is especially useful when using `valid_from` or `valid_to`time based segment filters.

For that to work you need to configure the so called "snippr tardis" to be active.  
Configuration is done via application.rb like so:

    class Application < Rails::Application
      config.snippr.tardis_enabled = true # or false or a Proc
    end

Then call the `snippr_tardis` helper in your view:  

    <%= snippr_tardis if Rails.env.development? %>

You will then see the tardis appear in the upper right corner after a server restart.
Click on the tardis icon.

Now use one of the following and click "warp":

+1d : advance time one day  
-4d : rewind time four days  
-7h : rewind time 7 hours  
+10m : advance ten minutes  

You get the idea. Exterminate!
