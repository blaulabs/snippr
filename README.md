# Snippr
## File based content management

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

    <p>Snippr says: {a_variable.doit}</p>

will yield:
  
    <p>Snippr says: HELLO</p>

You can even pass parameters to the call. Those *must* be enclosed in quotes ("):

    class Klazz
      def doitagain(p); "HELLO #{p}"; end
    end
    Snippr.load :snip :a_variable => Klass.new

on ...

    <p>Snippr says: {a_variable.doitagain("SNIPPR")}</p>

will yield:
  
    <p>Snippr says: HELLO SNIPPR</p>

### Meta Infos

A snippet can not only hold content but also meta infos for this snippet.

Inspired by [jekyll](http://jekyllrb.com) a snippet can host metdata that are accessable via the `.meta` method on a loaded snippet.
`.meta' will return an empty hash when no data was found.

Metadata must be placed at the top of the snippet and is delimited with three dashed.
The data itself is parsed as YAML:

    ---  
    a_yaml: hash  
    ---  
    normal snippet content comes here until the end of the file

### Including snippr files inside other files

A snippr file can include another snippr file:

    This snippr file includes another {snip:filepath/of/snip} file

This will cause `filepath/of/snip.snip` to be included in place.

Dynamic values of the parent snip will be accessable inside the included snip file.

You can pass additional dynamic values when using `{snip}`. These will override any parent parameter.

    {snip:filepath/of/snip,dyn_key1=dyn_value,dyn_key2=dyn_value2}

Those will be available as {dyn_key1} and {dyn_key2} in filepath/of/snip.snip

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

## Build Status
![Travis-CI](https://secure.travis-ci.org/blaulabs/snippr.png)